import '../../../../functional.dart';
import '../../errors.dart';
import '../../path.dart';
import '../../strategy.dart';

/// Floyd-Warshall all-pairs shortest path algorithm.
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
  final pairs = vertexStrategy.createMap<Map<V, FloyWarshallState<V>>>();
  for (final source in vertices) {
    final sourceMap = vertexStrategy.createMap<FloyWarshallState<V>>();
    final successors = successorsOf(source);
    for (final target in vertices) {
      final state = source == target
          ? FloyWarshallState<V>(distance: 0)
          : successors.contains(target)
          ? FloyWarshallState<V>(
              distance: edgeCost(source, target),
              next: target,
            )
          : FloyWarshallState<V>(distance: double.infinity);
      sourceMap[target] = state;
    }
    pairs[source] = sourceMap;
  }

  // Step 2: Floyd-Warshall loops.
  for (final k in vertices) {
    for (final i in vertices) {
      final ik = pairs[i]![k]!;
      if (ik.distance.isInfinite) continue;
      for (final j in vertices) {
        final kj = pairs[k]![j]!;
        if (kj.distance.isInfinite) continue;
        final ij = pairs[i]![j]!;
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

final class FloydWarshall<V> {
  final num Function(V source, V target) _edgeCost;
  final Map<V, Map<V, FloyWarshallState<V>>> _pairs;

  FloydWarshall(this._edgeCost, this._pairs);

  FloyWarshallState<V> _get(V source, V target) {
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

  /// Returns the path between [source] and [target]. Retruns `null`, if
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
  Iterable<Path<V, num>> allPaths({Iterable<V>? vertices}) sync* {
    final selected = vertices ?? _pairs.keys;
    for (final source in selected) {
      for (final target in selected) {
        final result = path(source, target);
        if (result != null) yield result;
      }
    }
  }
}

final class FloyWarshallState<V> {
  FloyWarshallState({this.distance = 0, this.next});

  num distance;

  V? next;
}
