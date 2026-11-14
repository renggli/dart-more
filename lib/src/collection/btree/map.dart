import 'dart:collection' show IterableBase, MapBase, SplayTreeMap;

import 'package:meta/meta.dart';

import '../../comparator/constructors/natural.dart';
import '../../comparator/operations/binary_search.dart';
import 'node.dart';

/// An ordered, in-memory map backed by an order-statistic B+Tree.
///
/// Keys are kept sorted according to a [Comparator]. All entries reside in
/// doubly-linked leaf nodes, while internal nodes store routing keys and subtree
/// element counts.
///
/// ### Advantages over [SplayTreeMap], `SortedList`, and [List]
///
/// - **vs. [SplayTreeMap]**: Stores multiple entries in contiguous node arrays
///   (`O(log_B n)` height), reducing pointer indirection, per-entry heap
///   allocations, and GC overhead. Read queries do not mutate tree structure
///   (no splaying), avoiding cache thrashing on uniform or random access
///   patterns. Supports `O(log n)` positional rank/select ([keyAt],
///   [indexOfKey], [removeAt]) and `O(1)` step doubly-linked leaf iteration
///   instead of `O(n)` index scans or stack-based tree traversal.
/// - **vs. `SortedList`**: Supports `O(log n)` insertions and removals
///   (`SortedList` requires `O(n)` contiguous list shifts on mutation) while
///   retaining `O(log n)` positional access and binary search.
/// - **vs. [List]**: Maintains keys in sorted order automatically on insertion
///   with `O(log n)` lookup, range queries, and neighbor searches ([floorKey],
///   [ceilingKey]), whereas an unsorted [List] requires `O(n)` linear scan or
///   `O(n log n)` full re-sorting.
///
/// ### Sizing [minEntries] and [maxEntries]
///
/// - [maxEntries] (`M`) defines the maximum number of entries in a leaf node
///   and children in an internal node before splitting (`M >= 4`).
/// - [minEntries] (`m`) defines the underflow threshold (`2 <= m <= M ~/ 2`).
/// - Default values (`minEntries = 16`, `maxEntries = 32`) balance CPU cache
///   locality and intra-node array shifting for general in-memory workloads.
/// - **Read-heavy / sequential workloads**: Larger capacities (`maxEntries`
///   around `64` to `128`) flatten tree height and speed up scans.
/// - **Write-heavy workloads**: Smaller capacities (`maxEntries` around `8` to
///   `16`) reduce intra-node list shifting overhead on mutation.
///
/// ```dart
/// final map = BTreeMap<String, int>.of({'b': 2, 'a': 1, 'c': 3});
/// print(map.keyAt(1)); // 'b'
/// print(map.indexOfKey('c')); // 2
/// print(map.ceilingKey('b')); // 'b'
/// print(map.keysInRange(min: 'a', max: 'b').toList()); // ['a', 'b']
/// ```
class BTreeMap<K, V> extends MapBase<K, V> {
  /// Constructs an empty [BTreeMap] with an optional [comparator],
  /// [minEntries], and [maxEntries].
  new({Comparator<K>? comparator, int? minEntries, int? maxEntries})
    : this._(
        BTreeLeafNode<K, V>(),
        comparator: comparator ?? naturalCompare,
        maxEntries: maxEntries ?? 32,
        minEntries: minEntries ?? (maxEntries ?? 32) ~/ 2,
      );

  new _(
    BTreeLeafNode<K, V> initialLeaf, {
    required this.comparator,
    required this.minEntries,
    required this.maxEntries,
  }) : _root = initialLeaf,
       _firstLeaf = initialLeaf,
       _lastLeaf = initialLeaf {
    if (maxEntries < 4) {
      throw ArgumentError.value(maxEntries, 'maxEntries', 'Must be at least 4');
    }
    if (minEntries < 2 || minEntries > maxEntries ~/ 2) {
      throw ArgumentError.value(
        minEntries,
        'minEntries',
        'Must be between 2 and ${maxEntries ~/ 2}',
      );
    }
  }

  /// Constructs a [BTreeMap] containing all entries of [other].
  factory of(
    Map<K, V> other, {
    Comparator<K>? comparator,
    int? minEntries,
    int? maxEntries,
  }) => BTreeMap<K, V>(
    comparator: comparator,
    minEntries: minEntries,
    maxEntries: maxEntries,
  )..addAll(other);

