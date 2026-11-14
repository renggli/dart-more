@TestOn('browser')
library;

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/enums.dart';
import '../../web/graph/modifiers.dart';
import '../../web/graph/state.dart';

void main() {
  group('ModifierRegistry and Categories', () {
    test('ModifierCategory does not contain generate', () {
      final names = ModifierCategory.values.map((c) => c.name).toList();
      check(names).not((n) => n.contains('generate'));
    });

    test('CombineModifier is registered in transform category', () {
      final spec = ModifierRegistry.getSpec('combine');
      check(spec.category).equals(ModifierCategory.transform);
      check(spec.name).equals('Combine');
    });

    test('addAllModifiersDisabled puts Combine at top', () {
      final state = AppState();
      state.addAllModifiersDisabled();
      check(state.modifiers).isNotEmpty();
      check(state.modifiers.first.id).equals('combine');
    });
  });

  group('CombineModifier', () {
    test('replace mode', () {
      final state = AppState();
      final mod = CombineModifier(
        operation: CombineOperation.replace,
        shape: GeneratorShape.cycle,
        count: 4,
      );
      final g = Graph<String, num>(isDirected: false);
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.transformedGraph).isNotNull();
      check(out.transformedGraph!.vertices.length).equals(4);
      check(out.transformedGraph!.edges).isNotEmpty();
    });

    test('union mode', () {
      final state = AppState();
      final mod = CombineModifier(
        operation: CombineOperation.union,
        shape: GeneratorShape.path,
        count: 3,
      );
      final g = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1);
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.transformedGraph).isNotNull();
      check(out.transformedGraph!.vertices.length).equals(5);
    });
  });

  group('TraversalModifier', () {
    test('BFS traversal generates tree edges', () {
      final state = AppState();
      final g = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1)
        ..addEdge('A', 'C', value: 1)
        ..addEdge('B', 'C', value: 1);
      final mod = TraversalModifier(type: TraversalType.bfs, startVertex: 'A');
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.overlay).isNotNull();
      final po = out.overlay! as PathOverlay;
      check(po.vertices.length).equals(3);
      check(po.edges.length).equals(2);
    });

    test('DFS traversal generates tree edges', () {
      final state = AppState();
      final g = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1)
        ..addEdge('B', 'C', value: 1);
      final mod = TraversalModifier(type: TraversalType.dfs, startVertex: 'A');
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.overlay).isNotNull();
      final po = out.overlay! as PathOverlay;
      check(po.vertices.length).equals(3);
      check(po.edges.length).equals(2);
    });
  });

  group('CycleDetectionModifier', () {
    test('undirected graph does not throw ArgumentError', () {
      final state = AppState();
      final g = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1)
        ..addEdge('B', 'C', value: 1)
        ..addEdge('C', 'A', value: 1);
      final mod = CycleDetectionModifier();
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.statusSummary).isNotNull().contains('Cycle');
    });

    test('directed acyclic graph', () {
      final state = AppState();
      final g = Graph<String, num>(isDirected: true)
        ..addEdge('A', 'B', value: 1)
        ..addEdge('B', 'C', value: 1);
      final mod = CycleDetectionModifier();
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.statusSummary).isNotNull().contains('Acyclic');
    });
  });

  group('IsomorphismModifier', () {
    test('subgraph isomorphism finds subgraphs', () {
      final state = AppState();
      // G is a 5-cycle
      final g = Graph<String, num>(isDirected: false)
        ..addEdge('1', '2', value: 1)
        ..addEdge('2', '3', value: 1)
        ..addEdge('3', '4', value: 1)
        ..addEdge('4', '5', value: 1)
        ..addEdge('5', '1', value: 1);
      // P is a 5-cycle
      final mod = IsomorphismModifier(
        mode: IsomorphismMode.subgraph,
        shape: GeneratorShape.cycle,
        count: 5,
      );
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.statusSummary).isNotNull().contains('Found');
    });

    test('full isomorphism check', () {
      final state = AppState();
      final g = Graph<String, num>(isDirected: false)
        ..addEdge('P0', 'P1', value: 1)
        ..addEdge('P1', 'P2', value: 1)
        ..addEdge('P2', 'P0', value: 1);
      final mod = IsomorphismModifier(
        mode: IsomorphismMode.full,
        shape: GeneratorShape.cycle,
        count: 3,
      );
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.statusSummary).isNotNull().contains('Isomorphic');
    });
  });

  group('GraphMetricsModifier', () {
    test('undirected graph does not throw ArgumentError', () {
      final state = AppState();
      final g = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1)
        ..addEdge('B', 'C', value: 1)
        ..addEdge('C', 'A', value: 1);
      final mod = GraphMetricsModifier();
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.tableData).isNotNull();
    });

    test('directed graph computes acyclic flag', () {
      final state = AppState();
      final g = Graph<String, num>(isDirected: true)
        ..addEdge('A', 'B', value: 1)
        ..addEdge('B', 'C', value: 1);
      final mod = GraphMetricsModifier();
      final out = mod.apply(g, state);
      check(out.hasError).isFalse();
      check(out.tableData).isNotNull();
    });
  });
}
