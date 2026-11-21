import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void allRTreeTests(
  String name,
  RTree<T> Function<T>({int? minEntries, int? maxEntries}) createRTree,
) {
  group(name, () {
    void validate<T>(
      RTree<T> tree, [
      RTreeNode<T>? parent,
      RTreeNode<T>? node,
    ]) {
      node ??= tree.root;
      check(node.tree).identicalTo(tree);
      check(node.parent).identicalTo(parent);
      if (node.isRoot) check(node).identicalTo(tree.root);
      if (parent != null) {
        final parentEntry = node.parentEntry!;
        check(node).identicalTo(parentEntry.child!);
        for (final entry in node.entries) {
          check(parentEntry.bounds.contains(entry.bounds)).isTrue;
        }
      }
      for (final entry in node.entries) {
        if (entry.isLeaf) {
          check(entry.data).isNotNull();
          check(entry.child).isNull;
        } else {
          check(entry.data).isNull;
          check(entry.child).isNotNull();
          validate(tree, node, entry.child);
        }
      }
    }

    test('stress', () {
      final rtree = createRTree<int>();
      final random = Random(3212312);
      final bounds = <Bounds>[];
      for (var i = 0; i < 1000; i++) {
        final bound = Bounds.fromList(
          List.generate(3, (index) => 2000.0 * random.nextDouble() - 1000.0),
        );
        rtree.insert(bound, i);
        bounds.add(bound);
      }
      check(rtree.length).equals(1000);
      check(rtree.isEmpty).isFalse;
      check(rtree.isNotEmpty).isTrue;
      check(rtree.toList().length).equals(1000);

      for (var i = 0; i < bounds.length; i += 20) {
        check(rtree.searchNodes()).isNotEmpty;
        check(rtree.searchEntries()).isNotEmpty;
        check(rtree.queryEntries(bounds[i])).isNotEmpty;
        check(rtree.query(bounds[i])).isNotEmpty;
        check(rtree.queryNodes(bounds[i], leaves: true)).isNotEmpty;
        check(rtree.queryNodes(bounds[i], leaves: false)).isNotEmpty;
      }
      validate(rtree);
    });

    test('empty tree query', () {
      final rtree = createRTree<int>();
      final queryBound = Bounds.fromList([0.0, 0.0]);
      check(rtree.root.bounds).isNull;
      check(rtree.bounds).isNull;
      check(rtree.length).equals(0);
      check(rtree.isEmpty).isTrue;
      check(rtree.queryEntries(queryBound)).isEmpty;
      check(rtree.query(queryBound)).isEmpty;
      check(rtree.queryNodes(queryBound)).isEmpty;
      check(rtree.nearest(Bounds.fromList([0.0, 0.0]))).isEmpty;
      check(rtree.nearest(Bounds.fromList([0.0, 0.0]), k: -1)).isEmpty;
    });

    test('nearest search multi-level', () {
      final rtree = createRTree<String>(minEntries: 2, maxEntries: 4);
      rtree.insert(Bounds.fromList([0.0, 0.0]), 'origin');
      rtree.insert(Bounds.fromList([10.0, 0.0]), 'p10');
      rtree.insert(Bounds.fromList([20.0, 0.0]), 'p20');
      rtree.insert(Bounds.fromList([100.0, 100.0]), 'far');

      // Expand to height > 1 to exercise internal node expansion in nearest
      for (var i = 1; i <= 30; i++) {
        rtree.insert(
          Bounds.fromList([i.toDouble() * 3, i.toDouble() * 3]),
          'item_$i',
        );
      }

      final nearest1 = rtree
          .nearest(Bounds.fromList([1.0, 0.0]), k: 1)
          .toList();
      check(nearest1).deepEquals(['origin']);

      final nearestEntries = rtree
          .nearestEntries(Bounds.fromList([1.0, 0.0]), k: 2)
          .toList();
      check(nearestEntries.length).equals(2);
      check(nearestEntries[0].data).equals('origin');

      final withMaxDist = rtree
          .nearest(Bounds.fromList([0.0, 0.0]), k: 5, maxDistance: 15)
          .toList();
      check(withMaxDist).contains('origin');
      check(withMaxDist).contains('p10');
      check(withMaxDist).not(.it()..contains('far'));
    });

    test('remove with dataPredicate and condensation to empty', () {
      final rtree = createRTree<int>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 20; i++) {
        rtree.insert(Bounds.fromList([i.toDouble(), 0.0]), i);
      }
      check(rtree.length).equals(20);

      // Remove with dataPredicate failing
      final pt5 = Bounds.fromList([5.0, 0.0]);
      check(rtree.remove(pt5, dataPredicate: (d) => d == 999)).isFalse;
      check(rtree.length).equals(20);

      // Remove with dataPredicate matching
      check(rtree.remove(pt5, dataPredicate: (d) => d == 5)).isTrue;
      check(rtree.length).equals(19);

      // Remove non-existent bound
      check(rtree.remove(Bounds.fromList([999.0, 999.0]))).isFalse;
      check(rtree.length).equals(19);

      // Remove all elements one by one until completely empty
      for (var i = 0; i < 20; i++) {
        if (i == 5) continue;
        check(rtree.remove(Bounds.fromList([i.toDouble(), 0.0]))).isTrue;
      }
      check(rtree.length).equals(0);
      check(rtree.isEmpty).isTrue;
      check(rtree.root.isLeaf).isTrue;
      check(rtree.root.entries).isEmpty;

      // Clear empty
      rtree.clear();
      check(rtree.length).equals(0);
      check(rtree.isEmpty).isTrue;
    });

    test('2D bounds insertion and query', () {
      final rtree = createRTree<String>();
      rtree.insert(Bounds.from2D(0.0, 0.0, 10.0, 10.0), 'box1');
      rtree.insert(Bounds.from2D(20.0, 20.0, 30.0, 30.0), 'box2');
      rtree.insert(Bounds.fromList([5.0, 5.0]), 'point1');

      check(rtree.query(Bounds.from2D(2.0, 2.0, 8.0, 8.0)))
          .unorderedEquals(['box1', 'point1']);
      check(rtree.query(Bounds.from2D(15.0, 15.0, 25.0, 25.0)))
          .deepEquals(['box2']);
    });
  });
}

