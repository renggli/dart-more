import 'package:collection/collection.dart';

import '../../functional/types/constant.dart';
import '../errors.dart';
import '../strategy.dart';

/// Stoer–Wagner minimum cut algorithm in _O(V*E + V^2*log(V))_.
///
/// See https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm.
({Set<V> first, Set<V> second, num weight}) stoerWagnerMinCut<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  num Function(V source, V target)? edgeWeight,
  StorageStrategy<V>? vertexStrategy,
}) {
  final strategy = vertexStrategy ?? StorageStrategy.defaultStrategy();
  final weightOf = edgeWeight ?? constantFunction2(1);
  final vertexMap = strategy.createMap<Set<V>>();
  final vertexList = <V>[];
  final adj = Map<Set<V>, Map<Set<V>, num>>.identity();
  for (final vertex in vertices) {
    if (!vertexMap.containsKey(vertex)) {
      final set = strategy.createSet()..add(vertex);
      vertexMap[vertex] = set;
      vertexList.add(vertex);
      adj[set] = Map<Set<V>, num>.identity();
    }
  }
  if (vertexList.length < 2) {
    throw GraphError(
      vertices,
      'vertices',
      'Graph must have at least 2 vertices',
    );
  }
  final seenEdges = strategy.createMap<Set<V>>();
  for (final source in vertexList) {
    final sourceSet = vertexMap[source]!;
    for (final target in neighboursOf(source)) {
      if (strategy.equals(source, target)) continue;
      final targetSet = vertexMap[target];
      if (targetSet == null) continue;
      if (seenEdges[target]?.contains(source) ?? false) continue;
      if (!seenEdges.putIfAbsent(source, strategy.createSet).add(target)) {
        continue;
      }
      final weight = weightOf(source, target);
      GraphError.checkPositiveEdgeValue(source, target, weight);
      adj[sourceSet]![targetSet] = weight;
      adj[targetSet]![sourceSet] = weight;
    }
  }
  var bestPartition = strategy.createSet();
  num bestWeight = double.infinity;
  final seed = adj.keys.first;
  while (adj.length > 1) {
    final queue = PriorityQueue<_State<V>>(_stateCompare);
    final states = Map<Set<V>, _State<V>>.identity();
    var current = seed, previous = strategy.createSet();
    final seedAdj = adj[seed]!;
    for (final vertex in adj.keys) {
      if (identical(vertex, seed)) continue;
      final weight = seedAdj[vertex];
      final state = _State<V>(
        vertex: vertex,
        weight: weight ?? 0,
        active: weight != null,
      );
      states[vertex] = state;
      queue.add(state);
    }
    while (queue.isNotEmpty) {
      final sourceState = queue.removeFirst();
      if (sourceState.isObsolete) continue;
      final source = sourceState.vertex;
      states.remove(source);
      previous = current;
      current = source;
      for (final entry in adj[source]!.entries) {
        final state = states[entry.key];
        if (state != null) {
          state.isObsolete = true;
          final newState = _State<V>(
            vertex: state.vertex,
            weight: state.weight + entry.value,
            active: true,
          );
          states[entry.key] = newState;
          queue.add(newState);
        }
      }
    }
    final weight = adj[current]!.values.sum;
    if (weight < bestWeight) {
      bestPartition = current;
      bestWeight = weight;
    }
    final merged = strategy.createSet()
      ..addAll(previous)
      ..addAll(current);
    final mergedAdj = Map<Set<V>, num>.identity();
    adj[merged] = mergedAdj;
    final prevAdj = adj.remove(previous)!;
    final currAdj = adj.remove(current)!;
    for (final vertex in adj.keys) {
      if (identical(vertex, merged)) continue;
      final vAdj = adj[vertex]!;
      final sourceWeight = prevAdj[vertex];
      final targetWeight = currAdj[vertex];
      vAdj.remove(previous);
      vAdj.remove(current);
      if (sourceWeight != null || targetWeight != null) {
        final mergedWeight = (sourceWeight ?? 0) + (targetWeight ?? 0);
        mergedAdj[vertex] = mergedWeight;
        vAdj[merged] = mergedWeight;
      }
    }
  }
  final second = strategy.createSet()
    ..addAll(vertexList)
    ..removeAll(bestPartition);
  return (first: bestPartition, second: second, weight: bestWeight);
}

final class _State<V> {
  new({required this.vertex, required this.weight, required this.active});

  final Set<V> vertex;
  final num weight;
  final bool active;
  bool isObsolete = false;
}

int _stateCompare<V>(_State<V> a, _State<V> b) {
  if (a.active && b.active) return -a.weight.compareTo(b.weight);
  if (a.active && !b.active) return -1;
  if (!a.active && b.active) return 1;
  return 0;
}
