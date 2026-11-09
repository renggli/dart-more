import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('RandomLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = RandomLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('vertices stay within specified bounds', () {
      const bounds = LayoutRectangle(50, 50, 150, 100);
      final input = LayoutInput<int>(
        vertices: [1, 2, 3, 4, 5],
        successorsOf: (_) => const [],
        vertexSize: (_) => const (width: 20.0, height: 20.0),
      );
      const strategy = RandomLayout<int>(bounds: bounds, seed: 12345);
      final result = strategy.layout(input);
      check(result.positions.length).equals(5);
      for (final p in result.positions.values) {
        check(p.x).isGreaterThan(bounds.minX - 0.001);
        check(p.x).isLessThan(bounds.maxX + 0.001);
        check(p.y).isGreaterThan(bounds.minY - 0.001);
        check(p.y).isLessThan(bounds.maxY + 0.001);
      }
    });

    test('deterministic with seed', () {
      final input = LayoutInput<int>(
        vertices: [1, 2, 3],
        successorsOf: (_) => const [],
      );
      const strategy = RandomLayout<int>(seed: 42);
      final r1 = strategy.layout(input);
      final r2 = strategy.layout(input);
      check(r1[1]).equals(r2[1]);
      check(r1[2]).equals(r2[2]);
      check(r1[3]).equals(r2[3]);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addVertex('A');
      final result = graph.layout(const RandomLayout(seed: 99));
      check(result.positions.containsKey('A')).isTrue();
    });
  });
}
