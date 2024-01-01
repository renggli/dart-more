import 'dart:collection' show MapBase;

import 'interval.dart';
import 'tree.dart';

/// A [IntervalMap] associates intervals with a value.
///
/// For all parts this code behaves like a normal [Map] with keys of type
/// `Interval<K>`. Additional helpers [entriesContainingPoint],
/// [keysContainingPoint], [valuesContainingPoint];
/// [entriesIntersectingInterval], [keysIntersectingInterval],
/// [valuesIntersectingInterval]; and [entriesEnclosingInterval],
/// [keysEnclosingInterval], [valuesEnclosingInterval] provide ways to query
/// point and interval conditions efficiently.
///
/// The first time any such method is called an internal balanced tree with the
/// intervals is built in O(n*log(n)). Afterwards all such queries are answered
/// in O(log(n)) until the intervals get changed again.
class IntervalMap<K extends Comparable<K>, V>
    with MapBase<Interval<K>, V>
    implements Map<Interval<K>, V> {
  /// Creates an emtpy [IntervalMap].
  IntervalMap();

  /// Internal [Map] delegate.
  final Map<Interval<K>, V> _map = {};

  /// Internal root node of the balanced interval tree.
  IntervalTreeNode<K, MapEntry<Interval<K>, V>>? _tree;

  /// Returns an [Iterable] over all entries that contain a [value].
  Iterable<MapEntry<Interval<K>, V>> entriesContainingPoint(K value) {
    _refresh();
    return _tree?.queryPoint(value).where((each) => each.key.contains(value)) ??
        const [];
  }

  /// Returns an [Iterable] over all keys that contain a [value].
  Iterable<Interval<K>> keysContainingPoint(K value) =>
      entriesContainingPoint(value).map((entry) => entry.key);

  /// Returns an [Iterable] over all values that contain a [value].
  Iterable<V> valuesContainingPoint(K value) =>
      entriesContainingPoint(value).map((entry) => entry.value);

  /// Returns an [Iterable] over all entries that overlap with [interval].
  Iterable<MapEntry<Interval<K>, V>> entriesIntersectingInterval(
      Interval<K> interval) {
    _refresh();
    return _tree
            ?.queryInterval(interval)
            .where((entry) => entry.key.intersects(interval)) ??
        const [];
  }

  /// Returns an [Iterable] over all keys that overlap with [interval].
  Iterable<Interval<K>> keysIntersectingInterval(Interval<K> interval) =>
      entriesIntersectingInterval(interval).map((entry) => entry.key);

  /// Returns an [Iterable] over all values that overlap with [interval].
  Iterable<V> valuesIntersectingInterval(Interval<K> interval) =>
      entriesIntersectingInterval(interval).map((entry) => entry.value);

  /// Returns an [Iterable] over all entries that cover [interval].
  Iterable<MapEntry<Interval<K>, V>> entriesEnclosingInterval(
      Interval<K> interval) {
    _refresh();
    return _tree
            ?.queryInterval(interval)
            .where((entry) => entry.key.encloses(interval)) ??
        const [];
  }

  /// Returns an [Iterable] over all keys that cover [interval].
  Iterable<Interval<K>> keysEnclosingInterval(Interval<K> interval) =>
      entriesEnclosingInterval(interval).map((entry) => entry.key);

  /// Returns an [Iterable] over all values that cover [interval].
  Iterable<V> valuesEnclosingInterval(Interval<K> interval) =>
      entriesEnclosingInterval(interval).map((entry) => entry.value);

  @override
  int get length => _map.length;

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<MapEntry<Interval<K>, V>> get entries => _map.entries;

  @override
  Iterable<Interval<K>> get keys => _map.keys;

  @override
  Iterable<V> get values => _map.values;

  @override
  V? operator [](Object? key) => _map[key];

  @override
  void operator []=(Interval<K> key, V value) {
    _tree = null;
    _map[key] = value;
  }

  @override
  void clear() {
    _tree = null;
    _map.clear();
  }

  @override
  V? remove(Object? key) {
    _tree = null;
    return _map.remove(key);
  }

  void _refresh() {
    if (isEmpty || _tree != null) return;
    _tree = IntervalTreeNode.fromNodes(_map.entries, (entry) => entry.key);
  }
}
