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
    : reinsertCount = _computeReinsertCount(
        maxEntries ?? 8,
        reinsertFactor ?? 0.3,
      );

  static int _computeReinsertCount(int maxEntries, double reinsertFactor) {
    if (!reinsertFactor.isFinite ||
        reinsertFactor < 0.0 ||
        reinsertFactor > 1.0) {
      throw ArgumentError.value(
        reinsertFactor,
        'reinsertFactor',
        'Must be between 0.0 and 1.0',
      );
    }
    if (reinsertFactor == 0.0) return 0;
    return math.max(1, ((maxEntries + 1) * reinsertFactor).round());
  }

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
    entry.child?.parent = node;

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
    var level = _levelOf(node);
    while (level > targetLevel) {
      final childIsLeaf = node.entries.first.child?.isLeaf ?? true;
      final selected = childIsLeaf
          ? _entryWithLeastOverlapEnlargement(node.entries, entry.bounds)
          : entryWithLeastAreaEnlargement(node.entries, entry.bounds);
      final child = selected.child;
      if (child == null) break;
      node = child;
      level--;
    }
    return node;
  }

  int _levelOf(RTreeNode<T> node) {
    var level = 0;
    var curr = node;
    while (!curr.isLeaf) {
      final child = curr.entries.first.child;
      if (child == null) break;
      level++;
      curr = child;
    }
    return level;
  }

  void _overflowTreatment(
    RTreeNode<T> node,
    int level,
    Set<int> overflowLevels,
  ) {
    if (!node.isRoot && reinsertCount > 0 && !overflowLevels.contains(level)) {
      overflowLevels.add(level);
      _reinsert(node, level, overflowLevels);
    } else {
      final split = _split(node);
      if (node.isRoot) {
        growTree([node, split]);
      } else {
        final parent = node.parent;
        if (parent == null) {
          growTree([node, split]);
          return;
        }
        final parentEntry = node.parentEntry;
        if (parentEntry != null && node.entries.isNotEmpty) {
          parentEntry.bounds = Bounds.unionAll(
            node.entries.map((e) => e.bounds),
          );
        }
        final splitEntry = RTreeEntry<T>(
          Bounds.unionAll(split.entries.map((e) => e.bounds)),
          child: split,
        );
        parent.entries.add(splitEntry);
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

    final entries = node.entries;
    final count = math.min(reinsertCount, entries.length - minEntries);
    final distances = [
      for (final entry in entries)
        (entry: entry, distSq: _centerDistanceSquared(entry.bounds, center)),
    ]..sort((a, b) => b.distSq.compareTo(a.distSq));

    final toReinsert = [for (var i = 0; i < count; i++) distances[i].entry];
    node.entries = [
      for (var i = count; i < distances.length; i++) distances[i].entry,
    ];

    _adjustBounds(node);

    for (final entry in toReinsert) {
      _insertEntry(entry, level, overflowLevels: overflowLevels);
    }
  }

  static double _centerDistanceSquared(Bounds bounds, List<double> center) {
    var sum = 0.0;
    for (var i = 0; i < bounds.length; i++) {
      final entryCenter =
          bounds.getMin(i) + 0.5 * (bounds.getMax(i) - bounds.getMin(i));
      final d = entryCenter - center[i];
      sum += d * d;
    }
    return sum;
  }

  RTreeNode<T> _split(RTreeNode<T> node) {
    final dimensions = node.entries.first.bounds.length;
    var minMarginSum = double.infinity;
    late List<RTreeEntry<T>> bestSortedByMin;
    late List<RTreeEntry<T>> bestSortedByMax;

    for (var d = 0; d < dimensions; d++) {
      final sortedByMin = node.entries.toList()
        ..sort((a, b) => a.bounds.getMin(d).compareTo(b.bounds.getMin(d)));
      final sortedByMax = node.entries.toList()
        ..sort((a, b) => a.bounds.getMax(d).compareTo(b.bounds.getMax(d)));
      final marginSum =
          _computeDistributionsMargin(sortedByMin) +
          _computeDistributionsMargin(sortedByMax);

      if (d == 0 || marginSum < minMarginSum) {
        minMarginSum = marginSum;
        bestSortedByMin = sortedByMin;
        bestSortedByMax = sortedByMax;
      }
    }

    final bestMin = _chooseBestSplitDistribution(bestSortedByMin);
    final bestMax = _chooseBestSplitDistribution(bestSortedByMax);

    final useMin =
        bestMin.overlap < bestMax.overlap ||
        (bestMin.overlap == bestMax.overlap && bestMin.area < bestMax.area);
    final winningList = useMin ? bestSortedByMin : bestSortedByMax;
    final splitIndex = useMin ? bestMin.splitIndex : bestMax.splitIndex;

    return splitNode(
      node,
      winningList.sublist(0, splitIndex),
      winningList.sublist(splitIndex),
    );
  }

  ({List<Bounds> prefix, List<Bounds> suffix}) _prefixSuffixBounds(
    List<RTreeEntry<T>> sorted,
  ) {
    final total = sorted.length;
    final prefix = List<Bounds>.filled(total, sorted[0].bounds);
    var acc = sorted[0].bounds;
    for (var i = 1; i < total; i++) {
      acc = acc.union(sorted[i].bounds);
      prefix[i] = acc;
    }
    final suffix = List<Bounds>.filled(total, sorted[total - 1].bounds);
    acc = sorted[total - 1].bounds;
    for (var i = total - 2; i >= 0; i--) {
      acc = acc.union(sorted[i].bounds);
      suffix[i] = acc;
    }
    return (prefix: prefix, suffix: suffix);
  }

  double _computeDistributionsMargin(List<RTreeEntry<T>> sorted) {
    final total = sorted.length;
    final (:prefix, :suffix) = _prefixSuffixBounds(sorted);
    var marginSum = 0.0;
    for (
      var splitIndex = minEntries;
      splitIndex <= total - minEntries;
      splitIndex++
    ) {
      marginSum += prefix[splitIndex - 1].margin + suffix[splitIndex].margin;
    }
    return marginSum;
  }

  ({int splitIndex, double overlap, double area}) _chooseBestSplitDistribution(
    List<RTreeEntry<T>> sorted,
  ) {
    final total = sorted.length;
    final (:prefix, :suffix) = _prefixSuffixBounds(sorted);
    var bestSplitIndex = minEntries;
    var minOverlap = double.infinity;
    var minArea = double.infinity;

    for (
      var splitIndex = minEntries;
      splitIndex <= total - minEntries;
      splitIndex++
    ) {
      final b1 = prefix[splitIndex - 1];
      final b2 = suffix[splitIndex];
      final overlap = b1.intersectionArea(b2);
      final area = b1.area + b2.area;

      if (overlap < minOverlap || (overlap == minOverlap && area < minArea)) {
        minOverlap = overlap;
        minArea = area;
        bestSplitIndex = splitIndex;
      }
    }
    return (splitIndex: bestSplitIndex, overlap: minOverlap, area: minArea);
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
      overlap += entries[i].bounds.intersectionArea(bounds);
    }
    return overlap;
  }

  void _adjustBounds(RTreeNode<T> node) {
    var curr = node;
    while (!curr.isRoot) {
      final parent = curr.parent;
      final parentEntry = curr.parentEntry;
      if (parent == null) break;
      if (parentEntry != null && curr.entries.isNotEmpty) {
        parentEntry.bounds = Bounds.unionAll(curr.entries.map((e) => e.bounds));
      }
      curr = parent;
    }
  }

  @override
  RTreeNode<T> chooseLeaf(RTreeEntry<T> entry) =>
      _chooseSubtree(root, entry, 0);

  @override
  RTreeNode<T>? overflowStrategy(RTreeNode<T> node) => _split(node);
}
