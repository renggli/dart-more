import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('CircularLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = CircularLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
      check(result.bounds.width).equals(0.0);
      check(result.bounds.height).equals(0.0);
    });

    test('single vertex centered', () {
      final input = LayoutInput<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      const strategy = CircularLayout<String>(center: LayoutPoint(100, 200));
      final result = strategy.layout(input);
      check(result.positions.length).equals(1);
      check(result['A']?.x).equals(100.0);
      check(result['A']?.y).equals(200.0);
    });

    test('multiple vertices equidistant on circle', () {
      const center = LayoutPoint(0, 0);
      const radius = 100.0;
      final input = LayoutInput<int>(
        vertices: [1, 2, 3, 4],
        successorsOf: (_) => const [],
        vertexSize: (_) => const (width: 10.0, height: 10.0),
      );
      const strategy = CircularLayout<int>(
        center: center,
        radius: radius,
        startAngle: 0,
      );
      final result = strategy.layout(input);
      check(result.positions.length).equals(4);

      for (var i = 1; i <= 4; i++) {
        final dist = result[i]!.distanceTo(center);
        check(dist).isCloseTo(radius, 1e-4);
      }
    });

    test('overlap prevention expands circle radius for wide vertices', () {
      final inputDefault = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
        vertexSize: (_) => const (width: 20.0, height: 20.0),
      );
      const stratDefault = CircularLayout<String>(vertexDistance: 10);
      final resDefault = stratDefault.layout(inputDefault);

      final inputWide = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
        vertexSize: (_) => const (width: 200.0, height: 50.0),
      );
      const stratWide = CircularLayout<String>(vertexDistance: 10);
      final resWide = stratWide.layout(inputWide);

      check(resWide.bounds.width).isGreaterThan(resDefault.bounds.width);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addVertex('A');
      graph.addVertex('B');
      graph.addEdge('A', 'B');

      final result = graph.layout(const CircularLayout(radius: 50));
      check(result.positions.keys).unorderedEquals(['A', 'B']);
    });
  });

  group('ShellLayout', () {
    test('places vertices on specified concentric shells', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
      );
      const strategy = ShellLayout<String>(
        shells: [
          ['A'],
          ['B', 'C', 'D'],
        ],
        layerDistance: 50,
      );
      final result = strategy.layout(input);
      check(result['A']).equals(const LayoutPoint(0, 0));
      check(result['B']!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(50.0, 1.0);
    });

    test('places vertices by shellOf function', () {
      final input = LayoutInput<int>(
        vertices: [0, 1, 2, 3],
        successorsOf: (_) => const [],
      );
      final strategy = ShellLayout<int>(
        shellOf: (v) => v == 0 ? 0 : 1,
        layerDistance: 40,
      );
      final result = strategy.layout(input);
      check(result[0]).equals(const LayoutPoint(0, 0));
      check(result[1]!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(40.0, 1.0);
    });
  });
}
