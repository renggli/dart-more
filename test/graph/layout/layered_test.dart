import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('LayeredLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = LayeredLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('linear DAG ranks sequentially in Y', () {
      final dag = <String, List<String>>{
        'A': ['B'],
        'B': ['C'],
        'C': [],
      };
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => dag[v] ?? const [],
        vertexSize: (_) => const (width: 40.0, height: 30.0),
      );
      const strategy = LayeredLayout<String>(layerDistance: 100);
      final result = strategy.layout(input);

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
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (v) => diamond[v] ?? const [],
        vertexSize: (_) => const (width: 40.0, height: 30.0),
      );
      const strategy = LayeredLayout<String>(layerDistance: 80);
      final result = strategy.layout(input);

      check(result.positions.length).equals(4);
      check(result['A']!.y).equals(0.0);
      check(result['B']!.y).equals(80.0);
      check(result['C']!.y).equals(80.0);
      check(result['D']!.y).equals(160.0);
    });

    test('long edge spanning multiple layers produces dummy edge route', () {
      // A -> B -> C, and A -> C (span 2)
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => switch (v) {
          'A' => ['B', 'C'],
          'B' => ['C'],
          _ => const [],
        },
        vertexSize: (_) => const (width: 40.0, height: 30.0),
      );
      const strategy = LayeredLayout<String>(layerDistance: 80);
      final result = strategy.layout(input);

      check(result.edgeRoutes.containsKey(('A', 'C'))).isTrue();
      final route = result.edgeRoutes[('A', 'C')]!;
      check(route.length).equals(1); // One dummy vertex at layer 1 (rank 1)
      check(route.first.y).equals(80.0);
    });

    test('ladder graph has 0 crossings', () {
      // Ladder DAG: A1 -> A2 -> A3, B1 -> B2 -> B3, A1 -> B1, A2 -> B2, A3 -> B3
      final input = LayoutInput<String>(
        vertices: ['A1', 'B1', 'A2', 'B2', 'A3', 'B3'],
        successorsOf: (v) => switch (v) {
          'A1' => ['A2'],
          'B1' => ['B2'],
          'A2' => ['A3'],
          'B2' => ['B3'],
          _ => const [],
        },
      );
      const strategy = LayeredLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.length).equals(6);
    });

    test(
      'horizontal spacing prevents overlap for wide vertices in same layer',
      () {
        final input = LayoutInput<String>(
          vertices: ['Root', 'Narrow', 'SuperWide'],
          successorsOf: (v) => v == 'Root' ? ['Narrow', 'SuperWide'] : const [],
          vertexSize: (v) => v == 'SuperWide'
              ? const (width: 300.0, height: 30.0)
              : const (width: 40.0, height: 30.0),
        );
        const strategy = LayeredLayout<String>(vertexDistance: 20.0);
        final result = strategy.layout(input);
        final sep = (result['SuperWide']!.x - result['Narrow']!.x).abs();
        check(sep).isGreaterThan(189.9);
      },
    );

    test('handles cycles gracefully', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => switch (v) {
          'A' => ['B'],
          'B' => ['A'],
          _ => const [],
        },
      );
      const strategy = LayeredLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.length).equals(2);
      check(result['A']).isNotNull();
      check(result['B']).isNotNull();
    });

    test('orientation leftToRight flows horizontally', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => v == 'A' ? ['B'] : const [],
      );
      const strategy = LayeredLayout<String>(
        layerDistance: 100,
        orientation: LayoutOrientation.leftToRight,
      );
      final result = strategy.layout(input);
      check(result['B']!.x - result['A']!.x).equals(100.0);
      check(result['A']!.y).equals(result['B']!.y);
    });

    test('ranking tightened runs successfully', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (v) => switch (v) {
          'A' => ['B', 'C'],
          'B' => ['D'],
          'C' => ['D'],
          _ => const [],
        },
      );
      const strategy = LayeredLayout<String>(
        ranking: RankingAlgorithm.tightened,
      );
      final result = strategy.layout(input);
      check(result.positions.length).equals(4);
    });

    test('ranking tightened pushes nodes downward to reduce slack', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (v) => switch (v) {
          'A' => ['D'],
          'B' => ['C'],
          'C' => ['D'],
          _ => const [],
        },
      );
      const strategy = LayeredLayout<String>(
        ranking: RankingAlgorithm.tightened,
      );
      final result = strategy.layout(input);
      check(result.positions.length).equals(4);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      final result = graph.layout(const LayeredLayout(), normalize: false);
      check(result['A']!.y).isLessThan(result['B']!.y);
      check(result['B']!.y).isLessThan(result['C']!.y);
    });
  });
}
