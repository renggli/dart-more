import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('export', () {
    group('toDot', () {
      test('directed', () {
        final graph = GraphFactory<int, void>(isDirected: true)
            .fromSuccessors(cyclicGraphData);
        check(graph.toDot().split('\n')).deepEquals([
          'digraph {',
          '  0 [label="0"];',
          '  1 [label="3"];',
          '  2 [label="1"];',
          '  3 [label="2"];',
          '  4 [label="4"];',
          '  0 -> 1;',
          '  1 -> 2;',
          '  1 -> 4;',
          '  2 -> 3;',
          '  2 -> 1;',
          '  3 -> 1;',
          '  4 -> 4;',
          '}',
        ]);
      });
      test('undirected', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .fromSuccessors(cyclicGraphData);
        check(graph.toDot().split('\n')).deepEquals([
          'graph {',
          '  0 [label="0"];',
          '  1 [label="3"];',
          '  2 [label="1"];',
          '  3 [label="2"];',
          '  4 [label="4"];',
          '  0 -- 1;',
          '  1 -- 2;',
          '  1 -- 3;',
          '  1 -- 4;',
          '  2 -- 3;',
          '  4 -- 4;',
          '}',
        ]);
      });
      test('default attributes', () {
        final graph = GraphFactory<String, String>(
          edgeProvider: (a, b) => '$a to $b',
        ).fromPath(['a', 'b']);
        check(graph.toDot().split('\n')).deepEquals([
          'digraph {',
          '  0 [label=a];',
          '  1 [label=b];',
          '  0 -> 1 [label="a to b"];',
          '}',
        ]);
      });
      test('custom attributes', () {
        final graph = GraphFactory<String, String>(
          edgeProvider: (a, b) => '$a to $b',
        ).fromPath(['a', 'b']);
        check(
          graph
              .toDot(
                graphAttributes: {'bgcolor': 'lightblue'},
                vertexLabel: (vertex) => 'Vertex $vertex',
                vertexAttributes: (vertex) => {'bgcolor': 'lightgreen'},
                edgeLabel: (edge) => 'Edge ${edge.value}',
                edgeAttributes: (edge) => {'color': 'turquoise'},
              )
              .split('\n'),
        ).deepEquals([
          'digraph {',
          '  bgcolor=lightblue;',
          '  0 [label="Vertex a", bgcolor=lightgreen];',
          '  1 [label="Vertex b", bgcolor=lightgreen];',
          '  0 -> 1 [label="Edge a to b", color=turquoise];',
          '}',
        ]);
      });
    });
  });
}
