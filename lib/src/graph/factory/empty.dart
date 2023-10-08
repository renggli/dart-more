import '../factory.dart';
import '../graph.dart';

extension EmptyGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates an empty graph.
  Graph<V, E> empty() => newBuilder().build();
}
