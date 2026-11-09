import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('GridLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = GridLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
      check(result.bounds.width).equals(0.0);
    });

    test('single vertex', () {
      final input = LayoutInput<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      const strategy = GridLayout<String>(origin: LayoutPoint(10, 20));
      final result = strategy.layout(input);
      check(result.positions.length).equals(1);
      check(result['A']?.x).equals(10.0);
      check(result['A']?.y).equals(20.0);
    });

    test('2x2 grid with explicit cell dimensions', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
      );
      const strategy = GridLayout<String>(
        cellWidth: 50,
        cellHeight: 40,
        origin: LayoutPoint(0, 0),
      );
      final result = strategy.layout(input);
      check(result.positions.length).equals(4);
      check(result['A']).equals(const LayoutPoint(0, 0));
      check(result['B']).equals(const LayoutPoint(50, 0));
      check(result['C']).equals(const LayoutPoint(0, 40));
      check(result['D']).equals(const LayoutPoint(50, 40));
    });

    test('grid cell size automatically adapts to vertex size', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (_) => const [],
        vertexSize: (_) => const (width: 150.0, height: 90.0),
      );
      const strategy = GridLayout<String>(columns: 2, vertexDistance: 20);
      final result = strategy.layout(input);
      // Separation between columns must be at least vertexWidth + vertexDistance = 170
      final sep = result['B']!.x - result['A']!.x;
      check(sep).isGreaterThan(169.9);
    });

    test('graph extension matches direct strategy', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addVertex('X');
      graph.addVertex('Y');
      const strategy = GridLayout<String>(cellWidth: 80);
      final result1 = graph.layout(strategy, normalize: false);
      final result2 = strategy.layout(
        LayoutInput(vertices: graph.vertices, successorsOf: graph.successorsOf),
      );
      check(result1.positions).deepEquals(result2.positions);
    });
  });
}
