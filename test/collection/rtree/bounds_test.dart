import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('bounds', () {
    final point1 = [1.0, 2.0, 3.0].toBounds();
    final point2 = Bounds.fromList([3.0, 2.0, 1.0], [3.0, 2.0, 1.0]);
    final bound1 = Bounds.fromList([-1.0, -1.0, -1.0], [1.0, 1.0, 1.0]);
    final bound2 = Bounds.fromList([-2.0, 1.0, 2.0], [2.0, 3.0, 5.0]);
    final bound3 = Bounds.fromList([-1.0, 2.0, 1.0], [3.0, 4.0, 4.0]);
    final bound4 = Bounds.fromList([-1.0, 2.0, 2.0], [2.0, 3.0, 4.0]);

    test('length', () {
      check(point1.length).equals(3);
      check(point2.length).equals(3);
      check(bound1.length).equals(3);
      check(bound2.length).equals(3);
    });
    test('distinct buffer for min and max in toBounds', () {
      final pt = [1.0, 2.0].toBounds();
      check(identical(pt.min, pt.max)).isFalse();
    });
    test('isPoint', () {
      check(point1.isPoint).isTrue();
      check(point2.isPoint).isTrue();
      check(bound1.isPoint).isFalse();
      check(bound2.isPoint).isFalse();
      final partialBox = Bounds.fromList([1.0, 2.0], [1.0, 5.0]);
      check(partialBox.isPoint).isFalse();
    });
    test('edges', () {
      check(point1.edges).deepEquals([0.0, 0.0, 0.0]);
      check(point2.edges).deepEquals([0.0, 0.0, 0.0]);
      check(bound1.edges).deepEquals([2.0, 2.0, 2.0]);
      check(bound2.edges).deepEquals([4.0, 2.0, 3.0]);
    });
    test('margin', () {
      check(point1.margin).equals(0.0);
      check(bound1.margin).equals(6.0);
      check(bound2.margin).equals(9.0);
    });
    test('area', () {
      check(point1.area).equals(0.0);
      check(point2.area).equals(0.0);
      check(bound1.area).equals(8.0);
      check(bound2.area).equals(24.0);
    });
    test('center', () {
      check(point1.center).deepEquals([1.0, 2.0, 3.0]);
      check(point2.center).deepEquals([3.0, 2.0, 1.0]);
      check(bound1.center).deepEquals([0.0, 0.0, 0.0]);
      check(bound2.center).deepEquals([0.0, 2.0, 3.5]);
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
      check(pointUnion.min).deepEquals([1.0, 2.0, 1.0]);
      check(pointUnion.max).deepEquals([3.0, 2.0, 3.0]);
      final boundUnion = bound1.union(bound2);
      check(boundUnion.min).deepEquals([-2.0, -1.0, -1.0]);
      check(boundUnion.max).deepEquals([2.0, 3.0, 5.0]);
      final pointBoundUnion = point1.union(bound1);
      check(pointBoundUnion.min).deepEquals([-1.0, -1.0, -1.0]);
      check(pointBoundUnion.max).deepEquals([1.0, 2.0, 3.0]);
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
      check(point1.toString()).anyOf([
        (s) => s.equals('Bounds(1, 2, 3)'),
        (s) => s.equals('Bounds(1.0, 2.0, 3.0)'),
      ]);
      check(point2.toString()).anyOf([
        (s) => s.equals('Bounds(3, 2, 1)'),
        (s) => s.equals('Bounds(3.0, 2.0, 1.0)'),
      ]);
      check(bound1.toString()).anyOf([
        (s) => s.equals('Bounds(-1, -1, -1; 1, 1, 1)'),
        (s) => s.equals('Bounds(-1.0, -1.0, -1.0; 1.0, 1.0, 1.0)'),
      ]);
      check(bound2.toString()).anyOf([
        (s) => s.equals('Bounds(-2, 1, 2; 2, 3, 5)'),
        (s) => s.equals('Bounds(-2.0, 1.0, 2.0; 2.0, 3.0, 5.0)'),
      ]);
    });
    test('minDistanceToPointSquared and minDistanceToBoundsSquared', () {
      final b1 = Bounds.from2D(0.0, 0.0, 2.0, 2.0);
      final b2 = Bounds.from2D(5.0, 0.0, 7.0, 2.0);
      final b3 = Bounds.from2D(0.0, 6.0, 2.0, 8.0);
      final b4 = Bounds.from2D(1.0, 1.0, 3.0, 3.0);

      check(b1.minDistanceToBoundsSquared(b2)).equals(9.0);
      check(b2.minDistanceToBoundsSquared(b1)).equals(9.0);
      check(b1.minDistanceToBoundsSquared(b3)).equals(16.0);
      check(b3.minDistanceToBoundsSquared(b1)).equals(16.0);
      check(b1.minDistanceToBoundsSquared(b4)).equals(0.0);

      // Distance to target points
      check(b1.minDistanceToPointSquared([1.0, 1.0])).equals(0.0);
      check(b1.minDistanceToPointSquared([-1.0, 1.0])).equals(1.0);
      check(b1.minDistanceToPointSquared([5.0, 1.0])).equals(9.0);
      check(b1.minDistanceToPointSquared([1.0, -2.0])).equals(4.0);
      check(b1.minDistanceToPointSquared([1.0, 5.0])).equals(9.0);
    });
    test('Point extension properties', () {
      const pt = Point(10.0, 20.0);
      final bPt = pt.toBounds();
      check(bPt.isPoint).isTrue();
      check(bPt.length).equals(2);
      check(bPt.minX).equals(10.0);
      check(bPt.minY).equals(20.0);
      check(bPt.maxX).equals(10.0);
      check(bPt.maxY).equals(20.0);
      check(bPt.width).equals(0.0);
      check(bPt.height).equals(0.0);
      check(bPt.area).equals(0.0);
      check(bPt.margin).equals(0.0);
      check(bPt.getMin(0)).equals(10.0);
      check(bPt.getMin(1)).equals(20.0);
      check(bPt.getMax(0)).equals(10.0);
      check(bPt.getMax(1)).equals(20.0);
      check(() => bPt.getMin(2)).throws<RangeError>();
      check(() => bPt.getMax(2)).throws<RangeError>();
    });
    test('Rectangle extension properties', () {
      const rect = Rectangle(5.0, 10.0, 20.0, 30.0);
      final bRect = rect.toBounds();
      check(bRect.isPoint).isFalse();
      check(bRect.length).equals(2);
      check(bRect.minX).equals(5.0);
      check(bRect.minY).equals(10.0);
      check(bRect.maxX).equals(25.0);
      check(bRect.maxY).equals(40.0);
      check(bRect.width).equals(20.0);
      check(bRect.height).equals(30.0);
      check(bRect.area).equals(600.0);
      check(bRect.margin).equals(50.0);
      check(bRect.getMin(0)).equals(5.0);
      check(bRect.getMin(1)).equals(10.0);
      check(bRect.getMax(0)).equals(25.0);
      check(bRect.getMax(1)).equals(40.0);
      check(() => bRect.getMin(-1)).throws<RangeError>();
      check(() => bRect.getMax(2)).throws<RangeError>();
    });
    test('2D coordinates and 2D union/intersection', () {
      final b2d1 = Bounds.from2D(0.0, 0.0, 10.0, 10.0);
      final b2d2 = Bounds.from2D(5.0, 5.0, 15.0, 15.0);
      check(() => b2d1.getMin(2)).throws<RangeError>();
      check(() => b2d1.getMax(-1)).throws<RangeError>();

      // Default 2D accessors on N-D bounds
      check(bound1.minX).equals(-1.0);
      check(bound1.minY).equals(-1.0);
      check(bound1.maxX).equals(1.0);
      check(bound1.maxY).equals(1.0);

      final u = b2d1.union(b2d2);
      check(u.minX).equals(0.0);
      check(u.minY).equals(0.0);
      check(u.maxX).equals(15.0);
      check(u.maxY).equals(15.0);

      final inter = b2d1.intersection(b2d2);
      check(inter).isNotNull();
      check(inter!.minX).equals(5.0);
      check(inter.minY).equals(5.0);
      check(inter.maxX).equals(10.0);
      check(inter.maxY).equals(10.0);

      final disjoint = Bounds.from2D(20.0, 20.0, 30.0, 30.0);
      check(b2d1.intersection(disjoint)).isNull();
    });
    test('unionAll', () {
      check(() => Bounds.unionAll([])).throws<StateError>();
      final singleUnion = Bounds.unionAll([bound1]);
      check(singleUnion.min).deepEquals(bound1.min);
      check(singleUnion.max).deepEquals(bound1.max);
      final fullUnion1 = Bounds.unionAll([point1, point2, bound1, bound2]);
      check(fullUnion1.min).deepEquals([-2.0, -1.0, -1.0]);
      check(fullUnion1.max).deepEquals([3.0, 3.0, 5.0]);

      // 2D unionAll
      final u2d = Bounds.unionAll([
        Bounds.from2D(0.0, 0.0, 5.0, 5.0),
        Bounds.from2D(3.0, 2.0, 10.0, 8.0),
      ]);
      check(u2d.minX).equals(0.0);
      check(u2d.minY).equals(0.0);
      check(u2d.maxX).equals(10.0);
      check(u2d.maxY).equals(8.0);
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

      // 2D intersectionAll
      final b2d1 = Bounds.from2D(0.0, 0.0, 10.0, 10.0);
      final b2d2 = Bounds.from2D(2.0, 2.0, 8.0, 8.0);
      final b2d3 = Bounds.from2D(4.0, 4.0, 6.0, 6.0);
      final inter2D = Bounds.intersectionAll([b2d1, b2d2, b2d3]);
      check(inter2D).isNotNull();
      check(inter2D!.minX).equals(4.0);
      check(inter2D.maxX).equals(6.0);

      final disjoint2D = Bounds.from2D(20.0, 20.0, 30.0, 30.0);
      check(Bounds.intersectionAll([b2d1, disjoint2D])).isNull();

      // 3D intersectionAll disjoint
      final b3D1 = Bounds.fromList([0.0, 0.0, 0.0], [10.0, 10.0, 10.0]);
      final b3D2 = Bounds.fromList([20.0, 20.0, 20.0], [30.0, 30.0, 30.0]);
      check(Bounds.intersectionAll([b3D1, b3D2])).isNull();
    });
    test('factory constructors', () {
      final p1 = Bounds.fromPoint(const Point(4.0, 5.0));
      check(p1.min).deepEquals([4.0, 5.0]);
      check(p1.max).deepEquals([4.0, 5.0]);

      final r1 = Bounds.fromRectangle(const Rectangle(1.0, 2.0, 3.0, 4.0));
      check(r1.min).deepEquals([1.0, 2.0]);
      check(r1.max).deepEquals([4.0, 6.0]);

      final b2dPoint = Bounds.from2D(10.0, 20.0);
      check(b2dPoint.isPoint).isTrue();
      check(b2dPoint.min).deepEquals([10.0, 20.0]);
      check(b2dPoint.max).deepEquals([10.0, 20.0]);

      final b2dBox = Bounds.from2D(10.0, 20.0, 30.0, 40.0);
      check(b2dBox.isPoint).isFalse();
      check(b2dBox.min).deepEquals([10.0, 20.0]);
      check(b2dBox.max).deepEquals([30.0, 40.0]);

      check(() => Bounds.from2D(10.0, 20.0, 30.0)).throws<AssertionError>();

      final bListPoint = Bounds.fromList([1.0, 2.0, 3.0]);
      check(bListPoint.isPoint).isTrue();
      check(bListPoint.min).deepEquals([1.0, 2.0, 3.0]);
      check(bListPoint.max).deepEquals([1.0, 2.0, 3.0]);

      final bListBox = Bounds.fromList([1.0, 2.0], [3.0, 4.0]);
      check(bListBox.isPoint).isFalse();
      check(bListBox.min).deepEquals([1.0, 2.0]);
      check(bListBox.max).deepEquals([3.0, 4.0]);
    });
  });
}
