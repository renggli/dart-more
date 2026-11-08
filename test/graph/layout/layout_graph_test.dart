import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('LayoutGraph', () {
    test('default dimensions and closures', () {
      final layout = LayoutGraph<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => v == 'A' ? ['B'] : const [],
      );

      check(layout.widthOf('A')).equals(40.0);
      check(layout.heightOf('A')).equals(40.0);
      check(layout.diameterOf('A')).isCloseTo(56.5685, 1e-3);
      check(layout.neighboursOf('A')).unorderedEquals(['B']);
    });

    test('custom vertex dimensions', () {
      final layout = LayoutGraph<String>(
        vertices: ['Small', 'Large'],
        successorsOf: (_) => const [],
        vertexWidth: (v) => v == 'Large' ? 120.0 : 30.0,
        vertexHeight: (v) => v == 'Large' ? 80.0 : 20.0,
      );

      check(layout.widthOf('Small')).equals(30.0);
      check(layout.heightOf('Small')).equals(20.0);
      check(layout.widthOf('Large')).equals(120.0);
      check(layout.heightOf('Large')).equals(80.0);
      check(layout.diameterOf('Small')).isCloseTo(36.0555, 1e-3);
      check(layout.diameterOf('Large')).isCloseTo(144.222, 1e-3);
    });

    test('graph.layout adapter respects graph direction and dimensions', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('A', 'B');

      final layout = graph.layout(
        vertexWidth: (v) => 60.0,
        vertexHeight: (v) => 40.0,
      );

      check(layout.widthOf('A')).equals(60.0);
      check(layout.heightOf('A')).equals(40.0);
      check(layout.successorsOf('A')).unorderedEquals(['B']);
      check(layout.predecessorsOf('B')).unorderedEquals(['A']);
      check(layout.neighboursOf('B')).unorderedEquals(['A']);
    });
  });
}
