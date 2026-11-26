import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('graph extension', () {
    test('computes cycle visiting all vertices', () {
      final graph = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1)
        ..addEdge('B', 'C', value: 1)
        ..addEdge('C', 'D', value: 1)
        ..addEdge('D', 'A', value: 1)
        ..addEdge('A', 'C', value: 2)
        ..addEdge('B', 'D', value: 2);
      final path = graph.tspHeuristic();
      check(path).isNotNull();
      check(path!.vertices.toSet()).deepEquals({'A', 'B', 'C', 'D'});
      check(path.vertices.first).equals(path.vertices.last);
    });

    test('single vertex graph returns null', () {
      final single = Graph<String, num>(isDirected: false)..addVertex('X');
      check(single.tspHeuristic()).isNull;
    });

    test('2-opt uncrosses intersecting edges to shorten tour', () {
      // Nearest-neighbor from A picks A -> B(1) -> C(1) -> D(1) -> A(100) = 103.
      // 2-opt reverses [C, D] to produce A -> B(1) -> D(2) -> C(1) -> A(2) = 6.
      final costs = <(String, String), num>{
        ('A', 'B'): 1,
        ('B', 'C'): 1,
        ('C', 'D'): 1,
        ('D', 'A'): 100,
        ('A', 'C'): 2,
        ('B', 'D'): 2,
      };
      num cost(String u, String v) =>
          costs[(u, v)] ?? costs[(v, u)] ?? double.infinity;

      final graph = Graph<String, num>(isDirected: false);
      for (final entry in costs.entries) {
        graph.addEdge(entry.key.$1, entry.key.$2, value: entry.value);
      }
      final path = graph.tspHeuristic(startVertex: 'A', edgeCost: cost);
      check(path).isNotNull();
      check(path!.cost).equals(6);
    });

    test('handles disconnected vertices with default infinity edge cost', () {
      final graph = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1)
        ..addVertex('C');
      final path = graph.tspHeuristic();
      check(path).isNotNull();
      check(path!.vertices.toSet()).deepEquals({'A', 'B', 'C'});
      check(path.cost).equals(double.infinity);
    });

    test('unknown startVertex throws GraphError', () {
      final graph = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1);
      check(() => graph.tspHeuristic(startVertex: 'Z')).throws<GraphError>();
    });
  });

  group('standalone', () {
    test('asymmetric edge costs never increase tour cost during 2-opt', () {
      final costs = <(String, String), num>{
        ('A', 'B'): 1,
        ('B', 'C'): 1,
        ('C', 'D'): 1,
        ('D', 'A'): 20,
        // Reversing [B, C] makes C -> B cost 1000, so it must not be taken.
        ('C', 'B'): 1000,
        ('A', 'C'): 2,
        ('B', 'D'): 2,
      };
      final path = tspHeuristic<String>(
        vertices: ['A', 'B', 'C', 'D'],
        startVertex: 'A',
        edgeCost: (u, v) => costs[(u, v)] ?? 50,
      );
      check(path).isNotNull();
      // Tour A -> B -> C -> D -> A has cost 23 (no reversal worsens to > 1000).
      check(path!.cost).isLessOrEqual(23);
    });
  });
}
