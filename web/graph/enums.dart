import 'package:more/graph.dart';

/// Default visual constants for vertex sizing in layout algorithms.
const double defaultNodeRadius = 20.0;
const double defaultNodeHeight = 48.0;
const double minNodeWidth = 48.0;
const double charWidthEstimate = 8.5;
const double nodeHorizontalPadding = 24.0;

/// Available layout engine algorithms.
enum LayoutEngine {
  stress('stress', 'Stress Majorization'),
  force('force', 'Force-Directed'),
  layered('layered', 'Layered'),
  tree('tree', 'Tree'),
  radial('radial', 'Radial'),
  shell('shell', 'Shell'),
  spectral('spectral', 'Spectral'),
  circular('circular', 'Circular'),
  grid('grid', 'Grid'),
  random('random', 'Random');

  new(this.id, this.label);

  /// Engine identifier matching serialized modifier configuration.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [LayoutEngine] by [id], defaulting to [LayoutEngine.stress].
  static LayoutEngine fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => LayoutEngine.stress);
}

/// Flow direction for hierarchical and layered graph layouts.
enum RankDir {
  tb('TB', 'Top → Bottom'),
  lr('LR', 'Left → Right'),
  bt('BT', 'Bottom → Top'),
  rl('RL', 'Right → Left');

  new(this.id, this.label);

  /// Direction identifier matching serialized modifier configuration.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [RankDir] by [id], defaulting to [RankDir.tb].
  static RankDir fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => RankDir.tb);

  /// Converts this direction to MoreDart [LayoutOrientation].
  LayoutOrientation toOrientation() => switch (this) {
    RankDir.lr => LayoutOrientation.leftToRight,
    RankDir.rl => LayoutOrientation.rightToLeft,
    RankDir.bt => LayoutOrientation.bottomToTop,
    RankDir.tb => LayoutOrientation.topToBottom,
  };
}

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
  inDegree('inDegree', 'In-Degree Centrality'),
  outDegree('outDegree', 'Out-Degree Centrality'),
  betweenness('betweenness', 'Betweenness Centrality'),
  closeness('closeness', 'Closeness Centrality'),
  pagerank('pagerank', 'PageRank'),
  eigenvector('eigenvector', 'Eigenvector Centrality'),
  coreNumbers('coreNumbers', 'Core Number (k-Core)'),
  clustering('clustering', 'Local Clustering Coefficient');

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

/// Decomposition and community detection mode for components.
enum ComponentMode {
  weakly('weakly', 'Connected / Weakly Connected'),
  strongly('strongly', 'Strongly Connected Components'),
  biconnected('biconnected', 'Biconnected Components'),
  louvain('louvain', 'Louvain Communities (Modularity)'),
  labelPropagation('labelPropagation', 'Label Propagation Communities');

  new(this.id, this.label);

  /// Component mode identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [ComponentMode] by [id], defaulting to [ComponentMode.weakly].
  static ComponentMode fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => ComponentMode.weakly);
}

/// Matching algorithm selection.
enum MatchingAlgorithm {
  blossom('blossom', 'Edmonds Blossom (General Graphs)'),
  bipartite('bipartite', 'Hopcroft–Karp (Bipartite Graphs)');

  new(this.id, this.label);

  /// Matching algorithm identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [MatchingAlgorithm] by [id], defaulting to [MatchingAlgorithm.blossom].
  static MatchingAlgorithm fromId(String id) => values.firstWhere(
    (e) => e.id == id,
    orElse: () => MatchingAlgorithm.blossom,
  );
}

/// Graph traversal strategy.
enum TraversalType {
  bfs('bfs', 'Breadth-First Search (BFS)'),
  dfs('dfs', 'Depth-First Search (DFS)'),
  topological('topological', 'Topological Sort (DAG)'),
  randomWalk('randomWalk', 'Random Walk');

  new(this.id, this.label);

  /// Traversal type identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [TraversalType] by [id], defaulting to [TraversalType.bfs].
  static TraversalType fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => TraversalType.bfs);
}

/// Binary graph combination operation.
enum CombineOperation {
  union('union', 'Union (G ∪ H)'),
  intersection('intersection', 'Intersection (G ∩ H)');

  new(this.id, this.label);

  /// Combine operation identifier.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [CombineOperation] by [id], defaulting to [CombineOperation.union].
  static CombineOperation fromId(String id) => values.firstWhere(
    (e) => e.id == id,
    orElse: () => CombineOperation.union,
  );
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
