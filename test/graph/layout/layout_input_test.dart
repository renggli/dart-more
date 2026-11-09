import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('LayoutInput', () {
    test('default dimensions and closures', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => v == 'A' ? ['B'] : const [],
      );

      check(input.widthOf('A')).equals(40.0);
      check(input.heightOf('A')).equals(40.0);
      check(input.diameterOf('A')).isCloseTo(56.5685, 1e-3);
      check(input.neighboursOf('A')).unorderedEquals(['B']);
      check(input.isDirected).isFalse();
    });

    test('custom vertex dimensions', () {
      final input = LayoutInput<String>(
        vertices: ['Small', 'Large'],
        successorsOf: (_) => const [],
        vertexSize: (v) => v == 'Large'
            ? const (width: 120.0, height: 80.0)
            : const (width: 30.0, height: 20.0),
      );

      check(input.widthOf('Small')).equals(30.0);
      check(input.heightOf('Small')).equals(20.0);
      check(input.widthOf('Large')).equals(120.0);
      check(input.heightOf('Large')).equals(80.0);
      check(input.diameterOf('Small')).isCloseTo(36.0555, 1e-3);
      check(input.diameterOf('Large')).isCloseTo(144.222, 1e-3);
    });

    test('directed vs undirected neighboursOf', () {
      final inputDirected = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => v == 'A' ? ['B'] : const [],
        predecessorsOf: (v) => v == 'B' ? ['A'] : const [],
      );
      check(inputDirected.isDirected).isTrue();
      check(inputDirected.neighboursOf('B')).unorderedEquals(['A']);
    });

    test('empty and transform on LayoutResult', () {
      final empty = LayoutResult.empty<String>();
      check(empty.positions).isEmpty();
      check(empty.bounds.width).equals(0.0);

      final result = LayoutResult<String>(
        positions: const {'A': LayoutPoint(10, 20)},
        edgeRoutes: const {
          ('A', 'A'): [LayoutPoint(15, 25)],
        },
      );
      final transformed = result.transform((_, p) => p.translate(5, 5));
      check(transformed['A']).equals(const LayoutPoint(15, 25));
      check(transformed.edgeRoutes[('A', 'A')]!.first)
          .equals(const LayoutPoint(20, 30));
    });

    test('graph.layout adapter passes topology and options', () {
      final graph = Graph<String, int>(isDirected: true);
      graph.addEdge('A', 'B', value: 5);

      final result = graph.layout(
        const GridLayout(cellWidth: 100),
        vertexSize: (v) => const (width: 60.0, height: 40.0),
        normalize: true,
        removeOverlaps: true,
      );

      check(result.positions.keys).unorderedEquals(['A', 'B']);
      check(result.bounds.minX).equals(0.0);
      check(result.bounds.minY).equals(0.0);
    });
  });
}
