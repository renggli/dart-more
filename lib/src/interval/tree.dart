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
  static IntervalTree<K, Interval<K>> fromIntervals<K extends Comparable<K>>([
    Iterable<Interval<K>> intervals = const [],
  ]) => fromValues<K, Interval<K>>(intervals, _identityGetter<K>);

  /// Creates an [IntervalTree] from an [Iterable] of [values] and a [getter]
  /// function that returns the associated [Interval].
  static IntervalTree<K, V> fromValues<K extends Comparable<K>, V>(
    Iterable<V> values,
    Interval<K> Function(V value) getter,
  ) {
    final entries = <_IntervalEntry<K, V>>[];
    for (final value in values) {
      entries.add(_IntervalEntry<K, V>(getter(value), value));
    }
    return IntervalTree<K, V>._(
      _IntervalTreeNode.fromEntries(entries),
      getter,
      entries.length,
    );
  }

  /// Internal constructor of the [IntervalTree].
  const new _(this._root, this.getter, this.length);

  /// The root node of this tree, or `null` if empty.
  final _IntervalTreeNode<K, V>? _root;

  /// The getter to access the intervals of the values.
  final Interval<K> Function(V value) getter;

  @override
  final int length;

  @override
  bool get isEmpty => length == 0;

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
  new(_IntervalTreeNode<K, V>? node) {
    if (node != null) _nodes.add(node);
  }

  final _nodes = <_IntervalTreeNode<K, V>>[];
  List<V>? _currentValues;
  int _currentIndex = 0;

  @override
  late V current;

  @override
  bool moveNext() {
    while (true) {
      final values = _currentValues;
      if (values != null) {
        if (_currentIndex < values.length) {
          current = values[_currentIndex++];
          return true;
        }
        _currentValues = null;
      }
      if (_nodes.isEmpty) return false;
      final node = _nodes.removeLast();
      if (node._leftNode != null) _nodes.add(node._leftNode);
      if (node._rightNode != null) _nodes.add(node._rightNode);
      _currentValues = node._leftValues;
      _currentIndex = 0;
    }
  }
}

final class _IntervalEntry<K extends Comparable<K>, V> {
  const new(this.interval, this.value);

  final Interval<K> interval;
  final V value;
}

@immutable
final class _IntervalTreeNode<K extends Comparable<K>, V> {
  static _IntervalTreeNode<K, V>? fromEntries<K extends Comparable<K>, V>(
    List<_IntervalEntry<K, V>> entries,
  ) {
    if (entries.isEmpty) return null;
    final endpoints = <K>[];
    for (final entry in entries) {
      endpoints.add(entry.interval.lower);
      endpoints.add(entry.interval.upper);
    }
    endpoints.sort();
    final median = endpoints[endpoints.length ~/ 2];
    final leftNode = <_IntervalEntry<K, V>>[];
    final leftValues = <_IntervalEntry<K, V>>[];
    final rightValues = <_IntervalEntry<K, V>>[];
    final rightNode = <_IntervalEntry<K, V>>[];
    for (final entry in entries) {
      final interval = entry.interval;
      if (interval.upper.compareTo(median) < 0) {
        leftNode.add(entry);
      } else if (median.compareTo(interval.lower) < 0) {
        rightNode.add(entry);
      } else {
        leftValues.add(entry);
        rightValues.add(entry);
      }
    }
    leftValues.sort((a, b) => a.interval.lower.compareTo(b.interval.lower));
    rightValues.sort((a, b) => b.interval.upper.compareTo(a.interval.upper));
    return _IntervalTreeNode<K, V>(
      fromEntries(leftNode),
      leftValues.map((e) => e.value).toList(growable: false),
      median,
      rightValues.map((e) => e.value).toList(growable: false),
      fromEntries(rightNode),
    );
  }

  const new(
    this._leftNode,
    this._leftValues,
    this._median,
    this._rightValues,
    this._rightNode,
  );

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
