// https://github.com/thomasjungblut/tjungblut-graph/blob/master/src/de/jungblut/graph/partition/StoerWagnerMinCut.java

import 'package:collection/collection.dart';

import '../../../graph.dart';
import '../../collection/heap.dart';
import '../../collection/iterable/unique.dart';
import '../../functional/scope.dart';
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
      final set = graph.vertexStrategy.createSet();
      _workingGraph.addVertex(set);
      vertexMap[vertex] = set;
      set.add(vertex);
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
    _workingGraph.removeVertex(_workingGraph.vertices.single);
  }

  // Internal state.
  final _workingGraph =
      Graph<Set<V>, num>.undirected(vertexStrategy: StorageStrategy.identity());
  Set<V> _bestPartition = const {};
  num _bestWeight = double.infinity;

  /// The underlying graph on which this cut was computed.
  final Graph<V, E> graph;

  /// The edge weight used to compute the cut.
  final num Function(V source, V target) edgeWeight;

  /// The vertex strategy to store vertices of type V.
  final StorageStrategy<V> vertexStrategy;

  /// Returns a list with the graphs on each side of the cut.
  late final List<Graph<V, E>> graphs = [
    graph.where(vertexPredicate: _bestPartition.contains),
    vertexStrategy.createSet().also((vertices) {
      vertices.addAll(graph.vertices);
      vertices.removeAll(_bestPartition);
      return graph.where(vertexPredicate: vertices.contains);
    }),
  ];

  /// Returns an iterable over the edges that are cut.
  ///
  /// Each undirected edge appears for each direction once, to de-duplicate
  /// use `minCut.edges.unique()`.
  late final List<Edge<V, E>> edges = graph.edges
      .where((edge) =>
          _bestPartition.contains(edge.source) !=
          _bestPartition.contains(edge.target))
      .toList();

  /// Returns the weight of the cut vertices.
  num get weight => _bestWeight;

  void _minimumCutPhase(Set<V> seed) {
    final queue = Heap<_State<V>>();
    final states = _workingGraph.vertexStrategy.createMap<_State<V>>();
    var current = seed, previous = vertexStrategy.createSet();
    for (final vertex in _workingGraph.vertices) {
      if (vertex == seed) continue;
      final edge = _workingGraph.getEdge(vertex, seed);
      final state = _State<V>(
          vertex: vertex, weight: edge?.value ?? 0, active: edge != null);
      states[vertex] = state;
      queue.add(state);
    }
    while (queue.isNotEmpty) {
      final source = queue.removeFirst().vertex;
      states.remove(source);
      previous = current;
      current = source;
      for (final edge in _workingGraph.outgoingEdgesOf(source)) {
        final state = states[edge.target];
        if (state != null) {
          queue.remove(state);
          state.active = true;
          state.weight += edge.value;
          queue.add(state);
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

class _State<V> extends HeapEntry<_State<V>> {
  _State({required this.vertex, required this.weight, required this.active});

  final Set<V> vertex;
  num weight;
  bool active;

  @override
  int compareTo(_State<V> other) {
    if (active && other.active) return -weight.compareTo(other.weight);
    if (active && !other.active) return -1;
    if (!active && other.active) return 1;
    return 0;
  }
}