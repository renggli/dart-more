import 'dart:math' as math;

import 'package:collection/collection.dart' show PriorityQueue;
import 'package:meta/meta.dart';

import '../functional/types.dart';
import 'rtree/bounds.dart';
import 'rtree/entry.dart';
import 'rtree/guttman.dart';
import 'rtree/linear.dart';
import 'rtree/node.dart';
import 'rtree/rstar.dart';

/// Abstract base implementation of the R-Tree data structure, a spatial index
/// for n-dimensional geometric bounding boxes and points.
///
/// An R-Tree indexes multi-dimensional spatial objects by grouping nearby objects
/// within hierarchical Minimum Bounding Rectangles (MBRs).
///
/// ### Choosing a Tree Variant
///
/// - [RTree.rStar]: Recommended default. Minimizes overlap between sibling nodes
///   and reorganizes entries via forced reinsertion, yielding the best query and
///   nearest-neighbor performance. Insertion has moderate overhead.
/// - [RTree.guttman]: Balanced choice with quadratic split (`O(M^2)`). Faster
///   insertion than R*-Tree for smaller node capacities, but larger overlap
///   and slower query performance on dense or clustered datasets.
/// - [RTree.linear]: Fastest insertion (`O(M)` split). Best for high-throughput
///   streaming or bulk ingestion workloads where query latency is secondary.
///
/// ### Sizing [minEntries] and [maxEntries]
///
/// - The node capacity [maxEntries] (`M`) defines how many child entries a node
///   can store before splitting (`M >= 2`). [minEntries] (`m`) defines the
///   underflow threshold (`1 <= m <= M ~/ 2`).
/// - Default values (`m = 4`, `M = 8`) offer a balanced starting point for
///   in-memory trees with interactive updates.
/// - **Read-heavy / static indexes**: Use larger capacities such as `M = 16` to `64`
///   and `m` around `0.3 * M` to `0.4 * M`. This flattens the tree height
///   and reduces pointer indirection.
/// - **Write-heavy / streaming data**: Use smaller capacities such as `M = 8` to `16`
///   with [RTree.linear] or [RTree.guttman] to minimize split evaluation time.
abstract class RTree<T> with Iterable<T> {
  /// Constructs a Guttman R-Tree using the quadratic split algorithm.
  ///
  /// Quadratic split evaluates all pairs of entries (`O(M^2)`) to identify seeds
  /// that maximize dead area, then distributes remaining entries to minimize area
  /// enlargement.
  ///
  /// Use this variant when insertions are frequent and the reinsertion overhead of
  /// [RTree.rStar] is undesirable, with small-to-moderate [maxEntries] (`M <= 32`).
  /// Set [minEntries] to approximately `0.4 * M` to `0.5 * M`.
  ///
  /// Throws an [ArgumentError] if [maxEntries] is less than `2` or [minEntries]
  /// is not in `1..(maxEntries ~/ 2)`.
  factory guttman({int? minEntries, int? maxEntries}) = GuttmanTree<T>;

  /// Constructs a Guttman R-Tree using the linear split algorithm.
  ///
  /// Linear split finds extreme bounding entries along normalized dimensions in
  /// linear time (`O(M)`), then greedily assigns entries.
  ///
  /// Use this variant for write-heavy ingestion workloads, high-frequency updates,
  /// or when using large [maxEntries] (`M >= 32`) where quadratic or topological
  /// split costs would be prohibitive. Set [minEntries] to approximately
  /// `0.3 * M` to `0.4 * M`.
  ///
  /// Throws an [ArgumentError] if [maxEntries] is less than `2` or [minEntries]
  /// is not in `1..(maxEntries ~/ 2)`.
  factory linear({int? minEntries, int? maxEntries}) = LinearRTree<T>;

  /// Constructs an R*-Tree using topological split, overlap minimization, and
  /// forced reinsertion.
  ///
  /// R*-Tree evaluates split axes by margin (perimeter), picks the distribution
  /// that minimizes bounding box overlap, and dynamically re-inserts a fraction of
  /// entries ([reinsertFactor], default `0.3`) upon node overflow.
  ///
  /// Recommended default for general-purpose spatial indexing and read-heavy
  /// workloads. Produces tighter bounding boxes and significantly faster spatial
  /// queries and k-NN lookups than [RTree.guttman] or [RTree.linear].
  /// Recommended configuration is [minEntries] set to `0.3 * M` to `0.4 * M`
  /// (e.g. `m = 4, M = 10` or `m = 8, M = 20`).
  ///
  /// Throws an [ArgumentError] if [maxEntries], [minEntries], or
  /// [reinsertFactor] is invalid.
  factory rStar({int? minEntries, int? maxEntries, double? reinsertFactor}) =
      RStarTree<T>;

