import '../../../functional/types/constant.dart';
import '../../errors.dart';
import '../../path.dart';
import '../../strategy.dart';

/// Floyd-Warshall all-pairs shortest paths algorithm.
///
/// Computes all shortest paths between all pairs of vertices in a graph.
///
/// See https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm.
FloydWarshall<V> floydWarshallSearch<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  num Function(V source, V target)? edgeCost,
  StorageStrategy<V>? vertexStrategy,
}) {
  edgeCost = edgeCost ?? constantFunction2(1);
  vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  // Step 1: Initialize matrix states.
  final pairs = vertexStrategy.createMap<Map<V, FloydWarshallState<V>>>();
  for (final source in vertices) {
    final sourceMap = vertexStrategy.createMap<FloydWarshallState<V>>();
    for (final target in vertices) {
      sourceMap[target] = FloydWarshallState<V>(
        distance: source == target ? 0 : double.infinity,
      );
    }
    for (final target in successorsOf(source)) {
      final state = sourceMap[target];
      if (state != null) {
        final cost = edgeCost(source, target);
        if (source == target) {
          if (cost < state.distance) {
            state.distance = cost;
            state.next = target;
          }
        } else if (state.next == null || cost < state.distance) {
          state.distance = cost;
          state.next = target;
        }
      }
    }
    pairs[source] = sourceMap;
  }

  // Step 2: Floyd-Warshall loops.
  for (final k in vertices) {
    final rowK = pairs[k]!;
    for (final i in vertices) {
      final rowI = pairs[i]!;
      final ik = rowI[k]!;
      if (ik.distance.isInfinite) continue;
      for (final j in vertices) {
        final kj = rowK[j]!;
        if (kj.distance.isInfinite) continue;
        final ij = rowI[j]!;
        final distance = ik.distance + kj.distance;
        if (distance < ij.distance) {
          ij.distance = distance;
          ij.next = ik.next;
        }
      }
    }
  }

  // Step 3: Check for negative cycles.
  for (final vertex in vertices) {
    if (pairs[vertex]![vertex]!.distance < 0) {
      throw GraphError(
        vertex,
        'vertex',
        'Graph contains a negative-weight cycle',
      );
    }
  }

  return FloydWarshall(edgeCost, pairs);
}

/// The result of the Floyd-Warshall all-pairs shortest paths algorithm.
final class FloydWarshall<V> {
  final num Function(V source, V target) _edgeCost;
  final Map<V, Map<V, FloydWarshallState<V>>> _pairs;

  new(this._edgeCost, this._pairs);

  FloydWarshallState<V> _get(V source, V target) {
    final targetMap = _pairs[source];
    if (targetMap == null) {
      throw GraphError(source, 'source', 'Unknown vertex');
    }
    final state = targetMap[target];
    if (state == null) {
      throw GraphError(target, 'target', 'Unknown vertex');
    }
    return state;
  }

  /// Returns the minimum distance between [source] and [target], or
  /// [double.infinity] if the two vertices are not connected.
  num distance(V source, V target) => _get(source, target).distance;

  /// Returns the path between [source] and [target]. Returns `null`, if
  /// there is no such path.
  Path<V, num>? path(V source, V target) {
    final vertices = [source];
    final values = <num>[];
    V? current = source;
    while (current != null && current != target) {
      current = _get(current, target).next;
      if (current == null) return null;
      values.add(_edgeCost(vertices.last, current));
      vertices.add(current);
    }
    return Path<V, num>.fromVertices(vertices, values: values);
  }

  /// Returns all paths between all vertices.
  ///
  /// If [sourceVertices] and/or [targetVertices] are specified, only paths
  /// between those vertices are returned.
  Iterable<Path<V, num>> allPaths({
    Iterable<V>? sourceVertices,
    Iterable<V>? targetVertices,
  }) sync* {
    final sources = sourceVertices ?? _pairs.keys;
    final targets = targetVertices ?? _pairs.keys;
    for (final source in sources) {
      for (final target in targets) {
        final result = path(source, target);
        if (result != null) yield result;
      }
    }
  }

  /// Returns the eccentricity of [vertex], which is the maximum distance
  /// from [vertex] to any other reachable vertex.
  ///
  /// If there are no other vertices in the graph, returns `0`.
  /// If [vertex] cannot reach all other vertices, returns [double.infinity].
  num eccentricity(V vertex) {
    final targetMap = _pairs[vertex];
    if (targetMap == null) {
      throw GraphError(vertex, 'vertex', 'Unknown vertex');
    }
    if (_pairs.length <= 1) return 0;
    var maxDist = 0.0;
    for (final entry in targetMap.entries) {
      if (entry.key == vertex) continue;
      final dist = entry.value.distance;
      if (dist.isInfinite) return double.infinity;
      if (dist > maxDist) maxDist = dist.toDouble();
    }
    return maxDist;
  }

  /// Returns the diameter of the graph, which is the maximum eccentricity
  /// among all vertices in the graph.
  ///
  /// Returns `0` if the graph has 0 or 1 vertex.
  /// Returns [double.infinity] if the graph is not strongly connected.
  num get diameter {
    if (_pairs.length <= 1) return 0;
    var maxEcc = 0.0;
    for (final vertex in _pairs.keys) {
      final ecc = eccentricity(vertex);
      if (ecc.isInfinite) return double.infinity;
      if (ecc > maxEcc) maxEcc = ecc.toDouble();
    }
    return maxEcc;
  }

  /// Returns the radius of the graph, which is the minimum eccentricity
  /// among all vertices in the graph.
  ///
  /// Returns `0` if the graph has 0 or 1 vertex.
  /// Returns [double.infinity] if the graph is disconnected.
  num get radius {
    if (_pairs.length <= 1) return 0;
    var minEcc = double.infinity;
    for (final vertex in _pairs.keys) {
      final ecc = eccentricity(vertex);
      if (ecc < minEcc) minEcc = ecc.toDouble();
    }
    return minEcc;
  }

  /// Returns the center of the graph, which is the set of vertices whose
  /// eccentricity equals the radius.
  Set<V> get center {
    final rad = radius;
    final result = <V>{};
    if (rad.isInfinite) return result;
    for (final vertex in _pairs.keys) {
      if (eccentricity(vertex) == rad) {
        result.add(vertex);
      }
    }
    return result;
  }

  /// Returns the periphery of the graph, which is the set of vertices whose
  /// eccentricity equals the diameter.
  Set<V> get periphery {
    final diam = diameter;
    final result = <V>{};
    if (diam.isInfinite) return result;
    for (final vertex in _pairs.keys) {
      if (eccentricity(vertex) == diam) {
        result.add(vertex);
      }
    }
    return result;
  }

  /// Returns the average shortest path length between all distinct pairs
  /// of connected vertices.
  ///
  /// Returns `0.0` if there are fewer than 2 vertices or no connected pairs.
  double get averagePathLength {
    var totalDistance = 0.0;
    var pairCount = 0;
    for (final source in _pairs.keys) {
      for (final entry in _pairs[source]!.entries) {
        if (source == entry.key) continue;
        final dist = entry.value.distance;
        if (!dist.isInfinite) {
          totalDistance += dist;
          pairCount++;
        }
      }
    }
    return pairCount == 0 ? 0.0 : totalDistance / pairCount;
  }
}

final class FloydWarshallState<V> {
  new({this.distance = 0, this.next});

  num distance;

  V? next;
}