  /// Constructs a [BTreeMap] from [entries].
  factory fromEntries(
    Iterable<MapEntry<K, V>> entries, {
    Comparator<K>? comparator,
    int? minEntries,
    int? maxEntries,
  }) => BTreeMap<K, V>(
    comparator: comparator,
    minEntries: minEntries,
    maxEntries: maxEntries,
  )..addEntries(entries);

  /// Constructs a [BTreeMap] from [iterable], computing keys and values with
  /// optional [key] and [value] functions.
  factory fromIterable(
    Iterable<Object?> iterable, {
    Comparator<K>? comparator,
    K Function(Object? element)? key,
    V Function(Object? element)? value,
    int? minEntries,
    int? maxEntries,
  }) => BTreeMap<K, V>.fromIterables(
    key == null ? iterable.cast<K>() : iterable.map(key),
    value == null ? iterable.cast<V>() : iterable.map(value),
    comparator: comparator,
    minEntries: minEntries,
    maxEntries: maxEntries,
  );

  /// Constructs a [BTreeMap] associating [keys] with [values] of equal length.
  factory fromIterables(
    Iterable<K> keys,
    Iterable<V> values, {
    Comparator<K>? comparator,
    int? minEntries,
    int? maxEntries,
  }) {
    final result = BTreeMap<K, V>(
      comparator: comparator,
      minEntries: minEntries,
      maxEntries: maxEntries,
    );
    final keyIterator = keys.iterator;
    final valueIterator = values.iterator;
    var moreKeys = keyIterator.moveNext();
    var moreValues = valueIterator.moveNext();
    while (moreKeys && moreValues) {
      result[keyIterator.current] = valueIterator.current;
      moreKeys = keyIterator.moveNext();
      moreValues = valueIterator.moveNext();
    }
    if (moreKeys || moreValues) {
      throw ArgumentError('Iterables do not have same length');
    }
    return result;
  }

  /// Comparator used to order keys in this map.
  final Comparator<K> comparator;

  /// Minimum number of entries per non-root node.
  final int minEntries;

  /// Maximum number of entries per leaf or children per internal node.
  final int maxEntries;

  BTreeNode<K, V> _root;
  BTreeLeafNode<K, V> _firstLeaf;
  BTreeLeafNode<K, V> _lastLeaf;
  int _modificationCount = 0;

  @override
  int get length => _root.size;

  @override
  bool get isEmpty => _root.size == 0;

  @override
  bool get isNotEmpty => _root.size > 0;

  /// The smallest key in this map, in `O(1)` time.
  ///
  /// Throws a [StateError] if the map is empty.
  K get firstKey =>
      isEmpty ? throw StateError('No element') : _firstLeaf.keys.first;

  /// The largest key in this map, in `O(1)` time.
  ///
  /// Throws a [StateError] if the map is empty.
  K get lastKey =>
      isEmpty ? throw StateError('No element') : _lastLeaf.keys.last;

  /// The entry with the smallest key in this map, in `O(1)` time.
  ///
  /// Throws a [StateError] if the map is empty.
  MapEntry<K, V> get firstEntry => isEmpty
      ? throw StateError('No element')
      : MapEntry(_firstLeaf.keys.first, _firstLeaf.values.first);

  /// The entry with the largest key in this map, in `O(1)` time.
  ///
  /// Throws a [StateError] if the map is empty.
  MapEntry<K, V> get lastEntry => isEmpty
      ? throw StateError('No element')
      : MapEntry(_lastLeaf.keys.last, _lastLeaf.values.last);

  @override
  Iterable<K> get keys =>
      _BTreeRangeIterable<K, V, K>(this, extract: (k, v) => k);

  @override
  Iterable<V> get values =>
      _BTreeRangeIterable<K, V, V>(this, extract: (k, v) => v);

  @override
  Iterable<MapEntry<K, V>> get entries =>
      _BTreeRangeIterable<K, V, MapEntry<K, V>>(this, extract: MapEntry.new);

  /// An iterable of all keys in descending order.
  Iterable<K> get reversedKeys =>
      _BTreeRangeIterable<K, V, K>(this, reversed: true, extract: (k, v) => k);