  /// Constructs a Guttman R-Tree described in Guttman (1984).
  @Deprecated('Use RTree.guttman instead')
  factory guttmann({int? minEntries, int? maxEntries}) = GuttmanTree<T>;

  /// Internal constructor for the R-Tree.
  ///
  /// Throws an [ArgumentError] if [maxEntries] is less than `2` or [minEntries]
  /// is not between `1` and `maxEntries ~/ 2`.
  new({int? minEntries, int? maxEntries})
    : maxEntries = maxEntries ?? 8,
      minEntries = minEntries ?? math.min(4, (maxEntries ?? 8) ~/ 2) {
    if (this.maxEntries < 2) {
      throw ArgumentError.value(
        this.maxEntries,
        'maxEntries',
        'Must be at least 2',
      );
    }
    if (this.minEntries < 1 || this.minEntries > this.maxEntries ~/ 2) {
      throw ArgumentError.value(
        this.minEntries,
        'minEntries',
        'Must be between 1 and ${this.maxEntries ~/ 2}',
      );
    }
  }

  /// Minimum number of entries per node (`1 <= m <= M ~/ 2`).
  final int minEntries;

  /// Maximum number of entries per node before a split is triggered.
  final int maxEntries;

  /// The root node of the tree.
  late RTreeNode<T> root = RTreeNode<T>(this, isLeaf: true);

  int _length = 0;

  /// Number of leaf elements stored in the tree.
  @override
  int get length => _length;

  @override
  bool get isEmpty => length == 0;

  @override
  bool get isNotEmpty => length > 0;

  /// The bounding box enclosing all entries in the tree, or `null` if empty.
  Bounds? get bounds => root.bounds;

  @override
  Iterator<T> get iterator =>
      searchEntries().map((entry) => entry.data as T).iterator;

  /// Associates [data] with the provided [bound].
  RTreeEntry<T> insert(Bounds bound, T data) {
    final entry = RTreeEntry<T>(bound, data: data);
    final node = chooseLeaf(entry);
    node.entries.add(entry);
    final splitNode = node.entries.length > maxEntries
        ? overflowStrategy(node)
        : null;
    adjustTree(node, splitNode);
    incrementLength();
    return entry;
  }

  /// Removes the first entry matching [bound] and optionally [dataPredicate].
  ///
  /// Returns `true` if an entry was removed, `false` otherwise.
  bool remove(Bounds bound, {Predicate1<T>? dataPredicate}) {
    final found = _findLeafEntry(root, bound, dataPredicate);
    if (found == null) return false;
    final (:leaf, :index) = found;
    leaf.entries.removeAt(index);
    decrementLength();
    _condenseTree(leaf);
    return true;
  }

  /// Removes all entries from the tree.
  void clear() {
    root = RTreeNode<T>(this, isLeaf: true);
    _length = 0;
  }

