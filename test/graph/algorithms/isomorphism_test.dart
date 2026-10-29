import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('isomorphism', () {
    group('full isomorphism', () {
      test('empty graphs are isomorphic', () {
        final g1 = Graph<int, void>(isDirected: false);
        final g2 = Graph<String, void>(isDirected: false);
        check(g1.isIsomorphicTo(g2)).isTrue();
      });

      test('differing directedness are not isomorphic', () {
        final g1 = Graph<int, void>(isDirected: false);
        final g2 = Graph<int, void>(isDirected: true);
        check(g1.isIsomorphicTo(g2)).isFalse();
      });

      test('differing vertex counts are not isomorphic', () {
        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        final g2 = Graph<int, void>(isDirected: false)
          ..addVertex(1)
          ..addVertex(2);
        check(g1.isIsomorphicTo(g2)).isFalse();
      });

      test('isomorphic paths with different vertex types', () {
        // Path 0-1-2 and Path 'a'-'b'-'c'
        final g1 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2);
        final g2 = Graph<String, void>(isDirected: false)
          ..addEdge('a', 'b')
          ..addEdge('b', 'c');

        check(g1.isIsomorphicTo(g2)).isTrue();

        // With vertex comparator
        check(
          g1.isIsomorphicTo(
            g2,
            vertexComparator: (v1, v2) => v1 == 1 ? v2 == 'b' : true,
          ),
        ).isTrue();
        check(
          g1.isIsomorphicTo(
            g2,
            vertexComparator: (v1, v2) => v1 == 1 ? v2 == 'a' : true,
          ),
        ).isFalse();
      });

      test('non-isomorphic graphs with same degree sequences', () {
        // Two 6-vertex graphs with degrees (2, 2, 2, 2, 2, 2):
        // C6 (one cycle of length 6) vs 2 * C3 (two disjoint triangles)
        final c6 = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 6);
        final twoC3 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 0)
          ..addEdge(3, 4)
          ..addEdge(4, 5)
          ..addEdge(5, 3);

        check(c6.isIsomorphicTo(twoC3)).isFalse();
      });

      test('directed graphs isomorphism', () {
        final g1 = Graph<int, void>(isDirected: true)
          ..addEdge(1, 2)
          ..addEdge(2, 3);
        final g2 = Graph<int, void>(isDirected: true)
          ..addEdge(10, 20)
          ..addEdge(20, 30);
        final g3 = Graph<int, void>(isDirected: true)
          ..addEdge(10, 20)
          ..addEdge(30, 20);

        check(g1.isIsomorphicTo(g2)).isTrue();
        check(g1.isIsomorphicTo(g3)).isFalse();
      });
    });

    group('subgraph isomorphism', () {
      test('triangle in bowtie', () {
        // Bowtie has two triangles sharing vertex 2: (0, 1, 2) and (2, 3, 4)
        final bowtie = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 0)
          ..addEdge(2, 3)
          ..addEdge(3, 4)
          ..addEdge(4, 2);

        final triangle = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 3);

        final matches = bowtie.findSubgraphIsomorphisms(triangle).toList();
        // Each triangle in bowtie has 6 automorphisms, 2 triangles -> 12 matches
        check(matches.length).equals(12);
      });

      test('pattern larger than target yields no matches', () {
        final target = GraphFactory<int, void>().path(vertexCount: 3);
        final pattern = GraphFactory<int, void>().path(vertexCount: 4);
        check(target.findSubgraphIsomorphisms(pattern)).isEmpty();
      });
    });
  });
}
