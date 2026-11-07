import 'dart:math';

import 'package:more/graph.dart';

/// Predefined curated graphs and graph factory generators.
final class GraphPresets {
  static GraphFactory<String, num> _createFactory({required bool isDirected}) =>
      GraphFactory<String, num>(
        isDirected: isDirected,
        vertexProvider: (i) => i.toString(),
        edgeProvider: (u, v) => 1,
      );

  /// Zachary's Karate Club network (34 vertices, 78 edges).
  static Graph<String, num> karateClub() {
    final g = Graph<String, num>(isDirected: false);
    for (var i = 1; i <= 34; i++) {
      g.addVertex('$i');
    }
    const edges = [
      (1, 2),
      (1, 3),
      (1, 4),
      (1, 5),
      (1, 6),
      (1, 7),
      (1, 8),
      (1, 9),
      (1, 11),
      (1, 12),
      (1, 13),
      (1, 14),
      (1, 18),
      (1, 20),
      (1, 22),
      (1, 32),
      (2, 3),
      (2, 4),
      (2, 8),
      (2, 14),
      (2, 18),
      (2, 20),
      (2, 22),
      (2, 31),
      (3, 4),
      (3, 8),
      (3, 9),
      (3, 10),
      (3, 14),
      (3, 28),
      (3, 29),
      (3, 33),
      (4, 8),
      (4, 13),
      (4, 14),
      (5, 7),
      (5, 11),
      (6, 7),
      (6, 11),
      (6, 17),
      (7, 17),
      (9, 31),
      (9, 33),
      (9, 34),
      (10, 34),
      (14, 34),
      (15, 33),
      (15, 34),
      (16, 33),
      (16, 34),
      (19, 33),
      (19, 34),
      (20, 34),
      (21, 33),
      (21, 34),
      (23, 33),
      (23, 34),
      (24, 26),
      (24, 28),
      (24, 30),
      (24, 33),
      (24, 34),
      (25, 26),
      (25, 28),
      (25, 32),
      (26, 32),
      (27, 30),
      (27, 34),
      (28, 34),
      (29, 32),
      (29, 34),
      (30, 33),
      (30, 34),
      (31, 33),
      (31, 34),
      (32, 33),
      (32, 34),
      (33, 34),
    ];
    for (final (u, v) in edges) {
      g.addEdge('$u', '$v', value: 1);
    }
    return g;
  }

  /// Petersen Graph (10 vertices, 15 edges, 3-regular).
  static Graph<String, num> petersen() {
    final g = Graph<String, num>(isDirected: false);
    for (var i = 0; i < 10; i++) {
      g.addVertex('$i');
    }
    // Outer 5-cycle: 0-1-2-3-4-0
    for (var i = 0; i < 5; i++) {
      g.addEdge('$i', '${(i + 1) % 5}', value: 1);
    }
    // Inner star: 5-7-9-6-8-5
    g.addEdge('5', '7', value: 1);
    g.addEdge('7', '9', value: 1);
    g.addEdge('9', '6', value: 1);
    g.addEdge('6', '8', value: 1);
    g.addEdge('8', '5', value: 1);
    // Spokes connecting outer to inner
    for (var i = 0; i < 5; i++) {
      g.addEdge('$i', '${i + 5}', value: 1);
    }
    return g;
  }

  /// Weighted road network of Swiss cities with highway travel distances (km).
  static Graph<String, num> roadNetwork() {
    final g = Graph<String, num>(isDirected: false);
    g.addEdge('Zurich', 'Basel', value: 87);
    g.addEdge('Zurich', 'Bern', value: 122);
    g.addEdge('Zurich', 'Lucerne', value: 52);
    g.addEdge('Zurich', 'St. Gallen', value: 85);
    g.addEdge('Basel', 'Bern', value: 96);
    g.addEdge('Bern', 'Lucerne', value: 110);
    g.addEdge('Bern', 'Lausanne', value: 104);
    g.addEdge('Lausanne', 'Geneva', value: 64);
    g.addEdge('Lucerne', 'Lugano', value: 170);
    g.addEdge('Zurich', 'Lugano', value: 206);
    return g;
  }

