import '../rtree.dart';
import 'entry.dart';
import 'node.dart';
import 'utils.dart';

/// Linear R-Tree described by Guttman (1984) with an `O(M)` split algorithm.
class LinearRTree<T> extends RTree<T> {
  new({super.minEntries, super.maxEntries});

  @override
  RTreeNode<T> chooseLeaf(RTreeEntry<T> entry) {
    var node = root;
    while (!node.isLeaf) {
      final child = entryWithLeastAreaEnlargement(
        node.entries,
        entry.bounds,
      ).child;
      if (child == null) break;
      node = child;
    }
    return node;
  }

  @override
  RTreeNode<T>? overflowStrategy(RTreeNode<T> node) {
    final entries = node.entries.toList();
    final (:first, :second) = _linearPickSeeds(entries);
    final seed1 = entries[first];
    final seed2 = entries[second];
    if (first > second) {
      entries.removeAt(first);
      entries.removeAt(second);
    } else {
      entries.removeAt(second);
      entries.removeAt(first);
    }
    final group1 = [seed1];
    var bounds1 = seed1.bounds;
    final group2 = [seed2];
    var bounds2 = seed2.bounds;

    while (entries.isNotEmpty) {
      final group1Underfull = group1.length + entries.length <= minEntries;
      final group2Underfull = group2.length + entries.length <= minEntries;
      if (group1Underfull && !group2Underfull) {
        group1.addAll(entries);
        break;
      }
      if (!group1Underfull && group2Underfull) {
        group2.addAll(entries);
        break;
      }

      final entry = entries.removeLast();
      final area1 = bounds1.area;
      final area2 = bounds2.area;
      final enlargement1 = bounds1.unionArea(entry.bounds) - area1;
      final enlargement2 = bounds2.unionArea(entry.bounds) - area2;

      final bool addToGroup1;
      if (enlargement1 == enlargement2) {
        if (area1 == area2) {
          addToGroup1 = group1.length < group2.length;
        } else {
          addToGroup1 = area1 < area2;
        }
      } else {
        addToGroup1 = enlargement1 < enlargement2;
      }

      if (addToGroup1) {
        group1.add(entry);
        bounds1 = bounds1.union(entry.bounds);
      } else {
        group2.add(entry);
        bounds2 = bounds2.union(entry.bounds);
      }
    }
    return splitNode(node, group1, group2);
  }

  ({int first, int second}) _linearPickSeeds(List<RTreeEntry<T>> entries) {
    final dimensions = entries.first.bounds.length;
    var maxNormalizedSeparation = double.negativeInfinity;
    var bestSeed1 = 0;
    var bestSeed2 = 1;

    for (var d = 0; d < dimensions; d++) {
      var lowestUpperBound = entries[0].bounds.getMax(d);
      var highestLowerBound = entries[0].bounds.getMin(d);
      var seed1 = 0;
      var seed2 = 0;

      var minCoord = entries[0].bounds.getMin(d);
      var maxCoord = entries[0].bounds.getMax(d);

      for (var i = 1; i < entries.length; i++) {
        final b = entries[i].bounds;
        final bMin = b.getMin(d);
        final bMax = b.getMax(d);
        if (bMin < minCoord) minCoord = bMin;
        if (bMax > maxCoord) maxCoord = bMax;

        if (bMax < lowestUpperBound) {
          lowestUpperBound = bMax;
          seed1 = i;
        }
        if (bMin > highestLowerBound) {
          highestLowerBound = bMin;
          seed2 = i;
        }
      }

      final width = maxCoord - minCoord;
      final separation = width > 0
          ? (highestLowerBound - lowestUpperBound) / width
          : 0.0;

      if (seed1 != seed2 && separation > maxNormalizedSeparation) {
        maxNormalizedSeparation = separation;
        bestSeed1 = seed1;
        bestSeed2 = seed2;
      }
    }

    return (first: bestSeed1, second: bestSeed2);
  }
}
