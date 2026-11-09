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

  group('LayoutRectangle', () {
    test('boundingBox', () {
      final rect = boundingBox([
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
      final rect = boundingBox(const []);
      check(rect.width).equals(0.0);
      check(rect.height).equals(0.0);
    });

    test('expandToInclude and expandToIncludePoint', () {
      const r1 = LayoutRectangle(0, 0, 10, 10);
      const r2 = LayoutRectangle(5, 5, 20, 20);
      final expanded = r1.expandToInclude(r2);
      check(expanded.minX).equals(0.0);
      check(expanded.minY).equals(0.0);
      check(expanded.maxX).equals(25.0);
      check(expanded.maxY).equals(25.0);

      final withPoint = r1.expandToIncludePoint(const LayoutPoint(-5, 15));
      check(withPoint.minX).equals(-5.0);
      check(withPoint.maxX).equals(10.0);
      check(withPoint.minY).equals(0.0);
      check(withPoint.maxY).equals(15.0);
    });
  });
}
