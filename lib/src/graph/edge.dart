/// Abstract definition of an edge.
abstract class Edge<V, E> {
  const Edge();

  /// Origin vertex of this edge.
  V get source;

  /// Destination vertex of this edge.
  V get target;

  /// Edge specific data
  E get data;

  /// Nullable edge specific data.
  E? get dataOrNull;

  @override
  String toString() => 'Edge{source: $source, target: $target'
      '${dataOrNull != null ? ', data: $data' : ''}}';
}
