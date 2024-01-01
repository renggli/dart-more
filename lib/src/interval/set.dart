import 'dart:collection' show SetBase;

import 'interval.dart';
import 'tree.dart';

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

  /// Internal root node of the balanced interval tree.
  IntervalTreeNode<E, Interval<E>>? _tree;

  /// Returns an [Iterable] over all intervals in arbitrary order that contain
  /// a [value].
  Iterable<Interval<E>> containingPoint(E value) {
    _refresh();
    return _tree?.queryPoint(value).where((each) => each.contains(value)) ??
        const [];
  }

  /// Returns an [Iterable] over all intervals in arbitrary order that overlap
  /// with [interval] in arbitrary order.
  Iterable<Interval<E>> intersectingInterval(Interval<E> interval) {
    _refresh();
    return _tree
            ?.queryInterval(interval)
            .where((each) => each.intersects(interval)) ??
        const [];
  }

  /// Returns an [Iterable] over all intervals in arbitrary order that are
  /// covering [interval] in arbitrary order.
  Iterable<Interval<E>> enclosingInterval(Interval<E> interval) {
    _refresh();
    return _tree
            ?.queryInterval(interval)
            .where((each) => each.encloses(interval)) ??
        const [];
  }

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
    if (result) _tree = null;
    return result;
  }

  @override
  void addAll(Iterable<Interval<E>> elements) {
    var changed = false;
    for (final element in elements) {
      changed |= _set.add(element);
    }
    if (changed) _tree = null;
  }

  @override
  void clear() {
    _set.clear();
    _tree = null;
  }

  @override
  bool remove(Object? value) {
    final result = _set.remove(value);
    if (result) _tree = null;
    return result;
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    var changed = false;
    for (final element in elements) {
      changed |= _set.remove(element);
    }
    if (changed) _tree = null;
  }

  @override
  Set<Interval<E>> toSet() => _set.toSet();

  void _refresh() {
    if (isEmpty || _tree != null) return;
    _tree = IntervalTreeNode.fromIntervals(this);
  }
}