  /// An iterable of all values in descending key order.
  Iterable<V> get reversedValues =>
      _BTreeRangeIterable<K, V, V>(this, reversed: true, extract: (k, v) => v);

  /// An iterable of all entries in descending key order.
  Iterable<MapEntry<K, V>> get reversedEntries =>
      _BTreeRangeIterable<K, V, MapEntry<K, V>>(
        this,
        reversed: true,
        extract: MapEntry.new,
      );

  @override
  V? operator [](Object? key) {
    final found = _findLeaf(key);
    return found == null ? null : found.$1.values[found.$2];
  }

  @override
  bool containsKey(Object? key) => _findLeaf(key) != null;

  @override
  void operator []=(K key, V value) {
    final (_, splitKey, rightChild) = _insert(_root, key, value);
    if (rightChild != null) {
      final newRoot = BTreeInternalNode<K, V>();
      newRoot.keys.add(splitKey as K);
      newRoot.children.add(_root);
      newRoot.children.add(rightChild);
      newRoot.size = _root.size + rightChild.size;
      _root = newRoot;
    }
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final found = _findLeaf(key);
    if (found != null) {
      return found.$1.values[found.$2];
    }
    final value = ifAbsent();
    this[key] = value;
    return value;
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final found = _findLeaf(key);
    if (found != null) {
      final newValue = update(found.$1.values[found.$2]);
      this[key] = newValue;
      return newValue;
    }
    if (ifAbsent != null) {
      final newValue = ifAbsent();
      this[key] = newValue;
      return newValue;
    }
    throw ArgumentError.value(key, 'key', 'Key not in map.');
  }

  @override
  V? remove(Object? key) {
    if (key is! K || isEmpty) return null;
    final (removed, value) = _removeKey(_root, key);
    if (!removed) return null;
    _collapseRootIfNeeded();
    return value;
  }

  @override
  void clear() {
    if (isEmpty) return;
    final root = BTreeLeafNode<K, V>();
    _root = root;
    _firstLeaf = root;
    _lastLeaf = root;
    _modificationCount++;
  }

  /// Returns the key at the sorted [index] in `O(log n)` time.
  K keyAt(int index) {
    final (leaf, offset) = _leafAndOffsetAt(index);
    return leaf.keys[offset];
  }

  /// Returns the value at the sorted [index] in `O(log n)` time.
  V valueAt(int index) {
    final (leaf, offset) = _leafAndOffsetAt(index);
    return leaf.values[offset];
  }

  /// Returns the entry at the sorted [index] in `O(log n)` time.
  MapEntry<K, V> entryAt(int index) {
    final (leaf, offset) = _leafAndOffsetAt(index);
    return MapEntry(leaf.keys[offset], leaf.values[offset]);
  }

  /// Returns the sorted 0-based rank of [key] in `O(log n)` time, or `-1` if
  /// not present.
  int indexOfKey(K key) {
    var rank = 0;
    var node = _root;
    while (node is BTreeInternalNode<K, V>) {
      final childIndex = comparator.binarySearchUpper(node.keys, key);
      for (var i = 0; i < childIndex; i++) {
        rank += node.children[i].size;
      }
      node = node.children[childIndex];
    }
    final leaf = node as BTreeLeafNode<K, V>;
    final index = comparator.binarySearchLower(leaf.keys, key);
    if (index < leaf.keys.length && comparator(leaf.keys[index], key) == 0) {
      return rank + index;
    }
    return -1;
  }

