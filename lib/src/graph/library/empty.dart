import '../graph.dart';
import '../library.dart';

extension EmptyGraphLibraryExtension<V, E> on GraphLibrary<V, E> {
  /// Creates an empty graph.
  Graph<V, E> empty() => newBuilder().build();
}
