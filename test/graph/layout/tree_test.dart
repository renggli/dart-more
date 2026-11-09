import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('TreeLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = TreeLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('single node at origin', () {
      final input = LayoutInput<String>(
        vertices: ['Root'],
        successorsOf: (_) => const [],
      );
      const strategy = TreeLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.length).equals(1);
      check(result['Root']?.x).equals(0.0);
      check(result['Root']?.y).equals(0.0);
    });

    test('balanced binary tree hierarchical levels', () {
      final tree = <String, List<String>>{
        'Root': ['L', 'R'],
        'L': ['LL', 'LR'],
        'R': ['RL', 'RR'],
      };
      final vertices = ['Root', 'L', 'R', 'LL', 'LR', 'RL', 'RR'];
      final input = LayoutInput<String>(
        vertices: vertices,
        successorsOf: (v) => tree[v] ?? const [],
        vertexSize: (_) => const (width: 30.0, height: 20.0),
      );
      const strategy = TreeLayout<String>(
        layerDistance: 100,
        vertexDistance: 50,
      );
      final result = strategy.layout(input);

      check(result.positions.length).equals(7);
      check(result['Root']!.y).equals(0.0);
      check(result['L']!.y).equals(100.0);
      check(result['R']!.y).equals(100.0);
      check(result['LL']!.y).equals(200.0);
      check(result['LR']!.y).equals(200.0);
      check(result['RL']!.y).equals(200.0);
      check(result['RR']!.y).equals(200.0);

      final lX = result['L']!.x;
      final rX = result['R']!.x;
      final rootX = result['Root']!.x;
      check(rX).isGreaterThan(lX);
      check(rootX).isCloseTo((lX + rX) / 2.0, 1e-4);
    });

    test('path graph', () {
      final input = LayoutInput<int>(
        vertices: [1, 2, 3],
        successorsOf: (v) => v < 3 ? [v + 1] : const [],
      );
      const strategy = TreeLayout<int>(layerDistance: 50);
      final result = strategy.layout(input);
      check(result[1]!.y).isLessThan(result[2]!.y);
      check(result[2]!.y).isLessThan(result[3]!.y);
    });

    test('star graph', () {
      final input = LayoutInput<String>(
        vertices: ['Center', 'S1', 'S2', 'S3'],
        successorsOf: (v) => v == 'Center' ? ['S1', 'S2', 'S3'] : const [],
      );
      const strategy = TreeLayout<String>(layerDistance: 50);
      final result = strategy.layout(input);
      check(result['Center']!.y).equals(0.0);
      check(result['S1']!.y).equals(50.0);
      check(result['S2']!.y).equals(50.0);
      check(result['S3']!.y).equals(50.0);
    });

    test('forest with multiple trees', () {
      final input = LayoutInput<String>(
        vertices: ['T1_Root', 'T1_Child', 'T2_Root', 'T2_Child'],
        successorsOf: (v) => switch (v) {
          'T1_Root' => ['T1_Child'],
          'T2_Root' => ['T2_Child'],
          _ => const [],
        },
      );
      const strategy = TreeLayout<String>(vertexDistance: 30);
      final result = strategy.layout(input);
      check(result.positions.length).equals(4);
      check(result['T2_Root']!.x).isGreaterThan(result['T1_Root']!.x);
    });

    test('cyclic graph handled via spanning forest', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => switch (v) {
          'A' => ['B'],
          'B' => ['C'],
          'C' => ['A'],
          _ => const [],
        },
      );
      const strategy = TreeLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.keys).unorderedEquals(['A', 'B', 'C']);
    });

    test('undirected input', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => switch (v) {
          'A' => ['B', 'C'],
          'B' => ['A'],
          'C' => ['A'],
          _ => const [],
        },
      );
      const strategy = TreeLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.length).equals(3);
    });

    test('all four orientations', () {
      final input = LayoutInput<String>(
        vertices: ['P', 'C'],
        successorsOf: (v) => v == 'P' ? ['C'] : const [],
      );

      final tb = const TreeLayout<String>(
        layerDistance: 100,
        orientation: LayoutOrientation.topToBottom,
      ).layout(input);
      check(tb['C']!.y - tb['P']!.y).equals(100.0);

      final bt = const TreeLayout<String>(
        layerDistance: 100,
        orientation: LayoutOrientation.bottomToTop,
      ).layout(input);
      check(bt['C']!.y - bt['P']!.y).equals(-100.0);

      final lr = const TreeLayout<String>(
        layerDistance: 100,
        orientation: LayoutOrientation.leftToRight,
      ).layout(input);
      check(lr['C']!.x - lr['P']!.x).equals(100.0);

      final rl = const TreeLayout<String>(
        layerDistance: 100,
        orientation: LayoutOrientation.rightToLeft,
      ).layout(input);
      check(rl['C']!.x - rl['P']!.x).equals(-100.0);
    });

    test('graph extension on tree graph', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');

      final result = graph.layout(const TreeLayout(), normalize: false);
      check(result.positions.length).equals(3);
      check(result['A']!.y).isLessThan(result['B']!.y);
      check(result['A']!.y).isLessThan(result['C']!.y);
    });
  });
}
