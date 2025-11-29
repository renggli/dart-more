import '../../edge.dart';
import '../../strategy.dart';
import 'base.dart';

abstract class DirectedMultiGraph<V, E> extends DirectedGraph<V, E> {
  factory DirectedMultiGraph.create({
    required bool uniqueEdges,
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => uniqueEdges
      ? DirectedMultiSetGraph.create(
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        )
      : DirectedMultiListGraph.create(
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        );

  DirectedMultiGraph({
    required super.vertexStrategy,
    required super.edgeStrategy,
  });

  @override
  void addEdge(V source, V target, {E? value}) {
    // TODO: implement addEdge
    throw UnimplementedError();
  }

  @override
  void addVertex(V vertex) {
    // TODO: implement addVertex
    throw UnimplementedError();
  }

  @override
  // TODO: implement edges
  Iterable<Edge<V, E>> get edges => throw UnimplementedError();

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) {
    // TODO: implement edgesOf
    throw UnimplementedError();
  }

  @override
  Edge<V, E>? getEdge(V source, V target) {
    // TODO: implement getEdge
    throw UnimplementedError();
  }

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) {
    // TODO: implement incomingEdgesOf
    throw UnimplementedError();
  }

  @override
  Iterable<V> neighboursOf(V vertex) {
    // TODO: implement neighboursOf
    throw UnimplementedError();
  }

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) {
    // TODO: implement outgoingEdgesOf
    throw UnimplementedError();
  }

  @override
  Iterable<V> predecessorsOf(V vertex) {
    // TODO: implement predecessorsOf
    throw UnimplementedError();
  }

  @override
  void removeEdge(V source, V target, {E? value}) {
    // TODO: implement removeEdge
    throw UnimplementedError();
  }

  @override
  void removeVertex(V vertex) {
    // TODO: implement removeVertex
    throw UnimplementedError();
  }

  @override
  Iterable<V> successorsOf(V vertex) {
    // TODO: implement successorsOf
    throw UnimplementedError();
  }

  @override
  // TODO: implement vertices
  Iterable<V> get vertices => throw UnimplementedError();
}

class DirectedMultiListGraph<V, E> extends DirectedMultiGraph<V, E> {
  factory DirectedMultiListGraph.create({
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => DirectedMultiListGraph<V, E>(
    vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
    edgeStrategy: edgeStrategy ?? StorageStrategy.defaultStrategy(),
  );

  DirectedMultiListGraph({
    required super.vertexStrategy,
    required super.edgeStrategy,
  });
}

class DirectedMultiSetGraph<V, E> extends DirectedMultiGraph<V, E> {
  factory DirectedMultiSetGraph.create({
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => DirectedMultiSetGraph<V, E>(
    vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
    edgeStrategy: edgeStrategy ?? StorageStrategy.defaultStrategy(),
  );

  DirectedMultiSetGraph({
    required super.vertexStrategy,
    required super.edgeStrategy,
  });
}
