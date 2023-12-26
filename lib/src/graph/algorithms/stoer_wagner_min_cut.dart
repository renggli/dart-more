// https://github.com/thomasjungblut/tjungblut-graph/blob/master/src/de/jungblut/graph/partition/StoerWagnerMinCut.java

import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../../../graph.dart';
import '../../functional/types.dart';

/// Stoer–Wagner minimum cut algorithm in _O(V*E + V*log(V))_.
///
/// See https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm.
class StoerWagnerMinCut<V, E> {
  StoerWagnerMinCut({
    required Graph<V, E> graph,
    num Function(V source, V target)? edgeWeight,
    StorageStrategy<V>? vertexStrategy,
  }) : this._(
          graph: graph,
          edgeWeight: edgeWeight ?? constantFunction2(1),
          vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
        );

  StoerWagnerMinCut._({
    required this.graph,
    required this.edgeWeight,
    required this.vertexStrategy,
  }) {
    GraphError.checkUndirected(graph);
    GraphError.checkVertexCount(graph, 2);

    // Initialize the vertices of the working graph.
    final vertexMap = graph.vertexStrategy.createMap<Set<V>>();
    for (final vertex in graph.vertices) {
      final list = graph.vertexStrategy.createSet();
      _workingGraph.addVertex(list);
      vertexMap[vertex] = list;
      list.add(vertex);
    }

    // Initialize the edges of the working graph.
    for (final edge in graph.edges.unique()) {
      final weight = edgeWeight(edge.source, edge.target);
      if (weight < 0) {
        throw GraphError(
            weight, 'edgeWeight', 'Expected positive edge weight for $edge');
      }
      _workingGraph.addEdge(vertexMap[edge.source]!, vertexMap[edge.target]!,
          value: weight);
    }

    // Perform the minimum cut of Stoer–Wagner.
    final vertex = _workingGraph.vertices.first;
    while (_workingGraph.vertices.length > 1) {
      _minimumCutPhase(vertex);
    }
  }

  // Internal state.
  final Graph<Set<V>, num> _workingGraph =
      Graph<Set<V>, num>.undirected(vertexStrategy: StorageStrategy.identity());
  Set<V> _bestPartition = const {};
  num _bestWeight = double.infinity;

  /// The underlying graph on which this cut was computed.
  final Graph<V, E> graph;

  /// The edge weight used to compute the cut.
  final num Function(V source, V target) edgeWeight;

  /// The vertex strategy to store vertices of type V.
  final StorageStrategy<V> vertexStrategy;

  /// Returns a view of the graph onto the first side of the cut.
  Graph<V, E> get first =>
      graph.where(vertexPredicate: _bestPartition.contains);

  /// Returns a view of the graph onto the second side of the cut.
  Graph<V, E> get second {
    final vertices = vertexStrategy.createSet();
    vertices.addAll(graph.vertices);
    vertices.removeAll(_bestPartition);
    return graph.where(vertexPredicate: vertices.contains);
  }

  /// Returns an iterable over the edges that are cut.
  ///
  /// Each undirected edge appears for each direction once, to de-duplicate
  /// use `minCut.edges.unique()`.
  Iterable<Edge<V, E>> get edges => graph.edges.where((edge) =>
      _bestPartition.contains(edge.source) !=
      _bestPartition.contains(edge.target));

  /// Returns the weight of the cut vertices.
  num get weight => _bestWeight;

  void _minimumCutPhase(Set<V> seed) {
    final queue = PriorityQueue<_VertexWeight<V>>();
    final mapping = <Set<V>, _VertexWeight<V>>{};
    var current = seed, previous = vertexStrategy.createSet();
    for (final vertex in _workingGraph.vertices) {
      if (vertex == seed) continue;
      final edge = _workingGraph.getEdge(vertex, seed);
      final data = _VertexWeight<V>(vertex, edge?.value ?? 0, edge != null);
      queue.add(data);
      mapping[vertex] = data;
    }
    while (queue.isNotEmpty) {
      final source = queue.removeFirst().vertex;
      mapping.remove(source);
      previous = current;
      current = source;
      for (final edge in _workingGraph.outgoingEdgesOf(source)) {
        final target = edge.target;
        final data = mapping[target];
        if (data != null) {
          queue.remove(data);
          data.active = true;
          data.weight += edge.value;
          queue.add(data);
        }
      }
    }
    final weight =
        _workingGraph.incomingEdgesOf(current).map((edge) => edge.value).sum;
    if (weight < _bestWeight) {
      _bestPartition = current;
      _bestWeight = weight;
    }
    _mergeVertices(previous, current);
  }

  void _mergeVertices(Set<V> source, Set<V> target) {
    final merged = vertexStrategy.createSet()
      ..addAll(source)
      ..addAll(target);
    _workingGraph.addVertex(merged);
    for (final vertex in _workingGraph.vertices) {
      if (source != vertex && target != vertex) {
        num mergedWeight = 0;
        final sourceEdge = _workingGraph.getEdge(vertex, source);
        if (sourceEdge != null) mergedWeight += sourceEdge.value;
        final targetEdge = _workingGraph.getEdge(vertex, target);
        if (targetEdge != null) mergedWeight += targetEdge.value;
        if (targetEdge != null || sourceEdge != null) {
          _workingGraph.addEdge(merged, vertex, value: mergedWeight);
        }
      }
    }
    _workingGraph.removeVertex(source);
    _workingGraph.removeVertex(target);
  }
}

class _VertexWeight<V> implements Comparable<_VertexWeight<V>> {
  _VertexWeight(this.vertex, this.weight, this.active);

  final Set<V> vertex;
  num weight;
  bool active;

  @override
  int compareTo(_VertexWeight<V> other) {
    if (active && other.active) return -weight.compareTo(other.weight);
    if (active && !other.active) return -1;
    if (!active && other.active) return 1;
    return 0;
  }
}
