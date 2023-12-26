import 'dart:collection';
import 'dart:math' as math;

import '../../../functional.dart';
import '../errors.dart';
import '../strategy.dart';
import '../traverse/depth_first.dart';

/// Dinic max flow algorithm in _O(V^2*E)_.
///
/// See https://en.wikipedia.org/wiki/Dinic%27s_algorithm.
class DinicMaxFlow<V> {
  DinicMaxFlow({
    required Iterable<V> seedVertices,
    required Iterable<V> Function(V vertex) successorsOf,
    num Function(V source, V target)? edgeCapacity,
    StorageStrategy<V>? vertexStrategy,
  }) : this._(
          seedVertices: seedVertices,
          successorsOf: successorsOf,
          edgeCapacity: edgeCapacity ?? constantFunction2(1),
          vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
        );

  DinicMaxFlow._({
    required Iterable<V> seedVertices,
    required Iterable<V> Function(V vertex) successorsOf,
    required num Function(V source, V target) edgeCapacity,
    required StorageStrategy<V> vertexStrategy,
  }) : _mapping = vertexStrategy.createMap<_Vertex<V>>() {
    for (final originalVertex in DepthFirstIterable(seedVertices,
        successorsOf: successorsOf, vertexStrategy: vertexStrategy)) {
      final vertex = _Vertex<V>(originalVertex);
      _mapping[originalVertex] = vertex;
      _vertices.add(vertex);
    }
    for (final source in _vertices) {
      for (final originalTarget in successorsOf(source.vertex)) {
        final capacity = edgeCapacity(source.vertex, originalTarget);
        final target = _mapping[originalTarget]!;
        if (0 < capacity) {
          final outgoing = _Edge<V>(source, target, capacity: capacity);
          final incoming = _Edge<V>(target, source);
          outgoing.reverse = incoming;
          incoming.reverse = outgoing;
          source.outgoing.add(outgoing);
          target.outgoing.add(incoming);
          _edges.add(outgoing);
          _edges.add(incoming);
        }
      }
    }
  }

  final Map<V, _Vertex<V>> _mapping;
  final List<_Vertex<V>> _vertices = [];
  final List<_Edge<V>> _edges = [];
  final Queue<_Vertex<V>> _queue = Queue();

  /// Computes the maximum flow between [source] and [target].
  num call(V source, V target) {
    final mappedSource = _mapping[source], mappedTarget = _mapping[target];
    if (mappedSource == null) {
      throw GraphError(source, 'source', 'Unknown vertex');
    }
    if (mappedTarget == null) {
      throw GraphError(target, 'target', 'Unknown vertex');
    }
    return _maxFlow(mappedSource, mappedTarget);
  }

  num _maxFlow(_Vertex<V> source, _Vertex<V> target) {
    num flow = 0;
    for (final edge in _edges) {
      edge.flow = 0;
    }
    while (true) {
      if (!_bfs(source, target)) break;
      for (final vertex in _vertices) {
        vertex.index = 0;
      }
      while (true) {
        final pushed = _dfs(source, target, double.infinity);
        if (pushed == 0) break;
        flow += pushed;
      }
    }
    return flow;
  }

  bool _bfs(_Vertex<V> source, _Vertex<V> target) {
    for (final vertex in _vertices) {
      vertex.level = -1;
    }
    source.level = 0;
    _queue.addLast(source);
    while (_queue.isNotEmpty) {
      final source = _queue.removeFirst();
      for (final edge in source.outgoing) {
        if (edge.residual <= 0) continue;
        if (edge.target.level != -1) continue;
        edge.target.level = source.level + 1;
        _queue.addLast(edge.target);
      }
    }
    return target.level != -1;
  }

  num _dfs(_Vertex<V> source, _Vertex<V> target, num pushed) {
    if (pushed <= 0) return 0;
    if (source == target) return pushed;
    for (; source.index < source.outgoing.length; source.index++) {
      final edge = source.outgoing[source.index];
      final u = edge.target;
      if (source.level + 1 != u.level) continue;
      if (edge.residual <= 0) continue;
      final tr = _dfs(u, target, math.min(pushed, edge.residual));
      if (tr == 0) continue;
      edge.flow += tr;
      edge.reverse.flow -= tr;
      return tr;
    }
    return 0;
  }
}

class _Vertex<V> {
  _Vertex(this.vertex);

  final V vertex;
  final List<_Edge<V>> outgoing = [];
  int level = -1;
  int index = 0;
}

class _Edge<V> {
  _Edge(this.source, this.target, {this.capacity = 0});

  final _Vertex<V> source;
  final _Vertex<V> target;
  late final _Edge<V> reverse;
  final num capacity;
  num flow = 0;

  num get residual => capacity - flow;
}
