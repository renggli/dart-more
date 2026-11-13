export 'layout_options.dart';

/// Available preset shapes for graph generation.
enum GeneratorShape {
  atlas('atlas', 'Atlas Graph (Read & Wilson)'),
  complete('complete', 'Complete Graph'),
  cycle('cycle', 'Cycle Graph'),
  star('star', 'Star Graph'),
  path('path', 'Path Graph'),
  tree('tree', 'Complete m-ary Tree'),
  bipartite('bipartite', 'Bipartite Graph'),
  grid('grid', 'Grid Graph'),
  random('random', 'Random (Erdős–Rényi G(n,p))');

  new(this.id, this.label);

  /// Preset shape identifier matching serialized modifier configuration.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [GeneratorShape] by [id], defaulting to [GeneratorShape.atlas].
  static GeneratorShape fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => GeneratorShape.atlas);
}

/// Combine mode for graph generation.
enum GeneratorCombineMode {
  replace('replace', 'Replace existing graph'),
  union('union', 'Merge into existing graph');

  new(this.id, this.label);

  /// Combine mode identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [GeneratorCombineMode] by [id], defaulting to [GeneratorCombineMode.replace].
  static GeneratorCombineMode fromId(String id) => values.firstWhere(
    (e) => e.id == id,
    orElse: () => GeneratorCombineMode.replace,
  );
}

/// Algorithms for shortest path and traversal.
enum ShortestPathAlgorithm {
  dijkstra('dijkstra', 'Dijkstra (uniform / positive weights)'),
  aStar('astar', 'A* Search (with Euclidean heuristic)'),
  bellmanFord('bellmanFord', 'Bellman–Ford (handles negative weights)'),
  bfs('bfs', 'Breadth-First Search (unweighted)'),
  dfs('dfs', 'Depth-First Search');

  new(this.id, this.label);

  /// Algorithm identifier matching serialized modifier configuration.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [ShortestPathAlgorithm] by [id], defaulting to [ShortestPathAlgorithm.dijkstra].
  static ShortestPathAlgorithm fromId(String id) => values.firstWhere(
    (e) => e.id == id,
    orElse: () => ShortestPathAlgorithm.dijkstra,
  );
}

/// Centrality metrics for node importance evaluation.
enum CentralityMetric {
  degree('degree', 'Degree Centrality'),
  betweenness('betweenness', 'Betweenness Centrality'),
  closeness('closeness', 'Closeness Centrality'),
  pagerank('pagerank', 'PageRank'),
  eigenvector('eigenvector', 'Eigenvector Centrality');

  new(this.id, this.label);

  /// Centrality metric identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [CentralityMetric] by [id], defaulting to [CentralityMetric.degree].
  static CentralityMetric fromId(String id) => values.firstWhere(
    (e) => e.id == id,
    orElse: () => CentralityMetric.degree,
  );
}

/// Decomposition mode for connected components.
enum ComponentMode {
  weakly('weakly', 'Connected / Weakly Connected'),
  strongly('strongly', 'Strongly Connected Components'),
  biconnected('biconnected', 'Biconnected Components');

  new(this.id, this.label);

  /// Component mode identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [ComponentMode] by [id], defaulting to [ComponentMode.weakly].
  static ComponentMode fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => ComponentMode.weakly);
}

/// Visual styling applied to vertices outside the k-core.
enum KCoreRemovedStyle {
  dim('dim', 'Dim (reduce opacity)'),
  dash('dash', 'Dashed outline'),
  hide('hide', 'Hide completely');

  new(this.id, this.label);

  /// Style identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [KCoreRemovedStyle] by [id], defaulting to [KCoreRemovedStyle.dash].
  static KCoreRemovedStyle fromId(String id) => values.firstWhere(
    (e) => e.id == id,
    orElse: () => KCoreRemovedStyle.dash,
  );
}

/// Mode of clique computation.
enum CliquesMode {
  cliques('cliques', 'Maximal Cliques (Bron–Kerbosch)'),
  independentSet('independentSet', 'Maximum Independent Set');

  new(this.id, this.label);

  /// Mode identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [CliquesMode] by [id], defaulting to [CliquesMode.cliques].
  static CliquesMode fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => CliquesMode.cliques);
}
