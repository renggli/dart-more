import 'package:meta/meta.dart';

import '../../functional.dart';
import 'rtree/bounds.dart';
import 'rtree/entry.dart';
import 'rtree/guttman.dart';
import 'rtree/node.dart';
import 'rtree/rstar.dart';

@experimental
abstract class RTree<T> {
  factory RTree.guttmann({int? minEntries, int? maxEntries}) = GuttmanTree<T>;

  factory RTree.rstar({int? minEntries, int? maxEntries}) = RStarTree<T>;

  RTree({int? minEntries, int? maxEntries})
      : minEntries = minEntries ?? 4,
        maxEntries = maxEntries ?? 8;

  /// Minimum number of entries per node.
  final int minEntries;

  /// Maximum number of entries per node.
  final int maxEntries;

  ///
  late RTreeNode<T> root = RTreeNode<T>(this, isLeaf: true);

  RTreeEntry<T> insert(Bounds bound, T data);

  /// Queries leaf entries for a location (either a point or a rectangle),
  /// returning an iterable.
  Iterable<RTreeEntry<T>> queryEntries(Bounds bounds) =>
      searchNodes(nodePredicate: (node) => node.bounds.intersects(bounds))
          .expand((node) =>
              node.entries.where((entry) => entry.bounds.intersects(bounds)));

  /// Queries nodes for a location (either a point or a rectangle), returning an
  /// iterable. By default, this method returns only leaf nodes, though
  /// intermediate-level nodes can also be returned by setting the leaves
  /// parameter to False.
  Iterable<RTreeNode<T>> queryNodes(Bounds bounds, {bool leaves = true}) =>
      searchNodes(
          nodePredicate: (node) => node.bounds.intersects(bounds),
          leaves: leaves);

  /// Traverses the tree, returning leaf entries that match a condition. This
  /// method optionally accepts both a node condition and an entry condition.
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

  /// Traverses the tree, returning nodes that match a condition. By default,
  /// this method returns only leaf nodes, but intermediate-level nodes can also
  /// be returned by passing leaves=False. The condition is evaluated for each
  /// node at every level of the tree, and if it returns False, the entire
  /// subtree is eliminated.
  Iterable<RTreeNode<T>> searchNodes({
    Predicate1<RTreeNode<T>>? nodePredicate,
    bool leaves = true,
  }) {
    final callback = leaves
        ? (RTreeNode<T> node) => (node.isLeaf ? [node] : <RTreeNode<T>>[])
        : (RTreeNode<T> node) => [node];
    return traverse(callback, condition: nodePredicate);
  }

  /// Traverses the nodes of the R-Tree in depth-first order, calling the given
  /// function on each node. A condition function may optionally be passed to
  /// filter which nodes get traversed. If condition returns False, then neither
  /// the node nor any of its descendants will be traversed.
  Iterable<R> traverse<R>(Map1<RTreeNode<T>, Iterable<R>> callback,
          {Predicate1<RTreeNode<T>>? condition}) =>
      root.traverse(callback, condition: condition);

  /// Grows the R-Tree by creating a new root node, with the given nodes as
  /// children.
  @protected
  RTreeNode<T> growTree(Iterable<RTreeNode<T>> nodes) {
    root = RTreeNode<T>(this, isLeaf: false);
    root.entries
        .addAll(nodes.map((node) => RTreeEntry<T>(node.bounds, child: node)));
    for (final node in nodes) {
      node.parent = root;
    }
    return root;
  }

  /// Splits a given node into two nodes. The original node will have the
  /// entries specified in group1, and the newly-created split node will have
  /// the entries specified in group2. Both the original and split node will
  /// have their children nodes adjusted so they have the correct parent.
  @protected
  RTreeNode<T> splitNode(RTreeNode<T> node, List<RTreeEntry<T>> group1,
      List<RTreeEntry<T>> group2) {
    node.entries = group1;
    final splitNode = RTreeNode<T>(this,
        isLeaf: node.isLeaf, parent: node.parent, entries: group2);
    node.fixChildren();
    splitNode.fixChildren();
    return splitNode;
  }
}