  /// Removes and returns the entry at the sorted [index] in `O(log n)` time.
  MapEntry<K, V> removeAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    final entry = _removeAt(_root, index);
    _collapseRootIfNeeded();
    return entry;
  }

  /// Removes and returns the entry with the smallest key in `O(log n)` time.
  ///
  /// Throws a [StateError] if the map is empty.
  MapEntry<K, V> removeFirst() =>
      isEmpty ? throw StateError('No element') : removeAt(0);

  /// Removes and returns the entry with the largest key in `O(log n)` time.
  ///
  /// Throws a [StateError] if the map is empty.
  MapEntry<K, V> removeLast() =>
      isEmpty ? throw StateError('No element') : removeAt(length - 1);

  /// Returns the greatest key strictly less than [key] in `O(log n)` time, or
  /// `null` if no such key exists.
  K? lowerKey(K key) => lowerEntry(key)?.key;

  /// Returns the entry with the greatest key strictly less than [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? lowerEntry(K key) => _predecessorEntry(key, inclusive: false);

  /// Returns the greatest key less than or equal to [key] in `O(log n)` time,
  /// or `null` if no such key exists.
  K? floorKey(K key) => floorEntry(key)?.key;

  /// Returns the entry with the greatest key less than or equal to [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? floorEntry(K key) => _predecessorEntry(key, inclusive: true);

  /// Returns the least key greater than or equal to [key] in `O(log n)` time,
  /// or `null` if no such key exists.
  K? ceilingKey(K key) => ceilingEntry(key)?.key;

  /// Returns the entry with the least key greater than or equal to [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? ceilingEntry(K key) => _successorEntry(key, inclusive: true);

  /// Returns the least key strictly greater than [key] in `O(log n)` time, or
  /// `null` if no such key exists.
  K? higherKey(K key) => higherEntry(key)?.key;

  /// Returns the entry with the least key strictly greater than [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? higherEntry(K key) => _successorEntry(key, inclusive: false);

  /// Returns a lazy iterable of entries within the bounds [[min], [max]] in
  /// `O(log n + k)` time.
  Iterable<MapEntry<K, V>> range({
    K? min,
    K? max,
    bool includeMin = true,
    bool includeMax = true,
    bool reversed = false,
  }) => _BTreeRangeIterable<K, V, MapEntry<K, V>>(
    this,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
    extract: MapEntry.new,
  );

  /// Returns a lazy iterable of keys within the bounds [[min], [max]] in
  /// `O(log n + k)` time.
  Iterable<K> keysInRange({
    K? min,
    K? max,
    bool includeMin = true,
    bool includeMax = true,
    bool reversed = false,
  }) => _BTreeRangeIterable<K, V, K>(
    this,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
    extract: (k, v) => k,
  );

  /// Returns a lazy iterable of values whose keys are within the bounds
  /// [[min], [max]] in `O(log n + k)` time.
  Iterable<V> valuesInRange({
    K? min,
    K? max,
    bool includeMin = true,
    bool includeMax = true,
    bool reversed = false,
  }) => _BTreeRangeIterable<K, V, V>(
    this,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
    extract: (k, v) => v,
  );

  // --- Internal Helpers ---

  BTreeLeafNode<K, V> _descendToLeaf(K key) {
    var node = _root;
    while (node is BTreeInternalNode<K, V>) {
      final childIndex = comparator.binarySearchUpper(node.keys, key);
      node = node.children[childIndex];
    }
    return node as BTreeLeafNode<K, V>;
  }

  (BTreeLeafNode<K, V>, int)? _findLeaf(Object? key) {
    if (key is! K) return null;
    final leaf = _descendToLeaf(key);
    final index = comparator.binarySearchLower(leaf.keys, key);
    if (index < leaf.keys.length && comparator(leaf.keys[index], key) == 0) {
      return (leaf, index);
    }
    return null;
  }

  (BTreeLeafNode<K, V>, int) _leafAndOffsetAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    var remaining = index;
    var node = _root;
    while (node is BTreeInternalNode<K, V>) {
      for (final child in node.children) {
        if (remaining < child.size) {
          node = child;
          break;
        }
        remaining -= child.size;
      }
    }
    return (node as BTreeLeafNode<K, V>, remaining);
  }

  MapEntry<K, V>? _predecessorEntry(K key, {required bool inclusive}) {
    if (isEmpty) return null;
    final leaf = _descendToLeaf(key);
    final index = inclusive
        ? comparator.binarySearchUpper(leaf.keys, key)
        : comparator.binarySearchLower(leaf.keys, key);
    if (index > 0) {
      return MapEntry(leaf.keys[index - 1], leaf.values[index - 1]);
    }
    final previous = leaf.previous;
    if (previous != null) {
      return MapEntry(previous.keys.last, previous.values.last);
    }
    return null;
  }

  MapEntry<K, V>? _successorEntry(K key, {required bool inclusive}) {
    if (isEmpty) return null;
    final leaf = _descendToLeaf(key);
    final index = inclusive
        ? comparator.binarySearchLower(leaf.keys, key)
        : comparator.binarySearchUpper(leaf.keys, key);
    if (index < leaf.keys.length) {
      return MapEntry(leaf.keys[index], leaf.values[index]);
    }
    final next = leaf.next;
    if (next != null) {
      return MapEntry(next.keys.first, next.values.first);
    }
    return null;
  }

  (bool, K?, BTreeNode<K, V>?) _insert(BTreeNode<K, V> node, K key, V value) {
    if (node is BTreeLeafNode<K, V>) {
      final index = comparator.binarySearchLower(node.keys, key);
      if (index < node.keys.length && comparator(node.keys[index], key) == 0) {
        node.keys[index] = key;
        node.values[index] = value;
        return (false, null, null);
      }
      node.keys.insert(index, key);
      node.values.insert(index, value);
      _modificationCount++;
      if (node.keys.length > maxEntries) {
        final mid = node.keys.length ~/ 2;
        final right = BTreeLeafNode<K, V>();
        right.keys.addAll(node.keys.sublist(mid));
        right.values.addAll(node.values.sublist(mid));
        node.keys.length = mid;
        node.values.length = mid;
        right.next = node.next;
        right.previous = node;
        node.next?.previous = right;
        node.next = right;
        if (identical(node, _lastLeaf)) _lastLeaf = right;
        return (true, right.keys.first, right);
      }
      return (true, null, null);
    }

    final internal = node as BTreeInternalNode<K, V>;
    final childIndex = comparator.binarySearchUpper(internal.keys, key);
    final (added, splitKey, rightChild) = _insert(
      internal.children[childIndex],
      key,
      value,
    );
    if (added) internal.size++;
    if (rightChild == null) return (added, null, null);

    internal.keys.insert(childIndex, splitKey as K);
    internal.children.insert(childIndex + 1, rightChild);
    if (internal.children.length > maxEntries) {
      final mid = internal.keys.length ~/ 2;
      final promotedKey = internal.keys[mid];
      final right = BTreeInternalNode<K, V>();
      right.keys.addAll(internal.keys.sublist(mid + 1));
      right.children.addAll(internal.children.sublist(mid + 1));
      internal.keys.length = mid;
      internal.children.length = mid + 1;
      internal.size = _sumSizes(internal.children);
      right.size = _sumSizes(right.children);
      return (added, promotedKey, right);
    }
    return (added, null, null);
  }

  static int _sumSizes<K, V>(List<BTreeNode<K, V>> children) {
    var total = 0;
    for (final child in children) {
      total += child.size;
    }
    return total;
  }

  (bool, V?) _removeKey(BTreeNode<K, V> node, K key) {
    if (node is BTreeLeafNode<K, V>) {
      final index = comparator.binarySearchLower(node.keys, key);
      if (index < node.keys.length && comparator(node.keys[index], key) == 0) {
        node.keys.removeAt(index);
        final value = node.values.removeAt(index);
        _modificationCount++;
        return (true, value);
      }
      return (false, null);
    }

    final internal = node as BTreeInternalNode<K, V>;
    final childIndex = comparator.binarySearchUpper(internal.keys, key);
    final (removed, value) = _removeKey(internal.children[childIndex], key);
    if (!removed) return (false, null);
    internal.size--;
    _rebalanceChild(internal, childIndex);
    return (true, value);
  }

  MapEntry<K, V> _removeAt(BTreeNode<K, V> node, int index) {
    if (node is BTreeLeafNode<K, V>) {
      final key = node.keys.removeAt(index);
      final value = node.values.removeAt(index);
      _modificationCount++;
      return MapEntry(key, value);
    }

    final internal = node as BTreeInternalNode<K, V>;
    var remaining = index;
    var childIndex = 0;
    while (childIndex < internal.children.length) {
      final childSize = internal.children[childIndex].size;
      if (remaining < childSize) break;
      remaining -= childSize;
      childIndex++;
    }
    final entry = _removeAt(internal.children[childIndex], remaining);
    internal.size--;
    _rebalanceChild(internal, childIndex);
    return entry;
  }

  void _rebalanceChild(BTreeInternalNode<K, V> parent, int childIndex) {
    final child = parent.children[childIndex];
    if (child is BTreeLeafNode<K, V>) {
      if (child.keys.length >= minEntries) return;
      if (childIndex > 0) {
        final left = parent.children[childIndex - 1] as BTreeLeafNode<K, V>;
        if (left.keys.length > minEntries) {
          child.keys.insert(0, left.keys.removeLast());
          child.values.insert(0, left.values.removeLast());
          parent.keys[childIndex - 1] = child.keys.first;
          return;
        }
      }
      if (childIndex + 1 < parent.children.length) {
        final right = parent.children[childIndex + 1] as BTreeLeafNode<K, V>;
        if (right.keys.length > minEntries) {
          child.keys.add(right.keys.removeAt(0));
          child.values.add(right.values.removeAt(0));
          parent.keys[childIndex] = right.keys.first;
          return;
        }
      }
      if (childIndex > 0) {
        final left = parent.children[childIndex - 1] as BTreeLeafNode<K, V>;
        _mergeLeaves(parent, childIndex - 1, left, child);
      } else {
        final right = parent.children[1] as BTreeLeafNode<K, V>;
        _mergeLeaves(parent, 0, child, right);
      }
      return;
    }

    final internalChild = child as BTreeInternalNode<K, V>;
    if (internalChild.children.length >= minEntries) return;
    if (childIndex > 0) {
      final left = parent.children[childIndex - 1] as BTreeInternalNode<K, V>;
      if (left.children.length > minEntries) {
        final borrowedChild = left.children.removeLast();
        final borrowedKey = left.keys.removeLast();
        internalChild.keys.insert(0, parent.keys[childIndex - 1]);
        internalChild.children.insert(0, borrowedChild);
        parent.keys[childIndex - 1] = borrowedKey;
        left.size -= borrowedChild.size;
        internalChild.size += borrowedChild.size;
        return;
      }
    }
    if (childIndex + 1 < parent.children.length) {
      final right = parent.children[childIndex + 1] as BTreeInternalNode<K, V>;
      if (right.children.length > minEntries) {
        final borrowedChild = right.children.removeAt(0);
        final borrowedKey = right.keys.removeAt(0);
        internalChild.keys.add(parent.keys[childIndex]);
        internalChild.children.add(borrowedChild);
        parent.keys[childIndex] = borrowedKey;
        right.size -= borrowedChild.size;
        internalChild.size += borrowedChild.size;
        return;
      }
    }
    if (childIndex > 0) {
      final left = parent.children[childIndex - 1] as BTreeInternalNode<K, V>;
      _mergeInternals(parent, childIndex - 1, left, internalChild);
    } else {
      final right = parent.children[1] as BTreeInternalNode<K, V>;
      _mergeInternals(parent, 0, internalChild, right);
    }
  }

  void _mergeLeaves(
    BTreeInternalNode<K, V> parent,
    int mergeIndex,
    BTreeLeafNode<K, V> left,
    BTreeLeafNode<K, V> right,
  ) {
    left.keys.addAll(right.keys);
    left.values.addAll(right.values);
    left.next = right.next;
    right.next?.previous = left;
    if (identical(right, _lastLeaf)) _lastLeaf = left;
    parent.keys.removeAt(mergeIndex);
    parent.children.removeAt(mergeIndex + 1);
  }

  void _mergeInternals(
    BTreeInternalNode<K, V> parent,
    int mergeIndex,
    BTreeInternalNode<K, V> left,
    BTreeInternalNode<K, V> right,
  ) {
    left.keys.add(parent.keys.removeAt(mergeIndex));
    left.keys.addAll(right.keys);
    left.children.addAll(right.children);
    left.size += right.size;
    parent.children.removeAt(mergeIndex + 1);
  }

  void _collapseRootIfNeeded() {
    if (_root case final BTreeInternalNode<K, V> internal
        when internal.children.length == 1) {
      _root = internal.children.first;
    }
  }
}

