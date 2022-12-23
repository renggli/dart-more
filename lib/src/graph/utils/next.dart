import 'package:meta/meta.dart';

/// A function type returning the outgoing edges.
typedef NextEdges<V> = Iterable<NextEdge<V>> Function(V vertex);

/// A function type returning the connected vertexes.
typedef NextVertices<V> = Iterable<V> Function(V vertex);

/// A data class holding the data of an outgoing edge.
@immutable
class NextEdge<V> {
  const NextEdge(this.target, {this.weight = 1});

  /// The target vertex this edge is pointing to.
  final V target;

  /// The weight of this edge.
  final num weight;
}

/// Internal creator of [NextEdges] functions.
NextEdges<V> createNextEdges<V>({
  NextEdges<V>? nextEdges,
  NextVertices<V>? nextVertices,
}) {
  assert((nextEdges == null) ^ (nextVertices == null),
      'Either `nextEdges` or `nextVertices` has to be provided.');
  if (nextEdges != null) {
    return nextEdges;
  } else if (nextVertices != null) {
    return (source) =>
        nextVertices(source).map((target) => NextEdge<V>(target));
  } else {
    return (source) => <NextEdge<V>>[];
  }
}
