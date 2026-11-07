import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('hamiltonian', () {
    group('directed', () {
      test('empty graph', () {
        final graph = Graph<int, void>(isDirected: true);
        check(graph.hasHamiltonianCircuit()).isFalse();
        check(graph.hasHamiltonianPath()).isFalse();
        check(graph.findHamiltonianPath()).isNull();
      });

      test('single isolated vertex', () {
        final graph = Graph<int, void>(isDirected: true)..addVertex(1);
        check(graph.hasHamiltonianCircuit()).isFalse();
        check(graph.hasHamiltonianPath()).isTrue();
        final path = graph.findHamiltonianPath();
        check(path).isNotNull();
        check(path!.vertices).deepEquals([1]);
        check(path.values).isEmpty();
        check(graph.findHamiltonianPath(circuit: true)).isNull();
      });

      test('single vertex with self-loop', () {
        final graph = Graph<int, String>(isDirected: true)
          ..addEdge(1, 1, value: 'loop');
        check(graph.hasHamiltonianCircuit()).isTrue();
        check(graph.hasHamiltonianPath()).isTrue();
        final circuit = graph.findHamiltonianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices).deepEquals([1, 1]);
        check(circuit.values).deepEquals(['loop']);
      });

      test('two vertices: single edge', () {
        final graph = Graph<int, void>(isDirected: true)..addEdge(1, 2);
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isFalse();
        final path = graph.findHamiltonianPath();
        check(path).isNotNull();
        check(path!.vertices).deepEquals([1, 2]);
      });

      test('two vertices: 2-cycle', () {
        final graph = Graph<int, String>(isDirected: true)
          ..addEdge(1, 2, value: 'a')
          ..addEdge(2, 1, value: 'b');
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isTrue();
        final circuit = graph.findHamiltonianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices).deepEquals([1, 2, 1]);
        check(circuit.values).deepEquals(['a', 'b']);
      });

      test('directed cycle C3', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isTrue();
        final circuit = graph.findHamiltonianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices.first).equals(circuit.vertices.last);
        check(circuit.vertices.length).equals(4);
      });

      test('directed line: path but not circuit', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(2, 3);
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isFalse();
        final path = graph.findHamiltonianPath();
        check(path).isNotNull();
        check(path!.vertices).deepEquals([1, 2, 3]);
      });

      test('directed fork: no path', () {
        final graph = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(1, 3);
        check(graph.hasHamiltonianPath()).isFalse();
        check(graph.hasHamiltonianCircuit()).isFalse();
      });
    });

    group('undirected', () {
      test('empty graph', () {
        final graph = Graph<int, void>(isDirected: false);
        check(graph.hasHamiltonianCircuit()).isFalse();
        check(graph.hasHamiltonianPath()).isFalse();
        check(graph.findHamiltonianPath()).isNull();
      });

      test('single isolated vertex', () {
        final graph = Graph<int, void>(isDirected: false)..addVertex(1);
        check(graph.hasHamiltonianCircuit()).isFalse();
        check(graph.hasHamiltonianPath()).isTrue();
        final path = graph.findHamiltonianPath();
        check(path).isNotNull();
        check(path!.vertices).deepEquals([1]);
      });

      test('two vertices: edge', () {
        final graph = Graph<int, void>(isDirected: false)..addEdge(1, 2);
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isFalse();
        final path = graph.findHamiltonianPath();
        check(path).isNotNull();
        check(path!.vertices.length).equals(2);
      });

      test('cycle C4', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 4);
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isTrue();
        final circuit = graph.findHamiltonianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices.first).equals(circuit.vertices.last);
        check(circuit.vertices.length).equals(5);
      });

      test('path P4', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .path(vertexCount: 4);
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isFalse();
        final path = graph.findHamiltonianPath();
        check(path).isNotNull();
        check(path!.vertices.length).equals(4);
      });

      test('star S4 (no hamiltonian path)', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .star(vertexCount: 4);
        check(graph.hasHamiltonianPath()).isFalse();
        check(graph.hasHamiltonianCircuit()).isFalse();
      });

      test('complete graph K5', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 5);
        check(graph.hasHamiltonianPath()).isTrue();
        check(graph.hasHamiltonianCircuit()).isTrue();
        final circuit = graph.findHamiltonianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices.length).equals(6);
      });

      test('Petersen graph (has path, but no circuit)', () {
        // Construct the 10-vertex Petersen graph:
        // Outer 5-cycle: 0-1-2-3-4-0
        // Inner 5-star: 5-7-9-6-8-5
        // Spokes: 0-5, 1-6, 2-7, 3-8, 4-9
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

        check(petersen.hasHamiltonianCircuit()).isFalse();
        check(petersen.hasHamiltonianPath()).isTrue();
        final path = petersen.findHamiltonianPath();
        check(path).isNotNull();
        check(path!.vertices.length).equals(10);
        // All 10 vertices must be visited distinctly
        check(path.vertices.toSet().length).equals(10);
      });

      test('disconnected graph', () {
        final graph = Graph<int, void>(isDirected: false)
          ..addEdge(1, 2)
          ..addEdge(3, 4);
        check(graph.hasHamiltonianPath()).isFalse();
        check(graph.hasHamiltonianCircuit()).isFalse();
      });
    });

    group('large graphs (n > 20 backtracking)', () {
      test('cycle C25', () {
        final c25 = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 25);
        check(c25.hasHamiltonianCircuit()).isTrue();
        check(c25.hasHamiltonianPath()).isTrue();
        final circuit = c25.findHamiltonianPath(circuit: true);
        check(circuit).isNotNull();
        check(circuit!.vertices.length).equals(26);
      });

      test('star S25', () {
        final s25 = GraphFactory<int, void>(isDirected: false)
            .star(vertexCount: 25);
        check(s25.hasHamiltonianPath()).isFalse();
        check(s25.hasHamiltonianCircuit()).isFalse();
      });
    });

    group('standalone functions', () {
      test('standalone findHamiltonianPath and predicates', () {
        final res = findHamiltonianPath<String, void>(
          vertices: ['a', 'b', 'c'],
          successorsOf: (v) => switch (v) {
            'a' => ['b'],
            'b' => ['c'],
            _ => ['a'],
          },
          isDirected: true,
          circuit: true,
        );
        check(res).isNotNull();
        check(res!.vertices).deepEquals(['a', 'b', 'c', 'a']);

        final resEdges = findHamiltonianPath<String, int>(
          vertices: ['a', 'b', 'c'],
          outgoingEdgesOf: (v) => switch (v) {
            'a' => [const Edge.directed('a', 'b', value: 10)],
            'b' => [const Edge.directed('b', 'c', value: 20)],
            _ => [const Edge.directed('c', 'a', value: 30)],
          },
          isDirected: true,
          circuit: true,
        );
        check(resEdges).isNotNull();
        check(resEdges!.vertices).deepEquals(['a', 'b', 'c', 'a']);
        check(resEdges.values).deepEquals([10, 20, 30]);

        check(
          hasHamiltonianCircuit<String, void>(
            vertices: ['a', 'b', 'c'],
            successorsOf: (v) => switch (v) {
              'a' => ['b'],
              'b' => ['c'],
              _ => ['a'],
            },
            isDirected: true,
          ),
        ).isTrue();

        check(
          hasHamiltonianPath<String, void>(
            vertices: ['a', 'b', 'c'],
            successorsOf: (v) => switch (v) {
              'a' => ['b'],
              'b' => ['c'],
              _ => const [],
            },
            isDirected: true,
          ),
        ).isTrue();
      });
    });
  });
}