  /// Queries leaf entries intersecting [bounds], returning a lazy iterable.
  Iterable<RTreeEntry<T>> queryEntries(Bounds bounds) sync* {
    if (root.entries.isEmpty) return;
    final stack = <RTreeNode<T>>[root];
    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (node.isLeaf) {
        for (final entry in node.entries) {
          if (entry.bounds.intersects(bounds)) {
            yield entry;
          }
        }
      } else {
        for (var i = node.entries.length - 1; i >= 0; i--) {
          final entry = node.entries[i];
          if (entry.bounds.intersects(bounds)) {
            final child = entry.child;
            if (child != null) stack.add(child);
          }
        }
      }
    }
  }

  /// Queries leaf elements whose bounds intersect [bounds].
  Iterable<T> query(Bounds bounds) =>
      queryEntries(bounds).map((entry) => entry.data as T);

  /// Finds up to [k] nearest leaf entries to [bounds] within [maxDistance],
  /// ordered by increasing distance.
  ///
  /// Returns an empty iterable if [k] is non-positive, [maxDistance] is
  /// negative or `NaN`, or the tree is empty.
  Iterable<RTreeEntry<T>> nearestEntries(
    Bounds bounds, {
    int k = 1,
    double maxDistance = double.infinity,
  }) {
    if (k <= 0 ||
        root.entries.isEmpty ||
        maxDistance.isNaN ||
        maxDistance < 0.0) {
      return const [];
    }
    final maxDistSq = maxDistance.isFinite
        ? maxDistance * maxDistance
        : double.infinity;

    final queue = PriorityQueue<_NearestItem<T>>(
      (a, b) => a.distSq.compareTo(b.distSq),
    );

    for (final entry in root.entries) {
      final d = entry.bounds.minDistanceToBoundsSquared(bounds);
      if (d <= maxDistSq) {
        queue.add(_NearestItem(entry, d));
      }
    }

    final results = <RTreeEntry<T>>[];
    while (queue.isNotEmpty && results.length < k) {
      final item = queue.removeFirst();
      final entry = item.entry;
      final child = entry.child;
      if (child == null) {
        results.add(entry);
      } else {
        for (final childEntry in child.entries) {
          final d = childEntry.bounds.minDistanceToBoundsSquared(bounds);
          if (d <= maxDistSq) {
            queue.add(_NearestItem(childEntry, d));
          }
        }
      }
    }
    return results;
  }

  /// Finds up to [k] nearest leaf values to [bounds] within [maxDistance],
  /// ordered by increasing distance.
  ///
  /// Returns an empty iterable if [k] is non-positive, [maxDistance] is
  /// negative or `NaN`, or the tree is empty.
  Iterable<T> nearest(
    Bounds bounds, {
    int k = 1,
    double maxDistance = double.infinity,
  }) => nearestEntries(
    bounds,
    k: k,
    maxDistance: maxDistance,
  ).map((e) => e.data as T);

  /// Queries nodes intersecting [bounds], returning a lazy iterable.
  ///
  /// By default, this method returns only leaf nodes, though intermediate-level
  /// nodes can also be returned by setting [leaves] to `false`.
  Iterable<RTreeNode<T>> queryNodes(Bounds bounds, {bool leaves = true}) sync* {
    if (root.entries.isEmpty) return;
    if (!root.entries.any((entry) => entry.bounds.intersects(bounds))) return;
    final stack = <RTreeNode<T>>[root];
    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (!leaves || node.isLeaf) {
        yield node;
      }
      if (!node.isLeaf) {
        for (var i = node.entries.length - 1; i >= 0; i--) {
          final entry = node.entries[i];
          if (entry.bounds.intersects(bounds)) {
            final child = entry.child;
            if (child != null) stack.add(child);
          }
        }
      }
    }
  }

  /// Traverses the tree, returning leaf entries that match a condition. This
  /// method optionally accepts both a [nodePredicate] and an [entryPredicate].
  /// The node condition is evaluated at each level and eliminates entire
  /// subtrees. In order for a leaf entry to be returned, all parent node
  /// conditions must pass. The entry condition is evaluated only at the leaf
  /// level. Both conditions are optional, and if neither is passed in, all leaf
  /// entries are returned.
  Iterable<RTreeEntry<T>> searchEntries({
    Predicate1<RTreeNode<T>>? nodePredicate,
    Predicate1<RTreeEntry<T>>? entryPredicate,
  }) sync* {
    for (final leaf in searchNodes(nodePredicate: nodePredicate)) {
      for (final entry in leaf.entries) {
        if (entryPredicate == null || entryPredicate(entry)) {
          yield entry;
        }
      }
    }
  }

  /// Traverses the tree, returning nodes that match [nodePredicate].
  ///
  /// By default, this method returns only leaf nodes, but intermediate-level
  /// nodes can also be returned by passing [leaves] as `false`. If
  /// [nodePredicate] returns `false`, the entire subtree is eliminated.
  Iterable<RTreeNode<T>> searchNodes({
    Predicate1<RTreeNode<T>>? nodePredicate,
    bool leaves = true,
  }) sync* {
    final stack = <RTreeNode<T>>[root];
    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (nodePredicate != null && !nodePredicate(node)) continue;
      if (!leaves || node.isLeaf) {
        yield node;
      }
      if (!node.isLeaf) {
        for (var i = node.entries.length - 1; i >= 0; i--) {
          final child = node.entries[i].child;
          if (child != null) stack.add(child);
        }
      }
    }
  }

  /// Traverses the nodes of the R-Tree in depth-first order, calling [callback]
  /// on each node.
  ///
  /// If [condition] returns `false`, neither the node nor any of its
  /// descendants will be traversed.
  Iterable<R> traverse<R>(
    Map1<RTreeNode<T>, Iterable<R>> callback, {
    Predicate1<RTreeNode<T>>? condition,
  }) => root.traverse(callback, condition: condition);

  ({RTreeNode<T> leaf, int index})? _findLeafEntry(
    RTreeNode<T> node,
    Bounds bound,
    Predicate1<T>? dataPredicate,
  ) {
    if (node.isLeaf) {
      for (var i = 0; i < node.entries.length; i++) {
        final entry = node.entries[i];
        if (entry.bounds == bound &&
            (dataPredicate == null || dataPredicate(entry.data as T))) {
          return (leaf: node, index: i);
        }
      }
      return null;
    }
    for (final entry in node.entries) {
      if (entry.bounds.contains(bound)) {
        final child = entry.child;
        if (child != null) {
          final found = _findLeafEntry(child, bound, dataPredicate);
          if (found != null) return found;
        }
      }
    }
    return null;
  }

  void _condenseTree(RTreeNode<T> node) {
    var curr = node;
    final eliminatedEntries = <RTreeEntry<T>>[];

    while (!curr.isRoot) {
      final parent = curr.parent;
      final parentEntry = curr.parentEntry;
      if (parent == null || parentEntry == null) break;

      if (curr.entries.length < minEntries) {
        parent.entries.remove(parentEntry);
        for (final entry in curr.traverse((n) => n.entries)) {
          if (entry.isLeaf) {
            eliminatedEntries.add(entry);
          }
        }
      } else {
        parentEntry.bounds = Bounds.unionAll(curr.entries.map((e) => e.bounds));
      }
      curr = parent;
    }

    while (!root.isLeaf && root.entries.length == 1) {
      final onlyChild = root.entries.first.child;
      if (onlyChild == null) break;
      root = onlyChild;
      root.parent = null;
    }

    // Reinsert orphaned entries
    for (final entry in eliminatedEntries) {
      insert(entry.bounds, entry.data as T);
      decrementLength(); // insert increments length, so balance it
    }
  }

  /// Select a leaf node in which to place a new index entry.
  @protected
  RTreeNode<T> chooseLeaf(RTreeEntry<T> entry);

  /// Split an overflowing node.
  @protected
  RTreeNode<T>? overflowStrategy(RTreeNode<T> node);

  /// Ascend from a leaf node to the root, adjusting covering rectangles and
  /// propagating node splits as necessary.
  @protected
  void adjustTree(RTreeNode<T> node, RTreeNode<T>? splitNode) {
    var current = node;
    var split = splitNode;
    while (!current.isRoot) {
      final parent = current.parent;
      final parentEntry = current.parentEntry;
      if (parent == null || parentEntry == null) break;
      parentEntry.bounds = Bounds.unionAll(
        current.entries.map((entry) => entry.bounds),
      );
      if (split != null) {
        final bounds = Bounds.unionAll(
          split.entries.map((entry) => entry.bounds),
        );
        parent.entries.add(RTreeEntry<T>(bounds, child: split));
        if (parent.entries.length > maxEntries) {
          split = overflowStrategy(parent);
        } else {
          split = null;
        }
      }
      current = parent;
    }
    if (split != null) {
      growTree([current, split]);
    }
  }

  /// Grows the R-Tree by creating a new root node, with the given nodes as
  /// children.
  @protected
  RTreeNode<T> growTree(Iterable<RTreeNode<T>> nodes) {
    root = RTreeNode<T>(this, isLeaf: false);
    for (final node in nodes) {
      final nodeBounds = node.bounds;
      if (nodeBounds != null) {
        root.entries.add(RTreeEntry<T>(nodeBounds, child: node));
      }
      node.parent = root;
    }
    return root;
  }

  /// Increments the internal leaf count.
  @protected
  void incrementLength() => _length++;

  /// Decrements the internal leaf count.
  @protected
  void decrementLength() => _length--;

  /// Splits a given node into two nodes. The original node will have the
  /// entries specified in [group1], and the newly-created split node will have
  /// the entries specified in [group2]. Both the original and split node will
  /// have their children nodes adjusted so they have the correct parent.
  @protected
  RTreeNode<T> splitNode(
    RTreeNode<T> node,
    List<RTreeEntry<T>> group1,
    List<RTreeEntry<T>> group2,
  ) {
    node.entries = group1;
    final splitNode = RTreeNode<T>(
      this,
      isLeaf: node.isLeaf,
      parent: node.parent,
      entries: group2,
    );
    node.fixChildren();
    splitNode.fixChildren();
    return splitNode;
  }
}

class _NearestItem<T> {
  const new(this.entry, this.distSq);

  final RTreeEntry<T> entry;
  final double distSq;
}
