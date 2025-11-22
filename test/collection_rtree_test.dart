// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:more/collection.dart';
import 'package:test/test.dart';

void allRTreeTests(
  RTree<T> Function<T>({int? minEntries, int? maxEntries}) createRTree,
) {
  void validate<T>(RTree<T> tree, [RTreeNode<T>? parent, RTreeNode<T>? node]) {
    node ??= tree.root;
    expect(node.tree, same(tree));
    expect(node.parent, same(parent));
    if (node.isRoot) expect(node, same(tree.root));
    if (parent != null) {
      final parentEntry = node.parentEntry!;
      expect(node, same(parentEntry.child));
      for (final entry in node.entries) {
        expect(parentEntry.bounds.contains(entry.bounds), isTrue);
      }
    }
    for (final entry in node.entries) {
      if (entry.isLeaf) {
        expect(entry.data, isNotNull);
        expect(entry.child, isNull);
      } else {
        expect(entry.data, isNull);
        expect(entry.child, isNotNull);
        validate(tree, node, entry.child);
      }
    }
  }

  test('stress', () {
    final rtree = createRTree<int>();
    final random = Random(3212312);
    final bounds = <Bounds>[];
    for (var i = 0; i < 1000; i++) {
      final bound = Bounds.fromPoint(
        List.generate(3, (index) => 2000 * random.nextDouble() - 1000),
      );
      rtree.insert(bound, i);
      bounds.add(bound);
    }
    for (var i = 0; i < bounds.length; i++) {
      expect(rtree.searchNodes(), isNotEmpty);
      expect(rtree.searchEntries(), isNotEmpty);
      expect(rtree.queryEntries(bounds[i]), isNotEmpty);
      expect(rtree.queryNodes(bounds[i], leaves: true), isNotEmpty);
      expect(rtree.queryNodes(bounds[i], leaves: false), isNotEmpty);
    }
    validate(rtree);
  });
}

