import '../builder.dart';
import '../graph.dart';

extension EmptyGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates an empty graph.
  Graph<V, E> empty() => isDirected
      ? Graph<V, E>.directed(vertexStrategy: vertexStrategy)
      : Graph<V, E>.undirected(vertexStrategy: vertexStrategy);
}
