import 'package:collection/collection.dart';

import '../edge.dart';
import '../path.dart';
import '../strategy.dart';

/// Checks if an undirected graph has an Eulerian path.
///
/// An Eulerian path is a path that visits every edge exactly once. For an
/// undirected graph to have an Eulerian path, it must be connected and have
/// exactly 0 or 2 vertices with odd degree.
///
/// See https://en.wikipedia.org/wiki/Eulerian_path
bool hasEulerianPathUndirected<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) =>
    _checkEulerianPathUndirected<V>(
      vertices,
      neighboursOf,
      vertexStrategy ?? StorageStrategy.defaultStrategy(),
    ) !=
    null;

/// Checks if an undirected graph has an Eulerian circuit.
///
/// An Eulerian circuit is an Eulerian path that starts and ends at the same
/// vertex. For an undirected graph to have an Eulerian circuit, it must be
/// connected and every vertex must have even degree.
///
/// See https://en.wikipedia.org/wiki/Eulerian_path
bool hasEulerianCircuitUndirected<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) =>
    _checkEulerianCircuitUndirected<V>(
      vertices,
      neighboursOf,
      vertexStrategy ?? StorageStrategy.defaultStrategy(),
    ) !=
    null;

/// Checks if a directed graph has an Eulerian path.
///
/// An Eulerian path is a path that visits every edge exactly once. For a
/// directed graph to have an Eulerian path, it must be connected and:
/// - At most one vertex has (out-degree - in-degree) = 1 (start vertex)
/// - At most one vertex has (in-degree - out-degree) = 1 (end vertex)
/// - All other vertices have equal in-degree and out-degree
///
/// See https://en.wikipedia.org/wiki/Eulerian_path
bool hasEulerianPathDirected<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required Iterable<V> Function(V vertex) predecessorsOf,
  StorageStrategy<V>? vertexStrategy,
}) =>
    _checkEulerianPathDirected<V>(
      vertices,
      successorsOf,
      predecessorsOf,
      vertexStrategy ?? StorageStrategy.defaultStrategy(),
    ) !=
    null;

/// Checks if a directed graph has an Eulerian circuit.
///
/// An Eulerian circuit is an Eulerian path that starts and ends at the same
/// vertex. For a directed graph to have an Eulerian circuit, it must be
/// strongly connected and every vertex must have equal in-degree and
/// out-degree.
///
/// See https://en.wikipedia.org/wiki/Eulerian_path
bool hasEulerianCircuitDirected<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required Iterable<V> Function(V vertex) predecessorsOf,
  StorageStrategy<V>? vertexStrategy,
}) =>
    _checkEulerianCircuitDirected<V>(
      vertices,
      successorsOf,
      predecessorsOf,
      vertexStrategy ?? StorageStrategy.defaultStrategy(),
    ) !=
    null;

/// Finds an Eulerian path in an undirected graph using Hierholzer's algorithm.
///
/// Returns a [Path] if an Eulerian path exists, or `null` otherwise.
/// An Eulerian path visits every edge exactly once.
///
/// See https://en.wikipedia.org/wiki/Eulerian_path#Hierholzer's_algorithm
Path<V, E>? findEulerianPathUndirected<V, E>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required Edge<V, E>? Function(V source, V target) getEdge,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final degreeInfo = _checkEulerianPathUndirected(
    vertices,
    neighboursOf,
    vertexStrategy,
  );
  if (degreeInfo == null) {
    return null;
  }
  final adjacency = _buildAdjacencyMap(vertices, neighboursOf, vertexStrategy);
  if (adjacency.isEmpty) {
    return null;
  }
  final startVertex = adjacency.keys.firstWhere(
    (v) => degreeInfo.degrees[v]! % 2 != 0,
    orElse: () => adjacency.keys.first,
  );
  return _hierholzer(startVertex, adjacency, getEdge, vertexStrategy, true);
}

