import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('connectivity', () {
    group('edgeConnectivity', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.edgeConnectivity()).equals(0);

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.edgeConnectivity()).equals(0);
      });

      test('line graph P3: 0 - 1 - 2', () {
        final p3 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        check(p3.edgeConnectivity()).equals(1);
        check(p3.edgeConnectivity(source: 0, target: 2)).equals(1);
      });

      test('cycle C4: 0 - 1 - 2 - 3 - 0', () {
        final c4 = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 4);

        check(c4.edgeConnectivity()).equals(2);
        check(c4.edgeConnectivity(source: 0, target: 2)).equals(2);
      });

      test('complete graph K4', () {
        final k4 = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 4);

        check(k4.edgeConnectivity()).equals(3);
      });

      test('directed graph connectivity', () {
        // Directed cycle: 0 -> 1 -> 2 -> 0 has edge connectivity 1
        final ringDir = GraphFactory<int, void>(isDirected: true)
            .ring(vertexCount: 3);
        check(ringDir.edgeConnectivity()).equals(1);

        // Disconnected directed graph
        final g = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(1, 2); // 2 cannot reach 0
        check(g.edgeConnectivity()).equals(0);
      });
    });

    group('vertexConnectivity', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.vertexConnectivity()).equals(0);

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.vertexConnectivity()).equals(0);
      });

      test('line graph P3: 0 - 1 - 2', () {
        final p3 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        // Removing 1 disconnects 0 and 2
        check(p3.vertexConnectivity()).equals(1);
        check(p3.vertexConnectivity(source: 0, target: 2)).equals(1);
      });

      test('cycle C4: 0 - 1 - 2 - 3 - 0', () {
        final c4 = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 4);

        // Removing 2 vertices disconnects C4
        check(c4.vertexConnectivity()).equals(2);
        check(c4.vertexConnectivity(source: 0, target: 2)).equals(2);
      });

      test('complete graph K4 has vertex connectivity 3', () {
        final k4 = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 4);
        check(k4.vertexConnectivity()).equals(3);
      });

      test('adjacent vertices pair', () {
        final p2 = Graph<int, void>(isDirected: false)..addEdge(0, 1);
        // By convention, non-adjacent vertices can be separated; adjacent vertices have n - 1 = 1
        check(p2.vertexConnectivity(source: 0, target: 1)).equals(1);
      });
    });
  });
}
