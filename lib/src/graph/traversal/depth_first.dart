import 'package:collection/collection.dart';

import '../path.dart';
import '../traversal.dart';

class DepthFirstTraversal<V> extends Traversal<V> {
  DepthFirstTraversal({
    super.nextEdges,
    super.nextVertices,
    super.vertexStrategy,
  });

  @override
  Iterable<Path<V>> startAll(Iterable<V> vertices) sync* {
    final seen = vertexStrategy.createSet()..addAll(vertices);
    final stack =
        addAllReversed(<Path<V>>[], vertices.map((vertex) => Path<V>(vertex)));
    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      yield current;
      final following = nextEdges(current.tail)
          .where((edge) => seen.add(edge.target))
          .map((edge) => Path<V>(edge.target,
              parent: current, weight: current.weight + edge.weight));
      addAllReversed(stack, following);
    }
  }
}

List<T> addAllReversed<T>(List<T> target, Iterable<T> iterable) {
  final original = target.length;
  return target
    ..addAll(iterable)
    ..reverseRange(original, target.length);
}
