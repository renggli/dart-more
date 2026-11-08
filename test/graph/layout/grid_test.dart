import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('gridLayout', () {
    test('empty vertices', () {
      final layout = LayoutGraph<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      final result = layout.grid();
      check(result.positions).isEmpty();
      check(result.bounds.width).equals(0.0);
    });

    test('single vertex', () {
      final layout = LayoutGraph<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      final result = layout.grid(origin: const LayoutPoint(10, 20));
      check(result.positions.length).equals(1);
      check(result['A']?.x).equals(10.0);
      check(result['A']?.y).equals(20.0);
    });

    test('2x2 grid with explicit cell dimensions', () {
      final layout = LayoutGraph<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
      );
      final result = layout.grid(
        cellWidth: 50,
        cellHeight: 40,
        origin: const LayoutPoint(0, 0),
      );
      check(result.positions.length).equals(4);
      check(result['A']).equals(const LayoutPoint(0, 0));
      check(result['B']).equals(const LayoutPoint(50, 0));
      check(result['C']).equals(const LayoutPoint(0, 40));
      check(result['D']).equals(const LayoutPoint(50, 40));
    });

    test('grid cell size automatically adapts to vertexWidth and vertexHeight', () {
      final layout = LayoutGraph<String>(
        vertices: ['A', 'B'],
        successorsOf: (_) => const [],
        vertexWidth: (_) => 150,
        vertexHeight: (_) => 90,
      );
      final result = layout.grid(columns: 2, spacing: 20);
      // Separation between columns must be at least vertexWidth + spacing = 170
      final sep = result['B']!.x - result['A']!.x;
      check(sep).isGreaterThan(169.9);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addVertex('X');
      graph.addVertex('Y');
      final result = graph.layout().grid(cellWidth: 80);
      check(result.positions.keys).unorderedEquals(['X', 'Y']);
    });
  });
}