void main() {
  allRTreeTests('guttman', RTree.guttman);
  allRTreeTests('linear', RTree.linear);
  allRTreeTests('rStar', RTree.rStar);

  group('guttman specifics', () {
    test('split distribution', () {
      final rtree = RTree<int>.guttman(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 5; i++) {
        rtree.insert(Bounds.fromList([i.toDouble()]), i);
      }
      check(rtree.root.entries).length.equals(2);
      for (final child in rtree.root.entries) {
        check(child.child!.entries.length).isGreaterOrEqual(2);
      }
    });

    test('searchEntries with entryPredicate', () {
      final rtree = RTree<int>.guttman();
      rtree.insert(Bounds.fromList(const [0.0, 0.0]), 10);
      rtree.insert(Bounds.fromList(const [1.0, 1.0]), 20);
      check(
        rtree
            .searchEntries(entryPredicate: (entry) => entry.data == 10)
            .map((entry) => entry.data),
      ).deepEquals([10]);
    });

    test('guttman split tie breaking and equal diffs', () {
      final rtree = RTree<int>.guttman(minEntries: 2, maxEntries: 4);
      rtree.insert(Bounds.fromList(const [0.0], const [10.0]), 1);
      rtree.insert(Bounds.fromList(const [100.0], const [110.0]), 2);
      rtree.insert(Bounds.fromList(const [50.0], const [60.0]), 3);
      rtree.insert(Bounds.fromList(const [30.0], const [30.0]), 4);
      rtree.insert(Bounds.fromList(const [5.0], const [5.0]), 5);
      check(rtree.root.entries).length.equals(2);

      // Asymmetric area boxes to force enlargement1 == enlargement2 with area1 != area2 tie breaking
      final rtreeTie = RTree<int>.guttman(minEntries: 2, maxEntries: 4);
      rtreeTie.insert(Bounds.fromList(const [0.0, 0.0], const [2.0, 2.0]), 1);
      rtreeTie.insert(
        Bounds.fromList(const [100.0, 0.0], const [104.0, 2.0]),
        2,
      );
      rtreeTie.insert(Bounds.fromList(const [0.0, 0.0], const [2.0, 2.0]), 3);
      rtreeTie.insert(
        Bounds.fromList(const [100.0, 0.0], const [104.0, 2.0]),
        4,
      );
      rtreeTie.insert(Bounds.fromList(const [50.0, 0.0], const [52.0, 2.0]), 5);
      check(rtreeTie.length).equals(5);
    });
  });

  group('linear specifics', () {
    test('identical seeds split fallback', () {
      final rtree = RTree<int>.linear(minEntries: 2, maxEntries: 4);
      // Insert identical bounds to force seed1 == seed2 fallback
      for (var i = 0; i < 5; i++) {
        rtree.insert(Bounds.fromList(const [10.0, 10.0]), i);
      }
      check(rtree.length).equals(5);
      check(rtree.root.entries.length).equals(2);
    });

    test('linear split tie breaking', () {
      final rtree = RTree<int>.linear(minEntries: 2, maxEntries: 4);
      rtree.insert(Bounds.fromList(const [0.0, 0.0], const [2.0, 2.0]), 1);
      rtree.insert(Bounds.fromList(const [100.0, 0.0], const [104.0, 2.0]), 2);
      rtree.insert(Bounds.fromList(const [0.0, 0.0], const [2.0, 2.0]), 3);
      rtree.insert(Bounds.fromList(const [100.0, 0.0], const [104.0, 2.0]), 4);
      rtree.insert(Bounds.fromList(const [50.0, 0.0], const [52.0, 2.0]), 5);
      check(rtree.length).equals(5);
    });
  });

  group('rstar specifics', () {
    test('multi-level tree with overlap minimization', () {
      final rtree = RTree<int>.rStar(minEntries: 2, maxEntries: 4);
      // Inserting enough items creates multiple levels above leaves
      for (var i = 0; i < 40; i++) {
        rtree.insert(
          Bounds.fromList(
            [i.toDouble() * 2, i.toDouble() * 2],
            [i.toDouble() * 2 + 3, i.toDouble() * 2 + 3],
          ),
          i,
        );
      }
      check(rtree.length).equals(40);
    });

    test('protected methods chooseLeaf, overflowStrategy and adjustTree', () {
      final rtree = RTree<int>.rStar(minEntries: 2, maxEntries: 4);
      final e1 = RTreeEntry<int>(Bounds.fromList(const [1.0, 1.0]), data: 1);
      final e2 = RTreeEntry<int>(Bounds.fromList(const [2.0, 2.0]), data: 2);
      final e3 = RTreeEntry<int>(Bounds.fromList(const [3.0, 3.0]), data: 3);
      final e4 = RTreeEntry<int>(Bounds.fromList(const [4.0, 4.0]), data: 4);
      final e5 = RTreeEntry<int>(Bounds.fromList(const [5.0, 5.0]), data: 5);

      // ignore: invalid_use_of_protected_member
      final leaf = rtree.chooseLeaf(e1);
      check(leaf.isLeaf).isTrue;

      leaf.entries.addAll([e1, e2, e3, e4, e5]);
      // ignore: invalid_use_of_protected_member
      final split = rtree.overflowStrategy(leaf);
      check(split).isNotNull();

      // ignore: invalid_use_of_protected_member
      rtree.adjustTree(leaf, split);
    });
  });

  group('Point and Rectangle integration', () {
    test('toBounds extensions and factory constructors', () {
      const pt = Point(3.5, 4.5);
      check(pt.toBounds().min).deepEquals([3.5, 4.5]);
      check(Bounds.fromPoint(pt).min).deepEquals([3.5, 4.5]);

      const rect = Rectangle(1.0, 2.0, 10.0, 20.0);
      check(rect.toBounds().min).deepEquals([1.0, 2.0]);
      check(rect.toBounds().max).deepEquals([11.0, 22.0]);
      check(Bounds.fromRectangle(rect).min).deepEquals([1.0, 2.0]);
      check(Bounds.fromRectangle(rect).max).deepEquals([11.0, 22.0]);

      final list3D = [1.0, 2.0, 3.0];
      final bList = list3D.toBounds();
      check(bList.length).equals(3);
      check(bList.min).deepEquals([1.0, 2.0, 3.0]);
      check(Bounds.fromList(list3D).min).deepEquals([1.0, 2.0, 3.0]);

      final b2D = Bounds.from2D(1.0, 2.0, 4.0, 6.0);
      check(b2D.min).deepEquals([1.0, 2.0]);
      check(b2D.max).deepEquals([4.0, 6.0]);

      final bPair = Bounds.fromList([1.0, 2.0], [3.0, 4.0]);
      check(bPair.min).deepEquals([1.0, 2.0]);
      check(bPair.max).deepEquals([3.0, 4.0]);
    });

    test('RTree operations with Point and Rectangle toBounds', () {
      final tree = RTree<String>.rStar();
      tree.insert(const Point(5.0, 5.0).toBounds(), 'ptA');
      tree.insert(const Rectangle(0.0, 0.0, 10.0, 10.0).toBounds(), 'rectA');
      tree.insert(const Rectangle(50.0, 50.0, 20.0, 20.0).toBounds(), 'rectB');

      // query with Rectangle toBounds
      final hits = tree
          .query(const Rectangle(2.0, 2.0, 6.0, 6.0).toBounds())
          .toList();
      check(hits).unorderedEquals(['ptA', 'rectA']);

      // nearest with Point toBounds
      final nearest = tree
          .nearest(const Point(4.0, 4.0).toBounds(), k: 2)
          .toList();
      check(nearest).deepEquals(['rectA', 'ptA']);

      // remove with Point toBounds
      check(tree.remove(const Point(5.0, 5.0).toBounds())).isTrue;
      check(tree.length).equals(2);

      // remove with Rectangle toBounds
      check(tree.remove(const Rectangle(0.0, 0.0, 10.0, 10.0).toBounds()))
          .isTrue;
      check(tree.length).equals(1);
      check(tree.remove(const Rectangle(99.0, 99.0, 1.0, 1.0).toBounds()))
          .isFalse;
    });
  });

  group('validation and edge cases', () {
    test('constructor parameter validation', () {
      check(() => RTree<int>.guttman(maxEntries: 1)).throws<ArgumentError>();
      check(() => RTree<int>.guttman(minEntries: 0, maxEntries: 4))
          .throws<ArgumentError>();
      check(() => RTree<int>.guttman(minEntries: 3, maxEntries: 4))
          .throws<ArgumentError>();
      check(() => RTree<int>.rStar(reinsertFactor: -0.1))
          .throws<ArgumentError>();
      check(() => RTree<int>.rStar(reinsertFactor: 1.1))
          .throws<ArgumentError>();
      check(() => RTree<int>.rStar(reinsertFactor: double.nan))
          .throws<ArgumentError>();

      // maxEntries: 4 defaults minEntries to 2 cleanly.
      final small = RTree<int>.rStar(maxEntries: 4);
      check(small.minEntries).equals(2);
      check(small.maxEntries).equals(4);
      for (var i = 0; i < 20; i++) {
        small.insert(Bounds.from2D(i.toDouble(), i.toDouble()), i);
      }
      check(small.length).equals(20);

      // reinsertFactor: 0.0 disables reinsertion.
      final noReinsert = RTree<int>.rStar(reinsertFactor: 0.0);
      for (var i = 0; i < 20; i++) {
        noReinsert.insert(Bounds.from2D(i.toDouble(), i.toDouble()), i);
      }
      check(noReinsert.length).equals(20);
    });
    test('nearest rejects negative or NaN maxDistance', () {
      final tree = RTree<int>.rStar();
      tree.insert(Bounds.from2D(0.0, 0.0), 1);
      tree.insert(Bounds.from2D(1.0, 1.0), 2);
      final q = Bounds.from2D(0.0, 0.0);
      check(tree.nearest(q, maxDistance: -5.0)).isEmpty;
      check(tree.nearest(q, maxDistance: double.negativeInfinity)).isEmpty;
      check(tree.nearest(q, maxDistance: double.nan)).isEmpty;
      check(tree.nearest(q, k: 0)).isEmpty;
    });
  });
}
