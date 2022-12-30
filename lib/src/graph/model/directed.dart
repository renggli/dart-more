import 'package:meta/meta.dart';

import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';

class DirectedGraph<V, E> extends Graph<V, E> {
  factory DirectedGraph({StorageStrategy<V>? vertexStrategy}) =>
      DirectedGraph._(vertexStrategy ?? StorageStrategy<V>.defaultStrategy());

  DirectedGraph._(this.vertexStrategy)
      : vertexWrappers = vertexStrategy.createMap<VertexWrapper<V, E>>();

  final Map<V, VertexWrapper<V, E>> vertexWrappers;

  @override
  final StorageStrategy<V> vertexStrategy;

  @override
  bool get isDirected => true;

  @override
  Iterable<V> get vertices => vertexWrappers.keys;

  @override
  Iterable<Edge<V, E>> get edges =>
      vertexWrappers.values.expand((data) => data.outgoingWrappers);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      vertexWrappers[vertex]?.incomingWrappers ?? <Edge<V, E>>[];

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      vertexWrappers[vertex]?.outgoingWrappers ?? <Edge<V, E>>[];

  @override
  void addVertex(V vertex) => getVertexWrapper(vertex);

  @override
  void addEdge(V source, V target, {E? data}) {
    final edgeWrapper = getEdgeWrapper(source, target, data: data);
    edgeWrapper.sourceWrapper.outgoingWrappers.add(edgeWrapper);
    edgeWrapper.targetWrapper.incomingWrappers.add(edgeWrapper);
  }

  @override
  void removeVertex(V vertex) {
    final wrapper = vertexWrappers.remove(vertex);
    if (wrapper != null) {
      for (var edge in wrapper.outgoingWrappers) {
        assert(edge.targetWrapper.incomingWrappers.contains(edge),
            'Missing incoming edge: $edge');
        edge.targetWrapper.incomingWrappers.remove(edge);
      }
      for (var edge in wrapper.incomingWrappers) {
        assert(edge.sourceWrapper.outgoingWrappers.contains(edge),
            'Missing outgoing edge: $edge');
        edge.sourceWrapper.outgoingWrappers.remove(edge);
      }
    }
  }

  @override
  void removeEdge(V source, V target, {E? data}) {
    final sourceWrapper = vertexWrappers[source];
    if (sourceWrapper == null) return;
    final targetWrapper = vertexWrappers[target];
    if (targetWrapper == null) return;
    sourceWrapper.outgoingWrappers.removeWhere((edge) =>
        edge.source == source &&
        edge.target == target &&
        edge.dataOrNull == data);
    targetWrapper.incomingWrappers.removeWhere((edge) =>
        edge.source == source &&
        edge.target == target &&
        edge.dataOrNull == data);
  }

  @internal
  VertexWrapper<V, E> getVertexWrapper(V vertex) =>
      vertexWrappers.putIfAbsent(vertex, () => VertexWrapper<V, E>(vertex));

  @internal
  EdgeWrapper<V, E> getEdgeWrapper(V source, V target, {E? data}) {
    final sourceWrapper = getVertexWrapper(source);
    final targetWrapper = getVertexWrapper(target);
    return data is E
        ? EdgeWrapperWithData<V, E>(sourceWrapper, targetWrapper, data)
        : EdgeWrapper<V, E>(sourceWrapper, targetWrapper);
  }
}

class VertexWrapper<V, E> {
  VertexWrapper(this.vertex);

  final V vertex;

  final List<EdgeWrapper<V, E>> incomingWrappers = [];

  final List<EdgeWrapper<V, E>> outgoingWrappers = [];
}

class EdgeWrapper<V, E> extends Edge<V, E> {
  const EdgeWrapper(this.sourceWrapper, this.targetWrapper);

  final VertexWrapper<V, E> sourceWrapper;

  @override
  V get source => sourceWrapper.vertex;

  final VertexWrapper<V, E> targetWrapper;

  @override
  V get target => targetWrapper.vertex;

  @override
  E get data => throw UnimplementedError();

  @override
  E? get dataOrNull => null;
}

class EdgeWrapperWithData<V, E> extends EdgeWrapper<V, E> {
  const EdgeWrapperWithData(
      super.sourceWrapper, super.targetWrapper, this.data);

  @override
  final E data;

  @override
  E? get dataOrNull => data;
}
