import 'dart:collection';
import 'dart:math';

import '../../../tuple.dart';
import '../graph.dart';
import '../strategy.dart';

extension RandomWalkGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a random order.
  Iterable<V> randomWalk(V vertex,
          {num Function(V source, V target)? edgeProbability,
          bool selfAvoiding = false,
          Random? random,
          StorageStrategy<V>? vertexStrategy}) =>
      RandomWalkIterable(vertex,
          successorsOf: successorsOf,
          edgeProbability: edgeProbability,
          selfAvoiding: selfAvoiding,
          vertexStrategy: vertexStrategy);
}

/// Iterable producing a random walk over a graph.
///
/// - If [selfAvoiding] is set to `true`, a vertex will be visited at most
///   once.
/// - If [edgeProbability] is provided, probabilities of picking an edge will
///   be weighted.
///
/// If there are no eligible successors the iterator terminates, however with
/// some graphs and call configurations the iterator is infinite.
///
/// See https://en.wikipedia.org/wiki/Random_walk.
class RandomWalkIterable<V> extends IterableBase<V> {
  RandomWalkIterable(this.vertex,
      {required this.successorsOf,
      this.edgeProbability,
      this.selfAvoiding = false,
      Random? random,
      StorageStrategy<V>? vertexStrategy})
      : vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy(),
        random = random ?? Random();

  final V vertex;
  final Iterable<V> Function(V vertex) successorsOf;
  final num Function(V source, V target)? edgeProbability;
  final bool selfAvoiding;
  final Random random;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<V> get iterator => _RandomWalkIterator<V>(this);
}

class _RandomWalkIterator<V> implements Iterator<V> {
  _RandomWalkIterator(this.iterable)
      : seen = iterable.vertexStrategy.createSet(),
        next = iterable.vertex {
    if (iterable.selfAvoiding) {
      seen.add(iterable.vertex);
    }
  }

  final RandomWalkIterable<V> iterable;
  final Set<V> seen;
  V? next;

  @override
  late V current;

  @override
  bool moveNext() {
    if (next == null) {
      return false;
    }
    current = next as V;
    final candidates = _candidatesAndProbabilities(current);
    if (candidates.isEmpty) {
      next = null;
    } else if (candidates.length == 1) {
      next = candidates.first.first;
    } else {
      final value = iterable.random.nextDouble();
      num sum = 0;
      for (final candidate in candidates) {
        sum += candidate.second;
        if (sum >= value) {
          next = candidate.first;
          break;
        }
      }
    }
    return true;
  }

  Iterable<(V, num)> _candidatesAndProbabilities(V source) {
    num probabilitySum = 0;
    final candidates = <(V, num)>[];
    for (final target in iterable.successorsOf(source)) {
      if (iterable.selfAvoiding && seen.add(target) == false) {
        continue;
      }
      final probability = iterable.edgeProbability?.call(source, target) ?? 1;
      if (probability > 0) {
        candidates.add((target, probability));
        probabilitySum += probability;
      }
    }
    if (probabilitySum > 0) {
      return candidates
          .map((tuple) => tuple.withSecond(tuple.second / probabilitySum))
          .toList();
    }
    return candidates;
  }
}
