import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('blossom matching', () {
    test('directed graph throws GraphError', () {
      final g = Graph<int, void>(isDirected: true);
      check(g.maximumMatching).throws<GraphError>();
    });

    test('empty and trivial graphs', () {
      final g0 = Graph<int, void>(isDirected: false);
      check(g0.maximumMatching()).isEmpty();

      final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
      check(g1.maximumMatching()).isEmpty();

      final g2 = Graph<int, void>(isDirected: false)..addEdge(1, 2);
      final m2 = g2.maximumMatching();
      check(m2[1]).equals(2);
      check(m2[2]).equals(1);

      final gDisconnected = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(3, 4);
      final mDisc = gDisconnected.maximumMatching();
      check(mDisc[1]).equals(2);
      check(mDisc[2]).equals(1);
      check(mDisc[3]).equals(4);
      check(mDisc[4]).equals(3);
    });

    test('bipartite graphs', () {
      final p4 = GraphFactory<int, void>(isDirected: false)
          .path(vertexCount: 4);
      final mP4 = p4.maximumMatching();
      check(mP4.length).equals(4);
      check(mP4[0]).equals(1);
      check(mP4[1]).equals(0);
      check(mP4[2]).equals(3);
      check(mP4[3]).equals(2);
    });

    test('triangle C3 (odd cycle)', () {
      final triangle = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1);
      final m = triangle.maximumMatching();
      check(m.length).equals(2);
      // Valid matching: one pair matched, one vertex unmatched
      final matchedPair = m.entries.first;
      check(m[matchedPair.value]).equals(matchedPair.key);
    });

    test('triangle with stem (blossom contraction)', () {
      // Triangle 0-1-2 with stem 0-3:
      // Can achieve perfect matching: 0-3 and 1-2.
      final g = Graph<int, void>(isDirected: false)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 0)
        ..addEdge(0, 3);
      final m = g.maximumMatching();
      check(m.length).equals(4);
      check(m[0]).equals(3);
      check(m[3]).equals(0);
      check(m[1]).equals(2);
      check(m[2]).equals(1);
    });

    test('5-cycle and 7-cycle', () {
      final c5 = GraphFactory<int, void>(isDirected: false)
          .ring(vertexCount: 5);
      final m5 = c5.maximumMatching();
      check(m5.length).equals(4);

      final c7 = GraphFactory<int, void>(isDirected: false)
          .ring(vertexCount: 7);
      final m7 = c7.maximumMatching();
      check(m7.length).equals(6);
    });

    test('bowtie graph (two triangles sharing a vertex)', () {
      final bowtie = Graph<int, void>(isDirected: false)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 0)
        ..addEdge(2, 3)
        ..addEdge(3, 4)
        ..addEdge(4, 2);
      final m = bowtie.maximumMatching();
      // Maximum matching has 2 edges (4 vertices in symmetric map)
      check(m.length).equals(4);
      for (final entry in m.entries) {
        check(m[entry.value]).equals(entry.key);
      }
    });

    test('complete graphs Kn', () {
      final k4 = GraphFactory<int, void>(isDirected: false)
          .complete(vertexCount: 4);
      final m4 = k4.maximumMatching();
      check(m4.length).equals(4);

      final k5 = GraphFactory<int, void>(isDirected: false)
          .complete(vertexCount: 5);
      final m5 = k5.maximumMatching();
      check(m5.length).equals(4);

      final k6 = GraphFactory<int, void>(isDirected: false)
          .complete(vertexCount: 6);
      final m6 = k6.maximumMatching();
      check(m6.length).equals(6);
    });

    test('Petersen graph has perfect matching of size 5', () {
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
      final m = petersen.maximumMatching();
      check(m.length).equals(10);
      for (final entry in m.entries) {
        check(m[entry.value]).equals(entry.key);
      }
    });

    test('standalone maximumMatching function', () {
      final m = maximumMatching<String>(
        vertices: ['a', 'b', 'c', 'd'],
        neighboursOf: (v) => switch (v) {
          'a' => ['b', 'c', 'd'],
          'b' => ['a', 'c'],
          'c' => ['a', 'b'],
          'd' => ['a'],
          _ => const [],
        },
      );
      check(m.length).equals(4);
      check(m['a']).equals('d');
      check(m['d']).equals('a');
      check(m['b']).equals('c');
      check(m['c']).equals('b');
    });
  });
}
