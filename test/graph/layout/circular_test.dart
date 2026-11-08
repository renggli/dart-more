import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('circularLayout', () {
    test('empty vertices', () {
      final layout = LayoutGraph<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      final result = layout.circular();
      check(result.positions).isEmpty();
      check(result.bounds.width).equals(0.0);
      check(result.bounds.height).equals(0.0);
    });

    test('single vertex centered', () {
      final layout = LayoutGraph<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      final result = layout.circular(center: const LayoutPoint(100, 200));
      check(result.positions.length).equals(1);
      check(result['A']?.x).equals(100.0);
      check(result['A']?.y).equals(200.0);
    });

    test('multiple vertices equidistant on circle', () {
      const center = LayoutPoint(0, 0);
      const radius = 100.0;
      final layout = LayoutGraph<int>(
        vertices: [1, 2, 3, 4],
        successorsOf: (_) => const [],
        vertexWidth: (_) => 10,
        vertexHeight: (_) => 10,
      );
      final result = layout.circular(
        center: center,
        radius: radius,
        startAngle: 0,
      );
      check(result.positions.length).equals(4);

      // Verify radii from center
      for (var i = 1; i <= 4; i++) {
        final dist = result[i]!.distanceTo(center);
        check(dist).isCloseTo(radius, 1e-4);
      }
    });

    test('overlap prevention expands circle radius for wide vertices', () {
      final layoutDefault = LayoutGraph<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
        vertexWidth: (_) => 20,
        vertexHeight: (_) => 20,
      );
      final resDefault = layoutDefault.circular(spacing: 10);

      final layoutWide = LayoutGraph<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
        vertexWidth: (_) => 200,
        vertexHeight: (_) => 50,
      );
      final resWide = layoutWide.circular(spacing: 10);

      // Radius for wide vertices must be larger to avoid overlap
      check(resWide.bounds.width).isGreaterThan(resDefault.bounds.width);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addVertex('A');
      graph.addVertex('B');
      graph.addEdge('A', 'B');

      final result = graph.layout().circular(radius: 50);
      check(result.positions.keys).unorderedEquals(['A', 'B']);
    });
  });
}
