import 'edge.dart';

abstract class Path<V, E> {
  V get source;

  V get target;

  Iterable<V> get vertices;

  Iterable<Edge<V, E>> get edges;
}
