import 'dart:collection' show MapBase;

import 'package:collection/collection.dart' show QueueList;

import '../functional/scope.dart';
import 'interval.dart';

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

  /// Internal root of the balanced interval tree.
  _IntervalNode<K, V>? _root;

  /// Returns an [Iterable] over all entries that contain a [value].
  Iterable<MapEntry<Interval<K>, V>> entriesContainingPoint(K value) =>
      _queryPoint(value);

  /// Returns an [Iterable] over all keys that contain a [value].
  Iterable<Interval<K>> keysContainingPoint(K value) =>
      entriesContainingPoint(value).map((entry) => entry.key);

  /// Returns an [Iterable] over all values that contain a [value].
  Iterable<V> valuesContainingPoint(K value) =>
      entriesContainingPoint(value).map((entry) => entry.value);

  /// Returns an [Iterable] over all entries that overlap with [interval].
  Iterable<MapEntry<Interval<K>, V>> entriesIntersectingInterval(
          Interval<K> interval) =>
      _queryInterval(interval).where((entry) => entry.key.intersects(interval));

  /// Returns an [Iterable] over all keys that overlap with [interval].
  Iterable<Interval<K>> keysIntersectingInterval(Interval<K> interval) =>
      entriesIntersectingInterval(interval).map((entry) => entry.key);

  /// Returns an [Iterable] over all values that overlap with [interval].
  Iterable<V> valuesIntersectingInterval(Interval<K> interval) =>
      entriesIntersectingInterval(interval).map((entry) => entry.value);

  /// Returns an [Iterable] over all entries that cover [interval].
  Iterable<MapEntry<Interval<K>, V>> entriesEnclosingInterval(
          Interval<K> interval) =>
      _queryInterval(interval).where((entry) => entry.key.encloses(interval));

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
    _root = null;
    _map[key] = value;
  }

  @override
  void clear() {
    _root = null;
    _map.clear();
  }

  @override
  V? remove(Object? key) {
    _root = null;
    return _map.remove(key);
  }

  void _refresh() {
    if (isEmpty || _root != null) return;
    _root = _createNode(_map.entries);
  }

  Iterable<MapEntry<Interval<K>, V>> _queryPoint(K value) sync* {
    _refresh();
    var node = _root;
    while (node != null) {
      for (final entry in node.entries) {
        if (entry.key.contains(value)) {
          yield entry;
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

  Iterable<MapEntry<Interval<K>, V>> _queryInterval(
      Interval<K> interval) sync* {
    _refresh();
    final nodes = QueueList<_IntervalNode<K, V>>();
    if (_root case final root?) nodes.add(root);
    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      yield* node.entries;
      if (interval.upper.compareTo(node.median) < 0) {
        node.left?.also(nodes.add);
      }
      if (node.median.compareTo(interval.lower) < 0) {
        node.right?.also(nodes.add);
      }
    }
  }
}

class _IntervalNode<K extends Comparable<K>, V> {
  final K median;
  final _IntervalNode<K, V>? left;
  final List<MapEntry<Interval<K>, V>> entries;
  final _IntervalNode<K, V>? right;

  _IntervalNode(this.median, this.left, this.entries, this.right);
}

_IntervalNode<K, V>? _createNode<K extends Comparable<K>, V>(
    Iterable<MapEntry<Interval<K>, V>> entries) {
  if (entries.isEmpty) return null;
  final endpoints = <K>[];
  for (final entry in entries) {
    endpoints.add(entry.key.lower);
    endpoints.add(entry.key.upper);
  }
  endpoints.sort();
  final median = endpoints[endpoints.length ~/ 2];
  final left = <MapEntry<Interval<K>, V>>[];
  final center = <MapEntry<Interval<K>, V>>[];
  final right = <MapEntry<Interval<K>, V>>[];
  for (final entry in entries) {
    if (entry.key.upper.compareTo(median) < 0) {
      left.add(entry);
    } else if (median.compareTo(entry.key.lower) < 0) {
      right.add(entry);
    } else {
      center.add(entry);
    }
  }
  return _IntervalNode<K, V>(
    median,
    _createNode(left),
    center,
    _createNode(right),
  );
}
