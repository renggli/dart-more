import '../builder.dart';
import '../graph.dart';

extension EmptyGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates an empty graph.
  Graph<V, E> empty() => newFactory().build();
}
