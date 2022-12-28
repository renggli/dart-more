import '../path.dart';

class DefaultPath<V> extends Path<V> {
  DefaultPath(this.vertices, this.cost);

  @override
  final List<V> vertices;

  @override
  final num cost;
}
