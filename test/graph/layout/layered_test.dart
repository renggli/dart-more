import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('layeredLayout', () {
    test('empty vertices', () {
      final layout = LayoutGraph<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      final result = layout.layered();
      check(result.positions).isEmpty();
    });

    test('linear DAG ranks sequentially in Y', () {
      final dag = <String, List<String>>{
        'A': ['B'],
        'B': ['C'],
        'C': [],
      };
      final layout = LayoutGraph<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => dag[v] ?? const [],
        vertexWidth: (_) => 40,
        vertexHeight: (_) => 30,
      );
      final result = layout.layered(layerDistance: 100);

      check(result.positions.length).equals(3);
      check(result['A']!.y).equals(0.0);
      check(result['B']!.y).equals(100.0);
      check(result['C']!.y).equals(200.0);
    });

    test('diamond DAG layers', () {
      final diamond = <String, List<String>>{
        'A': ['B', 'C'],
        'B': ['D'],
        'C': ['D'],
        'D': [],
      };
      final layout = LayoutGraph<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (v) => diamond[v] ?? const [],
        vertexWidth: (_) => 40,
        vertexHeight: (_) => 30,
      );
      final result = layout.layered(layerDistance: 80);

      check(result.positions.length).equals(4);
      // Layer 0: A
      check(result['A']!.y).equals(0.0);
      // Layer 1: B and C
      check(result['B']!.y).equals(80.0);
      check(result['C']!.y).equals(80.0);
      // Layer 2: D
      check(result['D']!.y).equals(160.0);
    });

    test(
      'horizontal spacing prevents overlap for wide vertices in same layer',
      () {
        final dag = <String, List<String>>{
          'Root': ['Narrow', 'SuperWide'],
        };
        final layout = LayoutGraph<String>(
          vertices: ['Root', 'Narrow', 'SuperWide'],
          successorsOf: (v) => dag[v] ?? const [],
          vertexWidth: (v) => v == 'SuperWide' ? 300.0 : 40.0,
          vertexHeight: (_) => 30.0,
        );
        final result = layout.layered(nodeDistance: 20.0);
        // Distance between Narrow and SuperWide must be >= (40 + 300)/2 + 20 = 190
        final sep = result['SuperWide']!.x - result['Narrow']!.x;
        check(sep).isGreaterThan(189.9);
      },
    );

    test('handles cycles gracefully', () {
      final cycle = <String, List<String>>{
        'A': ['B'],
        'B': ['A'],
      };
      final layout = LayoutGraph<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => cycle[v] ?? const [],
      );
      final result = layout.layered();
      check(result.positions.length).equals(2);
      check(result['A']).isNotNull();
      check(result['B']).isNotNull();
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      final result = graph.layout().layered();
      check(result['A']!.y).isLessThan(result['B']!.y);
      check(result['B']!.y).isLessThan(result['C']!.y);
    });
  });
}
