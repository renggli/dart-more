import 'dart:math' as math;

import '../rtree.dart';
import 'bounds.dart';
import 'entry.dart';
import 'node.dart';
import 'utils.dart';

/// R*-Tree implementation based on Beckmann et al. (1990):
/// "The R*-tree: An Efficient and Robust Access Method for Points and Rectangles".
class RStarTree<T> extends RTree<T> {
  new({super.minEntries, super.maxEntries, double? reinsertFactor})
    : reinsertCount = math.max(
        1,
        (((maxEntries ?? 8) + 1) * (reinsertFactor ?? 0.3)).round(),
      );

  /// Number of entries to remove and reinsert on first overflow at each level.
  final int reinsertCount;

  @override
  RTreeEntry<T> insert(Bounds bound, T data) {
    final entry = RTreeEntry<T>(bound, data: data);
    _insertEntry(entry, 0);
    incrementLength();
    return entry;
  }

  void _insertEntry(
    RTreeEntry<T> entry,
    int targetLevel, {
    Set<int>? overflowLevels,
  }) {
    overflowLevels ??= <int>{};
    final node = _chooseSubtree(root, entry, targetLevel);
    node.entries.add(entry);
    if (!entry.isLeaf) {
      entry.child!.parent = node;
    }

    if (node.entries.length > maxEntries) {
      _overflowTreatment(node, targetLevel, overflowLevels);
    } else {
      _adjustBounds(node);
    }
  }

  RTreeNode<T> _chooseSubtree(
    RTreeNode<T> subRoot,
    RTreeEntry<T> entry,
    int targetLevel,
  ) {
    var node = subRoot;
    while (_levelOf(node) > targetLevel) {
      final childIsLeaf = node.entries.first.child?.isLeaf ?? true;
      if (childIsLeaf) {
        node = _entryWithLeastOverlapEnlargement(
          node.entries,
          entry.bounds,
        ).child!;
      } else {
        node = entryWithLeastAreaEnlargement(node.entries, entry.bounds).child!;
      }
    }
    return node;
  }

  int _levelOf(RTreeNode<T> node) {
    var level = 0;
    var curr = node;
    while (!curr.isLeaf) {
      level++;
      curr = curr.entries.first.child!;
    }
    return level;
  }

  void _overflowTreatment(
    RTreeNode<T> node,
    int level,
    Set<int> overflowLevels,
  ) {
    if (!node.isRoot && !overflowLevels.contains(level)) {
      overflowLevels.add(level);
      _reinsert(node, level, overflowLevels);
    } else {
      final split = _split(node);
      if (node.isRoot) {
        growTree([node, split]);
      } else {
        final parent = node.parent!;
        _adjustBounds(node);
        final splitEntry = RTreeEntry<T>(
          Bounds.unionAll(split.entries.map((e) => e.bounds)),
          child: split,
        );
        parent.entries.add(splitEntry);
        split.parent = parent;
        split.fixChildren();
        if (parent.entries.length > maxEntries) {
          _overflowTreatment(parent, level + 1, overflowLevels);
        } else {
          _adjustBounds(parent);
        }
      }
    }
  }

  void _reinsert(RTreeNode<T> node, int level, Set<int> overflowLevels) {
    final center = node.bounds?.center;
    if (center == null || node.entries.length <= minEntries) return;

    node.entries.sort((a, b) {
      final distA = a.bounds.minDistanceToPointSquared(center);
      final distB = b.bounds.minDistanceToPointSquared(center);
      return distB.compareTo(distA);
    });

    final toReinsert = <RTreeEntry<T>>[];
    final count = math.min(reinsertCount, node.entries.length - minEntries);
    for (var i = 0; i < count; i++) {
      toReinsert.add(node.entries.removeAt(0));
    }

    _adjustBounds(node);

    for (final entry in toReinsert) {
      _insertEntry(entry, level, overflowLevels: overflowLevels);
    }
  }

  RTreeNode<T> _split(RTreeNode<T> node) {
    final dimensions = node.entries.first.bounds.length;
    var bestAxis = 0;
    var minMarginSum = double.infinity;

    for (var d = 0; d < dimensions; d++) {
      var marginSum = 0.0;
      final sortedByMin = node.entries.toList()
        ..sort((a, b) => a.bounds.getMin(d).compareTo(b.bounds.getMin(d)));
      marginSum += _computeDistributionsMargin(sortedByMin);

      final sortedByMax = node.entries.toList()
        ..sort((a, b) => a.bounds.getMax(d).compareTo(b.bounds.getMax(d)));
      marginSum += _computeDistributionsMargin(sortedByMax);

      if (marginSum < minMarginSum) {
        minMarginSum = marginSum;
        bestAxis = d;
      }
    }

    final sortedByMin = node.entries.toList()
      ..sort(
        (a, b) =>
            a.bounds.getMin(bestAxis).compareTo(b.bounds.getMin(bestAxis)),
      );
    final sortedByMax = node.entries.toList()
      ..sort(
        (a, b) =>
            a.bounds.getMax(bestAxis).compareTo(b.bounds.getMax(bestAxis)),
      );

    final bestMinSplit = _chooseBestSplitDistribution(sortedByMin);
    final bestMaxSplit = _chooseBestSplitDistribution(sortedByMax);

    final winningSplit =
        (bestMinSplit.overlap < bestMaxSplit.overlap ||
            (bestMinSplit.overlap == bestMaxSplit.overlap &&
                bestMinSplit.area < bestMaxSplit.area))
        ? bestMinSplit
        : bestMaxSplit;

    return splitNode(node, winningSplit.entries1, winningSplit.entries2);
  }