  /// Graph with directed negative edge weights for Bellman-Ford demo.
  static Graph<String, num> negativeEdges() {
    final g = Graph<String, num>(isDirected: true);
    g.addEdge('A', 'B', value: -1);
    g.addEdge('A', 'C', value: 4);
    g.addEdge('B', 'C', value: 3);
    g.addEdge('B', 'D', value: 2);
    g.addEdge('B', 'E', value: 2);
    g.addEdge('D', 'B', value: 1);
    g.addEdge('D', 'C', value: 5);
    g.addEdge('E', 'D', value: -3);
    return g;
  }

  /// Compiler Task DAG for topological sort and transitive operations.
  static Graph<String, num> compilerDag() {
    final g = Graph<String, num>(isDirected: true);
    g.addEdge('Lexer', 'Parser', value: 1);
    g.addEdge('Parser', 'AST', value: 1);
    g.addEdge('AST', 'TypeCheck', value: 1);
    g.addEdge('AST', 'Linter', value: 1);
    g.addEdge('TypeCheck', 'Optimizer', value: 1);
    g.addEdge('Linter', 'Optimizer', value: 1);
    g.addEdge('Optimizer', 'Codegen', value: 1);
    g.addEdge('Codegen', 'Assemble', value: 1);
    g.addEdge('Assemble', 'Link', value: 1);
    return g;
  }

  /// Graph illustrating articulation points, bridges, and biconnected blocks.
  static Graph<String, num> bridgesAndCutVertices() {
    final g = Graph<String, num>(isDirected: false);
    // Block 1: triangle A-B-C
    g.addEdge('A', 'B', value: 1);
    g.addEdge('B', 'C', value: 1);
    g.addEdge('C', 'A', value: 1);
    // Bridge C-D (C and D are articulation points)
    g.addEdge('C', 'D', value: 1);
    // Block 2: square D-E-F-G-D
    g.addEdge('D', 'E', value: 1);
    g.addEdge('E', 'F', value: 1);
    g.addEdge('F', 'G', value: 1);
    g.addEdge('G', 'D', value: 1);
    // Leaf bridge G-H (G is articulation point)
    g.addEdge('G', 'H', value: 1);
    return g;
  }

  /// Creates a Complete graph (Kn).
  static Graph<String, num> complete({
    required int vertexCount,
    required bool isDirected,
  }) =>
      _createFactory(isDirected: isDirected).complete(vertexCount: vertexCount);

  /// Creates a Path graph (Pn).
  static Graph<String, num> path({
    required int vertexCount,
    required bool isDirected,
  }) => _createFactory(isDirected: isDirected).path(vertexCount: vertexCount);

  /// Creates a Ring graph (Cn).
  static Graph<String, num> ring({
    required int vertexCount,
    required bool isDirected,
  }) => _createFactory(isDirected: isDirected).ring(vertexCount: vertexCount);

  /// Creates a Star graph (Sn).
  static Graph<String, num> star({
    required int vertexCount,
    required bool isDirected,
  }) => _createFactory(isDirected: isDirected).star(vertexCount: vertexCount);

  /// Creates a Complete Tree.
  static Graph<String, num> tree({
    required int vertexCount,
    required bool isDirected,
    int arity = 2,
  }) =>
      _createFactory(isDirected: isDirected)
          .completeTree(vertexCount: vertexCount, arity: arity);

  /// Creates a Partite graph.
  static Graph<String, num> partite({
    required Iterable<int> vertexCounts,
    required bool isDirected,
  }) =>
      _createFactory(isDirected: isDirected)
          .partite(vertexCounts: vertexCounts);

  /// Creates a Random Erdős–Rényi graph.
  static Graph<String, num> randomErdosRenyi({
    required int vertexCount,
    required double probability,
    required bool isDirected,
    Random? random,
  }) {
    final factory = GraphFactory<String, num>(
      isDirected: isDirected,
      vertexProvider: (i) => i.toString(),
      edgeProvider: (u, v) => 1,
      random: random,
    );
    return factory.randomErdosRenyi(
      vertexCount: vertexCount,
      probability: probability,
    );
  }

  /// Retrieves a graph from the Read-Wilson Atlas of Graphs (index 0..1252).
  static Graph<String, num> atlas(int number) {
    final factory = _createFactory(isDirected: false);
    final clamped = number.clamp(0, factory.atlasLength - 1);
    return factory.atlas(clamped);
  }
}
