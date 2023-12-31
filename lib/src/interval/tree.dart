import 'package:collection/collection.dart' show QueueList;

import '../functional/scope.dart';
import 'interval.dart';

class IntervalTreeNode<K extends Comparable<K>, N> {
  IntervalTreeNode(this.median, this.left, this.center, this.right);

  final K median;
  final IntervalTreeNode<K, N>? left;
  final List<N> center;
  final IntervalTreeNode<K, N>? right;
}

IntervalTreeNode<K, N>? createTreeNode<K extends Comparable<K>, N>(
    Iterable<N> nodes, Interval<K> Function(N node) getInterval) {
  if (nodes.isEmpty) return null;
  final endpoints = <K>[];
  for (final node in nodes) {
    final interval = getInterval(node);
    endpoints.add(interval.lower);
    endpoints.add(interval.upper);
  }
  endpoints.sort();
  final median = endpoints[endpoints.length ~/ 2];
  final left = <N>[], center = <N>[], right = <N>[];
  for (final node in nodes) {
    final interval = getInterval(node);
    if (interval.upper.compareTo(median) < 0) {
      left.add(node);
    } else if (median.compareTo(interval.lower) < 0) {
      right.add(node);
    } else {
      center.add(node);
    }
  }
  return IntervalTreeNode<K, N>(
    median,
    createTreeNode(left, getInterval),
    center,
    createTreeNode(right, getInterval),
  );
}

Iterable<N> queryPoint<K extends Comparable<K>, N>(
    IntervalTreeNode<K, N>? node, K value) sync* {
  while (node != null) {
    yield* node.center;
    final comparison = value.compareTo(node.median);
    node = comparison < 0
        ? node.left
        : comparison > 0
            ? node.right
            : null;
  }
}

Iterable<N> queryInterval<K extends Comparable<K>, N>(
    IntervalTreeNode<K, N>? node, Interval<K> interval) sync* {
  if (node == null) return;
  final nodes = QueueList<IntervalTreeNode<K, N>>()..add(node);
  while (nodes.isNotEmpty) {
    final node = nodes.removeFirst();
    yield* node.center;
    if (interval.upper.compareTo(node.median) < 0) {
      node.left?.also(nodes.add);
    }
    if (node.median.compareTo(interval.lower) < 0) {
      node.right?.also(nodes.add);
    }
  }
}
