import 'graph.dart';

/// Error thrown when encountering unexpected graph types.
class GraphError extends ArgumentError {
  /// Asserts that the [graph] is directed.
  static void checkDirected<V, E>(Graph<V, E> graph, [String? name]) {
    if (!graph.isDirected) {
      throw GraphError(graph, name, 'Graph must be directed');
    }
  }

  /// Asserts that the [graph] is not directed.
  static void checkNotDirected<V, E>(Graph<V, E> graph, [String? name]) {
    if (graph.isDirected) {
      throw GraphError(graph, name, 'Graph must not be directed');
    }
  }

  /// Assert that the edge [value] between [source] and [target] vertex is
  /// positive.
  static void checkPositiveEdgeValue<V, E extends num>(
    V source,
    V target,
    E value,
  ) {
    if (value < 0) {
      throw GraphError(
        null,
        null,
        'Expected a positive edge value between $source and $target, '
        'but got $value',
      );
    }
  }

  /// Asserts that the [graph] has at least at least [count] vertices.
  static void checkVertexCount<V, E>(
    Graph<V, E> graph,
    int count, [
    String? name,
  ]) {
    if (graph.vertices.length < count) {
      throw GraphError(graph, name, 'Graph must have at least $count vertices');
    }
  }

  /// Constructs a generic [GraphError].
  GraphError(super.value, [super.name, super.message]) : super.value();
}
