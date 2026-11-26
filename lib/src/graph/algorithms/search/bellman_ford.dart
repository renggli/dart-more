import '../../../functional/types/constant.dart';
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
  final startList = startVertices.toList(growable: false);
  final states = vertexStrategy.createMap<BellmanFordState<V>>();
  final vertices = BreadthFirstIterable<V>(
    startList,
    successorsOf: successorsOf,
    vertexStrategy: vertexStrategy,
  );
  for (final vertex in vertices) {
    states[vertex] = BellmanFordState<V>(vertex: vertex);
  }
  for (final vertex in startList) {
    final state = states[vertex]!;
    state.total = 0;
  }

  // Step 2: Relax edges repeatedly.
  for (var i = 0; i < states.length - 1; i++) {
    var relaxed = false;
    for (final sourceState in states.values) {
      if (sourceState.total.isInfinite) continue;
      for (final target in successorsOf(sourceState.vertex)) {
        final value = edgeCost(sourceState.vertex, target);
        if (value.isNaN) {
          throw GraphError(value, 'edgeCost', 'Negative or invalid edge cost');
        }
        final total = sourceState.total + value;
        final targetState = states[target]!;
        if (total < targetState.total) {
          targetState.total = total;
          targetState.predecessors.clear();
          targetState.predecessors.add((sourceState, value));
          relaxed = true;
        } else if (total == targetState.total &&
            !targetState.predecessors.any((p) => p.$1 == sourceState)) {
          targetState.predecessors.add((sourceState, value));
        }
      }
    }
    if (!relaxed) break;
  }

  // Step 3: Check for negative cycles.
  for (final sourceState in states.values) {
    if (sourceState.total.isInfinite) continue;
    for (final target in successorsOf(sourceState.vertex)) {
      final value = edgeCost(sourceState.vertex, target);
      if (value.isNaN) {
        throw GraphError(value, 'edgeCost', 'Negative or invalid edge cost');
      }
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
  }

  // Step 4: Emit paths.
  for (final sourceState in states.values) {
    if (targetPredicate(sourceState.vertex)) {
      if (includeAlternativePaths) {
        yield* createAllShortestPaths(
          sourceState,
          startVertices: startList,
          vertexStrategy: vertexStrategy,
        );
      } else {
        yield createShortestPath(
          sourceState,
          startVertices: startList,
          vertexStrategy: vertexStrategy,
        );
      }
    }
  }
}

final class BellmanFordState<V> implements SearchState<V, num> {
  new({required this.vertex});

  @override
  final V vertex;

  num total = double.infinity;

  @override
  final List<(SearchState<V, num>, num)> predecessors = [];
}