/// Finds an Eulerian circuit in an undirected graph using Hierholzer's algorithm.
///
/// Returns a [Path] if an Eulerian circuit exists, or `null` otherwise.
/// An Eulerian circuit is an Eulerian path that starts and ends at the same vertex.
///
/// See https://en.wikipedia.org/wiki/Eulerian_path#Hierholzer's_algorithm
Path<V, E>? findEulerianCircuitUndirected<V, E>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required Edge<V, E>? Function(V source, V target) getEdge,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  if (_checkEulerianCircuitUndirected(vertices, neighboursOf, vertexStrategy) ==
      null) {
    return null;
  }
  final adjacency = _buildAdjacencyMap(vertices, neighboursOf, vertexStrategy);
  if (adjacency.isEmpty) {
    return null;
  }
  return _hierholzer(
    adjacency.keys.first,
    adjacency,
    getEdge,
    vertexStrategy,
    true,
  );
}

/// Finds an Eulerian path in a directed graph using Hierholzer's algorithm.
///
/// Returns a [Path] if an Eulerian path exists, or `null` otherwise.
///
/// See https://en.wikipedia.org/wiki/Eulerian_path#Hierholzer's_algorithm
Path<V, E>? findEulerianPathDirected<V, E>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required Iterable<V> Function(V vertex) predecessorsOf,
  required Edge<V, E>? Function(V source, V target) getEdge,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final degreeInfo = _checkEulerianPathDirected(
    vertices,
    successorsOf,
    predecessorsOf,
    vertexStrategy,
  );
  if (degreeInfo == null) {
    return null;
  }
  final adjacency = _buildAdjacencyMap(vertices, successorsOf, vertexStrategy);
  if (adjacency.isEmpty) {
    return null;
  }
  final startVertex = adjacency.keys.firstWhere(
    (v) => degreeInfo.outDegrees[v]! > degreeInfo.inDegrees[v]!,
    orElse: () => adjacency.keys.first,
  );
  return _hierholzer(startVertex, adjacency, getEdge, vertexStrategy, false);
}

/// Finds an Eulerian circuit in a directed graph using Hierholzer's algorithm.
///
/// Returns a [Path] if an Eulerian circuit exists, or `null` otherwise.
///
/// See https://en.wikipedia.org/wiki/Eulerian_path#Hierholzer's_algorithm
Path<V, E>? findEulerianCircuitDirected<V, E>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required Iterable<V> Function(V vertex) predecessorsOf,
  required Edge<V, E>? Function(V source, V target) getEdge,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  if (_checkEulerianCircuitDirected(
        vertices,
        successorsOf,
        predecessorsOf,
        vertexStrategy,
      ) ==
      null) {
    return null;
  }
  final adjacency = _buildAdjacencyMap(vertices, successorsOf, vertexStrategy);
  if (adjacency.isEmpty) {
    return null;
  }
  return _hierholzer(
    adjacency.keys.first,
    adjacency,
    getEdge,
    vertexStrategy,
    false,
  );
}

({Set<V> verticesWithEdges, Map<V, int> degrees})?
_checkEulerianPathUndirected<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V> vertexStrategy,
) {
  if (vertices.isEmpty) {
    return const (verticesWithEdges: {}, degrees: {});
  }
  final degreeInfo = _calculateUndirectedDegrees(
    vertices,
    neighboursOf,
    vertexStrategy,
  );
  if (degreeInfo.verticesWithEdges.isEmpty) {
    return const (verticesWithEdges: {}, degrees: {});
  }
  if (!_isConnected(
    degreeInfo.verticesWithEdges,
    neighboursOf,
    vertexStrategy,
  )) {
    return null;
  }
  final oddDegreeCount = degreeInfo.verticesWithEdges
      .where((v) => degreeInfo.degrees[v]! % 2 != 0)
      .length;
  return (oddDegreeCount == 0 || oddDegreeCount == 2) ? degreeInfo : null;
}

