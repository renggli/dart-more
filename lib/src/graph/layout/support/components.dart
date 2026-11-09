import '../../traverse/breadth_first.dart';
import '../graph_layout.dart';

/// Returns the connected components of [input], ignoring edge directions.
List<List<V>> components<V>(LayoutInput<V> input) {
  final visited = input.vertexStrategy?.createSet() ?? <V>{};
  final result = <List<V>>[];
  for (final start in input.vertices) {
    if (!visited.contains(start)) {
      final component = BreadthFirstIterable<V>(
        [start],
        successorsOf: input.neighboursOf,
        vertexStrategy: input.vertexStrategy,
      ).toList();
      visited.addAll(component);
      result.add(component);
    }
  }
  return result;
}
