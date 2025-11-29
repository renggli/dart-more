import '../../edge.dart';
import '../../strategy.dart';
import 'base.dart';

abstract class UndirectedMultiGraph<V, E> extends UndirectedGraph<V, E> {
  factory UndirectedMultiGraph.create({
    required bool uniqueEdges,
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => uniqueEdges
      ? UndirectedMultiSetGraph.create(
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        )
      : UndirectedMultiListGraph.create(
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        );

  UndirectedMultiGraph({
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

class UndirectedMultiListGraph<V, E> extends UndirectedMultiGraph<V, E> {
  factory UndirectedMultiListGraph.create({
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => UndirectedMultiListGraph<V, E>(
    vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
    edgeStrategy: edgeStrategy ?? StorageStrategy.defaultStrategy(),
  );

  UndirectedMultiListGraph({
    required super.vertexStrategy,
    required super.edgeStrategy,
  });
}

class UndirectedMultiSetGraph<V, E> extends UndirectedMultiGraph<V, E> {
  factory UndirectedMultiSetGraph.create({
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => UndirectedMultiSetGraph<V, E>(
    vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
    edgeStrategy: edgeStrategy ?? StorageStrategy.defaultStrategy(),
  );

  UndirectedMultiSetGraph({
    required super.vertexStrategy,
    required super.edgeStrategy,
  });
}
