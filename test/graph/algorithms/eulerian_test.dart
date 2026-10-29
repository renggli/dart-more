import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('eulerian', () {
    group('directed', () {
      test('empty graph', () {
        final graph = Graph<int, void>(isDirected: true);
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isFalse();
        check(graph.findEulerianPath()).isNull();
      });

      test('single isolated vertex', () {
        final graph = Graph<int, void>(isDirected: true)..addVertex(1);
        check(graph.hasEulerianCircuit()).isTrue();
        check(graph.hasEulerianPath()).isTrue();
        final path = graph.findEulerianPath();
        check(path).isNotNull();
        check(path!.vertices).deepEquals([1]);
        check(path.values).isEmpty();
      });

      test('multiple isolated vertices', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addVertex(1)
          ..addVertex(2);
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isFalse();
        check(graph.findEulerianPath()).isNull();
      });

      test('single directed cycle (circuit)', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);
        check(graph.hasEulerianCircuit()).isTrue();
        check(graph.hasEulerianPath()).isTrue();
        final circuit = graph.findEulerianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices.first).equals(circuit.vertices.last);
        check(circuit.vertices.length).equals(4);
      });

      test('directed eulerian path (not circuit)', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(2, 3);
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isTrue();
        final path = graph.findEulerianPath();
        check(path).isNotNull();
        check(path!.vertices).deepEquals([1, 2, 3]);
      });

      test('directed graph with multiple incoming/outgoing differences', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(1, 3);
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isFalse();
        check(graph.findEulerianPath()).isNull();
      });

      test('directed disconnected components with edges', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(2, 1)
          ..addEdge(3, 4)
          ..addEdge(4, 3);
        // Degrees are balanced, but disconnected
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isFalse();
        check(graph.findEulerianPath()).isNull();
      });

      test('directed with self-loop', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 1);
        check(graph.hasEulerianCircuit()).isTrue();
        final circuit = graph.findEulerianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.edges.length).equals(3);
      });
    });

    group('undirected', () {
      test('empty graph', () {
        final graph = Graph<int, void>(isDirected: false);
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isFalse();
        check(graph.findEulerianPath()).isNull();
      });

      test('single isolated vertex', () {
        final graph = Graph<int, void>(isDirected: false)..addVertex(1);
        check(graph.hasEulerianCircuit()).isTrue();
        check(graph.hasEulerianPath()).isTrue();
        final path = graph.findEulerianPath();
        check(path).isNotNull();
        check(path!.vertices).deepEquals([1]);
        check(path.values).isEmpty();
      });

      test('single edge path', () {
        final graph = Graph<int, void>(isDirected: false)..addEdge(1, 2);
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isTrue();
        final path = graph.findEulerianPath();
        check(path).isNotNull();
        check(path!.vertices.length).equals(2);
      });

      test('undirected triangle (circuit)', () {
        final graph = Graph<int, void>(isDirected: false)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);
        check(graph.hasEulerianCircuit()).isTrue();
        check(graph.hasEulerianPath()).isTrue();
        final circuit = graph.findEulerianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices.first).equals(circuit.vertices.last);
        check(circuit.vertices.length).equals(4);
      });

      test('undirected K4 complete graph (no eulerian path or circuit)', () {
        // For a simple complete graph K4: all 4 vertices have degree 3.
        final k4 = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 4);
        check(k4.hasEulerianCircuit()).isFalse();
        check(k4.hasEulerianPath()).isFalse();
        check(k4.findEulerianPath()).isNull();
      });

      test('undirected bowtie / figure 8 (circuit)', () {
        // Two triangles sharing a vertex
        // 0-1, 1-2, 2-0, 0-3, 3-4, 4-0.
        // Vertex 0 has degree 4, all others degree 2. All even!
        final graph = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 0)
          ..addEdge(0, 3)
          ..addEdge(3, 4)
          ..addEdge(4, 0);
        check(graph.hasEulerianCircuit()).isTrue();
        final circuit = graph.findEulerianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.edges.length).equals(6);
        check(circuit.vertices.first).equals(circuit.vertices.last);
      });

      test('undirected with self-loop', () {
        final graph = Graph<int, void>(isDirected: false)
          ..addEdge(1, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);
        check(graph.hasEulerianCircuit()).isTrue();
        final circuit = graph.findEulerianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.edges.length).equals(4);
      });

      test('undirected disconnected components with edges', () {
        final graph = Graph<int, void>(isDirected: false)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          ..addEdge(6, 4);
        check(graph.hasEulerianCircuit()).isFalse();
        check(graph.hasEulerianPath()).isFalse();
        check(graph.findEulerianPath()).isNull();
      });
    });
  });
}
