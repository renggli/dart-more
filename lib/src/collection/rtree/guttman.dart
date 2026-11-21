import '../rtree.dart';
import 'bounds.dart';
import 'entry.dart';
import 'node.dart';
import 'utils.dart';

/// Guttman R-Tree described by Guttman (1984) with an `O(M^2)` quadratic split
/// algorithm.
class GuttmanTree<T> extends RTree<T> {
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
    final (:first, :second) = _pickSeeds(entries);
    final seed1 = entries[first];
    final seed2 = entries[second];
    // Remove higher index first so the lower index stays valid.
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
      // If one group has so few entries that all the rest must be assigned to
      // it in order to meet the minEntries requirement, assign them and stop.
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
      // Pick the next entry to assign.
      final area1 = bounds1.area;
      final area2 = bounds2.area;
      final (:index, :enlargement1, :enlargement2) = _pickNext(
        entries,
        bounds1,
        area1,
        bounds2,
        area2,
      );
      final entry = entries[index];
      // Swap-and-pop removal in O(1).
      entries[index] = entries.last;
      entries.removeLast();

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

  ({int first, int second}) _pickSeeds(List<RTreeEntry<T>> entries) {
    final areas = List<double>.generate(
      entries.length,
      (i) => entries[i].bounds.area,
      growable: false,
    );
    var seed1 = 0;
    var seed2 = 1;
    var maxWastedArea = double.negativeInfinity;
    for (var i = 0; i < entries.length - 1; i++) {
      final boundsI = entries[i].bounds;
      final areaI = areas[i];
      for (var j = i + 1; j < entries.length; j++) {
        final wastedArea =
            boundsI.unionArea(entries[j].bounds) - areaI - areas[j];
        if (wastedArea > maxWastedArea) {
          maxWastedArea = wastedArea;
          seed1 = i;
          seed2 = j;
        }
      }
    }
    return (first: seed1, second: seed2);
  }

  ({int index, double enlargement1, double enlargement2}) _pickNext(
    List<RTreeEntry<T>> entries,
    Bounds bounds1,
    double area1,
    Bounds bounds2,
    double area2,
  ) {
    var bestIndex = 0;
    var bestD1 = bounds1.unionArea(entries[0].bounds) - area1;
    var bestD2 = bounds2.unionArea(entries[0].bounds) - area2;
    var maxDiff = (bestD1 - bestD2).abs();
    for (var i = 1; i < entries.length; i++) {
      final entryBounds = entries[i].bounds;
      final d1 = bounds1.unionArea(entryBounds) - area1;
      final d2 = bounds2.unionArea(entryBounds) - area2;
      final diff = (d1 - d2).abs();
      if (diff > maxDiff) {
        maxDiff = diff;
        bestIndex = i;
        bestD1 = d1;
        bestD2 = d2;
      }
    }
    return (index: bestIndex, enlargement1: bestD1, enlargement2: bestD2);
  }
}
