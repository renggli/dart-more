import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('treeLayout', () {
    test('empty vertices', () {
      final layout = LayoutGraph<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      final result = layout.tree();
      check(result.positions).isEmpty();
    });

    test('single node at origin', () {
      final layout = LayoutGraph<String>(
        vertices: ['Root'],
        successorsOf: (_) => const [],
      );
      final result = layout.tree();
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
      final layout = LayoutGraph<String>(
        vertices: vertices,
        successorsOf: (v) => tree[v] ?? const [],
        vertexWidth: (_) => 30,
        vertexHeight: (_) => 20,
      );
      final result = layout.tree(levelDistance: 100, siblingDistance: 50);

      check(result.positions.length).equals(7);

      // Root is at depth 0
      check(result['Root']!.y).equals(0.0);

      // L and R at depth 1 (y = 100)
      check(result['L']!.y).equals(100.0);
      check(result['R']!.y).equals(100.0);

      // Leaves at depth 2 (y = 200)
      check(result['LL']!.y).equals(200.0);
      check(result['LR']!.y).equals(200.0);
      check(result['RL']!.y).equals(200.0);
      check(result['RR']!.y).equals(200.0);

      // Root x is centered above children
      final lX = result['L']!.x;
      final rX = result['R']!.x;
      final rootX = result['Root']!.x;
      check(rX).isGreaterThan(lX);
      check(rootX).isCloseTo((lX + rX) / 2.0, 1e-4);
    });

    test('sibling separation accounts for varying vertex widths', () {
      final tree = <String, List<String>>{
        'Root': ['Narrow', 'Wide'],
      };
      final layout = LayoutGraph<String>(
        vertices: ['Root', 'Narrow', 'Wide'],
        successorsOf: (v) => tree[v] ?? const [],
        vertexWidth: (v) => v == 'Wide' ? 200.0 : 40.0,
        vertexHeight: (_) => 30.0,
      );
      final result = layout.tree(siblingDistance: 20.0);
      // Separation between Narrow and Wide must accommodate their half-widths: (40 + 200)/2 + 20 = 140
      final sep = result['Wide']!.x - result['Narrow']!.x;
      check(sep).isGreaterThan(139.9);
    });

    test('horizontal orientation leftToRight', () {
      final tree = <String, List<String>>{
        'Root': ['Child'],
      };
      final layout = LayoutGraph<String>(
        vertices: ['Root', 'Child'],
        successorsOf: (v) => tree[v] ?? const [],
      );
      final result = layout.tree(
        levelDistance: 120,
        orientation: LayoutOrientation.leftToRight,
      );

      check(result['Root']!.x).equals(0.0);
      check(result['Child']!.x).equals(120.0);
    });

    test('graph extension on tree graph', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');

      final result = graph.layout().tree();
      check(result.positions.length).equals(3);
      check(result['A']!.y).isLessThan(result['B']!.y);
      check(result['A']!.y).isLessThan(result['C']!.y);
    });
  });
}
