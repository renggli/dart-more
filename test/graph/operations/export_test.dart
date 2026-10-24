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
      test('reserved keywords are quoted', () {
        final graph = GraphFactory<String, void>().fromPath([
          'graph',
          'node',
          'edge',
        ]);
        check(graph.toDot().split('\n')).deepEquals([
          'digraph {',
          '  0 [label="graph"];',
          '  1 [label="node"];',
          '  2 [label="edge"];',
          '  0 -> 1;',
          '  1 -> 2;',
          '}',
        ]);
      });
      group('subgraphs', () {
        test('default', () {
          final graph = GraphFactory<String, void>().fromPath([
            'a',
            'b',
            'c',
            'd',
          ]);
          check(
            graph
                .toDot(
                  subgraph: (vertex) => vertex == 'a' || vertex == 'b'
                      ? 'first'
                      : vertex == 'c'
                      ? 'second'
                      : null,
                )
                .split('\n'),
          ).deepEquals([
            'digraph {',
            '  0 [label=a];',
            '  1 [label=b];',
            '  2 [label=c];',
            '  3 [label=d];',
            '  0 -> 1;',
            '  1 -> 2;',
            '  2 -> 3;',
            '  subgraph { label=first; 0; 1; }',
            '  subgraph { label=second; 2; }',
            '}',
          ]);
        });
        test('custom label and attributes', () {
          final graph = GraphFactory<String, void>().fromPath(['a', 'b']);
          check(
            graph
                .toDot(
                  subgraph: (vertex) => 'g',
                  subgraphLabel: (group) => 'Group $group',
                  subgraphAttributes: (group) => {'color': 'blue'},
                )
                .split('\n'),
          ).deepEquals([
            'digraph {',
            '  0 [label=a];',
            '  1 [label=b];',
            '  0 -> 1;',
            '  subgraph { label="Group g"; color=blue; 0; 1; }',
            '}',
          ]);
        });
        test('named cluster', () {
          final graph = GraphFactory<String, void>().fromPath(['a', 'b']);
          check(
            graph
                .toDot(
                  subgraph: (vertex) => 'cluster_0',
                  subgraphName: (group) => group.toString(),
                  subgraphLabel: (group) => 'Cluster A',
                )
                .split('\n'),
          ).deepEquals([
            'digraph {',
            '  0 [label=a];',
            '  1 [label=b];',
            '  0 -> 1;',
            '  subgraph cluster_0 { label="Cluster A"; 0; 1; }',
            '}',
          ]);
        });
        test('named cluster with special characters', () {
          final graph = GraphFactory<String, void>().fromPath(['a', 'b']);
          check(
            graph
                .toDot(
                  subgraph: (vertex) => 0,
                  subgraphName: (group) => 'cluster $group',
                  subgraphLabel: (group) => '',
                )
                .split('\n'),
          ).deepEquals([
            'digraph {',
            '  0 [label=a];',
            '  1 [label=b];',
            '  0 -> 1;',
            '  subgraph "cluster 0" { 0; 1; }',
            '}',
          ]);
        });
        test('no vertices matched', () {
          final graph = GraphFactory<String, void>().fromPath(['a', 'b']);
          check(graph.toDot(subgraph: (vertex) => null).split('\n')).deepEquals(
            ['digraph {', '  0 [label=a];', '  1 [label=b];', '  0 -> 1;', '}'],
          );
        });
      });
    });
  });
}
