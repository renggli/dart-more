import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('randomLayout', () {
    test('empty vertices', () {
      final layout = LayoutGraph<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      final result = layout.random();
      check(result.positions).isEmpty();
    });

    test('vertices stay within specified bounds', () {
      const bounds = LayoutRect(minX: 50, minY: 50, maxX: 200, maxY: 150);
      final layout = LayoutGraph<int>(
        vertices: [1, 2, 3, 4, 5],
        successorsOf: (_) => const [],
        vertexWidth: (_) => 20,
        vertexHeight: (_) => 20,
      );
      final result = layout.random(bounds: bounds, seed: 12345);
      check(result.positions.length).equals(5);
      for (final p in result.positions.values) {
        check(p.x).isGreaterThan(bounds.minX - 0.001);
        check(p.x).isLessThan(bounds.maxX + 0.001);
        check(p.y).isGreaterThan(bounds.minY - 0.001);
        check(p.y).isLessThan(bounds.maxY + 0.001);
      }
    });

    test('deterministic with seed', () {
      final layout = LayoutGraph<int>(
        vertices: [1, 2, 3],
        successorsOf: (_) => const [],
      );
      final r1 = layout.random(seed: 42);
      final r2 = layout.random(seed: 42);
      check(r1[1]).equals(r2[1]);
      check(r1[2]).equals(r2[2]);
      check(r1[3]).equals(r2[3]);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addVertex('A');
      final result = graph.layout().random(seed: 99);
      check(result.positions.containsKey('A')).isTrue();
    });
  });
}
