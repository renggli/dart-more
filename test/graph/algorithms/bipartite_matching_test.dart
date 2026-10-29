import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('bipartite matching and cover', () {
    test('directed graph error', () {
      final g = Graph<int, void>(isDirected: true);
      check(g.bipartiteMatching).throws<GraphError>();
      check(g.minimumVertexCover).throws<GraphError>();
      check(g.maximumIndependentSet).throws<GraphError>();
    });

    test('non-bipartite graph error', () {
      final triangle = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1);
      check(triangle.bipartiteMatching).throws<GraphError>();
      check(triangle.minimumVertexCover).throws<GraphError>();
      check(triangle.maximumIndependentSet).throws<GraphError>();
    });

    test('empty graph', () {
      final g = Graph<int, void>(isDirected: false);
      check(g.bipartiteMatching()).isEmpty();
      check(g.minimumVertexCover()).isEmpty();
      check(g.maximumIndependentSet()).isEmpty();
    });

    test('single edge: 1 - 2', () {
      final g = Graph<int, void>(isDirected: false)..addEdge(1, 2);
      final matching = g.bipartiteMatching();
      check(matching[1]).equals(2);
      check(matching[2]).equals(1);

      // Vertex cover has size 1 (either 1 or 2)
      final cover = g.minimumVertexCover();
      check(cover.length).equals(1);
      check(cover.contains(1) || cover.contains(2)).isTrue();

      // Independent set has size 1 (the remaining vertex)
      final ind = g.maximumIndependentSet();
      check(ind.length).equals(1);
      check(cover.intersection(ind)).isEmpty();
    });

    test('complete bipartite graph K(2, 3)', () {
      // U = {1, 2}, V = {3, 4, 5}
      final g = Graph<int, void>(isDirected: false)
        ..addEdge(1, 3)
        ..addEdge(1, 4)
        ..addEdge(1, 5)
        ..addEdge(2, 3)
        ..addEdge(2, 4)
        ..addEdge(2, 5);

      final matching = g.bipartiteMatching();
      // Maximum matching size is 2 edges (4 entries in symmetric map)
      check(matching.length).equals(4);
      check(matching.containsKey(1)).isTrue();
      check(matching.containsKey(2)).isTrue();

      // Minimum vertex cover is {1, 2} of size 2
      final cover = g.minimumVertexCover();
      check(cover).unorderedEquals([1, 2]);

      // Maximum independent set is {3, 4, 5} of size 3
      final ind = g.maximumIndependentSet();
      check(ind).unorderedEquals([3, 4, 5]);
    });

    test('alternating path graph P4: 1 - 2 - 3 - 4', () {
      final g = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 4);

      final matching = g.bipartiteMatching();
      // Perfect matching: 1-2 and 3-4
      check(matching[1]).equals(2);
      check(matching[2]).equals(1);
      check(matching[3]).equals(4);
      check(matching[4]).equals(3);

      // Minimum vertex cover has size 2 (e.g. {2, 3})
      final cover = g.minimumVertexCover();
      check(cover.length).equals(2);

      // Maximum independent set has size 2
      final ind = g.maximumIndependentSet();
      check(ind.length).equals(2);
    });
  });
}
