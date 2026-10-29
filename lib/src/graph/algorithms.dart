import 'package:collection/collection.dart';

import '../comparator/constructors/natural.dart';
import '../functional/types/constant.dart';
import '../functional/types/predicate.dart';
import 'algorithms/betweenness_centrality.dart' as betweenness_centrality;
import 'algorithms/biconnected.dart' as biconnected;
import 'algorithms/bipartite_check.dart' as bipartite_check;
import 'algorithms/bipartite_matching.dart' as bipartite_matching;
import 'algorithms/bron_kerbosch_cliques.dart' as bron_kerbosch_cliques;
import 'algorithms/cycle_check.dart' as cycle_check;
import 'algorithms/dinic_max_flow.dart' as dinic_max_flow;
import 'algorithms/eulerian.dart' as eulerian;
import 'algorithms/kruskal_spanning_tree.dart' as kruskal_spanning_tree;
import 'algorithms/page_rank.dart' as page_rank;
import 'algorithms/prim_spanning_tree.dart' as prim_spanning_tree;
import 'algorithms/search/a_star.dart' as a_star;
import 'algorithms/search/bellman_ford.dart' as bellman_ford;
import 'algorithms/search/dijkstra.dart' as dijkstra;
import 'algorithms/search/floyd_warshall.dart' as floyd_warshall;
import 'algorithms/stoer_wagner_min_cut.dart' as stoer_wagner_min_cut;
import 'algorithms/tarjan_strongly_connected.dart' as tarjan_strongly_connected;
import 'algorithms/vertex_coloring.dart' as vertex_coloring;
import 'edge.dart';
import 'errors.dart';
import 'graph.dart';
import 'path.dart';
import 'strategy.dart';

