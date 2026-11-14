import '../rtree.dart';
import 'bounds.dart';
import 'entry.dart';
import 'node.dart';

/// Linear R-Tree described by Guttman (1984) with an _O(n)_ split algorithm.
class LinearRTree<T> extends RTree<T> {
  new({super.minEntries, super.maxEntries});

  @override
  RTreeNode<T> chooseLeaf(RTreeEntry<T> entry) {
    var node = root;
    while (!node.isLeaf) {
      node = _chooseEntry(node.entries, entry.bounds).child!;
    }
    return node;
  }

  @override
  RTreeNode<T>? overflowStrategy(RTreeNode<T> node) {
    final entries = node.entries.toList();
    final seeds = _linearPickSeeds(entries);
    final seed1 = seeds[0], seed2 = seeds[1];
    entries
      ..remove(seed1)
      ..remove(seed2);
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
      final uBounds1 = bounds1.union(entry.bounds);
      final uBounds2 = bounds2.union(entry.bounds);
      final enlargement1 = uBounds1.area - bounds1.area;
      final enlargement2 = uBounds2.area - bounds2.area;

      late List<RTreeEntry<T>> group;
      if (enlargement1 == enlargement2) {
        final area1 = bounds1.area;
        final area2 = bounds2.area;
        if (area1 == area2) {
          group = group1.length < group2.length ? group1 : group2;
        } else {
          group = area1 < area2 ? group1 : group2;
        }
      } else {
        group = enlargement1 < enlargement2 ? group1 : group2;
      }

      group.add(entry);
      if (group == group1) {
        bounds1 = uBounds1;
      } else {
        bounds2 = uBounds2;
      }
    }
    return splitNode(node, group1, group2);
  }

  @override
  void adjustTree(RTreeNode<T> node, RTreeNode<T>? splitNode) {
    while (!node.isRoot) {
      final parent = node.parent!;
      node.parentEntry!.bounds = Bounds.unionAll(
        node.entries.map((entry) => entry.bounds),
      );
      if (splitNode != null) {
        final bounds = Bounds.unionAll(
          splitNode.entries.map((entry) => entry.bounds),
        );
        final entry = RTreeEntry<T>(bounds, child: splitNode);
        parent.entries.add(entry);
        if (parent.entries.length > maxEntries) {
          splitNode = overflowStrategy(parent);
        } else {
          splitNode = null;
        }
      }
      node = parent;
    }
    if (splitNode != null) {
      growTree([node, splitNode]);
    }
  }

  RTreeEntry<T> _chooseEntry(List<RTreeEntry<T>> entries, Bounds bounds) {
    var minIndex = 0;
    var minArea = double.infinity;
    var minEnlargement = double.infinity;
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final beforeArea = entry.bounds.area;
      final afterArea = entry.bounds.union(bounds).area;
      final enlargement = afterArea - beforeArea;
      if (enlargement < minEnlargement ||
          (enlargement == minEnlargement && beforeArea < minArea)) {
        minIndex = i;
        minArea = beforeArea;
        minEnlargement = enlargement;
      }
    }
    return entries[minIndex];
  }

  List<RTreeEntry<T>> _linearPickSeeds(List<RTreeEntry<T>> entries) {
    final dimensions = entries.first.bounds.length;
    var maxNormalizedSeparation = -1.0;
    var bestSeed1 = entries[0];
    var bestSeed2 = entries[1];

    for (var d = 0; d < dimensions; d++) {
      var lowestUpperBound = entries[0].bounds.getMax(d);
      var highestLowerBound = entries[0].bounds.getMin(d);
      var seed1 = entries[0];
      var seed2 = entries[0];

      var minCoord = entries[0].bounds.getMin(d);
      var maxCoord = entries[0].bounds.getMax(d);

      for (var i = 1; i < entries.length; i++) {
        final entry = entries[i];
        final b = entry.bounds;
        final bMin = b.getMin(d);
        final bMax = b.getMax(d);
        if (bMin < minCoord) minCoord = bMin;
        if (bMax > maxCoord) maxCoord = bMax;

        if (bMax < lowestUpperBound) {
          lowestUpperBound = bMax;
          seed1 = entry;
        }
        if (bMin > highestLowerBound) {
          highestLowerBound = bMin;
          seed2 = entry;
        }
      }

      final width = maxCoord - minCoord;
      final separation = width > 0
          ? (highestLowerBound - lowestUpperBound).abs() / width
          : 0.0;

      if (separation > maxNormalizedSeparation) {
        maxNormalizedSeparation = separation;
        bestSeed1 = seed1;
        bestSeed2 = seed2;
      }
    }

    if (bestSeed1 == bestSeed2) {
      bestSeed1 = entries[0];
      bestSeed2 = entries[1];
    }
    return [bestSeed1, bestSeed2];
  }
}
