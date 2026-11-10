import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('PartiteLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = PartiteLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('bipartite graph aligned in two parallel columns', () {
      final input = LayoutInput<String>(
        vertices: ['U1', 'U2', 'V1', 'V2'],
        successorsOf: (v) => switch (v) {
          'U1' => ['V1', 'V2'],
          'U2' => ['V1'],
          _ => const [],
        },
      );
      final strategy = PartiteLayout<String>(
        layerOf: (v) => v.startsWith('U') ? 0 : 1,
        layerDistance: 100,
        orientation: LayoutOrientation.leftToRight,
      );
      final result = strategy.layout(input);

      check(result.positions.length).equals(4);
      // U vertices at column 0 (x = 0), V vertices at column 1 (x = 100)
      check(result['U1']!.x).equals(0.0);
      check(result['U2']!.x).equals(0.0);
      check(result['V1']!.x).equals(100.0);
      check(result['V2']!.x).equals(100.0);
    });

    test('default single column layout when disconnected without edges', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (_) => const [],
      );
      const strategy = PartiteLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.length).equals(2);
      check(result['A']!.x).equals(result['B']!.x);
    });

    test('automatic bipartite layering when connected with edges', () {
      final input = LayoutInput<String>(
        vertices: ['U1', 'U2', 'V1', 'V2'],
        successorsOf: (v) => switch (v) {
          'U1' => ['V1', 'V2'],
          'U2' => ['V1'],
          _ => const [],
        },
      );
      const strategy = PartiteLayout<String>(
        layerDistance: 100,
        orientation: LayoutOrientation.leftToRight,
      );
      final result = strategy.layout(input);

      check(result.positions.length).equals(4);
      // U vertices and V vertices should be in distinct columns
      check(result['U1']!.x).not((it) => it.equals(result['V1']!.x));
      check(result['U1']!.x).equals(result['U2']!.x);
      check(result['V1']!.x).equals(result['V2']!.x);
    });

    test('multipartite with explicit layers', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (_) => const [],
      );
      const strategy = PartiteLayout<String>(
        layers: [
          ['A', 'B'],
          ['C'],
          ['D'],
        ],
        layerDistance: 50,
        orientation: LayoutOrientation.topToBottom,
      );
      final result = strategy.layout(input);
      check(result['A']!.y).equals(0.0);
      check(result['B']!.y).equals(0.0);
      check(result['C']!.y).equals(50.0);
      check(result['D']!.y).equals(100.0);
    });

    test('multipartite edge spanning multiple layers produces edge routes', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => switch (v) {
          'A' => ['C'],
          _ => const [],
        },
      );
      const strategy = PartiteLayout<String>(
        layers: [
          ['A'],
          ['B'],
          ['C'],
        ],
        layerDistance: 50,
      );
      final result = strategy.layout(input);
      check(result.edgeRoutes).isNotEmpty();
    });
  });
}
