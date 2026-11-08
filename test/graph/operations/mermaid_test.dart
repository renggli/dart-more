import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('mermaid', () {
    group('toMermaid', () {
      test('directed', () {
        final graph = GraphFactory<int, void>(isDirected: true)
            .fromSuccessors(cyclicGraphData);
        check(graph.toMermaid().split('\n')).deepEquals([
          'flowchart TD',
          '  v0["0"]',
          '  v1["3"]',
          '  v2["1"]',
          '  v3["2"]',
          '  v4["4"]',
          '  v0 --> v1',
          '  v1 --> v2',
          '  v1 --> v4',
          '  v2 --> v3',
          '  v2 --> v1',
          '  v3 --> v1',
          '  v4 --> v4',
        ]);
      });

      test('undirected', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .fromSuccessors(cyclicGraphData);
        check(graph.toMermaid().split('\n')).deepEquals([
          'flowchart TD',
          '  v0["0"]',
          '  v1["3"]',
          '  v2["1"]',
          '  v3["2"]',
          '  v4["4"]',
          '  v0 --- v1',
          '  v1 --- v2',
          '  v1 --- v3',
          '  v1 --- v4',
          '  v2 --- v3',
          '  v4 --- v4',
        ]);
      });

      test('custom direction and type', () {
        final graph = GraphFactory<String, void>().fromPath(['a', 'b']);
        check(graph.toMermaid(direction: 'LR', type: 'graph').split('\n'))
            .deepEquals(['graph LR', '  a["a"]', '  b["b"]', '  a --> b']);
      });

      test('edge labels with weights', () {
        final graph = GraphFactory<String, int>(edgeProvider: (a, b) => 42)
            .fromPath(['a', 'b']);
        check(
          graph.toMermaid().split('\n'),
        ).deepEquals(['flowchart TD', '  a["a"]', '  b["b"]', '  a -->|42| b']);
      });

      test('custom vertex and edge labels with escaping', () {
        final graph = GraphFactory<String, String>(
          edgeProvider: (a, b) => 'a|b',
        ).fromPath(['a', 'b']);
        check(
          graph
              .toMermaid(
                vertexLabel: (v) => 'Node "$v" [test]',
                edgeLabel: (e) => 'Edge | ${e.value}',
              )
              .split('\n'),
        ).deepEquals([
          'flowchart TD',
          '  a["Node #quot;a#quot; #91;test#93;"]',
          '  b["Node #quot;b#quot; #91;test#93;"]',
          '  a -->|Edge #124; a#124;b| b',
        ]);
      });

      test('isolated vertices', () {
        final graph = Graph<String, void>(isDirected: true)
          ..addVertex('isolated')
          ..addEdge('a', 'b');
        check(graph.toMermaid().split('\n')).deepEquals([
          'flowchart TD',
          '  isolated["isolated"]',
          '  a["a"]',
          '  b["b"]',
          '  a --> b',
        ]);
      });

      test('reserved keywords as vertex names', () {
        final graph = GraphFactory<String, void>().fromPath([
          'subgraph',
          'end',
          'graph',
        ]);
        check(graph.toMermaid().split('\n')).deepEquals([
          'flowchart TD',
          '  v0["subgraph"]',
          '  v1["end"]',
          '  v2["graph"]',
          '  v0 --> v1',
          '  v1 --> v2',
        ]);
      });

      group('subgraphs', () {
        test('default subgraph naming', () {
          final graph = GraphFactory<String, void>().fromPath(['a', 'b', 'c']);
          check(
            graph
                .toMermaid(subgraph: (v) => v == 'a' ? 'Group 1' : 'Group 2')
                .split('\n'),
          ).deepEquals([
            'flowchart TD',
            '  a["a"]',
            '  b["b"]',
            '  c["c"]',
            '  a --> b',
            '  b --> c',
            '  subgraph Group_1 ["Group 1"]',
            '    a',
            '  end',
            '  subgraph Group_2 ["Group 2"]',
            '    b',
            '    c',
            '  end',
          ]);
        });

        test('custom subgraph naming and labels', () {
          final graph = GraphFactory<String, void>().fromPath(['a', 'b', 'c']);
          check(
            graph
                .toMermaid(
                  subgraph: (v) => v == 'a' ? 1 : 2,
                  subgraphName: (s) => 'cluster_$s',
                  subgraphLabel: (s) => 'Cluster #$s',
                )
                .split('\n'),
          ).deepEquals([
            'flowchart TD',
            '  a["a"]',
            '  b["b"]',
            '  c["c"]',
            '  a --> b',
            '  b --> c',
            '  subgraph cluster_1 ["Cluster #1"]',
            '    a',
            '  end',
            '  subgraph cluster_2 ["Cluster #2"]',
            '    b',
            '    c',
            '  end',
          ]);
        });
      });
    });
  });
}
