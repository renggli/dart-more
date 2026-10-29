import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('transitive', () {
    group('transitiveClosure', () {
      test('undirected graph error', () {
        final g = Graph<int, void>(isDirected: false);
        check(g.transitiveClosure).throws<GraphError>();
      });

      test('empty graph', () {
        final g = Graph<int, void>(isDirected: true);
        final tc = g.transitiveClosure();
        check(tc.vertices).isEmpty();
        check(tc.edges).isEmpty();
      });

      test('directed path P3: 0 -> 1 -> 2', () {
        final g = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        final tc = g.transitiveClosure();
        check(tc.vertices).unorderedEquals([0, 1, 2]);
        check(tc.containsEdge(0, 1)).isTrue();
        check(tc.containsEdge(1, 2)).isTrue();
        check(tc.containsEdge(0, 2)).isTrue();
        check(tc.containsEdge(2, 0)).isFalse();
        check(tc.containsEdge(0, 0)).isFalse();
      });

      test('directed cycle C3: 0 -> 1 -> 2 -> 0', () {
        final g = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 0);

        final tc = g.transitiveClosure();
        // Complete directed graph with self-loops because every node can reach every node
        for (final u in [0, 1, 2]) {
          for (final v in [0, 1, 2]) {
            check(tc.containsEdge(u, v)).isTrue();
          }
        }
      });
    });

    group('transitiveReduction', () {
      test('undirected graph error', () {
        final g = Graph<int, void>(isDirected: false);
        check(g.transitiveReduction).throws<GraphError>();
      });

      test('graph with cycle throws GraphError', () {
        final g = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(1, 0);
        check(g.transitiveReduction).throws<GraphError>();
      });

      test('empty graph', () {
        final g = Graph<int, void>(isDirected: true);
        final tr = g.transitiveReduction();
        check(tr.vertices).isEmpty();
        check(tr.edges).isEmpty();
      });

      test('triangle with shortcut: 0 -> 1 -> 2 and 0 -> 2', () {
        final g = Graph<int, String>(isDirected: true)
          ..addEdge(0, 1, value: 'a')
          ..addEdge(1, 2, value: 'b')
          ..addEdge(0, 2, value: 'redundant');

        final tr = g.transitiveReduction();
        check(tr.vertices).unorderedEquals([0, 1, 2]);
        check(tr.containsEdge(0, 1)).isTrue();
        check(tr.containsEdge(1, 2)).isTrue();
        check(tr.containsEdge(0, 2)).isFalse();
        check(tr.getEdge(0, 1)?.value).equals('a');
        check(tr.getEdge(1, 2)?.value).equals('b');
      });

      test('diamond with shortcut', () {
        // 0 -> 1 -> 3, 0 -> 2 -> 3, and shortcut 0 -> 3
        final g = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(1, 3)
          ..addEdge(0, 2)
          ..addEdge(2, 3)
          ..addEdge(0, 3);

        final tr = g.transitiveReduction();
        check(tr.containsEdge(0, 1)).isTrue();
        check(tr.containsEdge(1, 3)).isTrue();
        check(tr.containsEdge(0, 2)).isTrue();
        check(tr.containsEdge(2, 3)).isTrue();
        check(tr.containsEdge(0, 3)).isFalse();
      });
    });
  });
}
