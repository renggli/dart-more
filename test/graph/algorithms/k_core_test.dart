import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('kCore', () {
    test('directed graph error', () {
      final g = Graph<int, void>(isDirected: true);
      check(g.coreNumbers).throws<GraphError>();
      check(() => g.kCore(1)).throws<GraphError>();
    });

    test('empty graph', () {
      final g = Graph<int, void>(isDirected: false);
      check(g.coreNumbers()).isEmpty();
      check(g.kCore(1).vertices).isEmpty();
    });

    test('single isolated vertex has core 0', () {
      final g = Graph<int, void>(isDirected: false)..addVertex(1);
      final cores = g.coreNumbers();
      check(cores[1]).equals(0);
      check(g.kCore(0).vertices).unorderedEquals([1]);
      check(g.kCore(1).vertices).isEmpty();
    });

    test('line graph P3 has core 1', () {
      final g = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3);
      final cores = g.coreNumbers();
      check(cores[1]).equals(1);
      check(cores[2]).equals(1);
      check(cores[3]).equals(1);
      check(g.kCore(1).vertices).unorderedEquals([1, 2, 3]);
      check(g.kCore(2).vertices).isEmpty();
    });

    test('triangle with a pendant edge (antenna)', () {
      // Triangle {1, 2, 3} + edge {3, 4}
      final g = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1)
        ..addEdge(3, 4);

      final cores = g.coreNumbers();
      // Vertex 4 has degree 1 -> core 1.
      // After peeling 4, vertex 3 still has degree 2 in triangle.
      // Vertices 1, 2, 3 form a 2-core (cycle/clique).
      check(cores[4]).equals(1);
      check(cores[1]).equals(2);
      check(cores[2]).equals(2);
      check(cores[3]).equals(2);

      final k2 = g.kCore(2);
      check(k2.vertices).unorderedEquals([1, 2, 3]);
      check(k2.containsEdge(1, 2)).isTrue();
      check(k2.containsEdge(2, 3)).isTrue();
      check(k2.containsEdge(3, 1)).isTrue();
      check(k2.containsVertex(4)).isFalse();

      final k3 = g.kCore(3);
      check(k3.vertices).isEmpty();
    });

    test('complete graph K4 has core 3', () {
      final k4 = GraphFactory<int, void>(isDirected: false)
          .complete(vertexCount: 4);
      final cores = k4.coreNumbers();
      for (var i = 0; i < 4; i++) {
        check(cores[i]).equals(3);
      }
      check(k4.kCore(3).vertices.length).equals(4);
      check(k4.kCore(4).vertices).isEmpty();
    });
  });
}