({Set<V> verticesWithEdges, Map<V, int> degrees})?
_checkEulerianCircuitUndirected<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V> vertexStrategy,
) {
  if (vertices.isEmpty) {
    return const (verticesWithEdges: {}, degrees: {});
  }
  final degreeInfo = _calculateUndirectedDegrees(
    vertices,
    neighboursOf,
    vertexStrategy,
  );
  if (degreeInfo.verticesWithEdges.isEmpty) {
    return const (verticesWithEdges: {}, degrees: {});
  }
  if (!_isConnected(
    degreeInfo.verticesWithEdges,
    neighboursOf,
    vertexStrategy,
  )) {
    return null;
  }
  return degreeInfo.verticesWithEdges.every(
        (v) => degreeInfo.degrees[v]! % 2 == 0,
      )
      ? degreeInfo
      : null;
}

({Set<V> verticesWithEdges, Map<V, int> inDegrees, Map<V, int> outDegrees})?
_checkEulerianPathDirected<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) successorsOf,
  Iterable<V> Function(V vertex) predecessorsOf,
  StorageStrategy<V> vertexStrategy,
) {
  if (vertices.isEmpty) {
    return const (verticesWithEdges: {}, inDegrees: {}, outDegrees: {});
  }
  final degreeInfo = _calculateDirectedDegrees(
    vertices,
    successorsOf,
    predecessorsOf,
    vertexStrategy,
  );
  if (degreeInfo.verticesWithEdges.isEmpty) {
    return const (verticesWithEdges: {}, inDegrees: {}, outDegrees: {});
  }
  if (!_isWeaklyConnected(
    degreeInfo.verticesWithEdges,
    successorsOf,
    predecessorsOf,
    vertexStrategy,
  )) {
    return null;
  }
  var startVertices = 0;
  var endVertices = 0;
  for (final vertex in degreeInfo.verticesWithEdges) {
    final diff = degreeInfo.outDegrees[vertex]! - degreeInfo.inDegrees[vertex]!;
    if (diff == 1) {
      startVertices++;
    } else if (diff == -1) {
      endVertices++;
    } else if (diff != 0) {
      return null;
    }
  }
  return ((startVertices == 0 && endVertices == 0) ||
          (startVertices == 1 && endVertices == 1))
      ? degreeInfo
      : null;
}

({Set<V> verticesWithEdges, Map<V, int> inDegrees, Map<V, int> outDegrees})?
_checkEulerianCircuitDirected<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) successorsOf,
  Iterable<V> Function(V vertex) predecessorsOf,
  StorageStrategy<V> vertexStrategy,
) {
  if (vertices.isEmpty) {
    return const (verticesWithEdges: {}, inDegrees: {}, outDegrees: {});
  }
  final degreeInfo = _calculateDirectedDegrees(
    vertices,
    successorsOf,
    predecessorsOf,
    vertexStrategy,
  );
  if (degreeInfo.verticesWithEdges.isEmpty) {
    return const (verticesWithEdges: {}, inDegrees: {}, outDegrees: {});
  }
  if (!_isWeaklyConnected(
    degreeInfo.verticesWithEdges,
    successorsOf,
    predecessorsOf,
    vertexStrategy,
  )) {
    return null;
  }
  return degreeInfo.verticesWithEdges.every(
        (v) => degreeInfo.inDegrees[v] == degreeInfo.outDegrees[v],
      )
      ? degreeInfo
      : null;
}

({Set<V> verticesWithEdges, Map<V, int> degrees})
_calculateUndirectedDegrees<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V> vertexStrategy,
) {
  final verticesWithEdges = vertexStrategy.createSet();
  final degrees = vertexStrategy.createMap<int>();
  for (final vertex in vertices) {
    final neighbours = neighboursOf(vertex);
    if (neighbours.isNotEmpty) {
      verticesWithEdges.add(vertex);
      var degree = 0;
      for (final neighbour in neighbours) {
        degree += (neighbour == vertex) ? 2 : 1;
      }
      degrees[vertex] = degree;
    }
  }
  return (verticesWithEdges: verticesWithEdges, degrees: degrees);
}

