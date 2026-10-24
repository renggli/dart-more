import 'package:collection/collection.dart';

import '../../../functional/types/constant.dart';
import '../../errors.dart';
import '../../path.dart';
import '../../strategy.dart';
import 'utils.dart';

/// Dijkstra's search algorithm.
///
/// See https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm.
Iterable<Path<V, num>> dijkstraSearch<V>({
  required Iterable<V> startVertices,
  required bool Function(V vertex) targetPredicate,
  required Iterable<V> Function(V vertex) successorsOf,
  num Function(V source, V target)? edgeCost,
  bool includeAlternativePaths = false,
  StorageStrategy<V>? vertexStrategy,
}) sync* {
  edgeCost = edgeCost ?? constantFunction2(1);
  vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final states = vertexStrategy.createMap<DijkstraState<V>>();
  final queue = PriorityQueue<DijkstraState<V>>(stateCompare);
  for (final vertex in startVertices) {
    final state = DijkstraState<V>(vertex: vertex);
    states[vertex] = state;
    queue.add(state);
  }

  while (queue.isNotEmpty) {
    final sourceState = queue.removeFirst();
    if (sourceState.isObsolete) continue;
    for (final target in successorsOf(sourceState.vertex)) {
      final value = edgeCost(sourceState.vertex, target);
      GraphError.checkPositiveEdgeValue(sourceState.vertex, target, value);
      final total = sourceState.total + value;
      final targetState = states[target];
      if (targetState == null || total < targetState.total) {
        targetState?.isObsolete = true;
        final state = DijkstraState<V>(vertex: target, total: total);
        state.predecessors.add((sourceState, value));
        states[target] = state;
        queue.add(state);
      } else if (total == targetState.total) {
        targetState.predecessors.add((sourceState, value));
      }
    }
    if (targetPredicate(sourceState.vertex)) {
      if (includeAlternativePaths) {
        yield* createAllShortestPaths(
          sourceState,
          startVertices: startVertices,
        );
      } else {
        yield createShortestPath(sourceState, startVertices: startVertices);
      }
    }
  }
}

final class DijkstraState<V> implements SearchState<V, num> {
  new({required this.vertex, this.total = 0}) : super();

  @override
  final V vertex;

  @override
  final List<(SearchState<V, num>, num)> predecessors = [];

  final num total;
  bool isObsolete = false;
}

int stateCompare<V>(DijkstraState<V> a, DijkstraState<V> b) =>
    a.total.compareTo(b.total);
