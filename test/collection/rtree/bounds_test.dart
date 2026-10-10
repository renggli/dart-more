import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('bounds', () {
    final point1 = Bounds.fromPoint([1, 2, 3]);
    final point2 = Bounds.fromLists([3, 2, 1], [3, 2, 1]);
    final bound1 = Bounds.fromLists([-1, -1, -1], [1, 1, 1]);
    final bound2 = Bounds.fromLists([-2, 1, 2], [2, 3, 5]);
    final bound3 = Bounds.fromLists([-1, 2, 1], [3, 4, 4]);
    final bound4 = Bounds.fromLists([-1, 2, 2], [2, 3, 4]);

    test('length', () {
      check(point1.length).equals(3);
      check(point2.length).equals(3);
      check(bound1.length).equals(3);
      check(bound2.length).equals(3);
    });
    test('isPoint', () {
      check(point1.isPoint).isTrue();
      check(point2.isPoint).isTrue();
      check(bound1.isPoint).isFalse();
      check(bound2.isPoint).isFalse();
    });
    test('edges', () {
      check(point1.edges).deepEquals([0, 0, 0]);
      check(point2.edges).deepEquals([0, 0, 0]);
      check(bound1.edges).deepEquals([2, 2, 2]);
      check(bound2.edges).deepEquals([4, 2, 3]);
    });
    test('area', () {
      check(point1.area).equals(0);
      check(point2.area).equals(0);
      check(bound1.area).equals(8);
      check(bound2.area).equals(24);
    });
    test('center', () {
      check(point1.center).deepEquals([1, 2, 3]);
      check(point2.center).deepEquals([3, 2, 1]);
      check(bound1.center).deepEquals([0, 0, 0]);
      check(bound2.center).deepEquals([0, 2, 3.5]);
    });
    test('contains', () {
      check(point1.contains(point1)).isTrue();
      check(point1.contains(point2)).isFalse();
      check(point1.contains(bound1)).isFalse();
      check(point1.contains(bound2)).isFalse();

      check(point2.contains(point1)).isFalse();
      check(point2.contains(point2)).isTrue();
      check(point2.contains(bound1)).isFalse();
      check(point2.contains(bound2)).isFalse();

      check(bound1.contains(point1)).isFalse();
      check(bound1.contains(point2)).isFalse();
      check(bound1.contains(bound1)).isTrue();
      check(bound1.contains(bound2)).isFalse();

      check(bound2.contains(point1)).isTrue();
      check(bound2.contains(point2)).isFalse();
      check(bound2.contains(bound1)).isFalse();
      check(bound2.contains(bound2)).isTrue();
    });
    test('union', () {
      final pointUnion = point1.union(point2);
      check(pointUnion.min).deepEquals([1, 2, 1]);
      check(pointUnion.max).deepEquals([3, 2, 3]);
      final boundUnion = bound1.union(bound2);
      check(boundUnion.min).deepEquals([-2, -1, -1]);
      check(boundUnion.max).deepEquals([2, 3, 5]);
      final pointBoundUnion = point1.union(bound1);
      check(pointBoundUnion.min).deepEquals([-1, -1, -1]);
      check(pointBoundUnion.max).deepEquals([1, 2, 3]);
    });
    test('intersects', () {
      check(point1.intersects(point1)).isTrue();
      check(point1.intersects(point2)).isFalse();
      check(point1.intersects(bound1)).isFalse();
      check(point1.intersects(bound2)).isTrue();

      check(point2.intersects(point1)).isFalse();
      check(point2.intersects(point2)).isTrue();
      check(point2.intersects(bound1)).isFalse();
      check(point2.intersects(bound2)).isFalse();

      check(bound1.intersects(point1)).isFalse();
      check(bound1.intersects(point2)).isFalse();
      check(bound1.intersects(bound1)).isTrue();
      check(bound1.intersects(bound2)).isFalse();

      check(bound2.intersects(point1)).isTrue();
      check(bound2.intersects(point2)).isFalse();
      check(bound2.intersects(bound1)).isFalse();
      check(bound2.intersects(bound2)).isTrue();

      check(bound2.intersects(bound3)).isTrue();
      check(bound3.intersects(bound2)).isTrue();
    });
    test('intersection', () {
      check(point1.intersection(point1)).equals(point1);
      check(point1.intersection(point2)).isNull();
      check(point1.intersection(bound1)).isNull();
      check(point1.intersection(bound2)).equals(point1);

      check(point2.intersection(point1)).isNull();
      check(point2.intersection(point2)).equals(point2);
      check(point2.intersection(bound1)).isNull();
      check(point2.intersection(bound2)).isNull();

      check(bound1.intersection(point1)).isNull();
      check(bound1.intersection(point2)).isNull();
      check(bound1.intersection(bound1)).equals(bound1);
      check(bound1.intersection(bound2)).isNull();

      check(bound2.intersection(point1)).equals(point1);
      check(bound2.intersection(point2)).isNull();
      check(bound2.intersection(bound1)).isNull();
      check(bound2.intersection(bound2)).equals(bound2);

      check(bound2.intersection(bound3)).equals(bound4);
      check(bound3.intersection(bound2)).equals(bound4);
    });
    test('==', () {
      check(point1).equals(point1);
      check(point1).not((it) => it.equals(point2));
      check(point1).not((it) => it.equals(bound1));
      check(point1).not((it) => it.equals(bound2));

      check(point2).not((it) => it.equals(point1));
      check(point2).equals(point2);
      check(point2).not((it) => it.equals(bound1));
      check(point2).not((it) => it.equals(bound2));

      check(bound1).not((it) => it.equals(point1));
      check(bound1).not((it) => it.equals(point2));
      check(bound1).equals(bound1);
      check(bound1).not((it) => it.equals(bound2));

      check(bound2).not((it) => it.equals(point1));
      check(bound2).not((it) => it.equals(point2));
      check(bound2).not((it) => it.equals(bound1));
      check(bound2).equals(bound2);
    });
    test('hashCode', () {
      check(point1.hashCode).equals(point1.hashCode);
      check(point1.hashCode).not((it) => it.equals(point2.hashCode));
      check(point1.hashCode).not((it) => it.equals(bound1.hashCode));
      check(point1.hashCode).not((it) => it.equals(bound2.hashCode));

      check(point2.hashCode).not((it) => it.equals(point1.hashCode));
      check(point2.hashCode).equals(point2.hashCode);
      check(point2.hashCode).not((it) => it.equals(bound1.hashCode));
      check(point2.hashCode).not((it) => it.equals(bound2.hashCode));

      check(bound1.hashCode).not((it) => it.equals(point1.hashCode));
      check(bound1.hashCode).not((it) => it.equals(point2.hashCode));
      check(bound1.hashCode).equals(bound1.hashCode);
      check(bound1.hashCode).not((it) => it.equals(bound2.hashCode));

      check(bound2.hashCode).not((it) => it.equals(point1.hashCode));
      check(bound2.hashCode).not((it) => it.equals(point2.hashCode));
      check(bound2.hashCode).not((it) => it.equals(bound1.hashCode));
      check(bound2.hashCode).equals(bound2.hashCode);
    });
    test('toString', () {
      check(point1.toString())
          .matchesPattern(RegExp(r'Bounds\(1(.0)?, 2(.0)?, 3(.0)?\)'));
      check(point2.toString())
          .matchesPattern(RegExp(r'Bounds\(3(.0)?, 2(.0)?, 1(.0)?\)'));
      check(bound1.toString()).matchesPattern(
        RegExp(r'Bounds\(-1(.0)?, -1(.0)?, -1(.0)?; 1(.0)?, 1(.0)?, 1(.0)?\)'),
      );
      check(bound2.toString()).matchesPattern(
        RegExp(r'Bounds\(-2(.0)?, 1(.0)?, 2(.0)?; 2(.0)?, 3(.0)?, 5(.0)?\)'),
      );
    });
    test('unionAll', () {
      check(() => Bounds.unionAll([])).throws<StateError>();
      final singleUnion = Bounds.unionAll([bound1]);
      check(singleUnion.min).deepEquals(bound1.min);
      check(singleUnion.max).deepEquals(bound1.max);
      final fullUnion1 = Bounds.unionAll([point1, point2, bound1, bound2]);
      check(fullUnion1.min).deepEquals([-2.0, -1.0, -1.0]);
      check(fullUnion1.max).deepEquals([3.0, 3.0, 5.0]);
      final fullUnion2 = Bounds.unionAll([bound1, bound2, point2]);
      check(fullUnion2.min).deepEquals([-2.0, -1.0, -1.0]);
      check(fullUnion2.max).deepEquals([3.0, 3.0, 5.0]);
    });
    test('intersectionAll', () {
      check(() => Bounds.intersectionAll([])).throws<StateError>();
      final singleUnion = Bounds.intersectionAll([bound1]);
      check(singleUnion!.min).deepEquals(bound1.min);
      check(singleUnion.max).deepEquals(bound1.max);
      final emptyUnion = Bounds.intersectionAll([bound1, bound2]);
      check(emptyUnion).isNull();
      final fullUnion1 = Bounds.intersectionAll([bound2, bound3]);
      check(fullUnion1!.min).deepEquals(bound4.min);
      check(fullUnion1.max).deepEquals(bound4.max);
      final fullUnion2 = Bounds.intersectionAll([bound2, bound3, point1]);
      check(fullUnion2!.min).deepEquals(point1.min);
      check(fullUnion2.max).deepEquals(point1.max);
    });
  });
}
