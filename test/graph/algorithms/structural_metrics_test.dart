import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('structural metrics', () {
    group('density', () {
      test('empty and single vertex graph', () {
        final g0 = Graph<int, void>(isDirected: false);
        check(g0.density).equals(0.0);

        final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
        check(g1.density).equals(0.0);

        final g1Dir = Graph<int, void>(isDirected: true)..addVertex(1);
        check(g1Dir.density).equals(0.0);
      });

      test('complete graphs have density 1.0', () {
        final k4Undirected = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: 4);
        check(k4Undirected.density).equals(1.0);

        final k4Directed = GraphFactory<int, void>(isDirected: true)
            .complete(vertexCount: 4);
        check(k4Directed.density).equals(1.0);
      });

      test('undirected path P4', () {
        // 4 vertices, 3 edges (0-1, 1-2, 2-3). Max undirected edges = 4 * 3 / 2 = 6.
        // Density = 3 / 6 = 0.5.
        final p4 = GraphFactory<int, void>(isDirected: false)
            .path(vertexCount: 4);
        check(p4.density).equals(0.5);
      });

      test('directed path P4', () {
        // 4 vertices, 3 directed edges. Max directed edges = 4 * 3 = 12.
        // Density = 3 / 12 = 0.25.
        final p4Dir = GraphFactory<int, void>(isDirected: true)
            .path(vertexCount: 4);
        check(p4Dir.density).equals(0.25);
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
  });
}
