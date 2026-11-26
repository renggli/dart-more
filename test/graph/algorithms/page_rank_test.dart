import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('graph extension', () {
    test('empty and single vertex graph', () {
      final g0 = Graph<int, void>(isDirected: true);
      check(g0.pageRank()).isEmpty;

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
      check(pr[0]! > pr[1]!).isTrue;
      check(pr[1]!).isCloseTo(pr[2]!, 1e-6);
      check(pr[2]!).isCloseTo(pr[3]!, 1e-6);

      // Sum of all PageRanks should be approximately 1.0
      final total = pr.values.reduce((a, b) => a + b);
      check(total).isCloseTo(1.0, 1e-4);
    });
  });

  group('standalone', () {
    test('without predecessorsOf or strategy', () {
      final pr = pageRank<int>(
        vertices: [0, 1, 2],
        successorsOf: (v) => v == 0 ? [1] : (v == 1 ? [2] : [0]),
      );
      check(pr[0]!).isCloseTo(1 / 3, 1e-4);
      check(pr[1]!).isCloseTo(1 / 3, 1e-4);
      check(pr[2]!).isCloseTo(1 / 3, 1e-4);
    });

    test('with external predecessor', () {
      final pr = pageRank<int>(
        vertices: [0, 1],
        successorsOf: (v) => v == 0 ? [1] : const [],
        predecessorsOf: (v) => v == 1 ? [0, 99] : const [],
      );
      check(pr.values.reduce((a, b) => a + b)).isCloseTo(1.0, 1e-4);
    });
  });
}