/// Extension on [Graph] providing access to graph algorithms.
extension AlgorithmsGraphExtension<V, E> on Graph<V, E> {
  /// Performs a search for the shortest path between [source] and [target].
  ///
  /// - [edgeCost] is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the numeric edge
  ///   value or a constant weight of _1_ is used.
  ///
  /// - [costEstimate] is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  Path<V, num>? shortestPath(
    V source,
    V target, {
    num Function(V source, V target)? edgeCost,
    num Function(V vertex)? costEstimate,
    bool includeAlternativePaths = false,
    bool hasNegativeEdges = false,
    StorageStrategy<V>? vertexStrategy,
  }) => shortestPathAll(
    source,
    targetPredicate: (vertex) => target == vertex,
    edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
    costEstimate: costEstimate,
    includeAlternativePaths: includeAlternativePaths,
    hasNegativeEdges: hasNegativeEdges,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  ).firstOrNull;

  /// Performs a search for the shortest paths starting at [source].
  ///
  /// - [targetPredicate] is a predicate function that decides if the target
  ///   vertex has been reached. If no predicate is provided, the shortest
  ///   paths to all reachable vertices are returned.
  ///
  /// - [edgeCost] is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the numeric edge
  ///   value or a constant weight of _1_ is used.
  ///
  /// - [costEstimate] is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  /// - If [hasNegativeEdges] is set to `true`, the slower Bellman–Ford
  ///   algorithm is used to compute the shortest path.
  ///
  /// - If [includeAlternativePaths] is set to `true`, multiple equal cost
  ///   paths to the same target are returned. The default is to not include
  ///   such alternatives.
  ///
  Iterable<Path<V, num>> shortestPathAll(
    V source, {
    Predicate1<V>? targetPredicate,
    num Function(V source, V target)? edgeCost,
    num Function(V target)? costEstimate,
    bool includeAlternativePaths = false,
    bool hasNegativeEdges = false,
    StorageStrategy<V>? vertexStrategy,
  }) {
    if (costEstimate != null && hasNegativeEdges) {
      throw GraphError(
        costEstimate,
        'costEstimate',
        'A cost estimate cannot be provided together with negative edges',
      );
    }
    return hasNegativeEdges
        ? bellman_ford.bellmanFordSearch<V>(
            startVertices: [source],
            targetPredicate: targetPredicate ?? constantFunction1(true),
            successorsOf: successorsOf,
            edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
            includeAlternativePaths: includeAlternativePaths,
            vertexStrategy: vertexStrategy ?? this.vertexStrategy,
          )
        : costEstimate == null
        ? dijkstra.dijkstraSearch<V>(
            startVertices: [source],
            targetPredicate: targetPredicate ?? constantFunction1(true),
            successorsOf: successorsOf,
            edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
            includeAlternativePaths: includeAlternativePaths,
            vertexStrategy: vertexStrategy ?? this.vertexStrategy,
          )
        : a_star.aStarSearch<V>(
            startVertices: [source],
            targetPredicate: targetPredicate ?? constantFunction1(true),
            successorsOf: successorsOf,
            costEstimate: costEstimate,
            edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
            includeAlternativePaths: includeAlternativePaths,
            vertexStrategy: vertexStrategy ?? this.vertexStrategy,
          );
  }

  /// Computes all shortest paths between all pairs of vertices in a graph.
  ///
  /// - [edgeCost] is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the numeric edge
  ///   value or a constant weight of _1_ is used.
  ///
  floyd_warshall.FloydWarshall<V> allShortestPaths({
    num Function(V source, V target)? edgeCost,
    StorageStrategy<V>? vertexStrategy,
  }) => floyd_warshall.floydWarshallSearch(
    vertices: vertices,
    successorsOf: successorsOf,
    edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Returns an object that can compute the maximum flow between different
  /// vertices of this graph using the Dinic max flow algorithm.
  ///
  /// - [edgeCapacity] is a function that returns the positive maximum capacity
  ///   between two vertices. If no function is provided, the numeric edge value
  ///   or a constant weight of _1_ is used.
  ///
  dinic_max_flow.DinicMaxFlow<V> maxFlow({
    num Function(V source, V target)? edgeCapacity,
    StorageStrategy<V>? vertexStrategy,
  }) => dinic_max_flow.DinicMaxFlow<V>(
    seedVertices: vertices,
    successorsOf: successorsOf,
    edgeCapacity: edgeCapacity ?? _getDefaultEdgeValueOr(1),
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Returns an object that computes the min-cut using the Stoer-Wagner
  /// algorithm.
  ///
  /// - [edgeWeight] is a function that returns the positive weight between two
  ///   edges. If no function is provided, the numeric edge value or a constant
  ///   weight of _1_ is used.
  ///
  stoer_wagner_min_cut.StoerWagnerMinCut<V, E> minCut({
    num Function(V source, V target)? edgeWeight,
    StorageStrategy<V>? vertexStrategy,
  }) => stoer_wagner_min_cut.StoerWagnerMinCut<V, E>(
    graph: this,
    edgeWeight: edgeWeight ?? _getDefaultEdgeValueOr(1),
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Returns the spanning tree of the graph.
  ///
  /// - [startVertex] is the root node of the new graph. If specified, Prim's
  ///   algorithm is returning the spanning tree starting at that vertex;
  ///   disconnected parts of the graph will be missing. Otherwise Kruskal's
  ///   algorithm is used, which always returns all vertices of the graph.
  ///
  /// - [edgeWeight] is a function that returns the weight between two edges. If
  ///   no function is provided, the numeric edge value or a constant weight of
  ///   _1_ is used.
  ///
  ///  - [weightComparator] is a function that compares two weights. If no
  ///    function is provided, the standard comparator is used yielding a
  ///    minimum spanning tree.
  ///
  Graph<V, E> spanningTree({
    V? startVertex,
    num Function(V source, V target)? edgeWeight,
    Comparator<num>? weightComparator,
    StorageStrategy<V>? vertexStrategy,
  }) => startVertex == null
      ? kruskal_spanning_tree.kruskalSpanningTree<V, E>(
          this,
          edgeWeight: edgeWeight ?? _getDefaultEdgeValueOr(1),
          weightComparator: weightComparator ?? naturalComparable<num>,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        )
      : prim_spanning_tree.primSpanningTree<V, E>(
          this,
          startVertex: startVertex,
          edgeWeight: edgeWeight ?? _getDefaultEdgeValueOr(1),
          weightComparator: weightComparator ?? naturalComparable<num>,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        );

  /// Returns the strongly connected components in this directed graph. The
  /// implementation uses Tarjan's algorithm and runs in linear time.
  Iterable<Set<V>> stronglyConnected({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkDirected(this);
    return tarjan_strongly_connected.tarjanStronglyConnected<V>(
      vertices,
      successorsOf: successorsOf,
      vertexStrategy: vertexStrategy ?? this.vertexStrategy,
    );
  }

  /// Returns the maximal cliques in this undirected graph. The implementation
  /// uses the Bron–Kerbosch algorithm and runs in exponential time.
  Iterable<Set<V>> findCliques({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    return bron_kerbosch_cliques.bronKerboschCliques<V>(
      vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: vertexStrategy ?? this.vertexStrategy,
    );
  }

  /// Computes the coloring of the graph.
  Map<V, int> vertexColoring({StorageStrategy<V>? vertexStrategy}) =>
      vertex_coloring.vertexColoring<V>(
        vertices: vertices,
        neighboursOf: neighboursOf,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Checks if the graph is bipartite.
  bool isBipartite({StorageStrategy<V>? vertexStrategy}) =>
      bipartite_check.isBipartite<V>(
        vertices: vertices,
        neighboursOf: neighboursOf,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Checks if the directed graph has a cycle.
  bool hasCycle({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkDirected(this);
    return cycle_check.hasCycle<V>(
      vertices: vertices,
      successorsOf: successorsOf,
      vertexStrategy: vertexStrategy ?? this.vertexStrategy,
    );
  }

  /// Checks if this graph has an Eulerian circuit.
  bool hasEulerianCircuit({StorageStrategy<V>? vertexStrategy}) =>
      eulerian.hasEulerianCircuit<V, E>(
        this,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Checks if this graph has an Eulerian path.
  bool hasEulerianPath({StorageStrategy<V>? vertexStrategy}) =>
      eulerian.hasEulerianPath<V, E>(
        this,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Finds an Eulerian path or circuit in this graph using Hierholzer's algorithm.
  ///
  /// If [circuit] is `true`, only an Eulerian circuit is searched for.
  Path<V, E>? findEulerianPath({
    bool circuit = false,
    StorageStrategy<V>? vertexStrategy,
  }) => eulerian.findEulerianPath<V, E>(
    this,
    circuit: circuit,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Returns the articulation points (cut vertices) of this undirected graph.
  Set<V> articulationPoints({StorageStrategy<V>? vertexStrategy}) =>
      biconnected.articulationPoints<V, E>(
        this,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Returns the bridges (cut edges) of this undirected graph.
  Set<Edge<V, E>> bridges({StorageStrategy<V>? vertexStrategy}) =>
      biconnected.bridges<V, E>(
        this,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Returns the biconnected components of this undirected graph.
  Iterable<Graph<V, E>> biconnectedComponents({
    StorageStrategy<V>? vertexStrategy,
  }) => biconnected.biconnectedComponents<V, E>(
    this,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Returns the density of this graph.
  ///
  /// For a directed graph with $|V|$ vertices and $|E|$ edges, density is
  /// $\frac{|E|}{|V|(|V|-1)}$.
  /// For an undirected graph, density is $\frac{2|E_u|}{|V|(|V|-1)}$ where
  /// $|E_u|$ is the number of undirected edges (excluding self-loops).
  ///
  /// Returns `0.0` if $|V| < 2$.
  double get density {
    final n = vertices.length;
    if (n < 2) return 0.0;
    final maxEdges = n * (n - 1);
    if (isDirected) {
      // Exclude self-loops from density numerator
      var count = 0;
      for (final edge in edges) {
        if (edge.source != edge.target) count++;
      }
      return count / maxEdges;
    } else {
      // In undirected graph, non-self edges appear twice in edges (or neighbours).
      // We count distinct undirected edges {u, v} with u != v.
      var count = 0;
      for (final v in vertices) {
        for (final u in neighboursOf(v)) {
          if (u != v) count++;
        }
      }
      // count is 2 * |E_u|. Density is (2 * |E_u|) / (n * (n - 1)) = count / maxEdges.
      return count / maxEdges;
    }
  }

  /// Returns the local clustering coefficient of [vertex].
  ///
  /// For undirected graphs, this is the ratio of edges between neighbours of
  /// [vertex] to the maximum possible edges between them:
  /// $\frac{2 e}{k(k - 1)}$ where $k$ is the number of distinct neighbours
  /// and $e$ is the number of undirected edges between those neighbours.
  ///
  /// Returns `0.0` if [vertex] has fewer than 2 neighbours.
  double localClusteringCoefficient(
    V vertex, {
    StorageStrategy<V>? vertexStrategy,
  }) {
    final neighbours = neighboursOf(vertex).toSet()..remove(vertex);
    final k = neighbours.length;
    if (k < 2) return 0.0;
    var links = 0;
    if (isDirected) {
      for (final u in neighbours) {
        for (final w in successorsOf(u)) {
          if (u != w && neighbours.contains(w)) {
            links++;
          }
        }
      }
      return links / (k * (k - 1));
    } else {
      for (final u in neighbours) {
        for (final w in neighboursOf(u)) {
          if (u != w && neighbours.contains(w)) {
            links++;
          }
        }
      }
      // links counts each undirected edge between neighbours twice.
      // Ratio is 2 * e / (k * (k - 1)) = links / (k * (k - 1)).
      return links / (k * (k - 1));
    }
  }

  /// Returns the average clustering coefficient across all vertices in the graph.
  ///
  /// Returns `0.0` if the graph has no vertices.
  double averageClusteringCoefficient({StorageStrategy<V>? vertexStrategy}) {
    if (vertices.isEmpty) return 0.0;
    var sum = 0.0;
    for (final v in vertices) {
      sum += localClusteringCoefficient(v, vertexStrategy: vertexStrategy);
    }
    return sum / vertices.length;
  }

  /// Returns the transitivity (global clustering coefficient) of the graph.
  ///
  /// Transitivity is defined as $3 \times \frac{\text{number of triangles}}{\text{number of connected triplets}}$.
  /// Returns `0.0` if there are no connected triplets.
  double transitivity({StorageStrategy<V>? vertexStrategy}) {
    var triangles = 0;
    var triplets = 0;
    for (final v in vertices) {
      final neighbours = neighboursOf(v).toSet()..remove(v);
      final k = neighbours.length;
      if (k < 2) continue;
      triplets += k * (k - 1);
      for (final u in neighbours) {
        for (final w in neighboursOf(u)) {
          if (u != w && neighbours.contains(w)) {
            triangles++;
          }
        }
      }
    }
    return triplets == 0 ? 0.0 : triangles / triplets;
  }

  /// Computes the betweenness centrality of all vertices in this graph.
  Map<V, double> betweennessCentrality({
    bool normalized = true,
    StorageStrategy<V>? vertexStrategy,
  }) => betweenness_centrality.betweennessCentrality<V, E>(
    this,
    normalized: normalized,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Computes the PageRank of all vertices in this graph.
  Map<V, double> pageRank({
    double damping = 0.85,
    double tolerance = 1e-6,
    int maxIterations = 100,
    StorageStrategy<V>? vertexStrategy,
  }) => page_rank.pageRank<V, E>(
    this,
    damping: damping,
    tolerance: tolerance,
    maxIterations: maxIterations,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Computes the closeness centrality of all vertices in this graph.
  Map<V, double> closenessCentrality({
    bool normalized = true,
    num Function(V source, V target)? edgeCost,
    StorageStrategy<V>? vertexStrategy,
  }) {
    final fw = allShortestPaths(
      edgeCost: edgeCost,
      vertexStrategy: vertexStrategy,
    );
    final strategy = vertexStrategy ?? this.vertexStrategy;
    final result = strategy.createMap<double>();
    for (final v in vertices) {
      result[v] = fw.closenessCentrality(v, normalized: normalized);
    }
    return result;
  }

  /// Computes the maximum bipartite matching of this undirected bipartite graph.
  Map<V, V> bipartiteMatching({StorageStrategy<V>? vertexStrategy}) =>
      bipartite_matching.bipartiteMatching<V, E>(
        this,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Computes the minimum vertex cover of this undirected bipartite graph.
  Set<V> minimumVertexCover({StorageStrategy<V>? vertexStrategy}) =>
      bipartite_matching.minimumVertexCover<V, E>(
        this,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Computes the maximum independent set of this undirected bipartite graph.
  Set<V> maximumIndependentSet({StorageStrategy<V>? vertexStrategy}) =>
      bipartite_matching.maximumIndependentSet<V, E>(
        this,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Internal helper that returns a function using the numeric edge value
  /// of this graph, or otherwise a constant value for each edge.
  num Function(V source, V target) _getDefaultEdgeValueOr(num value) =>
      this is Graph<V, num>
      ? (source, target) => getEdge(source, target)!.value as num
      : constantFunction2(value);
}