({Set<V> verticesWithEdges, Map<V, int> inDegrees, Map<V, int> outDegrees})
_calculateDirectedDegrees<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) successorsOf,
  Iterable<V> Function(V vertex) predecessorsOf,
  StorageStrategy<V> vertexStrategy,
) {
  final verticesWithEdges = vertexStrategy.createSet();
  final inDegrees = vertexStrategy.createMap<int>();
  final outDegrees = vertexStrategy.createMap<int>();
  for (final vertex in vertices) {
    final successors = successorsOf(vertex);
    final predecessors = predecessorsOf(vertex);
    if (successors.isNotEmpty || predecessors.isNotEmpty) {
      verticesWithEdges.add(vertex);
      outDegrees[vertex] = successors.length;
      inDegrees[vertex] = predecessors.length;
    }
  }
  return (
    verticesWithEdges: verticesWithEdges,
    inDegrees: inDegrees,
    outDegrees: outDegrees,
  );
}

Map<V, Set<V>> _buildAdjacencyMap<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V> vertexStrategy,
) {
  final adjacency = vertexStrategy.createMap<Set<V>>();
  for (final vertex in vertices) {
    final neighbours = neighboursOf(vertex).toSet();
    if (neighbours.isNotEmpty) {
      adjacency[vertex] = neighbours;
    }
  }
  return adjacency;
}

bool _isConnected<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V> vertexStrategy,
) {
  if (vertices.isEmpty) {
    return true;
  }
  final visited = vertexStrategy.createSet();
  final queue = <V>[vertices.first];
  visited.add(vertices.first);
  while (queue.isNotEmpty) {
    final current = queue.removeLast();
    for (final neighbour in neighboursOf(current)) {
      if (!visited.contains(neighbour)) {
        visited.add(neighbour);
        queue.add(neighbour);
      }
    }
  }
  return visited.length == vertices.length;
}

bool _isWeaklyConnected<V>(
  Iterable<V> vertices,
  Iterable<V> Function(V vertex) successorsOf,
  Iterable<V> Function(V vertex) predecessorsOf,
  StorageStrategy<V> vertexStrategy,
) {
  if (vertices.isEmpty) {
    return true;
  }
  final visited = vertexStrategy.createSet();
  final queue = <V>[vertices.first];
  visited.add(vertices.first);
  while (queue.isNotEmpty) {
    final current = queue.removeLast();
    for (final neighbour in [
      ...successorsOf(current),
      ...predecessorsOf(current),
    ]) {
      if (!visited.contains(neighbour)) {
        visited.add(neighbour);
        queue.add(neighbour);
      }
    }
  }
  return visited.length == vertices.length;
}

Path<V, E> _hierholzer<V, E>(
  V startVertex,
  Map<V, Set<V>> adjacency,
  Edge<V, E>? Function(V source, V target) getEdge,
  StorageStrategy<V> vertexStrategy,
  bool isUndirected,
) {
  final stack = <V>[startVertex];
  final path = <V>[];
  final usedEdges = vertexStrategy.createMap<Set<V>>();
  while (stack.isNotEmpty) {
    final vertex = stack.last;
    final neighbours = adjacency[vertex];
    final unusedNeighbour = neighbours?.firstWhereOrNull((neighbour) {
      final used = usedEdges[vertex];
      return used == null || !used.contains(neighbour);
    });
    if (unusedNeighbour == null) {
      path.add(stack.removeLast());
    } else {
      usedEdges
          .putIfAbsent(vertex, () => vertexStrategy.createSet())
          .add(unusedNeighbour);
      if (isUndirected) {
        usedEdges
            .putIfAbsent(unusedNeighbour, () => vertexStrategy.createSet())
            .add(vertex);
      }
      stack.add(unusedNeighbour);
    }
  }
  return Path.fromEdges([
    for (var i = path.length - 1; i > 0; i--)
      if (getEdge(path[i], path[i - 1]) case final edge) edge!,
  ]);
}
