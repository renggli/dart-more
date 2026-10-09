import '../factory.dart';
import '../graph.dart';

/// Extension on [GraphFactory] to create an empty graph.
extension EmptyGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates an empty graph.
  Graph<V, E> empty() => newBuilder().build();
}
