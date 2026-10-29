import '../edge.dart';
import '../graph.dart';
import '../path.dart';
import '../strategy.dart';

/// Checks if [graph] has an Eulerian circuit (a closed trail visiting every edge exactly once).
bool hasEulerianCircuit<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) =>
    findEulerianPath<V, E>(
      graph,
      circuit: true,
      vertexStrategy: vertexStrategy,
    ) !=
    null;

/// Checks if [graph] has an Eulerian path (a trail visiting every edge exactly once).
bool hasEulerianPath<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) =>
    findEulerianPath<V, E>(
      graph,
      circuit: false,
      vertexStrategy: vertexStrategy,
    ) !=
    null;

/// Finds an Eulerian path or circuit in [graph] using Hierholzer's algorithm.
///
/// Returns `null` if no Eulerian path or circuit exists.
Path<V, E>? findEulerianPath<V, E>(
  Graph<V, E> graph, {
  bool circuit = false,
  StorageStrategy<V>? vertexStrategy,
}) {
  if (graph.vertices.isEmpty) return null;

  vertexStrategy ??= graph.vertexStrategy;

  // 1. Degree condition check and find starting vertex.
  V? startVertex;

  if (graph.isDirected) {
    var startCandidates = 0;
    var endCandidates = 0;
    for (final v in graph.vertices) {
      final outDeg = graph.outDegreeOf(v);
      final inDeg = graph.inDegreeOf(v);
      final diff = outDeg - inDeg;
      if (diff == 1) {
        startVertex = v;
        startCandidates++;
      } else if (diff == -1) {
        endCandidates++;
      } else if (diff != 0) {
        return null;
      }
    }
    if (circuit) {
      if (startCandidates != 0 || endCandidates != 0) return null;
    } else {
      if (!((startCandidates == 0 && endCandidates == 0) ||
          (startCandidates == 1 && endCandidates == 1))) {
        return null;
      }
    }
  } else {
    var oddVertices = 0;
    for (final v in graph.vertices) {
      // For undirected graphs, self-loops add 2 to degree, but graph.degreeOf(v)
      // counts neighbours, where a self loop (v, v) is 1 neighbour.
      // So degree in terms of edge endpoints is: neighbours.length + (has self-loop ? 1 : 0).
      var deg = graph.degreeOf(v);
      if (graph.containsEdge(v, v)) {
        deg += 1;
      }
      if (deg.isOdd) {
        oddVertices++;
        startVertex ??= v;
      }
    }
    if (circuit) {
      if (oddVertices != 0) return null;
    } else {
      if (oddVertices != 0 && oddVertices != 2) return null;
    }
  }

  // If no start vertex was identified by degree imbalance, pick any vertex with edges.
  if (startVertex == null) {
    for (final v in graph.vertices) {
      if (graph.degreeOf(v) > 0) {
        startVertex = v;
        break;
      }
    }
  }

  // If all vertices have degree 0:
  if (startVertex == null) {
    if (graph.vertices.length == 1) {
      return Path<V, E>.fromVertices([graph.vertices.first]);
    }
    return null;
  }

  // 2. Hierholzer's algorithm.
  final pathEdges = <Edge<V, E>>[];
  final stack = <V>[startVertex];

  if (graph.isDirected) {
    final edgeCount = graph.edges.length;
    final remainingEdges = vertexStrategy.createMap<List<Edge<V, E>>>();
    for (final v in graph.vertices) {
      final outgoing = graph.outgoingEdgesOf(v).toList();
      if (outgoing.isNotEmpty) {
        remainingEdges[v] = outgoing;
      }
    }

    final edgeStack = <Edge<V, E>>[];

    while (stack.isNotEmpty) {
      final current = stack.last;
      final edges = remainingEdges[current];
      if (edges != null && edges.isNotEmpty) {
        final edge = edges.removeLast();
        stack.add(edge.target);
        edgeStack.add(edge);
      } else {
        stack.removeLast();
        if (edgeStack.isNotEmpty) {
          pathEdges.add(edgeStack.removeLast());
        }
      }
    }

    if (pathEdges.length != edgeCount) {
      // Disconnected graph with edges in multiple components.
      return null;
    }

    return Path<V, E>.fromEdges(pathEdges.reversed);
  } else {
    // For undirected graphs, canonicalize edges so each undirected edge has a unique ID.
    // In graph.edges, each non-self edge appears twice: (u, v) and (v, u). Self loops appear once.
    final remainingEdges = vertexStrategy.createMap<List<(int, Edge<V, E>)>>();
    var undirectedEdgeCount = 0;
    final seenEdges = vertexStrategy.createMap<Set<V>>();

    for (final v in graph.vertices) {
      for (final edge in graph.outgoingEdgesOf(v)) {
        final u = edge.source;
        final w = edge.target;
        if (u == w) {
          final id = undirectedEdgeCount++;
          (remainingEdges[u] ??= []).add((id, edge));
        } else {
          final seenW = seenEdges[w];
          if (seenW == null || !seenW.contains(u)) {
            final id = undirectedEdgeCount++;
            (seenEdges[u] ??= vertexStrategy.createSet()).add(w);
            (remainingEdges[u] ??= []).add((id, edge));
            final reversedEdge = Edge<V, E>.undirected(w, u, value: edge.value);
            (remainingEdges[w] ??= []).add((id, reversedEdge));
          }
        }
      }
    }

    final edgeUsed = List<bool>.filled(undirectedEdgeCount, false);
    final edgeStack = <Edge<V, E>>[];

    while (stack.isNotEmpty) {
      final current = stack.last;
      final edges = remainingEdges[current];
      // Skip used edges.
      while (edges != null && edges.isNotEmpty && edgeUsed[edges.last.$1]) {
        edges.removeLast();
      }
      if (edges != null && edges.isNotEmpty) {
        final (id, edge) = edges.removeLast();
        edgeUsed[id] = true;
        stack.add(edge.target);
        edgeStack.add(edge);
      } else {
        stack.removeLast();
        if (edgeStack.isNotEmpty) {
          pathEdges.add(edgeStack.removeLast());
        }
      }
    }

    if (pathEdges.length != undirectedEdgeCount) {
      // Disconnected graph with edges in multiple components.
      return null;
    }

    return Path<V, E>.fromEdges(pathEdges.reversed);
  }
}
