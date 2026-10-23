import 'package:checks/checks.dart';
import 'package:more/src/graph/algorithms/search/utils.dart';
import 'package:test/scaffolding.dart';

class _CustomSearchState<V, E> extends SearchState<V, E> {
  new(this.vertex);

  @override
  final V vertex;

  @override
  final List<(SearchState<V, E> state, E value)> predecessors = [];
}

void main() {
  group('SearchState', () {
    test('subclass constructor and properties', () {
      final state = _CustomSearchState<String, int>('a');
      check(state.vertex).equals('a');
      check(state.predecessors).isEmpty();
    });
    test('createShortestPath with custom state', () {
      final s1 = _CustomSearchState<String, int>('start');
      final s2 = _CustomSearchState<String, int>('end');
      s2.predecessors.add((s1, 10));
      final path = createShortestPath<String, int>(s2);
      check(path.vertices).deepEquals(['start', 'end']);
      check(path.values).deepEquals([10]);
    });
  });
}
