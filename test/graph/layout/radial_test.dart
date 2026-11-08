import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('radialLayout', () {
    test('empty vertices', () {
      final layout = LayoutGraph<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      final result = layout.radial();
      check(result.positions).isEmpty();
    });

    test('single vertex at center', () {
      final layout = LayoutGraph<String>(
        vertices: ['Center'],
        successorsOf: (_) => const [],
      );
      final result = layout.radial(center: const LayoutPoint(50, 60));
      check(result.positions.length).equals(1);
      check(result['Center']).equals(const LayoutPoint(50, 60));
    });

    test('star graph concentric rings', () {
      final star = <String, List<String>>{
        'Hub': ['Spoke1', 'Spoke2', 'Spoke3'],
        'Spoke1': [],
        'Spoke2': [],
        'Spoke3': [],
      };
      const center = LayoutPoint(0, 0);
      const radiusStep = 100.0;
      final layout = LayoutGraph<String>(
        vertices: ['Hub', 'Spoke1', 'Spoke2', 'Spoke3'],
        successorsOf: (v) => star[v] ?? const [],
        vertexWidth: (_) => 20,
        vertexHeight: (_) => 20,
      );
      final result = layout.radial(
        centerVertex: 'Hub',
        center: center,
        radiusStep: radiusStep,
      );

      check(result.positions.length).equals(4);
      check(result['Hub']).equals(center);

      for (final spoke in ['Spoke1', 'Spoke2', 'Spoke3']) {
        final dist = result[spoke]!.distanceTo(center);
        check(dist).isCloseTo(radiusStep, 1e-4);
      }
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('Root', 'A');
      graph.addEdge('A', 'B');

      final result = graph
          .layout(vertexWidth: (_) => 30, vertexHeight: (_) => 30)
          .radial(centerVertex: 'Root', radiusStep: 80);
      check(result['Root']!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(0.0, 1e-4);
      check(result['A']!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(80.0, 1e-4);
      check(result['B']!.distanceTo(const LayoutPoint(0, 0)))
          .isCloseTo(160.0, 1e-4);
    });
  });
}
