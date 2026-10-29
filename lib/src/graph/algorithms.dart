import 'package:collection/collection.dart';

import '../comparator/constructors/natural.dart';
import '../functional/types/constant.dart';
import '../functional/types/predicate.dart';
import 'algorithms/betweenness_centrality.dart' as betweenness_centrality;
import 'algorithms/biconnected.dart' as biconnected;
import 'algorithms/bipartite_check.dart' as bipartite_check;
import 'algorithms/bipartite_matching.dart' as bipartite_matching;
import 'algorithms/bron_kerbosch_cliques.dart' as bron_kerbosch_cliques;
import 'algorithms/connectivity.dart' as connectivity;
import 'algorithms/cycle_check.dart' as cycle_check;
import 'algorithms/dinic_max_flow.dart' as dinic_max_flow;
import 'algorithms/eulerian.dart' as eulerian;
import 'algorithms/isomorphism.dart' as isomorphism;
import 'algorithms/k_core.dart' as k_core;
import 'algorithms/kruskal_spanning_tree.dart' as kruskal_spanning_tree;
import 'algorithms/page_rank.dart' as page_rank;
import 'algorithms/prim_spanning_tree.dart' as prim_spanning_tree;
import 'algorithms/search/a_star.dart' as a_star;
import 'algorithms/search/bellman_ford.dart' as bellman_ford;
import 'algorithms/search/dijkstra.dart' as dijkstra;
import 'algorithms/search/floyd_warshall.dart' as floyd_warshall;
import 'algorithms/stoer_wagner_min_cut.dart' as stoer_wagner_min_cut;
import 'algorithms/structural_metrics.dart' as structural_metrics;
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
        vertices: vertices,
        outgoingEdgesOf: outgoingEdgesOf,
        isDirected: isDirected,
        inDegreeOf: isDirected ? inDegreeOf : null,
        outDegreeOf: isDirected ? outDegreeOf : null,
        degreeOf: !isDirected ? degreeOf : null,
        containsEdge: containsEdge,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Checks if this graph has an Eulerian path.
  bool hasEulerianPath({StorageStrategy<V>? vertexStrategy}) =>
      eulerian.hasEulerianPath<V, E>(
        vertices: vertices,
        outgoingEdgesOf: outgoingEdgesOf,
        isDirected: isDirected,
        inDegreeOf: isDirected ? inDegreeOf : null,
        outDegreeOf: isDirected ? outDegreeOf : null,
        degreeOf: !isDirected ? degreeOf : null,
        containsEdge: containsEdge,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Finds an Eulerian path or circuit in this graph using Hierholzer's algorithm.
  ///
  /// If [circuit] is `true`, only an Eulerian circuit is searched for.
  Path<V, E>? findEulerianPath({
    bool circuit = false,
    StorageStrategy<V>? vertexStrategy,
  }) => eulerian.findEulerianPath<V, E>(
    vertices: vertices,
    outgoingEdgesOf: outgoingEdgesOf,
    isDirected: isDirected,
    inDegreeOf: isDirected ? inDegreeOf : null,
    outDegreeOf: isDirected ? outDegreeOf : null,
    degreeOf: !isDirected ? degreeOf : null,
    containsEdge: containsEdge,
    circuit: circuit,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Returns the articulation points (cut vertices) of this undirected graph.
  Set<V> articulationPoints({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    return biconnected.articulationPoints<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: vertexStrategy ?? this.vertexStrategy,
    );
  }

  /// Returns the bridges (cut edges) of this undirected graph.
  Set<Edge<V, E>> bridges({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    final bridgePairs = biconnected.bridges<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: vertexStrategy ?? this.vertexStrategy,
    );
    final result = <Edge<V, E>>{};
    for (final (u, v) in bridgePairs) {
      final edge = getEdge(u, v);
      if (edge != null) result.add(edge);
    }
    return result;
  }

  /// Returns the biconnected components of this undirected graph.
  Iterable<Graph<V, E>> biconnectedComponents({
    StorageStrategy<V>? vertexStrategy,
  }) {
    GraphError.checkNotDirected(this);
    final strategy = vertexStrategy ?? this.vertexStrategy;
    final comps = biconnected.biconnectedComponents<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: strategy,
    );
    return comps.map((comp) {
      final sub = Graph<V, E>(isDirected: false, vertexStrategy: strategy);
      for (final v in comp.vertices) {
        sub.addVertex(v);
      }
      for (final (u, v) in comp.edges) {
        final edge = getEdge(u, v);
        sub.addEdge(u, v, value: edge?.value);
      }
      return sub;
    });
  }

  /// Returns the density of this graph.
  ///
  /// For a directed graph with $|V|$ vertices and $|E|$ edges, density is
  /// $\frac{|E|}{|V|(|V|-1)}$.
  /// For an undirected graph, density is $\frac{2|E_u|}{|V|(|V|-1)}$ where
  /// $|E_u|$ is the number of undirected edges (excluding self-loops).
  ///
  /// Returns `0.0` if $|V| < 2$.
  double get density => structural_metrics.graphDensity<V>(
    vertices: vertices,
    successorsOf: successorsOf,
    isDirected: isDirected,
  );

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
  }) => structural_metrics.localClusteringCoefficient<V>(
    vertex,
    neighboursOf: neighboursOf,
    successorsOf: successorsOf,
    isDirected: isDirected,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Returns the average clustering coefficient across all vertices in the graph.
  ///
  /// Returns `0.0` if the graph has no vertices.
  double averageClusteringCoefficient({StorageStrategy<V>? vertexStrategy}) =>
      structural_metrics.averageClusteringCoefficient<V>(
        vertices: vertices,
        neighboursOf: neighboursOf,
        successorsOf: successorsOf,
        isDirected: isDirected,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Returns the transitivity (global clustering coefficient) of the graph.
  ///
  /// Transitivity is defined as $3 \times \frac{\text{number of triangles}}{\text{number of connected triplets}}$.
  /// Returns `0.0` if there are no connected triplets.
  double transitivity({StorageStrategy<V>? vertexStrategy}) =>
      structural_metrics.graphTransitivity<V>(
        vertices: vertices,
        neighboursOf: neighboursOf,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Computes the betweenness centrality of all vertices in this graph.
  Map<V, double> betweennessCentrality({
    bool normalized = true,
    StorageStrategy<V>? vertexStrategy,
  }) => betweenness_centrality.betweennessCentrality<V>(
    vertices: vertices,
    successorsOf: successorsOf,
    isDirected: isDirected,
    normalized: normalized,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Computes the PageRank of all vertices in this graph.
  Map<V, double> pageRank({
    double damping = 0.85,
    double tolerance = 1e-6,
    int maxIterations = 100,
    StorageStrategy<V>? vertexStrategy,
  }) => page_rank.pageRank<V>(
    vertices: vertices,
    successorsOf: successorsOf,
    predecessorsOf: predecessorsOf,
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
  Map<V, V> bipartiteMatching({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    try {
      return bipartite_matching.bipartiteMatching<V>(
        vertices: vertices,
        neighboursOf: neighboursOf,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );
    } on ArgumentError catch (e) {
      throw GraphError(this, 'graph', e.message);
    }
  }

  /// Computes the minimum vertex cover of this undirected bipartite graph.
  Set<V> minimumVertexCover({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    try {
      return bipartite_matching.minimumVertexCover<V>(
        vertices: vertices,
        neighboursOf: neighboursOf,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );
    } on ArgumentError catch (e) {
      throw GraphError(this, 'graph', e.message);
    }
  }

  /// Computes the maximum independent set of this undirected bipartite graph.
  Set<V> maximumIndependentSet({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    try {
      return bipartite_matching.maximumIndependentSet<V>(
        vertices: vertices,
        neighboursOf: neighboursOf,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );
    } on ArgumentError catch (e) {
      throw GraphError(this, 'graph', e.message);
    }
  }

  /// Computes the core numbers of all vertices in this undirected graph.
  Map<V, int> coreNumbers({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    return k_core.coreNumbers<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: vertexStrategy ?? this.vertexStrategy,
    );
  }

  /// Returns the $k$-core subgraph of this undirected graph.
  Graph<V, E> kCore(int k, {StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkNotDirected(this);
    final strategy = vertexStrategy ?? this.vertexStrategy;
    final coreVerts = k_core.kCoreVertices<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      k: k,
      vertexStrategy: strategy,
    );
    final sub = Graph<V, E>(isDirected: false, vertexStrategy: strategy);
    for (final v in coreVerts) {
      sub.addVertex(v);
    }
    for (final v in sub.vertices) {
      for (final edge in outgoingEdgesOf(v)) {
        if (sub.containsVertex(edge.target)) {
          sub.addEdge(edge.source, edge.target, value: edge.value);
        }
      }
    }
    return sub;
  }

  /// Computes the edge connectivity of this graph (or between [source] and [target]).
  int edgeConnectivity({
    V? source,
    V? target,
    StorageStrategy<V>? vertexStrategy,
  }) => connectivity.edgeConnectivity<V>(
    vertices: vertices,
    successorsOf: successorsOf,
    containsEdge: containsEdge,
    isDirected: isDirected,
    source: source,
    target: target,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Computes the vertex connectivity of this graph (or between [source] and [target]).
  int vertexConnectivity({
    V? source,
    V? target,
    StorageStrategy<V>? vertexStrategy,
  }) => connectivity.vertexConnectivity<V>(
    vertices: vertices,
    successorsOf: successorsOf,
    containsEdge: containsEdge,
    isDirected: isDirected,
    source: source,
    target: target,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );

  /// Checks if this graph is isomorphic to [other].
  bool isIsomorphicTo<W, F>(
    Graph<W, F> other, {
    bool Function(V targetVertex, W patternVertex)? vertexComparator,
    bool Function(E targetEdgeValue, F patternEdgeValue)? edgeComparator,
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<W>? otherStrategy,
  }) {
    if (isDirected != other.isDirected) return false;
    return isomorphism
        .findIsomorphisms<V, E, W, F>(
          targetVertices: vertices,
          patternVertices: other.vertices,
          targetSuccessorsOf: successorsOf,
          patternSuccessorsOf: other.successorsOf,
          targetPredecessorsOf: predecessorsOf,
          patternPredecessorsOf: other.predecessorsOf,
          targetEdgeCount: edges.length,
          patternEdgeCount: other.edges.length,
          isDirected: isDirected,
          subgraph: false,
          vertexComparator: vertexComparator,
          edgeComparator: edgeComparator,
          targetEdgeValue: (u, v) => getEdge(u, v)?.value,
          patternEdgeValue: (u, v) => other.getEdge(u, v)?.value,
          targetStrategy: vertexStrategy ?? this.vertexStrategy,
          patternStrategy: otherStrategy ?? other.vertexStrategy,
        )
        .isNotEmpty;
  }

  /// Finds all induced subgraph isomorphisms of [pattern] in this graph.
  Iterable<Map<W, V>> findSubgraphIsomorphisms<W, F>(
    Graph<W, F> pattern, {
    bool Function(V targetVertex, W patternVertex)? vertexComparator,
    bool Function(E targetEdgeValue, F patternEdgeValue)? edgeComparator,
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<W>? patternStrategy,
  }) {
    if (isDirected != pattern.isDirected) return const [];
    return isomorphism.findIsomorphisms<V, E, W, F>(
      targetVertices: vertices,
      patternVertices: pattern.vertices,
      targetSuccessorsOf: successorsOf,
      patternSuccessorsOf: pattern.successorsOf,
      targetPredecessorsOf: predecessorsOf,
      patternPredecessorsOf: pattern.predecessorsOf,
      targetEdgeCount: edges.length,
      patternEdgeCount: pattern.edges.length,
      isDirected: isDirected,
      subgraph: true,
      vertexComparator: vertexComparator,
      edgeComparator: edgeComparator,
      targetEdgeValue: (u, v) => getEdge(u, v)?.value,
      patternEdgeValue: (u, v) => pattern.getEdge(u, v)?.value,
      targetStrategy: vertexStrategy ?? this.vertexStrategy,
      patternStrategy: patternStrategy ?? pattern.vertexStrategy,
    );
  }

  /// Internal helper that returns a function using the numeric edge value
  /// of this graph, or otherwise a constant value for each edge.
  num Function(V source, V target) _getDefaultEdgeValueOr(num value) =>
      this is Graph<V, num>
      ? (source, target) => getEdge(source, target)!.value as num
      : constantFunction2(value);
}
