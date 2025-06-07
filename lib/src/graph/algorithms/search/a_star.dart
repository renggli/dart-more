import 'package:collection/collection.dart';

import '../../../../functional.dart';
import '../../path.dart';
import '../../strategy.dart';
import 'utils.dart';

/// A-Star search algorithm.
///
/// See https://en.wikipedia.org/wiki/A*_search_algorithm.
Iterable<Path<V, num>> aStarSearch<V>({
  required Iterable<V> startVertices,
  required bool Function(V vertex) targetPredicate,
  required Iterable<V> Function(V vertex) successorsOf,
  required num Function(V source) costEstimate,
  num Function(V source, V target)? edgeCost,
  bool includeAlternativePaths = false,
  StorageStrategy<V>? vertexStrategy,
}) sync* {
  edgeCost = edgeCost ?? constantFunction2(1);
  vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final states = vertexStrategy.createMap<AStarState<V>>();
  final queue = PriorityQueue<AStarState<V>>(stateCompare);
  for (final vertex in startVertices) {
    final state = AStarState<V>(vertex: vertex, estimate: costEstimate(vertex));
    states[vertex] = state;
    queue.add(state);
  }

  while (queue.isNotEmpty) {
    final sourceState = queue.removeFirst();
    if (sourceState.isObsolete) continue;
    for (final target in successorsOf(sourceState.vertex)) {
      final value = edgeCost(sourceState.vertex, target);
      assert(
        value >= 0,
        'Expected positive edge weight between '
        '${sourceState.vertex} and $target',
      );
      final total = sourceState.total + value;
      final targetState = states[target];
      if (targetState == null || total < targetState.total) {
        targetState?.isObsolete = true;
        final estimate = total + costEstimate(target);
        final state = AStarState<V>(
          vertex: target,
          value: value,
          total: total,
          estimate: estimate,
        );
        state.predecessors.add(sourceState);
        states[target] = state;
        queue.add(state);
      } else if (total == targetState.total) {
        targetState.predecessors.add(sourceState);
      }
    }
    if (targetPredicate(sourceState.vertex)) {
      if (includeAlternativePaths) {
        yield* createAllShortestPaths(sourceState);
      } else {
        yield createShortestPath(sourceState);
      }
    }
  }
}

final class AStarState<V> extends SearchState<V, num> {
  AStarState({
    required super.vertex,
    required this.estimate,
    this.value = 0,
    this.total = 0,
  });

  @override
  final num value;

  @override
  final List<AStarState<V>> predecessors = [];

  final num total;
  final num estimate;
  bool isObsolete = false;
}

int stateCompare<V>(AStarState<V> a, AStarState<V> b) =>
    a.estimate.compareTo(b.estimate);
