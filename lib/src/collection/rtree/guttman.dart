import '../iterable/combinations.dart';
import '../rtree.dart';
import 'bounds.dart';
import 'entry.dart';
import 'node.dart';
import 'utils.dart';

/// Guttman R-Tree described in this paper:
/// http://www-db.deis.unibo.it/courses/SI-LS/papers/Gut84.pdf
class GuttmanTree<T> extends RTree<T> {
  GuttmanTree({super.minEntries, super.maxEntries});

  @override
  RTreeNode<T> chooseLeaf(RTreeEntry<T> entry) {
    var node = root;
    while (!node.isLeaf) {
      final leastAreaEnlargement =
          entryWithLeastAreaEnlargement(node.entries, entry.bounds);
      node = leastAreaEnlargement.child!;
    }
    return node;
  }

  @override
  RTreeNode<T>? overflowStrategy(RTreeNode<T> node) {
    final entries = node.entries.toList();
    final seeds = _pickSeeds(entries);
    final seed1 = seeds[0], seed2 = seeds[1];
    entries
      ..remove(seed1)
      ..remove(seed2);
    final group1 = [seed1];
    var bounds1 = seed1.bounds;
    final group2 = [seed2];
    var bounds2 = seed2.bounds;
    while (entries.isNotEmpty) {
      // If one group has so few entries that all the rest must be assigned to it in order for it to meet the
      // min_entries requirement, assign them and stop. (If both groups are underfull, then proceed with the
      // algorithm to determine the best group to extend.)
      final group1Underfull = group1.length < minEntries &&
          minEntries <= group1.length + entries.length;
      final group2Underfull = group2.length < minEntries &&
          minEntries <= group2.length + entries.length;
      if (group1Underfull && !group2Underfull) {
        group1.addAll(entries);
        break;
      }
      if (!group1Underfull && group2Underfull) {
        group2.addAll(entries);
        break;
      }
      // Pick the next entry to assign.
      final area1 = bounds1.area, area2 = bounds2.area;
      final entry = _pickNext(entries, bounds1, area1, bounds2, area2);
      // Add it to the group whose covering rectangle will have to be enlarged
      // the least to accommodate it. Resolve ties by adding the entry to the
      // group with the smaller area, then to the one with fewer entries, then
      // to either.
      final uBounds1 = bounds1.union(entry.bounds);
      final uBounds2 = bounds2.union(entry.bounds);
      final enlargement1 = uBounds1.area - area1;
      final enlargement2 = uBounds2.area - area2;
      late List<RTreeEntry<T>> group;
      if (enlargement1 == enlargement2) {
        if (area1 == area2) {
          group = group1.length < group2.length ? group1 : group2;
        } else {
          group = area1 < area2 ? group1 : group2;
        }
      } else {
        group = enlargement1 < enlargement2 ? group1 : group2;
      }
      group.add(entry);
      // Update the winning group's covering rectangle
      if (group == group1) {
        bounds1 = uBounds1;
      } else {
        bounds2 = uBounds2;
      }
      // update entries list
      entries.remove(entry);
    }
    return splitNode(node, group1, group2);
  }

  @override
  void adjustTree(RTreeNode<T> node, RTreeNode<T>? splitNode) {
    while (!node.isRoot) {
      final parent = node.parent!;
      node.parentEntry!.bounds =
          Bounds.unionAll(node.entries.map((entry) => entry.bounds));
      if (splitNode != null) {
        final bounds =
            Bounds.unionAll(splitNode.entries.map((entry) => entry.bounds));
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

  List<RTreeEntry<T>> _pickSeeds(List<RTreeEntry<T>> entries) {
    var seeds = <RTreeEntry<T>>[];
    var maxWastedArea = double.negativeInfinity;
    for (final combination in entries.combinations(2)) {
      final combinedBounds = combination[0].bounds.union(combination[1].bounds);
      final wastedArea = combinedBounds.area -
          combination[0].bounds.area -
          combination[1].bounds.area;
      if (wastedArea > maxWastedArea) {
        maxWastedArea = wastedArea;
        seeds = combination;
      }
    }
    return seeds;
  }

  RTreeEntry<T> _pickNext(List<RTreeEntry<T>> entries, Bounds bounds1,
      double area1, Bounds bounds2, double area2) {
    late RTreeEntry<T> result;
    var maxDiff = double.negativeInfinity;
    for (final entry in entries) {
      final d1 = bounds1.union(entry.bounds).area - area1;
      final d2 = bounds2.union(entry.bounds).area - area2;
      final diff = (d1 - d2).abs();
      if (diff > maxDiff) {
        maxDiff = diff;
        result = entry;
      }
    }
    return result;
  }
}
