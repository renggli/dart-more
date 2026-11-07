import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('centrality', () {
    group('betweennessCentrality', () {
      test('empty and small graphs', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.betweennessCentrality()).isEmpty();

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.betweennessCentrality()[1]).equals(0.0);

        final g2 = Graph<int, void>(isDirected: false)..addEdge(1, 2);
        final bc2 = g2.betweennessCentrality();
        check(bc2[1]).equals(0.0);
        check(bc2[2]).equals(0.0);
      });

      test('line graph P3: 0 - 1 - 2', () {
        final p3 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        // Vertex 1 lies on the only shortest path between 0 and 2.
        // For unnormalized: 1.0 for vertex 1, 0.0 for endpoints 0 and 2.
        final unnorm = p3.betweennessCentrality(normalized: false);
        check(unnorm[0]).equals(0.0);
        check(unnorm[1]).equals(1.0);
        check(unnorm[2]).equals(0.0);

        // Normalized: scale factor is 2 / ((3-1)(3-2)) = 1.0.
        final norm = p3.betweennessCentrality(normalized: true);
        check(norm[1]).equals(1.0);
      });

      test('star graph S5 (central hub)', () {
        final star = GraphFactory<int, void>(isDirected: false)
            .star(vertexCount: 5);
        // Star has center 0 and leaves 1, 2, 3, 4.
        // All paths between any pair of leaves pass through 0.
        // Number of pairs of leaves = 4 * 3 / 2 = 6.
        final unnorm = star.betweennessCentrality(normalized: false);
        check(unnorm[0]).equals(6.0);
        check(unnorm[1]).equals(0.0);
        check(unnorm[2]).equals(0.0);
        check(unnorm[3]).equals(0.0);
        check(unnorm[4]).equals(0.0);

        // Normalized: scale factor 2 / (4 * 3) = 1/6.
        // So center has normalized score 6 * (1/6) = 1.0.
        final norm = star.betweennessCentrality(normalized: true);
        check(norm[0]).equals(1.0);
      });

      test('directed line: 0 -> 1 -> 2', () {
        final p3Dir = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        final bc = p3Dir.betweennessCentrality(normalized: false);
        check(bc[0]).equals(0.0);
        check(bc[1]).equals(1.0);
        check(bc[2]).equals(0.0);
      });
    });

    group('closenessCentrality', () {
      test('line graph P3: 0 - 1 - 2', () {
        final p3 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        // Distances from 1: d(1, 0)=1, d(1, 2)=1. Sum = 2.
        // Closeness of 1: (3-1) / 2 = 1.0.
        // Distances from 0: d(0, 1)=1, d(0, 2)=2. Sum = 3.
        // Closeness of 0: (3-1) / 3 = 2/3.
        final cc = p3.closenessCentrality();
        check(cc[1]).equals(1.0);
        check(cc[0]!).isCloseTo(2 / 3, 1e-6);
        check(cc[2]!).isCloseTo(2 / 3, 1e-6);
      });

      test('disconnected graph', () {
        final g = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addVertex(2);

        final cc = g.closenessCentrality();
        // 2 reaches 0 other vertices -> 0.0
        check(cc[2]).equals(0.0);
        // 0 reaches 1 out of 2 other vertices with dist 1.
        // Wasserman-Faust: (1 / 2) * (1 / 1) = 0.5.
        check(cc[0]).equals(0.5);
      });
    });

    group('pageRank', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: true);
        check(g0.pageRank()).isEmpty();

        final g1 = Graph<int, void>(isDirected: true)..addVertex(1);
        check(g1.pageRank()[1]).equals(1.0);
      });

      test('ring graph R3 (symmetric scores)', () {
        final ring = GraphFactory<int, void>(isDirected: true)
            .ring(vertexCount: 3);
        final pr = ring.pageRank();
        check(pr[0]!).isCloseTo(1 / 3, 1e-4);
        check(pr[1]!).isCloseTo(1 / 3, 1e-4);
        check(pr[2]!).isCloseTo(1 / 3, 1e-4);
      });

      test('star graph pointing to center (center has highest PageRank)', () {
        // Directed star where leaves 1, 2, 3 point to hub 0
        final star = Graph<int, void>(isDirected: true)
          ..addEdge(1, 0)
          ..addEdge(2, 0)
          ..addEdge(3, 0);

        final pr = star.pageRank();
        check(pr[0]! > pr[1]!).isTrue();
        check(pr[1]!).isCloseTo(pr[2]!, 1e-6);
        check(pr[2]!).isCloseTo(pr[3]!, 1e-6);

        // Sum of all PageRanks should be approximately 1.0
        final total = pr.values.reduce((a, b) => a + b);
        check(total).isCloseTo(1.0, 1e-4);
      });
    });

    group('degreeCentrality', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.degreeCentrality()).isEmpty();

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.degreeCentrality()[1]).equals(0.0);
      });

      test('undirected line P3: 0 - 1 - 2', () {
        final p3 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        final dc = p3.degreeCentrality();
        check(dc[0]).equals(0.5);
        check(dc[1]).equals(1.0);
        check(dc[2]).equals(0.5);
      });

      test('complete graph K4', () {
        final k4 = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 4);
        final dc = k4.degreeCentrality();
        for (var i = 0; i < 4; i++) {
          check(dc[i]).equals(1.0);
        }
      });

      test('directed line: in-, out-, and total degree centrality', () {
        final g = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        final inDc = g.inDegreeCentrality();
        check(inDc[0]).equals(0.0);
        check(inDc[1]).equals(0.5);
        check(inDc[2]).equals(0.5);

        final outDc = g.outDegreeCentrality();
        check(outDc[0]).equals(0.5);
        check(outDc[1]).equals(0.5);
        check(outDc[2]).equals(0.0);

        final dc = g.degreeCentrality();
        check(dc[0]).equals(0.5);
        check(dc[1]).equals(1.0);
        check(dc[2]).equals(0.5);
      });

      test('standalone degreeCentrality function', () {
        final res = degreeCentrality<String>(
          vertices: ['a', 'b', 'c'],
          degreeOf: (v) => v == 'b' ? 2 : 1,
        );
        check(res['a']).equals(0.5);
        check(res['b']).equals(1.0);
        check(res['c']).equals(0.5);
      });
    });

    group('eigenvectorCentrality', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.eigenvectorCentrality()).isEmpty();

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.eigenvectorCentrality()[1]).equals(0.0);

        final g1Loop = Graph<int, void>(isDirected: false)..addEdge(1, 1);
        check(g1Loop.eigenvectorCentrality()[1]).equals(1.0);
      });

      test('disconnected vertices (zero norm)', () {
        final g = Graph<int, void>(isDirected: false)
          ..addVertex(1)
          ..addVertex(2);
        final ec = g.eigenvectorCentrality();
        check(ec[1]).equals(0.0);
        check(ec[2]).equals(0.0);
      });

      test('undirected ring R3', () {
        final ring = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 3);
        final ec = ring.eigenvectorCentrality();
        const expected = 1 / 1.7320508; // 1 / sqrt(3)
        check(ec[0]!).isCloseTo(expected, 1e-4);
        check(ec[1]!).isCloseTo(expected, 1e-4);
        check(ec[2]!).isCloseTo(expected, 1e-4);
      });

      test('star graph S3 (center has higher score)', () {
        final star = GraphFactory<int, void>(isDirected: false)
            .star(vertexCount: 3);
        // Center is 0, leaves are 1 and 2.
        final ec = star.eigenvectorCentrality();
        // x_0 = sqrt(0.5) ~ 0.7071, x_1 = x_2 = 0.5.
        check(ec[0]!).isCloseTo(0.707106, 1e-4);
        check(ec[1]!).isCloseTo(0.5, 1e-4);
        check(ec[2]!).isCloseTo(0.5, 1e-4);
      });

      test('weighted edges', () {
        final g = Graph<int, int>(isDirected: false)
          ..addEdge(0, 1, value: 2)
          ..addEdge(0, 2, value: 1);
        final ec = g.eigenvectorCentrality(
          edgeWeight: (u, v) => g.getEdge(u, v)!.value,
        );
        check(ec[1]! > ec[2]!).isTrue();
      });

      test(
        'standalone eigenvectorCentrality function without predecessorsOf',
        () {
          final ec = eigenvectorCentrality<int>(
            vertices: [1, 2, 3],
            successorsOf: (v) => v == 1 ? [2, 3] : [1],
          );
          check(ec[1]!).isCloseTo(0.707106, 1e-4);
          check(ec[2]!).isCloseTo(0.5, 1e-4);
          check(ec[3]!).isCloseTo(0.5, 1e-4);
        },
      );
    });
  });
}
