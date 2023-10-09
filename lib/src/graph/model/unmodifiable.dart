import '../graph.dart';
import 'forwarding.dart';

extension UnmodifiableGraphExtension<V, E> on Graph<V, E> {
  /// Returns a graph that throws an exception when being modified.
  Graph<V, E> get unmodifiable =>
      isUnmodifiable ? this : UnmodifiableGraph<V, E>(this);
}

class UnmodifiableGraph<V, E> extends ForwardingGraph<V, E> {
  UnmodifiableGraph(super.delegate);

  @override
  bool get isUnmodifiable => true;

  @override
  void addVertex(V vertex) => _throw();

  @override
  void addEdge(V source, V target, {E? value}) => _throw();

  @override
  void removeVertex(V vertex) => _throw();

  @override
  void removeEdge(V source, V target) => _throw();

  Never _throw() =>
      throw UnsupportedError('Cannot modify an unmodifiable graph');
}