  double _computeDistributionsMargin(List<RTreeEntry<T>> sorted) {
    var marginSum = 0.0;
    final total = sorted.length;
    for (var k = 1; k <= total - 2 * minEntries + 1; k++) {
      final splitIndex = minEntries - 1 + k;
      final b1 = Bounds.unionAll(sorted.take(splitIndex).map((e) => e.bounds));
      final b2 = Bounds.unionAll(sorted.skip(splitIndex).map((e) => e.bounds));
      marginSum += b1.margin + b2.margin;
    }
    return marginSum;
  }

  _SplitDistribution<T> _chooseBestSplitDistribution(
    List<RTreeEntry<T>> sorted,
  ) {
    final total = sorted.length;
    var minOverlap = double.infinity;
    var minArea = double.infinity;
    late _SplitDistribution<T> best;

    for (var k = 1; k <= total - 2 * minEntries + 1; k++) {
      final splitIndex = minEntries - 1 + k;
      final group1 = sorted.sublist(0, splitIndex);
      final group2 = sorted.sublist(splitIndex);

      final b1 = Bounds.unionAll(group1.map((e) => e.bounds));
      final b2 = Bounds.unionAll(group2.map((e) => e.bounds));

      final overlap = b1.intersection(b2)?.area ?? 0.0;
      final area = b1.area + b2.area;

      if (overlap < minOverlap || (overlap == minOverlap && area < minArea)) {
        minOverlap = overlap;
        minArea = area;
        best = _SplitDistribution(group1, group2, overlap, area);
      }
    }
    return best;
  }

  RTreeEntry<T> _entryWithLeastOverlapEnlargement(
    List<RTreeEntry<T>> entries,
    Bounds bounds,
  ) {
    var minIndex = 0;
    var minOverlapEnlargement = double.infinity;
    var minAreaEnlargement = double.infinity;

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final currentOverlap = _overlapOf(entries, i, entry.bounds);
      final enlargedBounds = entry.bounds.union(bounds);
      final newOverlap = _overlapOf(entries, i, enlargedBounds);
      final overlapEnlargement = newOverlap - currentOverlap;
      final areaEnlargement = enlargedBounds.area - entry.bounds.area;

      if (overlapEnlargement < minOverlapEnlargement ||
          (overlapEnlargement == minOverlapEnlargement &&
              areaEnlargement < minAreaEnlargement)) {
        minIndex = i;
        minOverlapEnlargement = overlapEnlargement;
        minAreaEnlargement = areaEnlargement;
      }
    }
    return entries[minIndex];
  }

  double _overlapOf(
    List<RTreeEntry<T>> entries,
    int excludeIndex,
    Bounds bounds,
  ) {
    var overlap = 0.0;
    for (var i = 0; i < entries.length; i++) {
      if (i == excludeIndex) continue;
      overlap += entries[i].bounds.intersection(bounds)?.area ?? 0.0;
    }
    return overlap;
  }

  void _adjustBounds(RTreeNode<T> node) {
    var curr = node;
    while (!curr.isRoot) {
      final parentEntry = curr.parentEntry;
      if (parentEntry != null && curr.entries.isNotEmpty) {
        parentEntry.bounds = Bounds.unionAll(curr.entries.map((e) => e.bounds));
      }
      curr = curr.parent!;
    }
  }

  @override
  RTreeNode<T> chooseLeaf(RTreeEntry<T> entry) =>
      _chooseSubtree(root, entry, 0);

  @override
  RTreeNode<T>? overflowStrategy(RTreeNode<T> node) => _split(node);

  @override
  void adjustTree(RTreeNode<T> node, RTreeNode<T>? splitNode) {
    _adjustBounds(node);
  }
}

class _SplitDistribution<T> {
  const new(this.entries1, this.entries2, this.overlap, this.area);

  final List<RTreeEntry<T>> entries1;
  final List<RTreeEntry<T>> entries2;
  final double overlap;
  final double area;
}
