import '../../../../functional.dart';
import '../../errors.dart';
import '../../path.dart';
import '../../strategy.dart';
import '../../traverse/breadth_first.dart';
import 'utils.dart';

/// Bellman-Ford shortest path algorithm.
///
/// Handles graphs with negative edge weights.
///
/// See https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm.
Iterable<Path<V, num>> bellmanFordSearch<V>({
  required Iterable<V> startVertices,
  required bool Function(V vertex) targetPredicate,
  required Iterable<V> Function(V vertex) successorsOf,
  num Function(V source, V target)? edgeCost,
  bool includeAlternativePaths = false,
  StorageStrategy<V>? vertexStrategy,
}) sync* {
  edgeCost = edgeCost ?? constantFunction2(1);
  vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  // Step 1: Initialize state.
  final states = vertexStrategy.createMap<BellmanFordState<V>>();
  final vertices = BreadthFirstIterable<V>(
    startVertices,
    successorsOf: successorsOf,
    vertexStrategy: vertexStrategy,
  );
  for (final vertex in vertices) {
    states[vertex] = BellmanFordState<V>(vertex: vertex);
  }
  for (final vertex in startVertices) {
    final state = states[vertex]!;
    state.value = state.total = 0;
  }

  // Step 2: Relax edges repeatedly.
  for (var i = 0; i < states.length - 1; i++) {
    for (final sourceState in states.values) {
      for (final target in successorsOf(sourceState.vertex)) {
        final value = edgeCost(sourceState.vertex, target);
        final total = sourceState.total + value;
        final targetState = states[target]!;
        if (total < targetState.total) {
          targetState.value = value;
          targetState.total = total;
          targetState.predecessors.clear();
          targetState.predecessors.add(sourceState);
        } else if (total == targetState.total &&
            !targetState.predecessors.contains(sourceState)) {
          targetState.predecessors.add(sourceState);
        }
      }
    }
  }

  // Step 3: Check for negative cycles.
  for (final sourceState in states.values) {
    for (final target in successorsOf(sourceState.vertex)) {
      final value = edgeCost(sourceState.vertex, target);
      final total = sourceState.total + value;
      final targetState = states[target]!;
      if (total < targetState.total) {
        throw GraphError(
          sourceState.vertex,
          'vertex',
          'Graph contains a negative-weight cycle',
        );
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

final class BellmanFordState<V> extends SearchState<V, num> {
  BellmanFordState({required super.vertex});

  @override
  num value = double.infinity;

  num total = double.infinity;

  @override
  final List<BellmanFordState<V>> predecessors = [];
}
