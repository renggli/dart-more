import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('structural metrics', () {
    group('density', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.density()).equals(0.0);

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.density()).equals(0.0);

        final g1Dir = Graph<int, void>(isDirected: true)..addVertex(1);
        check(g1Dir.density()).equals(0.0);
      });

      test('complete graphs have density 1.0', () {
        final k4Undirected = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 4);
        check(k4Undirected.density()).equals(1.0);

        final k4Directed = GraphFactory<int, void>(isDirected: true)
            .complete(vertexCount: 4);
        check(k4Directed.density()).equals(1.0);
      });

      test('undirected path P4', () {
        // 4 vertices, 3 edges (0-1, 1-2, 2-3). Max undirected edges = 4 * 3 / 2 = 6.
        // Density = 3 / 6 = 0.5.
        final p4 = GraphFactory<int, void>(isDirected: false)
            .path(vertexCount: 4);
        check(p4.density()).equals(0.5);
      });

      test('directed path P4', () {
        // 4 vertices, 3 directed edges. Max directed edges = 4 * 3 = 12.
        // Density = 3 / 12 = 0.25.
        final p4Dir = GraphFactory<int, void>(isDirected: true)
            .path(vertexCount: 4);
        check(p4Dir.density()).equals(0.25);
      });
    });

    group('clustering coefficient and transitivity', () {
      test('empty graph', () {
        final graph = Graph<int, void>(isDirected: false);
        check(graph.averageClusteringCoefficient()).equals(0.0);
        check(graph.transitivity()).equals(0.0);
      });

      test('triangle C3 (all closed, clustering = 1.0)', () {
        final triangle = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 0);

        check(triangle.localClusteringCoefficient(0)).equals(1.0);
        check(triangle.localClusteringCoefficient(1)).equals(1.0);
        check(triangle.localClusteringCoefficient(2)).equals(1.0);
        check(triangle.averageClusteringCoefficient()).equals(1.0);
        check(triangle.transitivity()).equals(1.0);
      });

      test('path P3: 0 - 1 - 2 (open triplet, clustering = 0.0)', () {
        final p3 = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2);

        // Vertex 1 has 2 neighbours (0 and 2), but no edge between 0 and 2 -> 0.0.
        // Vertices 0 and 2 have 1 neighbour -> 0.0.
        check(p3.localClusteringCoefficient(0)).equals(0.0);
        check(p3.localClusteringCoefficient(1)).equals(0.0);
        check(p3.localClusteringCoefficient(2)).equals(0.0);
        check(p3.averageClusteringCoefficient()).equals(0.0);
        check(p3.transitivity()).equals(0.0);
      });

      test('bowtie graph (two triangles sharing central vertex)', () {
        // Triangles 0-1-2 and 2-3-4 sharing vertex 2.
        final bowtie = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(1, 2)
          ..addEdge(2, 0)
          ..addEdge(2, 3)
          ..addEdge(3, 4)
          ..addEdge(4, 2);

        // For vertices 0, 1, 3, 4: 2 neighbours, connected by 1 edge -> 1.0.
        check(bowtie.localClusteringCoefficient(0)).equals(1.0);
        check(bowtie.localClusteringCoefficient(1)).equals(1.0);
        check(bowtie.localClusteringCoefficient(3)).equals(1.0);
        check(bowtie.localClusteringCoefficient(4)).equals(1.0);

        // For vertex 2: 4 neighbours (0, 1, 3, 4).
        // Edges between them: (0, 1) and (3, 4) -> 2 edges.
        // Max possible edges = 4 * 3 / 2 = 6.
        // Local clustering = 2 / 6 = 1/3.
        check(bowtie.localClusteringCoefficient(2)).isCloseTo(1 / 3, 1e-6);

        // Average clustering = (1 + 1 + 1 + 1 + 1/3) / 5 = (13/3) / 5 = 13/15.
        check(bowtie.averageClusteringCoefficient()).isCloseTo(13 / 15, 1e-6);

        // Transitivity:
        // Triangles in bowtie: 2 triangles. Each triangle contributes 6 directed triangles.
        // Total directed triangles = 12.
        // Connected triplets:
        // at 0: 2 * 1 = 2
        // at 1: 2 * 1 = 2
        // at 3: 2 * 1 = 2
        // at 4: 2 * 1 = 2
        // at 2: 4 * 3 = 12
        // Total triplets = 20.
        // Transitivity = 12 / 20 = 3/5 = 0.6.
        check(bowtie.transitivity()).isCloseTo(0.6, 1e-6);
      });
    });

    group('degreeAssortativity', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.degreeAssortativity().isNaN).isTrue();

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.degreeAssortativity().isNaN).isTrue();
      });

      test('regular graphs (zero degree variance)', () {
        // Complete graph K4: all vertices have degree 3
        final k4 = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 4);
        check(k4.degreeAssortativity().isNaN).isTrue();

        // Ring graph R4: all vertices have degree 2
        final r4 = GraphFactory<int, void>(isDirected: false)
            .ring(vertexCount: 4);
        check(r4.degreeAssortativity().isNaN).isTrue();
      });

      test('star graph S3 is disassortative (-1.0)', () {
        final star = GraphFactory<int, void>(isDirected: false)
            .star(vertexCount: 3);
        check(star.degreeAssortativity()).isCloseTo(-1.0, 1e-6);
      });

      test('path P4 is disassortative (-0.5)', () {
        final p4 = GraphFactory<int, void>(isDirected: false)
            .path(vertexCount: 4);
        check(p4.degreeAssortativity()).isCloseTo(-0.5, 1e-6);
      });

      test('disjoint edge and triangle is assortative (1.0)', () {
        // Edge 0 - 1 (degree 1) and triangle 2 - 3 - 4 - 2 (degree 2)
        final g = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(2, 3)
          ..addEdge(3, 4)
          ..addEdge(4, 2);
        check(g.degreeAssortativity()).isCloseTo(1.0, 1e-6);
      });

      test('directed graph assortativity', () {
        // Directed star where leaves point to center: 1 -> 0, 2 -> 0, 3 -> 0
        // Out-degrees: leaves have 1, center has 0.
        // In-degrees: leaves have 0, center has 3.
        // Edges: (1, 0), (2, 0), (3, 0).
        // Each edge has j_u = 1, k_v = 3 (both constant across all edges -> zero variance).
        final starIn = Graph<int, void>(isDirected: true)
          ..addEdge(1, 0)
          ..addEdge(2, 0)
          ..addEdge(3, 0);
        check(starIn.degreeAssortativity().isNaN).isTrue();

        // Directed path 0 -> 1 -> 2 -> 3
        // Out-degrees: 0: 1, 1: 1, 2: 1, 3: 0.
        // In-degrees: 0: 0, 1: 1, 2: 1, 3: 1.
        // Edges:
        // (0, 1): j=1, k=1
        // (1, 2): j=1, k=1
        // (2, 3): j=1, k=1
        // Again zero variance across edges -> NaN.
        final p4Dir = GraphFactory<int, void>(isDirected: true)
            .path(vertexCount: 4);
        check(p4Dir.degreeAssortativity().isNaN).isTrue();

        // Directed graph with non-zero variance on both ends:
        final gDir = Graph<int, void>(isDirected: true)
          ..addEdge(0, 1)
          ..addEdge(0, 2)
          ..addEdge(1, 2);
        // 0: out=2, in=0
        // 1: out=1, in=1
        // 2: out=0, in=2
        // Edges: (0, 1) -> (2, 1); (0, 2) -> (2, 2); (1, 2) -> (1, 2).
        // j: 2, 2, 1 (not constant). k: 1, 2, 2 (not constant).
        check(gDir.degreeAssortativity().isNaN).isFalse();
      });

      test('standalone degreeAssortativity function', () {
        final val = degreeAssortativity<int>(
          vertices: [0, 1, 2],
          successorsOf: (v) => v == 0 ? [1, 2] : [0],
          isDirected: false,
        );
        check(val).isCloseTo(-1.0, 1e-6);
      });
    });
  });
}
