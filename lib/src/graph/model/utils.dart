import '../graph.dart';

Graph<V, E> copyEmpty<V, E>(Graph<V, E> other) => other.isDirected
    ? Graph<V, E>.directed(vertexStrategy: other.vertexStrategy)
    : Graph<V, E>.undirected(vertexStrategy: other.vertexStrategy);
