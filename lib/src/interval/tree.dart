import 'package:meta/meta.dart';

import 'interval.dart';

/// Immutable [IntervalTree] that can hold arbitrary elements of type [V] with
/// [Interval]s of type [K]. The data structure is built in _O(n*log(n))_ and
/// can be queried in _O(log(n))_.
///
/// The implementation is loosely based on the slide-deck of
/// https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/intervaltrees.pdf.
@immutable
class IntervalTree<K extends Comparable<K>, V> with Iterable<V> {
  /// Creates an [IntervalTree] from an [Iterable] of [intervals].
  static IntervalTree<K, Interval<K>> fromIntervals<K extends Comparable<K>>(
          [Iterable<Interval<K>> intervals = const []]) =>
      fromValues<K, Interval<K>>(intervals, _identityGetter<K>);

  /// Creates an [IntervalTree] form an [Iterable] of [values] and a [getter]
  /// function that returns the associated [Interval].
  static IntervalTree<K, V> fromValues<K extends Comparable<K>, V>(
          Iterable<V> values, Interval<K> Function(V value) getter) =>
      IntervalTree<K, V>._(
          _IntervalTreeNode.fromValues(values, getter), getter);

  /// Internal constructor of the [IntervalTree].
  const IntervalTree._(this._root, this.getter);

  /// The root node of this tree, or `null` if empty.
  final _IntervalTreeNode<K, V>? _root;

  /// The getter to access the intervals of the values.
  final Interval<K> Function(V value) getter;

  @override
  bool get isEmpty => _root == null;

  @override
  Iterator<V> get iterator => _IntervalTreeIterator(_root);

  /// An [Iterable] over all values whose [Interval] contains [value].
  Iterable<V> queryPoint(K value) sync* {
    var node = _root;
    while (node != null) {
      final comparison = value.compareTo(node._median);
      if (comparison < 0) {
        for (final leftValue in node._leftValues) {
          final interval = getter(leftValue);
          if (value.compareTo(interval.lower) < 0) break;
          yield leftValue;
        }
        node = node._leftNode;
      } else {
        for (final rightValue in node._rightValues) {
          final interval = getter(rightValue);
          if (interval.upper.compareTo(value) < 0) break;
          yield rightValue;
        }
        node = node._rightNode;
      }
      if (comparison == 0) break;
    }
  }

  /// An [Iterable] over all values whose [Interval] intersects with [interval].
  Iterable<V> queryInterval(Interval<K> interval) sync* {
    if (_root == null) return;
    final nodes = <_IntervalTreeNode<K, V>>[_root];
    while (nodes.isNotEmpty) {
      final node = nodes.removeLast();
      if (interval.upper.compareTo(node._median) < 0) {
        for (final leftValue in node._leftValues) {
          final valueInterval = getter(leftValue);
          if (interval.upper.compareTo(valueInterval.lower) < 0) break;
          yield leftValue;
        }
        if (node._leftNode != null) nodes.add(node._leftNode);
      } else if (interval.lower.compareTo(node._median) > 0) {
        for (final rightValue in node._rightValues) {
          final valueInterval = getter(rightValue);
          if (interval.lower.compareTo(valueInterval.upper) > 0) break;
          yield rightValue;
        }
        if (node._rightNode != null) nodes.add(node._rightNode);
      } else {
        yield* node._leftValues;
        if (node._leftNode != null) nodes.add(node._leftNode);
        if (node._rightNode != null) nodes.add(node._rightNode);
      }
    }
  }
}

final class _IntervalTreeIterator<K extends Comparable<K>, V>
    implements Iterator<V> {
  _IntervalTreeIterator(_IntervalTreeNode<K, V>? node) {
    if (node != null) _nodes.add(node);
  }

  final _nodes = <_IntervalTreeNode<K, V>>[];
  final _values = <V>[];

  @override
  late V current;

  @override
  bool moveNext() {
    if (_values.isNotEmpty) {
      current = _values.removeLast();
      return true;
    }
    if (_nodes.isNotEmpty) {
      final node = _nodes.removeLast();
      if (node._leftNode != null) _nodes.add(node._leftNode);
      if (node._rightNode != null) _nodes.add(node._rightNode);
      _values.addAll(node._leftValues);
      current = _values.removeLast();
      return true;
    }
    return false;
  }
}

@immutable
final class _IntervalTreeNode<K extends Comparable<K>, V> {
  static _IntervalTreeNode<K, V>? fromValues<K extends Comparable<K>, V>(
      Iterable<V> values, Interval<K> Function(V value) getter) {
    if (values.isEmpty) return null;
    final endpoints = <K>[];
    for (final value in values) {
      final interval = getter(value);
      endpoints.add(interval.lower);
      endpoints.add(interval.upper);
    }
    endpoints.sort();
    final median = endpoints[endpoints.length ~/ 2];
    final leftNode = <V>[], leftValues = <V>[];
    final rightValues = <V>[], rightNode = <V>[];
    for (final value in values) {
      final interval = getter(value);
      if (interval.upper.compareTo(median) < 0) {
        leftNode.add(value);
      } else if (median.compareTo(interval.lower) < 0) {
        rightNode.add(value);
      } else {
        leftValues.add(value);
        rightValues.add(value);
      }
    }
    leftValues.sort((a, b) => getter(a).lower.compareTo(getter(b).lower));
    rightValues.sort((a, b) => getter(b).upper.compareTo(getter(a).upper));
    return _IntervalTreeNode<K, V>(fromValues(leftNode, getter), leftValues,
        median, rightValues, fromValues(rightNode, getter));
  }

  const _IntervalTreeNode(this._leftNode, this._leftValues, this._median,
      this._rightValues, this._rightNode);

  /// All nodes smaller than the median point, or `null`.
  final _IntervalTreeNode<K, V>? _leftNode;

  /// All values containing the median point in increasing order by lower bound.
  final List<V> _leftValues;

  /// The median point.
  final K _median;

  /// All values containing the median point in decreasing order by upper bound.
  final List<V> _rightValues;

  /// All nodes larger than the median point, or `null`.
  final _IntervalTreeNode<K, V>? _rightNode;
}

Interval<K> _identityGetter<K extends Comparable<K>>(Interval<K> interval) =>
    interval;