void main() {
  group('bounds', () {
    final point1 = Bounds.fromPoint([1, 2, 3]);
    final point2 = Bounds.fromLists([3, 2, 1], [3, 2, 1]);
    final bound1 = Bounds.fromLists([-1, -1, -1], [1, 1, 1]);
    final bound2 = Bounds.fromLists([-2, 1, 2], [2, 3, 5]);
    final bound3 = Bounds.fromLists([-1, 2, 1], [3, 4, 4]);
    final bound4 = Bounds.fromLists([-1, 2, 2], [2, 3, 4]);
    test('length', () {
      expect(point1.length, 3);
      expect(point2.length, 3);
      expect(bound1.length, 3);
      expect(bound2.length, 3);
    });
    test('isPoint', () {
      expect(point1.isPoint, isTrue);
      expect(point2.isPoint, isTrue);
      expect(bound1.isPoint, isFalse);
      expect(bound2.isPoint, isFalse);
    });
    test('edges', () {
      expect(point1.edges, [0, 0, 0]);
      expect(point2.edges, [0, 0, 0]);
      expect(bound1.edges, [2, 2, 2]);
      expect(bound2.edges, [4, 2, 3]);
    });
    test('area', () {
      expect(point1.area, 0);
      expect(point2.area, 0);
      expect(bound1.area, 8);
      expect(bound2.area, 24);
    });
    test('center', () {
      expect(point1.center, [1, 2, 3]);
      expect(point2.center, [3, 2, 1]);
      expect(bound1.center, [0, 0, 0]);
      expect(bound2.center, [0, 2, 3.5]);
    });
    test('contains', () {
      expect(point1.contains(point1), isTrue);
      expect(point1.contains(point2), isFalse);
      expect(point1.contains(bound1), isFalse);
      expect(point1.contains(bound2), isFalse);

      expect(point2.contains(point1), isFalse);
      expect(point2.contains(point2), isTrue);
      expect(point2.contains(bound1), isFalse);
      expect(point2.contains(bound2), isFalse);

      expect(bound1.contains(point1), isFalse);
      expect(bound1.contains(point2), isFalse);
      expect(bound1.contains(bound1), isTrue);
      expect(bound1.contains(bound2), isFalse);

      expect(bound2.contains(point1), isTrue);
      expect(bound2.contains(point2), isFalse);
      expect(bound2.contains(bound1), isFalse);
      expect(bound2.contains(bound2), isTrue);
    });
    test('union', () {
      final pointUnion = point1.union(point2);
      expect(pointUnion.min, [1, 2, 1]);
      expect(pointUnion.max, [3, 2, 3]);
      final boundUnion = bound1.union(bound2);
      expect(boundUnion.min, [-2, -1, -1]);
      expect(boundUnion.max, [2, 3, 5]);
      final pointBoundUnion = point1.union(bound1);
      expect(pointBoundUnion.min, [-1, -1, -1]);
      expect(pointBoundUnion.max, [1, 2, 3]);
    });
    test('intersects', () {
      expect(point1.intersects(point1), isTrue);
      expect(point1.intersects(point2), isFalse);
      expect(point1.intersects(bound1), isFalse);
      expect(point1.intersects(bound2), isTrue);

      expect(point2.intersects(point1), isFalse);
      expect(point2.intersects(point2), isTrue);
      expect(point2.intersects(bound1), isFalse);
      expect(point2.intersects(bound2), isFalse);

      expect(bound1.intersects(point1), isFalse);
      expect(bound1.intersects(point2), isFalse);
      expect(bound1.intersects(bound1), isTrue);
      expect(bound1.intersects(bound2), isFalse);

      expect(bound2.intersects(point1), isTrue);
      expect(bound2.intersects(point2), isFalse);
      expect(bound2.intersects(bound1), isFalse);
      expect(bound2.intersects(bound2), isTrue);

      expect(bound2.intersects(bound3), isTrue);
      expect(bound3.intersects(bound2), isTrue);
    });
    test('intersection', () {
      expect(point1.intersection(point1), point1);
      expect(point1.intersection(point2), isNull);
      expect(point1.intersection(bound1), isNull);
      expect(point1.intersection(bound2), point1);

      expect(point2.intersection(point1), isNull);
      expect(point2.intersection(point2), point2);
      expect(point2.intersection(bound1), isNull);
      expect(point2.intersection(bound2), isNull);

      expect(bound1.intersection(point1), isNull);
      expect(bound1.intersection(point2), isNull);
      expect(bound1.intersection(bound1), bound1);
      expect(bound1.intersection(bound2), isNull);

      expect(bound2.intersection(point1), point1);
      expect(bound2.intersection(point2), isNull);
      expect(bound2.intersection(bound1), isNull);
      expect(bound2.intersection(bound2), bound2);

      expect(bound2.intersection(bound3), bound4);
      expect(bound3.intersection(bound2), bound4);
    });
    test('==', () {
      expect(point1, point1);
      expect(point1, isNot(point2));
      expect(point1, isNot(bound1));
      expect(point1, isNot(bound2));

      expect(point2, isNot(point1));
      expect(point2, point2);
      expect(point2, isNot(bound1));
      expect(point2, isNot(bound2));

      expect(bound1, isNot(point1));
      expect(bound1, isNot(point2));
      expect(bound1, bound1);
      expect(bound1, isNot(bound2));

      expect(bound2, isNot(point1));
      expect(bound2, isNot(point2));
      expect(bound2, isNot(bound1));
      expect(bound2, bound2);
    });
    test('hashCode', () {
      expect(point1.hashCode, point1.hashCode);
      expect(point1.hashCode, isNot(point2.hashCode));
      expect(point1.hashCode, isNot(bound1.hashCode));
      expect(point1.hashCode, isNot(bound2.hashCode));

      expect(point2.hashCode, isNot(point1.hashCode));
      expect(point2.hashCode, point2.hashCode);
      expect(point2.hashCode, isNot(bound1.hashCode));
      expect(point2.hashCode, isNot(bound2.hashCode));

      expect(bound1.hashCode, isNot(point1.hashCode));
      expect(bound1.hashCode, isNot(point2.hashCode));
      expect(bound1.hashCode, bound1.hashCode);
      expect(bound1.hashCode, isNot(bound2.hashCode));

      expect(bound2.hashCode, isNot(point1.hashCode));
      expect(bound2.hashCode, isNot(point2.hashCode));
      expect(bound2.hashCode, isNot(bound1.hashCode));
      expect(bound2.hashCode, bound2.hashCode);
    });
    test('toString', () {
      expect(
        point1.toString(),
        matches(RegExp(r'Bounds\(1(.0)?, 2(.0)?, 3(.0)?\)')),
      );
      expect(
        point2.toString(),
        matches(RegExp(r'Bounds\(3(.0)?, 2(.0)?, 1(.0)?\)')),
      );
      expect(
        bound1.toString(),
        matches(
          RegExp(
            r'Bounds\(-1(.0)?, -1(.0)?, -1(.0)?; 1(.0)?, 1(.0)?, 1(.0)?\)',
          ),
        ),
      );
      expect(
        bound2.toString(),
        matches(
          RegExp(r'Bounds\(-2(.0)?, 1(.0)?, 2(.0)?; 2(.0)?, 3(.0)?, 5(.0)?\)'),
        ),
      );
    });
    test('unionAll', () {
      expect(() => Bounds.unionAll([]), throwsStateError);
      final singleUnion = Bounds.unionAll([bound1]);
      expect(singleUnion.min, bound1.min);
      expect(singleUnion.max, bound1.max);
      final fullUnion1 = Bounds.unionAll([point1, point2, bound1, bound2]);
      expect(fullUnion1.min, [-2.0, -1.0, -1.0]);
      expect(fullUnion1.max, [3.0, 3.0, 5.0]);
      final fullUnion2 = Bounds.unionAll([bound1, bound2, point2]);
      expect(fullUnion2.min, [-2.0, -1.0, -1.0]);
      expect(fullUnion2.max, [3.0, 3.0, 5.0]);
    });
    test('intersectionAll', () {
      expect(() => Bounds.intersectionAll([]), throwsStateError);
      final singleUnion = Bounds.intersectionAll([bound1]);
      expect(singleUnion?.min, bound1.min);
      expect(singleUnion?.max, bound1.max);
      final emptyUnion = Bounds.intersectionAll([bound1, bound2]);
      expect(emptyUnion, isNull);
      final fullUnion1 = Bounds.intersectionAll([bound2, bound3]);
      expect(fullUnion1?.min, bound4.min);
      expect(fullUnion1?.max, bound4.max);
      final fullUnion2 = Bounds.intersectionAll([bound2, bound3, point1]);
      expect(fullUnion2?.min, point1.min);
      expect(fullUnion2?.max, point1.max);
    });
  });
  group('guttman', () {
    allRTreeTests(
      <T>({int? minEntries, int? maxEntries}) =>
          RTree<T>.guttmann(minEntries: minEntries, maxEntries: maxEntries),
    );
  });
}
