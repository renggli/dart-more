import 'package:collection/collection.dart' show QueueList;

import '../functional/scope.dart';
import 'interval.dart';

/// Immutable [IntervalTreeNode] that can hold arbitrary elements of type [N]
/// with [Interval] of type [K]. Built in _O(n*log(n))_ and searched in
/// _O(log(n))_.
///
/// This implementation is loosely based on the slide-deck of
/// https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/intervaltrees.pdf.
class IntervalTreeNode<K extends Comparable<K>, N> {
  /// Creates an [IntervalTreeNode] from an iterable of [intervals]. Returns `null`
  /// if [intervals] is empty.
  static IntervalTreeNode<K, Interval<K>>?
      fromIntervals<K extends Comparable<K>>(Iterable<Interval<K>> intervals) =>
          fromNodes<K, Interval<K>>(intervals, (interval) => interval);

  /// Creates an [IntervalTreeNode] form a list of [nodes] and a function
  /// [getInterval] that returns the associated interval.
  static IntervalTreeNode<K, N>? fromNodes<K extends Comparable<K>, N>(
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
    return IntervalTreeNode<K, N>._(median, center,
        fromNodes(left, getInterval), fromNodes(right, getInterval));
  }

  /// Internal constructor of an [IntervalTreeNode].
  IntervalTreeNode._(this._median, this._center, this._left, this._right);

  /// The median point of this node.
  final K _median;

  /// All nodes that contain the median point are in this list.
  final List<N> _center;

  /// All nodes that are smaller than the median point are in this node.
  final IntervalTreeNode<K, N>? _left;

  /// All nodes that are larger than the median point are in this node.
  final IntervalTreeNode<K, N>? _right;

  /// Returns an [Iterable] of all nodes in this tree.
  Iterable<N> get iterable sync* {
    final nodes = QueueList<IntervalTreeNode<K, N>>()..add(this);
    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      yield* node._center;
      node._left?.also(nodes.add);
      node._right?.also(nodes.add);
    }
  }

  /// Returns an [Iterable] of all nodes with intervals that possibly intersect
  /// with [value]. This likely includes false-positives, make sure to always
  /// check the resulting iterable for the exact desired condition.
  Iterable<N> queryPoint(K value) sync* {
    IntervalTreeNode<K, N>? node = this;
    while (node != null) {
      yield* node._center;
      final comparison = value.compareTo(node._median);
      node = comparison < 0
          ? node._left
          : comparison > 0
              ? node._right
              : null;
    }
  }

  /// Returns an [Iterable] of all nodes with intervals that possibly intersect
  /// with [interval]. This likely includes false-positives, make sure to always
  /// check the resulting iterable for the exact desired condition.
  Iterable<N> queryInterval(Interval<K> interval) sync* {
    final nodes = QueueList<IntervalTreeNode<K, N>>()..add(this);
    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      yield* node._center;
      if (interval.lower.compareTo(node._median) < 0 ||
          interval.upper.compareTo(node._median) < 0) {
        node._left?.also(nodes.add);
      }
      if (node._median.compareTo(interval.lower) < 0 ||
          node._median.compareTo(interval.upper) < 0) {
        node._right?.also(nodes.add);
      }
    }
  }
}
