import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('vertex cover and independent set', () {
    test('directed graph error', () {
      final g = Graph<int, void>(isDirected: true);
      check(g.minimumVertexCover).throws<GraphError>();
      check(g.maximumIndependentSet).throws<GraphError>();
    });

    test('empty graph', () {
      final g = Graph<int, void>(isDirected: false);
      check(g.minimumVertexCover()).isEmpty();
      check(g.maximumIndependentSet()).isEmpty();
      check(g.minimumVertexCover(approximate: true)).isEmpty();
      check(g.maximumIndependentSet(approximate: true)).isEmpty();
    });

    test('single isolated vertex', () {
      final g = Graph<int, void>(isDirected: false)..addVertex(1);
      check(g.minimumVertexCover()).isEmpty();
      check(g.maximumIndependentSet()).unorderedEquals([1]);
      check(g.minimumVertexCover(approximate: true)).isEmpty();
      check(g.maximumIndependentSet(approximate: true)).unorderedEquals([1]);
    });

    test('single vertex with self-loop', () {
      final g = Graph<int, void>(isDirected: false)..addEdge(1, 1);
      check(g.minimumVertexCover()).unorderedEquals([1]);
      check(g.maximumIndependentSet()).isEmpty();
      check(g.minimumVertexCover(approximate: true)).unorderedEquals([1]);
      check(g.maximumIndependentSet(approximate: true)).isEmpty();
    });

    group('bipartite graphs (exact via König)', () {
      test('single edge: 1 - 2', () {
        final g = Graph<int, void>(isDirected: false)..addEdge(1, 2);
        final cover = g.minimumVertexCover();
        final ind = g.maximumIndependentSet();
        check(cover.length).equals(1);
        check(ind.length).equals(1);
        check(cover.intersection(ind)).isEmpty();
      });

      test('complete bipartite K(2, 3)', () {
        final g = Graph<int, void>(isDirected: false)
          ..addEdge(1, 3)
          ..addEdge(1, 4)
          ..addEdge(1, 5)
          ..addEdge(2, 3)
          ..addEdge(2, 4)
          ..addEdge(2, 5);

        final cover = g.minimumVertexCover();
        check(cover).unorderedEquals([1, 2]);

        final ind = g.maximumIndependentSet();
        check(ind).unorderedEquals([3, 4, 5]);
      });
    });

    group('non-bipartite graphs (exact branch-and-bound)', () {
      test('triangle C3', () {
        final g = Graph<int, void>(isDirected: false)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);

        final cover = g.minimumVertexCover();
        check(cover.length).equals(2);

        final ind = g.maximumIndependentSet();
        check(ind.length).equals(1);
        check(cover.intersection(ind)).isEmpty();
      });

      test('5-cycle C5', () {
        final g = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 5);
        final cover = g.minimumVertexCover();
        check(cover.length).equals(3);

        final ind = g.maximumIndependentSet();
        check(ind.length).equals(2);
        check(cover.intersection(ind)).isEmpty();
      });

      test('complete graph K5', () {
        final g = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 5);
        final cover = g.minimumVertexCover();
        check(cover.length).equals(4);

        final ind = g.maximumIndependentSet();
        check(ind.length).equals(1);
        check(cover.intersection(ind)).isEmpty();
      });

      test('Petersen graph', () {
        final petersen = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 4)
          ..addEdge(4, 0)
          ..addEdge(5, 7)
          ..addEdge(7, 9)
          ..addEdge(9, 6)
          ..addEdge(6, 8)
          ..addEdge(8, 5)
          ..addEdge(0, 5)
          ..addEdge(1, 6)
          ..addEdge(2, 7)
          ..addEdge(3, 8)
          ..addEdge(4, 9);

        // Independence number of Petersen graph is 4, vertex cover is 6
        final ind = petersen.maximumIndependentSet();
        check(ind.length).equals(4);

        final cover = petersen.minimumVertexCover();
        check(cover.length).equals(6);
        check(cover.intersection(ind)).isEmpty();
      });
    });

    group('approximation algorithms', () {
      test('approximate 2-cover on K6', () {
        final g = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 6);
        final approxCover = g.minimumVertexCover(approximate: true);
        // Any valid vertex cover must cover all edges
        for (final edge in g.edges) {
          check(
            approxCover.contains(edge.source) ||
                approxCover.contains(edge.target),
          ).isTrue();
        }
        // Size of 2-approximation is at most 2 * optimal (optimal is 5)
        check(approxCover.length <= 10).isTrue();
      });

      test('approximate independent set on Petersen graph', () {
        final petersen = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 4)
          ..addEdge(4, 0)
          ..addEdge(5, 7)
          ..addEdge(7, 9)
          ..addEdge(9, 6)
          ..addEdge(6, 8)
          ..addEdge(8, 5)
          ..addEdge(0, 5)
          ..addEdge(1, 6)
          ..addEdge(2, 7)
          ..addEdge(3, 8)
          ..addEdge(4, 9);

        final ind = petersen.maximumIndependentSet(approximate: true);
        // Must be an independent set (no edge between any pair)
        for (final u in ind) {
          for (final v in ind) {
            if (u != v) {
              check(petersen.containsEdge(u, v)).isFalse();
            }
          }
        }
      });
    });

    group('standalone functions', () {
      test('standalone approximateMinimumVertexCover and approximateMaximumIndependentSet', () {
        final cover = approximateMinimumVertexCover<String>(
          vertices: ['a', 'b', 'c'],
          neighboursOf: (v) => switch (v) {
            'a' => ['b', 'c'],
            'b' => ['a'],
            'c' => ['a'],
            _ => const [],
          },
        );
        check(
          cover.contains('a') || (cover.contains('b') && cover.contains('c')),
        ).isTrue();

        final ind = approximateMaximumIndependentSet<String>(
          vertices: ['a', 'b', 'c'],
          neighboursOf: (v) => switch (v) {
            'a' => ['b', 'c'],
            'b' => ['a'],
            'c' => ['a'],
            _ => const [],
          },
        );
        check(ind.isNotEmpty).isTrue();
      });
    });
  });
}
