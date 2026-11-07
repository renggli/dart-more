import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('community detection and modularity', () {
    test('directed graph error on undirected community algorithms', () {
      final directed = Graph<int, void>.directed()..addEdge(1, 2);
      check(directed.labelPropagationCommunities).throws<GraphError>();
      check(directed.louvainCommunities).throws<GraphError>();
    });

    group('modularity', () {
      test('empty graph', () {
        final graph = Graph<int, void>.undirected();
        check(graph.modularity([])).equals(0.0);
      });

      test('graph without edges', () {
        final graph = Graph<int, void>.undirected()
          ..addVertex(1)
          ..addVertex(2);
        check(
          graph.modularity([
            {1},
            {2},
          ]),
        ).equals(0.0);
      });

      test('all vertices in single community yields zero modularity', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);
        check(
          graph.modularity([
            {1, 2, 3},
          ]),
        ).equals(0.0);
      });

      test('two disjoint cliques', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          ..addEdge(6, 4);
        final q = graph.modularity([
          {1, 2, 3},
          {4, 5, 6},
        ]);
        check(q).equals(0.5);
      });

      test('directed graph modularity', () {
        final directed = Graph<int, void>.directed()
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          ..addEdge(6, 4);
        final q = directed.modularity([
          {1, 2, 3},
          {4, 5, 6},
        ]);
        check(q).equals(0.5);
      });

      test('weighted edges modularity', () {
        final graph = Graph<int, num>.undirected()
          ..addEdge(1, 2, value: 5)
          ..addEdge(3, 4, value: 5);
        final q = graph.modularity([
          {1, 2},
          {3, 4},
        ]);
        check(q).equals(0.5);
      });
    });

    group('label propagation', () {
      test('empty graph', () {
        final graph = Graph<int, void>.undirected();
        check(graph.labelPropagationCommunities()).isEmpty();
      });

      test('single vertex', () {
        final graph = Graph<int, void>.undirected()..addVertex(1);
        final communities = graph.labelPropagationCommunities().toList();
        check(communities).length.equals(1);
        check(communities.first).deepEquals({1});
      });

      test('disjoint triangles', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          ..addEdge(6, 4);
        final communities = graph
            .labelPropagationCommunities()
            .map((c) => c.toSet())
            .toSet();
        check(communities).deepEquals({
          {1, 2, 3},
          {4, 5, 6},
        });
      });

      test('two cliques connected by a weak bridge', () {
        final graph = Graph<int, num>.undirected()
          ..addEdge(1, 2, value: 2)
          ..addEdge(2, 3, value: 2)
          ..addEdge(3, 1, value: 2)
          ..addEdge(4, 5, value: 2)
          ..addEdge(5, 6, value: 2)
          ..addEdge(6, 4, value: 2)
          ..addEdge(3, 4, value: 0.5);
        final communities = graph
            .labelPropagationCommunities()
            .map((c) => c.toSet())
            .toSet();
        check(communities).deepEquals({
          {1, 2, 3},
          {4, 5, 6},
        });
      });

      test('randomized label propagation', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          ..addEdge(6, 4);
        final communities = graph
            .labelPropagationCommunities(random: Random(42))
            .map((c) => c.toSet())
            .toSet();
        check(communities).deepEquals({
          {1, 2, 3},
          {4, 5, 6},
        });
      });
    });

    group('louvain', () {
      test('empty graph', () {
        final graph = Graph<int, void>.undirected();
        check(graph.louvainCommunities()).isEmpty();
      });

      test('single vertex', () {
        final graph = Graph<int, void>.undirected()..addVertex(1);
        final communities = graph.louvainCommunities().toList();
        check(communities).length.equals(1);
        check(communities.first).deepEquals({1});
      });

      test('graph with only isolated vertices', () {
        final graph = Graph<int, void>.undirected()
          ..addVertex(1)
          ..addVertex(2);
        final communities = graph
            .louvainCommunities()
            .map((c) => c.toSet())
            .toSet();
        check(communities).deepEquals({
          {1},
          {2},
        });
      });

      test('two triangles connected by a bridge', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          ..addEdge(6, 4)
          ..addEdge(3, 4);
        final communities = graph
            .louvainCommunities()
            .map((c) => c.toSet())
            .toSet();
        check(communities).deepEquals({
          {1, 2, 3},
          {4, 5, 6},
        });
      });

      test('resolution effects', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          ..addEdge(6, 4)
          ..addEdge(3, 4);

        // Low resolution merges everything into 1 community
        final lowRes = graph
            .louvainCommunities(resolution: 0.05)
            .map((c) => c.toSet())
            .toSet();
        check(lowRes).deepEquals({
          {1, 2, 3, 4, 5, 6},
        });

        // High resolution splits into smaller communities
        final highRes = graph
            .louvainCommunities(resolution: 5.0)
            .map((c) => c.toSet())
            .toSet();
        check(highRes.length).isGreaterThan(2);
      });

      test('weighted edges', () {
        final graph = Graph<int, num>.undirected()
          // Strong triangle 1
          ..addEdge(1, 2, value: 10)
          ..addEdge(2, 3, value: 10)
          ..addEdge(3, 1, value: 10)
          // Strong triangle 2
          ..addEdge(4, 5, value: 10)
          ..addEdge(5, 6, value: 10)
          ..addEdge(6, 4, value: 10)
          // Weak bridge
          ..addEdge(3, 4, value: 1);
        final communities = graph
            .louvainCommunities()
            .map((c) => c.toSet())
            .toSet();
        check(communities).deepEquals({
          {1, 2, 3},
          {4, 5, 6},
        });
      });

      test('graph with self-loops', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 2)
          ..addEdge(3, 3)
          ..addEdge(3, 4)
          ..addEdge(4, 4);
        final communities = graph
            .louvainCommunities()
            .map((c) => c.toSet())
            .toSet();
        check(communities).deepEquals({
          {1, 2},
          {3, 4},
        });
      });
    });

    group('standalone functions', () {
      test('standalone modularity, label propagation, and louvain', () {
        final edges = {
          1: [2, 3],
          2: [1, 3],
          3: [1, 2],
        };
        final lpa = labelPropagationCommunities(
          vertices: [1, 2, 3],
          neighboursOf: (v) => edges[v]!,
        );
        check(lpa.map((c) => c.toSet()).toSet()).deepEquals({
          {1, 2, 3},
        });

        final louvain = louvainCommunities(
          vertices: [1, 2, 3],
          neighboursOf: (v) => edges[v]!,
        );
        check(louvain.map((c) => c.toSet()).toSet()).deepEquals({
          {1, 2, 3},
        });

        final mod = modularity(
          vertices: [1, 2, 3],
          successorsOf: (v) => edges[v]!,
          communities: [
            {1, 2, 3},
          ],
          isDirected: false,
        );
        check(mod).equals(0.0);
      });
    });
  });
}
