import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Distance and Extremities (Diameter, Radius, Center, Periphery)', () {
    test('path graph extremities', () {
      // 0 - 1 - 2 - 3 - 4
      final graph = GraphFactory<int, void>(isDirected: false)
          .path(vertexCount: 5);
      check(graph.diameter()).equals(4);
      check(graph.radius()).equals(2);
      check(graph.center()).deepEquals({2});
      check(graph.periphery()).deepEquals({0, 4});
      check(graph.eccentricity(2)).equals(2);
      check(graph.eccentricity(0)).equals(4);
    });

    test('ring graph extremities', () {
      final ring = GraphFactory<int, void>(isDirected: false)
          .ring(vertexCount: 4);
      check(ring.diameter()).equals(2);
      check(ring.radius()).equals(2);
      check(ring.center()).deepEquals({0, 1, 2, 3});
      check(ring.periphery()).deepEquals({0, 1, 2, 3});
    });
  });

  group('dominatingSet', () {
    test('star graph dominating set is center', () {
      // S5 has center 0 connected to 1, 2, 3, 4
      final star = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 5);
      final dom = star.dominatingSet();
      check(dom).contains(0);
      check(dom.length).equals(1);
    });

    test('path graph dominating set covers all vertices', () {
      final path = GraphFactory<int, void>(isDirected: false)
          .path(vertexCount: 4);
      final dom = path.dominatingSet();
      // Dominating set must cover 0, 1, 2, 3
      final covered = <int>{};
      for (final v in dom) {
        covered.add(v);
        covered.addAll(path.neighboursOf(v));
      }
      check(covered).deepEquals({0, 1, 2, 3});
    });
  });

  group('katzCentrality', () {
    test('star graph katz centrality ranks center highest', () {
      final star = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 5);
      final scores = star.katzCentrality(alpha: 0.1);
      final centerScore = scores[0]!;
      for (var i = 1; i < 5; i++) {
        check(centerScore > scores[i]!).isTrue;
      }
    });

    test('empty graph returns empty map', () {
      final empty = Graph<int, void>(isDirected: true);
      check(empty.katzCentrality()).isEmpty;
    });
  });

  group('hits', () {
    test('authority and hub scores on simple directed structure', () {
      final graph = Graph<String, void>(isDirected: true)
        ..addEdge('H1', 'A1')
        ..addEdge('H1', 'A2')
        ..addEdge('H2', 'A1')
        ..addEdge('H2', 'A2');
      final (auth, hubs) = graph.hits();
      check(auth['A1']! > 0).isTrue;
      check(auth['A2']! > 0).isTrue;
      check(hubs['H1']! > 0).isTrue;
      check(hubs['H2']! > 0).isTrue;
    });

    test('empty graph returns empty records', () {
      final empty = Graph<String, void>(isDirected: true);
      final (auth, hubs) = empty.hits();
      check(auth).isEmpty;
      check(hubs).isEmpty;
    });
  });

  group('tspHeuristic', () {
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

    test('handles disconnected vertices with infinite edge cost', () {
      final graph = Graph<String, num>(isDirected: false)
        ..addEdge('A', 'B', value: 1)
        ..addVertex('C');
      final path = graph.tspHeuristic(
        edgeCost: (u, v) => graph.getEdge(u, v)?.value ?? double.infinity,
      );
      check(path).isNotNull();
      check(path!.vertices.toSet()).deepEquals({'A', 'B', 'C'});
    });
  });
}
