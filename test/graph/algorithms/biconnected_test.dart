import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('biconnected', () {
    test('directed graph error', () {
      final graph = Graph<int, void>(isDirected: true);
      check(graph.articulationPoints).throws<GraphError>();
      check(graph.bridges).throws<GraphError>();
      check(graph.biconnectedComponents).throws<GraphError>();
    });

    test('empty graph', () {
      final graph = Graph<int, void>(isDirected: false);
      check(graph.articulationPoints()).isEmpty();
      check(graph.bridges()).isEmpty();
      check(graph.biconnectedComponents()).isEmpty();
    });

    test('isolated vertex', () {
      final graph = Graph<int, void>(isDirected: false)..addVertex(1);
      check(graph.articulationPoints()).isEmpty();
      check(graph.bridges()).isEmpty();
      final components = graph.biconnectedComponents().toList();
      check(components.length).equals(1);
      check(components.first.vertices).deepEquals([1]);
    });

    test('single edge (bridge, no articulation points)', () {
      final graph = Graph<int, void>(isDirected: false)..addEdge(1, 2);
      check(graph.articulationPoints()).isEmpty();
      final bridges = graph.bridges();
      check(bridges.length).equals(1);
      final edge = bridges.single;
      check(
        (edge.source == 1 && edge.target == 2) ||
            (edge.source == 2 && edge.target == 1),
      ).isTrue();

      final components = graph.biconnectedComponents().toList();
      check(components.length).equals(1);
      check(components.first.edges.length).equals(2); // undirected pair
    });

    test('line graph: 1 - 2 - 3', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3);
      // Vertex 2 is an articulation point
      check(graph.articulationPoints()).unorderedEquals([2]);
      // Both edges are bridges
      check(graph.bridges().length).equals(2);
      // Two biconnected components
      final components = graph.biconnectedComponents().toList();
      check(components.length).equals(2);
    });

    test('triangle graph (cycle C3): no articulation points, no bridges', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1);
      check(graph.articulationPoints()).isEmpty();
      check(graph.bridges()).isEmpty();
      final components = graph.biconnectedComponents().toList();
      check(components.length).equals(1);
      check(components.first.vertices).unorderedEquals([1, 2, 3]);
    });

    test('bowtie / two triangles joined at a vertex (articulation point, no bridges)', () {
      // Triangles (1, 2, 3) and (3, 4, 5) joined at vertex 3
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1)
        ..addEdge(3, 4)
        ..addEdge(4, 5)
        ..addEdge(5, 3);
      check(graph.articulationPoints()).unorderedEquals([3]);
      check(graph.bridges()).isEmpty();

      final components = graph.biconnectedComponents().toList();
      check(components.length).equals(2);
      final c1 = components[0].vertices.toSet();
      final c2 = components[1].vertices.toSet();
      check(
        (c1.contains(1) && c2.contains(4)) ||
            (c1.contains(4) && c2.contains(1)),
      ).isTrue();
    });

    test('dumbbell graph (two triangles connected by a bridge)', () {
      // Triangle (1, 2, 3), bridge (3, 4), triangle (4, 5, 6)
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1)
        ..addEdge(3, 4)
        ..addEdge(4, 5)
        ..addEdge(5, 6)
        ..addEdge(6, 4);
      // Articulation points: 3 and 4
      check(graph.articulationPoints()).unorderedEquals([3, 4]);
      // Bridge: (3, 4)
      final bridges = graph.bridges();
      check(bridges.length).equals(1);
      final b = bridges.single;
      check(
        (b.source == 3 && b.target == 4) || (b.source == 4 && b.target == 3),
      ).isTrue();
      // Biconnected components: triangle 1, bridge edge, triangle 2
      final components = graph.biconnectedComponents().toList();
      check(components.length).equals(3);
    });

    test('disconnected components', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(4, 5)
        ..addEdge(5, 6)
        ..addEdge(6, 4);
      // Articulation points: 2
      check(graph.articulationPoints()).unorderedEquals([2]);
      // Bridges: (1, 2), (2, 3)
      check(graph.bridges().length).equals(2);
      // Components: (1, 2), (2, 3), triangle (4, 5, 6)
      check(graph.biconnectedComponents().length).equals(3);
    });

    test('graph with self-loops', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 1)
        ..addEdge(1, 2);
      // 1-2 is a bridge
      check(graph.bridges().length).equals(1);
    });
  });
}