/// Exposes internal tree state for structural invariant verification in tests.
@visibleForTesting
extension BTreeMapTestingExtension<K, V> on BTreeMap<K, V> {
  /// Root node of this B+Tree.
  BTreeNode<K, V> get debugRoot => _root;

  /// First leaf node in the doubly-linked leaf chain.
  BTreeLeafNode<K, V> get debugFirstLeaf => _firstLeaf;

  /// Last leaf node in the doubly-linked leaf chain.
  BTreeLeafNode<K, V> get debugLastLeaf => _lastLeaf;
}

/// Conversion extension on [Map] to create a [BTreeMap].
extension BTreeMapExtension<K, V> on Map<K, V> {
  /// Converts this map to a [BTreeMap].
  BTreeMap<K, V> toBTreeMap({
    Comparator<K>? comparator,
    int? minEntries,
    int? maxEntries,
  }) => BTreeMap<K, V>.of(
    this,
    comparator: comparator,
    minEntries: minEntries,
    maxEntries: maxEntries,
  );
}

final class _BTreeRangeIterable<K, V, T> extends IterableBase<T> {
  new(
    this._map, {
    this.min,
    this.max,
    this.includeMin = true,
    this.includeMax = true,
    this.reversed = false,
    required this.extract,
  });

  final BTreeMap<K, V> _map;
  final K? min;
  final K? max;
  final bool includeMin;
  final bool includeMax;
  final bool reversed;
  final T Function(K key, V value) extract;

