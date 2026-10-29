import '../edge.dart';
import '../path.dart';
import '../strategy.dart';

/// Checks if a graph has an Eulerian circuit (a closed trail visiting every edge exactly once).
bool hasEulerianCircuit<V, E>({
  required Iterable<V> vertices,
  required Iterable<Edge<V, E>> Function(V vertex) outgoingEdgesOf,
  required bool isDirected,
  int Function(V vertex)? inDegreeOf,
  int Function(V vertex)? outDegreeOf,
  int Function(V vertex)? degreeOf,
  bool Function(V u, V v)? containsEdge,
  StorageStrategy<V>? vertexStrategy,
}) =>
    findEulerianPath<V, E>(
      vertices: vertices,
      outgoingEdgesOf: outgoingEdgesOf,
      isDirected: isDirected,
      inDegreeOf: inDegreeOf,
      outDegreeOf: outDegreeOf,
      degreeOf: degreeOf,
      containsEdge: containsEdge,
      circuit: true,
      vertexStrategy: vertexStrategy,
    ) !=
    null;

/// Checks if a graph has an Eulerian path (a trail visiting every edge exactly once).
bool hasEulerianPath<V, E>({
  required Iterable<V> vertices,
  required Iterable<Edge<V, E>> Function(V vertex) outgoingEdgesOf,
  required bool isDirected,
  int Function(V vertex)? inDegreeOf,
  int Function(V vertex)? outDegreeOf,
  int Function(V vertex)? degreeOf,
  bool Function(V u, V v)? containsEdge,
  StorageStrategy<V>? vertexStrategy,
}) =>
    findEulerianPath<V, E>(
      vertices: vertices,
      outgoingEdgesOf: outgoingEdgesOf,
      isDirected: isDirected,
      inDegreeOf: inDegreeOf,
      outDegreeOf: outDegreeOf,
      degreeOf: degreeOf,
      containsEdge: containsEdge,
      circuit: false,
      vertexStrategy: vertexStrategy,
    ) !=
    null;

/// Finds an Eulerian path or circuit in a graph using Hierholzer's algorithm.
///
/// Returns `null` if no Eulerian path or circuit exists.
Path<V, E>? findEulerianPath<V, E>({
  required Iterable<V> vertices,
  required Iterable<Edge<V, E>> Function(V vertex) outgoingEdgesOf,
  required bool isDirected,
  int Function(V vertex)? inDegreeOf,
  int Function(V vertex)? outDegreeOf,
  int Function(V vertex)? degreeOf,
  bool Function(V u, V v)? containsEdge,
  bool circuit = false,
  StorageStrategy<V>? vertexStrategy,
}) {
  final vertexList = vertices.toList(growable: false);
  if (vertexList.isEmpty) return null;

  vertexStrategy ??= StorageStrategy.defaultStrategy();

  // 1. Degree condition check and find starting vertex.
  V? startVertex;

  if (isDirected) {
    outDegreeOf ??= (v) => outgoingEdgesOf(v).length;
    if (inDegreeOf == null) {
      final inDegrees = vertexStrategy.createMap<int>();
      for (final v in vertexList) {
        inDegrees[v] = 0;
      }
      for (final v in vertexList) {
        for (final edge in outgoingEdgesOf(v)) {
          if (inDegrees.containsKey(edge.target)) {
            inDegrees[edge.target] = inDegrees[edge.target]! + 1;
          }
        }
      }
      inDegreeOf = (v) => inDegrees[v] ?? 0;
    }

    var startCandidates = 0;
    var endCandidates = 0;
    for (final v in vertexList) {
      final outDeg = outDegreeOf(v);
      final inDeg = inDegreeOf(v);
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
    degreeOf ??= (v) => outgoingEdgesOf(v).length;
    containsEdge ??= (u, v) => outgoingEdgesOf(u).any((e) => e.target == v);

    var oddVertices = 0;
    for (final v in vertexList) {
      var deg = degreeOf(v);
      if (containsEdge(v, v)) {
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
    for (final v in vertexList) {
      if (outgoingEdgesOf(v).isNotEmpty) {
        startVertex = v;
        break;
      }
    }
  }

  // If all vertices have degree 0:
  if (startVertex == null) {
    if (vertexList.length == 1) {
      return Path<V, E>.fromVertices([vertexList.first]);
    }
    return null;
  }

  // 2. Hierholzer's algorithm.
  final pathEdges = <Edge<V, E>>[];
  final stack = <V>[startVertex];

  if (isDirected) {
    var edgeCount = 0;
    final remainingEdges = vertexStrategy.createMap<List<Edge<V, E>>>();
    for (final v in vertexList) {
      final outgoing = outgoingEdgesOf(v).toList();
      if (outgoing.isNotEmpty) {
        remainingEdges[v] = outgoing;
        edgeCount += outgoing.length;
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
    final remainingEdges = vertexStrategy.createMap<List<(int, Edge<V, E>)>>();
    var undirectedEdgeCount = 0;
    final seenEdges = vertexStrategy.createMap<Set<V>>();

    for (final v in vertexList) {
      for (final edge in outgoingEdgesOf(v)) {
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
