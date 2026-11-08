import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('LayoutPoint', () {
    test('translate and scale', () {
      const p = LayoutPoint(10, 20);
      final shifted = p.translate(5, -10);
      check(shifted).equals(const LayoutPoint(15, 10));

      final scaled = p.scale(2, 3);
      check(scaled).equals(const LayoutPoint(20, 60));

      final uniformScaled = p.scale(2);
      check(uniformScaled).equals(const LayoutPoint(20, 40));
    });

    test('distanceTo', () {
      const p1 = LayoutPoint(0, 0);
      const p2 = LayoutPoint(3, 4);
      check(p1.distanceTo(p2)).equals(5.0);
    });
  });

  group('LayoutRect', () {
    test('fromPoints', () {
      final rect = LayoutRect.fromPoints([
        const LayoutPoint(10, 50),
        const LayoutPoint(100, 20),
        const LayoutPoint(30, 80),
      ]);
      check(rect.minX).equals(10.0);
      check(rect.maxX).equals(100.0);
      check(rect.minY).equals(20.0);
      check(rect.maxY).equals(80.0);
      check(rect.width).equals(90.0);
      check(rect.height).equals(60.0);
      check(rect.center).equals(const LayoutPoint(55.0, 50.0));
    });

    test('from empty points returns zero rect', () {
      final rect = LayoutRect.fromPoints(const []);
      check(rect.width).equals(0.0);
      check(rect.height).equals(0.0);
    });
  });

  group('LayoutResult.fit', () {
    test('fits points within target bounding box with margin', () {
      const initial = LayoutResult<String>(
        positions: {
          'A': LayoutPoint(0, 0),
          'B': LayoutPoint(100, 0),
          'C': LayoutPoint(100, 100),
          'D': LayoutPoint(0, 100),
        },
        bounds: LayoutRect(minX: 0, minY: 0, maxX: 100, maxY: 100),
      );

      final fitted = initial.fit(
        targetBounds: const LayoutRect(minX: 0, minY: 0, maxX: 500, maxY: 500),
        margin: 50,
      );

      check(fitted.bounds.minX).isGreaterThan(49.99);
      check(fitted.bounds.maxX).isLessThan(450.01);
      check(fitted.bounds.minY).isGreaterThan(49.99);
      check(fitted.bounds.maxY).isLessThan(450.01);
    });
  });
}