  @override
  Iterator<T> get iterator => _BTreeRangeIterator<K, V, T>(
    _map,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
    extract: extract,
  );
}

final class _BTreeRangeIterator<K, V, T> implements Iterator<T> {
  new(
    this._map, {
    required this.min,
    required this.max,
    required this.includeMin,
    required this.includeMax,
    required this.reversed,
    required this.extract,
  }) : _expectedModCount = _map._modificationCount {
    if (_map.isEmpty) {
      _leaf = null;
      _index = 0;
      return;
    }
    if (min != null && max != null) {
      final cmp = _map.comparator(min as K, max as K);
      if (cmp > 0 || (cmp == 0 && (!includeMin || !includeMax))) {
        _leaf = null;
        _index = 0;
        return;
      }
    }
    if (!reversed) {
      if (min == null) {
        _leaf = _map._firstLeaf;
        _index = 0;
      } else {
        final leaf = _map._descendToLeaf(min as K);
        final idx = includeMin
            ? _map.comparator.binarySearchLower(leaf.keys, min as K)
            : _map.comparator.binarySearchUpper(leaf.keys, min as K);
        if (idx < leaf.keys.length) {
          _leaf = leaf;
          _index = idx;
        } else {
          _leaf = leaf.next;
          _index = 0;
        }
      }
    } else {
      if (max == null) {
        _leaf = _map._lastLeaf;
        _index = _leaf!.keys.length - 1;
      } else {
        final leaf = _map._descendToLeaf(max as K);
        final pos = includeMax
            ? _map.comparator.binarySearchUpper(leaf.keys, max as K)
            : _map.comparator.binarySearchLower(leaf.keys, max as K);
        if (pos > 0) {
          _leaf = leaf;
          _index = pos - 1;
        } else {
          _leaf = leaf.previous;
          _index = _leaf == null ? -1 : _leaf!.keys.length - 1;
        }
      }
    }
  }

