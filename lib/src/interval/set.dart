import 'dart:collection' show SetBase;

import 'package:collection/collection.dart' show QueueList;

import '../functional/scope.dart';
import 'interval.dart';

/// A [IntervalSet] contains unique intervals.
///
/// For all parts this code behaves like a normal [Set] with elements of type
/// [Interval]. Additional helpers [containingPoint], [intersectingInterval],
/// and [enclosingInterval] provide ways to query point and interval conditions
/// efficiently.
///
/// The first time any such method is called an internal balanced tree with the
/// intervals is built in O(n*log(n)). Afterwards all such queries are answered
/// in O(log(n)) until the intervals get changed again.
class IntervalSet<E extends Comparable<E>>
    with SetBase<Interval<E>>
    implements Set<Interval<E>> {
  /// Creates an emtpy [IntervalSet].
  IntervalSet();

  /// Internal [Map] delegate.
  final Set<Interval<E>> _set = {};

  /// Internal root of the balanced interval tree.
  _IntervalNode<E>? _root;

  /// Returns an [Iterable] over all intervals in arbitrary order that contain
  /// a [value].
  Iterable<Interval<E>> containingPoint(E value) => _queryPoint(value);

  /// Returns an [Iterable] over all intervals in arbitrary order that overlap
  /// with [interval] in arbitrary order.
  Iterable<Interval<E>> intersectingInterval(Interval<E> interval) =>
      _queryInterval(interval).where((each) => each.intersects(interval));

  /// Returns an [Iterable] over all intervals in arbitrary order that are
  /// covering [interval] in arbitrary order.
  Iterable<Interval<E>> enclosingInterval(Interval<E> interval) =>
      _queryInterval(interval).where((each) => each.encloses(interval));

  @override
  int get length => _set.length;

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  bool get isNotEmpty => _set.isNotEmpty;

  @override
  Iterator<Interval<E>> get iterator => _set.iterator;

  @override
  bool contains(Object? element) => _set.contains(element);

  @override
  Interval<E>? lookup(Object? element) => _set.lookup(element);

  @override
  bool add(Interval<E> value) {
    final result = _set.add(value);
    if (result) _root = null;
    return result;
  }

  @override
  void addAll(Iterable<Interval<E>> elements) {
    var changed = false;
    for (final element in elements) {
      changed |= _set.add(element);
    }
    if (changed) _root = null;
  }

  @override
  void clear() {
    _set.clear();
    _root = null;
  }

  @override
  bool remove(Object? value) {
    final result = _set.remove(value);
    if (result) _root = null;
    return result;
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    var changed = false;
    for (final element in elements) {
      changed |= _set.remove(element);
    }
    if (changed) _root = null;
  }

  @override
  Set<Interval<E>> toSet() => _set.toSet();

  void _refresh() {
    if (isEmpty || _root != null) return;
    _root = _createNode(this);
  }

  Iterable<Interval<E>> _queryPoint(E value) sync* {
    _refresh();
    var node = _root;
    while (node != null) {
      for (final interval in node.intervals) {
        if (interval.contains(value)) {
          yield interval;
        }
      }
      final comparison = value.compareTo(node.median);
      node = comparison < 0
          ? node.left
          : comparison > 0
              ? node.right
              : null;
    }
  }

  Iterable<Interval<E>> _queryInterval(Interval<E> interval) sync* {
    _refresh();
    final nodes = QueueList<_IntervalNode<E>>();
    if (_root case final root?) nodes.add(root);
    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      yield* node.intervals;
      if (interval.upper.compareTo(node.median) < 0) {
        node.left?.also(nodes.add);
      }
      if (node.median.compareTo(interval.lower) < 0) {
        node.right?.also(nodes.add);
      }
    }
  }
}

class _IntervalNode<E extends Comparable<E>> {
  final E median;
  final _IntervalNode<E>? left;
  final List<Interval<E>> intervals;
  final _IntervalNode<E>? right;

  _IntervalNode(this.median, this.left, this.intervals, this.right);
}

_IntervalNode<E>? _createNode<E extends Comparable<E>>(
    Iterable<Interval<E>> intervals) {
  if (intervals.isEmpty) return null;
  final endpoints = <E>[];
  for (final interval in intervals) {
    endpoints.add(interval.lower);
    endpoints.add(interval.upper);
  }
  endpoints.sort();
  final median = endpoints[endpoints.length ~/ 2];
  final left = <Interval<E>>[];
  final center = <Interval<E>>[];
  final right = <Interval<E>>[];
  for (final interval in intervals) {
    if (interval.upper.compareTo(median) < 0) {
      left.add(interval);
    } else if (median.compareTo(interval.lower) < 0) {
      right.add(interval);
    } else {
      center.add(interval);
    }
  }
  return _IntervalNode<E>(
    median,
    _createNode(left),
    center,
    _createNode(right),
  );
}
