import 'package:collection/collection.dart';

import '../comparator/constructors/natural.dart';
import '../functional/types/constant.dart';
import '../functional/types/predicate.dart';
import 'algorithms/bipartite_check.dart' as bipartite_check;
import 'algorithms/bron_kerbosch_cliques.dart' as bron_kerbosch_cliques;
import 'algorithms/cycle_check.dart' as cycle_check;
import 'algorithms/dinic_max_flow.dart' as dinic_max_flow;
import 'algorithms/eulerian_path.dart' as eulerian_path;
import 'algorithms/kruskal_spanning_tree.dart' as kruskal_spanning_tree;
import 'algorithms/prim_spanning_tree.dart' as prim_spanning_tree;
import 'algorithms/search/a_star.dart' as a_star;
import 'algorithms/search/bellman_ford.dart' as bellman_ford;
import 'algorithms/search/dijkstra.dart' as dijkstra;
import 'algorithms/search/floyd_warshall.dart' as floyd_warshall;
import 'algorithms/stoer_wagner_min_cut.dart' as stoer_wagner_min_cut;
import 'algorithms/tarjan_strongly_connected.dart' as tarjan_strongly_connected;
import 'algorithms/vertex_coloring.dart' as vertex_coloring;
import 'errors.dart';
import 'graph.dart';
import 'path.dart';
import 'strategy.dart';

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
  /// - [edgeCapacity] is a function function that returns the positive maximum
  ///   capacity between two vertices. If no function is provided, the numeric
  ///   edge value or a constant weight of _1_ is used.
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
  /// - [edgeWeight] is a function function that returns the positive weight
  ///   between two edges. If no function is provided, the numeric edge value
  ///   or a constant weight of _1_ is used.
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
  /// implementation uses the Tarjan's algorithm and runs in linear time.
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
        successorsOf: successorsOf,
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

  /// Checks if the graph has an Eulerian path.
  ///
  /// An Eulerian path is a path that visits every edge exactly once.
  ///
  /// For an undirected graph, an Eulerian path exists if and only if the
  /// graph is connected and has exactly 0 or 2 vertices with odd degree.
  ///
  /// For a directed graph, an Eulerian path exists if and only if the graph
  /// is connected and:
  /// - At most one vertex has (out-degree - in-degree) = 1 (start vertex)
  /// - At most one vertex has (in-degree - out-degree) = 1 (end vertex)
  /// - All other vertices have equal in-degree and out-degree
  ///
  /// See https://en.wikipedia.org/wiki/Eulerian_path
  bool hasEulerianPath({StorageStrategy<V>? vertexStrategy}) => isDirected
      ? eulerian_path.hasEulerianPathDirected<V>(
          vertices: vertices,
          successorsOf: successorsOf,
          predecessorsOf: predecessorsOf,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        )
      : eulerian_path.hasEulerianPathUndirected<V>(
          vertices: vertices,
          neighboursOf: neighboursOf,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        );

  /// Checks if the graph has an Eulerian circuit.
  ///
  /// An Eulerian circuit is an Eulerian path that starts and ends at the
  /// same vertex.
  ///
  /// For an undirected graph, an Eulerian circuit exists if and only if the
  /// graph is connected and every vertex has even degree.
  ///
  /// For a directed graph, an Eulerian circuit exists if and only if the
  /// graph is connected and every vertex has equal in-degree and out-degree.
  ///
  /// See https://en.wikipedia.org/wiki/Eulerian_path
  bool hasEulerianCircuit({StorageStrategy<V>? vertexStrategy}) => isDirected
      ? eulerian_path.hasEulerianCircuitDirected<V>(
          vertices: vertices,
          successorsOf: successorsOf,
          predecessorsOf: predecessorsOf,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        )
      : eulerian_path.hasEulerianCircuitUndirected<V>(
          vertices: vertices,
          neighboursOf: neighboursOf,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        );

  /// Finds an Eulerian path in the graph.
  ///
  /// Returns a [Path] that visits every edge exactly once, or `null` if no
  /// such path exists.
  ///
  /// For an undirected graph, an Eulerian path exists if and only if the
  /// graph is connected and has exactly 0 or 2 vertices with odd degree.
  ///
  /// For a directed graph, an Eulerian path exists if and only if the graph
  /// is connected and:
  /// - At most one vertex has (out-degree - in-degree) = 1 (start vertex)
  /// - At most one vertex has (in-degree - out-degree) = 1 (end vertex)
  /// - All other vertices have equal in-degree and out-degree
  ///
  /// Uses Hierholzer's algorithm which runs in O(E) time where E is the
  /// number of edges.
  ///
  /// See https://en.wikipedia.org/wiki/Eulerian_path#Hierholzer's_algorithm
  Path<V, E>? eulerianPath({StorageStrategy<V>? vertexStrategy}) => isDirected
      ? eulerian_path.findEulerianPathDirected<V, E>(
          vertices: vertices,
          successorsOf: successorsOf,
          predecessorsOf: predecessorsOf,
          getEdge: getEdge,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        )
      : eulerian_path.findEulerianPathUndirected<V, E>(
          vertices: vertices,
          neighboursOf: neighboursOf,
          getEdge: getEdge,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        );

  /// Finds an Eulerian circuit in the graph.
  ///
  /// Returns a [Path] that visits every edge exactly once and returns to the
  /// starting vertex, or `null` if no such circuit exists.
  ///
  /// For an undirected graph, an Eulerian circuit exists if and only if the
  /// graph is connected and every vertex has even degree.
  ///
  /// For a directed graph, an Eulerian circuit exists if and only if the
  /// graph is connected and every vertex has equal in-degree and out-degree.
  ///
  /// Uses Hierholzer's algorithm which runs in O(E) time where E is the
  /// number of edges.
  ///
  /// See https://en.wikipedia.org/wiki/Eulerian_path#Hierholzer's_algorithm
  Path<V, E>? eulerianCircuit({StorageStrategy<V>? vertexStrategy}) =>
      isDirected
      ? eulerian_path.findEulerianCircuitDirected<V, E>(
          vertices: vertices,
          successorsOf: successorsOf,
          predecessorsOf: predecessorsOf,
          getEdge: getEdge,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        )
      : eulerian_path.findEulerianCircuitUndirected<V, E>(
          vertices: vertices,
          neighboursOf: neighboursOf,
          getEdge: getEdge,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy,
        );

  /// Internal helper that returns a function using the numeric edge value
  /// of this graph, or otherwise a constant value for each edge.
  num Function(V source, V target) _getDefaultEdgeValueOr(num value) =>
      this is Graph<V, num>
      ? (source, target) => getEdge(source, target)!.value as num
      : constantFunction2(value);
}