  final BTreeMap<K, V> _map;
  final K? min;
  final K? max;
  final bool includeMin;
  final bool includeMax;
  final bool reversed;
  final T Function(K key, V value) extract;
  final int _expectedModCount;

  BTreeLeafNode<K, V>? _leaf;
  int _index = 0;

  @override
  late T current;

  @override
  bool moveNext() {
    if (_expectedModCount != _map._modificationCount) {
      throw ConcurrentModificationError(_map);
    }
    final leaf = _leaf;
    if (leaf == null) return false;
    if (!reversed) {
      if (_index >= leaf.keys.length) {
        _leaf = null;
        return false;
      }
      final key = leaf.keys[_index];
      if (max != null) {
        final cmp = _map.comparator(key, max as K);
        if (cmp > 0 || (cmp == 0 && !includeMax)) {
          _leaf = null;
          return false;
        }
      }
      current = extract(key, leaf.values[_index]);
      _index++;
      if (_index >= leaf.keys.length) {
        _leaf = leaf.next;
        _index = 0;
      }
      return true;
    } else {
      if (_index < 0) {
        _leaf = null;
        return false;
      }
      final key = leaf.keys[_index];
      if (min != null) {
        final cmp = _map.comparator(key, min as K);
        if (cmp < 0 || (cmp == 0 && !includeMin)) {
          _leaf = null;
          return false;
        }
      }
      current = extract(key, leaf.values[_index]);
      _index--;
      if (_index < 0) {
        _leaf = leaf.previous;
        _index = _leaf == null ? -1 : _leaf!.keys.length - 1;
      }
      return true;
    }
  }
}
