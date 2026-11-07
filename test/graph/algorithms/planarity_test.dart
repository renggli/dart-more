import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('planarity', () {
    test('directed graph error', () {
      final directed = Graph<int, void>.directed()..addEdge(1, 2);
      check(directed.isPlanar).throws<GraphError>();
    });

    group('planar graphs', () {
      test('empty graph', () {
        final graph = Graph<int, void>.undirected();
        check(graph.isPlanar()).isTrue();
      });

      test('single isolated vertex', () {
        final graph = Graph<int, void>.undirected()..addVertex(1);
        check(graph.isPlanar()).isTrue();
      });

      test('complete graphs K1 to K4', () {
        for (var n = 1; n <= 4; n++) {
          final kn = Graph<int, void>.undirected();
          for (var i = 1; i <= n; i++) {
            for (var j = i + 1; j <= n; j++) {
              kn.addEdge(i, j);
            }
          }
          check(kn.isPlanar()).isTrue();
        }
      });

      test('tree graph', () {
        final tree = Graph<int, void>.undirected()
          ..addEdge(1, 2)
          ..addEdge(1, 3)
          ..addEdge(2, 4)
          ..addEdge(2, 5)
          ..addEdge(3, 6)
          ..addEdge(3, 7);
        check(tree.isPlanar()).isTrue();
      });

      test('cycle graphs Cn', () {
        for (var n = 3; n <= 10; n++) {
          final cycle = Graph<int, void>.undirected();
          for (var i = 0; i < n; i++) {
            cycle.addEdge(i, (i + 1) % n);
          }
          check(cycle.isPlanar()).isTrue();
        }
      });

      test('wheel graph W6', () {
        final wheel = Graph<int, void>.undirected();
        // Hub at 0, rim 1..5
        for (var i = 1; i <= 5; i++) {
          wheel.addEdge(0, i);
          wheel.addEdge(i, i == 5 ? 1 : i + 1);
        }
        check(wheel.isPlanar()).isTrue();
      });

      test('cube graph Q3 (8 vertices, 12 edges)', () {
        final cube = Graph<int, void>.undirected();
        // Vertices 000 (0) to 111 (7)
        for (var u = 0; u < 8; u++) {
          for (var bit = 0; bit < 3; bit++) {
            final v = u ^ (1 << bit);
            if (u < v) {
              cube.addEdge(u, v);
            }
          }
        }
        check(cube.isPlanar()).isTrue();
      });

      test('octahedral graph (6 vertices, 12 edges)', () {
        // Octahedron is K6 minus 3 disjoint antipodal edges: (0, 5), (1, 4), (2, 3)
        final octahedron = Graph<int, void>.undirected();
        for (var i = 0; i < 6; i++) {
          for (var j = i + 1; j < 6; j++) {
            if (i + j != 5) {
              octahedron.addEdge(i, j);
            }
          }
        }
        check(octahedron.isPlanar()).isTrue();
      });

      test('planar graph with self loops and multiple edges', () {
        final graph = Graph<int, void>.undirected()
          ..addEdge(1, 1)
          ..addEdge(1, 2)
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);
        check(graph.isPlanar()).isTrue();
      });

      test('disjoint union of planar components', () {
        final graph = Graph<int, void>.undirected()
          // Component 1: triangle
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1)
          // Component 2: path
          ..addEdge(4, 5)
          ..addEdge(5, 6)
          // Component 3: isolated
          ..addVertex(7);
        check(graph.isPlanar()).isTrue();
      });
    });

    group('non-planar graphs', () {
      test('complete graph K5', () {
        final k5 = Graph<int, void>.undirected();
        for (var i = 1; i <= 5; i++) {
          for (var j = i + 1; j <= 5; j++) {
            k5.addEdge(i, j);
          }
        }
        check(k5.isPlanar()).isFalse();
      });

      test('complete bipartite graph K(3, 3)', () {
        final k33 = Graph<int, void>.undirected();
        for (var i = 1; i <= 3; i++) {
          for (var j = 4; j <= 6; j++) {
            k33.addEdge(i, j);
          }
        }
        check(k33.isPlanar()).isFalse();
      });

      test('Petersen graph', () {
        // Outer 5-cycle: 0..4, inner 5-star: 5..9, spokes: i - i+5
        final petersen = Graph<int, void>.undirected();
        for (var i = 0; i < 5; i++) {
          petersen.addEdge(i, (i + 1) % 5);
          petersen.addEdge(i + 5, ((i + 2) % 5) + 5);
          petersen.addEdge(i, i + 5);
        }
        check(petersen.isPlanar()).isFalse();
      });

      test('subdivision of K5', () {
        // K5 with one edge subdivided into two edges by adding vertex 6
        final k5Sub = Graph<int, void>.undirected();
        for (var i = 1; i <= 5; i++) {
          for (var j = i + 1; j <= 5; j++) {
            if (i == 1 && j == 2) {
              // Subdivide edge (1, 2)
              k5Sub.addEdge(1, 6);
              k5Sub.addEdge(6, 2);
            } else {
              k5Sub.addEdge(i, j);
            }
          }
        }
        check(k5Sub.isPlanar()).isFalse();
      });

      test('subdivision of K(3, 3)', () {
        // K33 with one edge subdivided
        final k33Sub = Graph<int, void>.undirected();
        for (var i = 1; i <= 3; i++) {
          for (var j = 4; j <= 6; j++) {
            if (i == 1 && j == 4) {
              k33Sub.addEdge(1, 7);
              k33Sub.addEdge(7, 4);
            } else {
              k33Sub.addEdge(i, j);
            }
          }
        }
        check(k33Sub.isPlanar()).isFalse();
      });

      test('disjoint union containing a non-planar component', () {
        final graph = Graph<int, void>.undirected()
          // Planar triangle
          ..addEdge(1, 2)
          ..addEdge(2, 3)
          ..addEdge(3, 1);
        // Non-planar K5
        for (var i = 10; i <= 14; i++) {
          for (var j = i + 1; j <= 14; j++) {
            graph.addEdge(i, j);
          }
        }
        check(graph.isPlanar()).isFalse();
      });
    });

    group('standalone function', () {
      test('standalone isPlanar on triangle and K5', () {
        final triangleNeighbours = {
          1: [2, 3],
          2: [1, 3],
          3: [1, 2],
        };
        check(
          isPlanar(
            vertices: [1, 2, 3],
            neighboursOf: (v) => triangleNeighbours[v]!,
          ),
        ).isTrue();

        final k5Neighbours = {
          1: [2, 3, 4, 5],
          2: [1, 3, 4, 5],
          3: [1, 2, 4, 5],
          4: [1, 2, 3, 5],
          5: [1, 2, 3, 4],
        };
        check(
          isPlanar(
            vertices: [1, 2, 3, 4, 5],
            neighboursOf: (v) => k5Neighbours[v]!,
          ),
        ).isFalse();
      });
    });
  });
}
