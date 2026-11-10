import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('RadialLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = RadialLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('single vertex at center', () {
      final input = LayoutInput<String>(
        vertices: ['Center'],
        successorsOf: (_) => const [],
      );
      const strategy = RadialLayout<String>(center: LayoutPoint(50, 60));
      final result = strategy.layout(input);
      check(result.positions.length).equals(1);
      check(result['Center']).equals(const LayoutPoint(50, 60));
    });

    test('rootSelector picks custom root', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => v == 'B' ? ['A'] : const [],
      );
      final strategy = RadialLayout<String>(rootSelector: (inp) => 'B');
      final result = strategy.layout(input);
      check(result['B']).equals(const LayoutPoint(0, 0));
    });

    test('star graph concentric rings', () {
      final star = <String, List<String>>{
        'Hub': ['Spoke1', 'Spoke2', 'Spoke3'],
        'Spoke1': [],
        'Spoke2': [],
        'Spoke3': [],
      };
      const center = LayoutPoint(0, 0);
      const layerDistance = 100.0;
      final input = LayoutInput<String>(
        vertices: ['Hub', 'Spoke1', 'Spoke2', 'Spoke3'],
        successorsOf: (v) => star[v] ?? const [],
        vertexSize: (_) => const (width: 20.0, height: 20.0),
      );
      const strategy = RadialLayout<String>(
        root: 'Hub',
        center: center,
        layerDistance: layerDistance,
      );
      final result = strategy.layout(input);

      check(result.positions.length).equals(4);
      check(result['Hub']).equals(center);

      for (final spoke in ['Spoke1', 'Spoke2', 'Spoke3']) {
        final dist = result[spoke]!.distanceTo(center);
        check(dist).isCloseTo(layerDistance, 1e-4);
      }
    });

    test('disconnected components are packed separately', () {
      final input = LayoutInput<String>(
        vertices: ['A1', 'A2', 'B1', 'B2'],
        successorsOf: (v) => switch (v) {
          'A1' => ['A2'],
          'B1' => ['B2'],
          _ => const [],
        },
      );
      const strategy = RadialLayout<String>(layerDistance: 50);
      final result = strategy.layout(input);
      check(result.positions.keys).unorderedEquals(['A1', 'A2', 'B1', 'B2']);
    });

    test('disconnected components with packComponents false assigns positions to all vertices', () {
      final input = LayoutInput<String>(
        vertices: ['A1', 'A2', 'B1', 'B2'],
        successorsOf: (v) => switch (v) {
          'A1' => ['A2'],
          'B1' => ['B2'],
          _ => const [],
        },
        packComponents: false,
      );
      const strategy = RadialLayout<String>(layerDistance: 50);
      final result = strategy.layout(input);
      check(result.positions.keys).unorderedEquals(['A1', 'A2', 'B1', 'B2']);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('Root', 'A');
      graph.addEdge('A', 'B');

      final result = graph.layout(
        const RadialLayout(root: 'Root', layerDistance: 80),
        vertexSize: (_) => const (width: 30.0, height: 30.0),
        normalize: false,
      );
      check(result['Root']!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(0.0, 1e-4);
      check(result['A']!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(80.0, 1e-4);
      check(result['B']!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(160.0, 1e-4);
    });
  });
}
