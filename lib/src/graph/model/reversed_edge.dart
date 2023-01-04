import '../edge.dart';

extension ReversedEdgeExtension<V, E> on Edge<V, E> {
  /// Returns a edge where the endpoints are swapped.
  Edge<V, E> get reversed {
    final self = this;
    return self is ReversedEdge<V, E>
        ? self.delegate
        : ReversedEdge<V, E>(self);
  }
}

class ReversedEdge<V, E> extends Edge<V, E> {
  const ReversedEdge(this.delegate);

  final Edge<V, E> delegate;

  @override
  V get source => delegate.target;

  @override
  V get target => delegate.source;

  @override
  E get data => delegate.data;
}
