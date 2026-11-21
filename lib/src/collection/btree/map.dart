part of '../btree.dart';

/// An ordered, in-memory map backed by an order-statistic B+Tree.
///
/// Keys are kept sorted according to a [Comparator]. All entries reside in
/// doubly-linked leaf nodes, while internal nodes store routing keys and subtree
/// element counts.
///
/// ### Advantages over [SplayTreeMap], `SortedList`, and [List]
///
/// - **vs. [SplayTreeMap]**: Delivers `O(log n)` positional rank/select
///   ([keyAt], [indexOfKey], [removeAt]) instead of `O(n)` scans, and `O(1)`
///   step doubly-linked leaf iteration for faster full iteration and [range]
///   scans. Read queries do not mutate tree structure (no splaying), while
///   single-key lookups remain comparable and mutations trade slightly higher
///   constant-factor array shifts for shallower `O(log_B n)` tree height and
///   fewer heap allocations.
/// - **vs. `SortedList`**: Supports `O(log n)` insertions and removals instead
///   of `O(n)` contiguous list shifts, making bulk construction and mutations
///   much faster while retaining `O(log n)` positional access and binary search
///   (`SortedList` remains faster for static `O(1)` indexing and iteration).
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
  ///
  /// Throws an [ArgumentError] if [maxEntries] is less than `4` or [minEntries]
  /// is not between `2` and `maxEntries ~/ 2`.
  new({Comparator<K>? comparator, int? minEntries, int? maxEntries})
    : this._(
        BTreeLeafNode<K, V>(values: <V>[]),
        comparator: comparator ?? naturalCompare,
        maxEntries: maxEntries ?? 32,
        minEntries: minEntries ?? (maxEntries ?? 32) ~/ 2,
        hasValues: true,
      );

  new _set({Comparator<K>? comparator, int? minEntries, int? maxEntries})
    : this._(
        BTreeLeafNode<K, V>(),
        comparator: comparator ?? naturalCompare,
        maxEntries: maxEntries ?? 32,
        minEntries: minEntries ?? (maxEntries ?? 32) ~/ 2,
        hasValues: false,
      );

  new _(
    BTreeLeafNode<K, V> initialLeaf, {
    required this.comparator,
    required this.minEntries,
    required this.maxEntries,
    required this._hasValues,
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

  new _fromParts({
    required this._root,
    required this._firstLeaf,
    required this._lastLeaf,
    required this.comparator,
    required this.minEntries,
    required this.maxEntries,
    required this._hasValues,
  });

  /// Constructs a [BTreeMap] containing all entries of [other].
  ///
  /// When [other] is a [BTreeMap] with the same [comparator], [minEntries], and
  /// [maxEntries], the underlying tree is cloned directly in `O(n)` time.
  ///
  /// Throws an [ArgumentError] if [maxEntries] or [minEntries] is invalid.
  factory of(
    Map<K, V> other, {
    Comparator<K>? comparator,
    int? minEntries,
    int? maxEntries,
  }) {
    final resolvedComparator = comparator ?? naturalCompare;
    final resolvedMax = maxEntries ?? 32;
    final resolvedMin = minEntries ?? resolvedMax ~/ 2;
    if (other is BTreeMap<K, V> &&
        other.comparator == resolvedComparator &&
        other.minEntries == resolvedMin &&
        other.maxEntries == resolvedMax) {
      return other._clone();
    }
    return BTreeMap<K, V>(
      comparator: comparator,
      minEntries: minEntries,
      maxEntries: maxEntries,
    )..addAll(other);
  }

  /// Constructs a [BTreeMap] containing all entries of [other], casting keys
  /// to [K] and values to [V].
  ///
  /// Throws an [ArgumentError] if [maxEntries] or [minEntries] is invalid.
  factory from(
    Map<Object?, Object?> other, {
    Comparator<K>? comparator,
    int? minEntries,
    int? maxEntries,
  }) {
    final result = BTreeMap<K, V>(
      comparator: comparator,
      minEntries: minEntries,
      maxEntries: maxEntries,
    );
    other.forEach((key, value) {
      result[key as K] = value as V;
    });
    return result;
  }

  /// Constructs a [BTreeMap] from [entries].
  ///
  /// Throws an [ArgumentError] if [maxEntries] or [minEntries] is invalid.
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
  /// optional [key] and [value] functions in a single pass.
  ///
  /// Throws an [ArgumentError] if [maxEntries] or [minEntries] is invalid.
  factory fromIterable(
    Iterable<Object?> iterable, {
    Comparator<K>? comparator,
    K Function(Object? element)? key,
    V Function(Object? element)? value,
    int? minEntries,
    int? maxEntries,
  }) {
    final result = BTreeMap<K, V>(
      comparator: comparator,
      minEntries: minEntries,
      maxEntries: maxEntries,
    );
    final keyProvider = key ?? (element) => element as K;
    final valueProvider = value ?? (element) => element as V;
    for (final element in iterable) {
      result[keyProvider(element)] = valueProvider(element);
    }
    return result;
  }

  /// Constructs a [BTreeMap] associating [keys] with [values] of equal length.
  ///
  /// Throws an [ArgumentError] if [keys] and [values] have different lengths,
  /// or if [maxEntries] or [minEntries] is invalid.
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

  final bool _hasValues;
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
      : MapEntry(_firstLeaf.keys.first, (_firstLeaf.values as List<V>).first);

  /// The entry with the largest key in this map, in `O(1)` time.
  ///
  /// Throws a [StateError] if the map is empty.
  MapEntry<K, V> get lastEntry => isEmpty
      ? throw StateError('No element')
      : MapEntry(_lastLeaf.keys.last, (_lastLeaf.values as List<V>).last);

  @override
  Iterable<K> get keys => _BTreeKeyRangeIterable<K, V>(this);

  @override
  Iterable<V> get values => _BTreeValueRangeIterable<K, V>(this);

  @override
  Iterable<MapEntry<K, V>> get entries => _BTreeEntryRangeIterable<K, V>(this);

  /// An iterable of all keys in descending order.
  Iterable<K> get reversedKeys =>
      _BTreeKeyRangeIterable<K, V>(this, reversed: true);

  /// An iterable of all values in descending key order.
  Iterable<V> get reversedValues =>
      _BTreeValueRangeIterable<K, V>(this, reversed: true);

  /// An iterable of all entries in descending key order.
  Iterable<MapEntry<K, V>> get reversedEntries =>
      _BTreeEntryRangeIterable<K, V>(this, reversed: true);

  @override
  V? operator [](Object? key) {
    final found = _findLeaf(key);
    if (found == null) return null;
    return (found.leaf.values as List<V>)[found.index];
  }

  @override
  bool containsKey(Object? key) => _findLeaf(key) != null;

  @override
  bool containsValue(Object? value) {
    BTreeLeafNode<K, V>? leaf = _firstLeaf;
    while (leaf != null) {
      final values = leaf.values as List<V>;
      for (var i = 0; i < values.length; i++) {
        if (values[i] == value) return true;
      }
      leaf = leaf.next;
    }
    return false;
  }

  @override
  void operator []=(K key, V value) {
    final (:splitKey, :rightChild, added: _) = _insert(
      _root,
      key,
      value,
      overwrite: true,
    );
    if (rightChild != null) {
      _root = BTreeInternalNode<K, V>(
        keys: <K>[splitKey as K],
        children: <BTreeNode<K, V>>[_root, rightChild],
        size: _root.size + rightChild.size,
      );
    }
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final found = _findLeaf(key);
    if (found != null) {
      return (found.leaf.values as List<V>)[found.index];
    }
    final modCount = _modificationCount;
    final value = ifAbsent();
    if (modCount != _modificationCount) {
      throw ConcurrentModificationError(this);
    }
    this[key] = value;
    return value;
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final found = _findLeaf(key);
    if (found != null) {
      final values = found.leaf.values as List<V>;
      final modCount = _modificationCount;
      final newValue = update(values[found.index]);
      if (modCount != _modificationCount) {
        throw ConcurrentModificationError(this);
      }
      values[found.index] = newValue;
      return newValue;
    }
    if (ifAbsent != null) {
      final modCount = _modificationCount;
      final newValue = ifAbsent();
      if (modCount != _modificationCount) {
        throw ConcurrentModificationError(this);
      }
      this[key] = newValue;
      return newValue;
    }
    throw ArgumentError.value(key, 'key', 'Key not in map.');
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    final modCount = _modificationCount;
    BTreeLeafNode<K, V>? leaf = _firstLeaf;
    while (leaf != null) {
      final keys = leaf.keys;
      final values = leaf.values as List<V>;
      for (var i = 0; i < keys.length; i++) {
        final newValue = update(keys[i], values[i]);
        if (modCount != _modificationCount) {
          throw ConcurrentModificationError(this);
        }
        values[i] = newValue;
      }
      leaf = leaf.next;
    }
  }

  @override
  void forEach(void Function(K key, V value) action) {
    final modCount = _modificationCount;
    BTreeLeafNode<K, V>? leaf = _firstLeaf;
    while (leaf != null) {
      final keys = leaf.keys;
      final values = leaf.values as List<V>;
      for (var i = 0; i < keys.length; i++) {
        action(keys[i], values[i]);
        if (modCount != _modificationCount) {
          throw ConcurrentModificationError(this);
        }
      }
      leaf = leaf.next;
    }
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) transform) {
    final result = <K2, V2>{};
    final modCount = _modificationCount;
    BTreeLeafNode<K, V>? leaf = _firstLeaf;
    while (leaf != null) {
      final keys = leaf.keys;
      final values = leaf.values as List<V>;
      for (var i = 0; i < keys.length; i++) {
        final entry = transform(keys[i], values[i]);
        if (modCount != _modificationCount) {
          throw ConcurrentModificationError(this);
        }
        result[entry.key] = entry.value;
      }
      leaf = leaf.next;
    }
    return result;
  }

  @override
  V? remove(Object? key) {
    if (key is! K || isEmpty) return null;
    final (:removed, :value) = _removeKey(_root, key);
    if (!removed) return null;
    _collapseRootIfNeeded();
    return value;
  }

  @override
  void clear() {
    if (isEmpty) return;
    final root = BTreeLeafNode<K, V>(values: _hasValues ? <V>[] : null);
    _root = root;
    _firstLeaf = root;
    _lastLeaf = root;
    _modificationCount++;
  }

  /// Returns the key at the sorted [index] in `O(log n)` time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  K keyAt(int index) {
    final (:leaf, :offset) = _leafAndOffsetAt(index);
    return leaf.keys[offset];
  }

  /// Returns the value at the sorted [index] in `O(log n)` time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  V valueAt(int index) {
    final (:leaf, :offset) = _leafAndOffsetAt(index);
    return (leaf.values as List<V>)[offset];
  }

  /// Returns the entry at the sorted [index] in `O(log n)` time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  MapEntry<K, V> entryAt(int index) {
    final (:leaf, :offset) = _leafAndOffsetAt(index);
    return MapEntry(leaf.keys[offset], (leaf.values as List<V>)[offset]);
  }

  /// Returns the sorted 0-based rank of [key] in `O(log n)` time, or `-1` if
  /// not present.
  int indexOfKey(Object? key) {
    if (key is! K) return -1;
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
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  MapEntry<K, V> removeAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    final (:key, :value) = _removeAt(_root, index);
    _collapseRootIfNeeded();
    return MapEntry(key, value as V);
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
  K? lowerKey(K key) {
    final found = _predecessor(key, inclusive: false);
    return found?.leaf.keys[found.index];
  }

  /// Returns the entry with the greatest key strictly less than [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? lowerEntry(K key) =>
      _entryFrom(_predecessor(key, inclusive: false));

  /// Returns the greatest key less than or equal to [key] in `O(log n)` time,
  /// or `null` if no such key exists.
  K? floorKey(K key) {
    final found = _predecessor(key, inclusive: true);
    return found?.leaf.keys[found.index];
  }

  /// Returns the entry with the greatest key less than or equal to [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? floorEntry(K key) =>
      _entryFrom(_predecessor(key, inclusive: true));

  /// Returns the least key greater than or equal to [key] in `O(log n)` time,
  /// or `null` if no such key exists.
  K? ceilingKey(K key) {
    final found = _successor(key, inclusive: true);
    return found?.leaf.keys[found.index];
  }

  /// Returns the entry with the least key greater than or equal to [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? ceilingEntry(K key) =>
      _entryFrom(_successor(key, inclusive: true));

  /// Returns the least key strictly greater than [key] in `O(log n)` time, or
  /// `null` if no such key exists.
  K? higherKey(K key) {
    final found = _successor(key, inclusive: false);
    return found?.leaf.keys[found.index];
  }

  /// Returns the entry with the least key strictly greater than [key] in
  /// `O(log n)` time, or `null` if no such entry exists.
  MapEntry<K, V>? higherEntry(K key) =>
      _entryFrom(_successor(key, inclusive: false));

  /// Returns a lazy iterable of entries with keys between [min] and [max] in
  /// `O(log n + k)` time.
  ///
  /// When [min] or [max] is `null`, that side of the range is unbounded (note
  /// that `null` cannot be used as an explicit bound for nullable key types).
  /// [includeMin] and [includeMax] control whether keys equal to [min] or [max]
  /// are included. When [reversed] is `true`, entries are yielded in descending
  /// key order. Returns an empty iterable if [min] is greater than [max].
  Iterable<MapEntry<K, V>> range({
    K? min,
    K? max,
    bool includeMin = true,
    bool includeMax = true,
    bool reversed = false,
  }) => _BTreeEntryRangeIterable<K, V>(
    this,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
  );

  /// Returns a lazy iterable of keys between [min] and [max] in `O(log n + k)`
  /// time.
  ///
  /// When [min] or [max] is `null`, that side of the range is unbounded (note
  /// that `null` cannot be used as an explicit bound for nullable key types).
  /// [includeMin] and [includeMax] control whether keys equal to [min] or [max]
  /// are included. When [reversed] is `true`, keys are yielded in descending
  /// order. Returns an empty iterable if [min] is greater than [max].
  Iterable<K> keysInRange({
    K? min,
    K? max,
    bool includeMin = true,
    bool includeMax = true,
    bool reversed = false,
  }) => _BTreeKeyRangeIterable<K, V>(
    this,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
  );

  /// Returns a lazy iterable of values whose keys are between [min] and [max]
  /// in `O(log n + k)` time.
  ///
  /// When [min] or [max] is `null`, that side of the range is unbounded (note
  /// that `null` cannot be used as an explicit bound for nullable key types).
  /// [includeMin] and [includeMax] control whether keys equal to [min] or [max]
  /// are included. When [reversed] is `true`, values are yielded in descending
  /// key order. Returns an empty iterable if [min] is greater than [max].
  Iterable<V> valuesInRange({
    K? min,
    K? max,
    bool includeMin = true,
    bool includeMax = true,
    bool reversed = false,
  }) => _BTreeValueRangeIterable<K, V>(
    this,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
  );

  // --- Internal Helpers (also used by BTreeSet) ---

  K? _lookupKey(Object? key) {
    final found = _findLeaf(key);
    return found?.leaf.keys[found.index];
  }

  bool _addKeyIfAbsent(K key) {
    final (:splitKey, :rightChild, :added) = _insert(
      _root,
      key,
      null as V,
      overwrite: false,
    );
    if (rightChild != null) {
      _root = BTreeInternalNode<K, V>(
        keys: <K>[splitKey as K],
        children: <BTreeNode<K, V>>[_root, rightChild],
        size: _root.size + rightChild.size,
      );
    }
    return added;
  }

  bool _removeKeyBool(Object? key) {
    if (key is! K || isEmpty) return false;
    final (:removed, value: _) = _removeKey(_root, key);
    if (!removed) return false;
    _collapseRootIfNeeded();
    return true;
  }

  K _removeKeyAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    final (:key, value: _) = _removeAt(_root, index);
    _collapseRootIfNeeded();
    return key;
  }

  BTreeMap<K, V> _clone() {
    BTreeLeafNode<K, V>? firstLeaf;
    BTreeLeafNode<K, V>? prevLeaf;
    BTreeNode<K, V> cloneNode(BTreeNode<K, V> node) {
      switch (node) {
        case BTreeLeafNode<K, V>():
          final nodeValues = node.values;
          final copy = BTreeLeafNode<K, V>(
            keys: List<K>.of(node.keys),
            values: nodeValues == null ? null : List<V>.of(nodeValues),
          );
          final prev = prevLeaf;
          copy.previous = prev;
          if (prev != null) {
            prev.next = copy;
          } else {
            firstLeaf = copy;
          }
          prevLeaf = copy;
          return copy;
        case BTreeInternalNode<K, V>():
          return BTreeInternalNode<K, V>(
            keys: List<K>.of(node.keys),
            children: [for (final child in node.children) cloneNode(child)],
            size: node.size,
          );
      }
    }

    final root = cloneNode(_root);
    return BTreeMap<K, V>._fromParts(
      root: root,
      firstLeaf: firstLeaf as BTreeLeafNode<K, V>,
      lastLeaf: prevLeaf as BTreeLeafNode<K, V>,
      comparator: comparator,
      minEntries: minEntries,
      maxEntries: maxEntries,
      hasValues: _hasValues,
    );
  }

  MapEntry<K, V>? _entryFrom(({BTreeLeafNode<K, V> leaf, int index})? found) {
    if (found == null) return null;
    return MapEntry(
      found.leaf.keys[found.index],
      (found.leaf.values as List<V>)[found.index],
    );
  }

  BTreeLeafNode<K, V> _descendToLeaf(K key) {
    var node = _root;
    while (node is BTreeInternalNode<K, V>) {
      final childIndex = comparator.binarySearchUpper(node.keys, key);
      node = node.children[childIndex];
    }
    return node as BTreeLeafNode<K, V>;
  }

  ({BTreeLeafNode<K, V> leaf, int index})? _findLeaf(Object? key) {
    if (key is! K) return null;
    final leaf = _descendToLeaf(key);
    final index = comparator.binarySearchLower(leaf.keys, key);
    if (index < leaf.keys.length && comparator(leaf.keys[index], key) == 0) {
      return (leaf: leaf, index: index);
    }
    return null;
  }

  int _lowerBoundIndex(K key) {
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
    return rank + comparator.binarySearchLower(leaf.keys, key);
  }

  int _upperBoundIndex(K key) {
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
    return rank + comparator.binarySearchUpper(leaf.keys, key);
  }

  ({BTreeLeafNode<K, V> leaf, int offset}) _leafAndOffsetAt(int index) {
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
    return (leaf: node as BTreeLeafNode<K, V>, offset: remaining);
  }

  ({BTreeLeafNode<K, V> leaf, int index})? _predecessor(
    K key, {
    required bool inclusive,
  }) {
    if (isEmpty) return null;
    final leaf = _descendToLeaf(key);
    final index = inclusive
        ? comparator.binarySearchUpper(leaf.keys, key)
        : comparator.binarySearchLower(leaf.keys, key);
    if (index > 0) {
      return (leaf: leaf, index: index - 1);
    }
    final previous = leaf.previous;
    if (previous != null) {
      return (leaf: previous, index: previous.keys.length - 1);
    }
    return null;
  }

  ({BTreeLeafNode<K, V> leaf, int index})? _successor(
    K key, {
    required bool inclusive,
  }) {
    if (isEmpty) return null;
    final leaf = _descendToLeaf(key);
    final index = inclusive
        ? comparator.binarySearchLower(leaf.keys, key)
        : comparator.binarySearchUpper(leaf.keys, key);
    if (index < leaf.keys.length) {
      return (leaf: leaf, index: index);
    }
    final next = leaf.next;
    if (next != null) {
      return (leaf: next, index: 0);
    }
    return null;
  }

  ({bool added, K? splitKey, BTreeNode<K, V>? rightChild}) _insert(
    BTreeNode<K, V> node,
    K key,
    V value, {
    required bool overwrite,
  }) {
    if (node is BTreeLeafNode<K, V>) {
      final index = comparator.binarySearchLower(node.keys, key);
      if (index < node.keys.length && comparator(node.keys[index], key) == 0) {
        if (overwrite) {
          node.values?[index] = value;
        }
        return (added: false, splitKey: null, rightChild: null);
      }
      node.keys.insert(index, key);
      final values = node.values;
      if (values != null) {
        values.insert(index, value);
      }
      _modificationCount++;
      if (node.keys.length > maxEntries) {
        final mid = node.keys.length ~/ 2;
        final rightKeys = node.keys.sublist(mid);
        node.keys.length = mid;
        List<V>? rightValues;
        if (values != null) {
          rightValues = values.sublist(mid);
          values.length = mid;
        }
        final right = BTreeLeafNode<K, V>(keys: rightKeys, values: rightValues);
        right.next = node.next;
        right.previous = node;
        node.next?.previous = right;
        node.next = right;
        if (identical(node, _lastLeaf)) _lastLeaf = right;
        return (added: true, splitKey: right.keys.first, rightChild: right);
      }
      return (added: true, splitKey: null, rightChild: null);
    }

    final internal = node as BTreeInternalNode<K, V>;
    final childIndex = comparator.binarySearchUpper(internal.keys, key);
    final (:added, :splitKey, :rightChild) = _insert(
      internal.children[childIndex],
      key,
      value,
      overwrite: overwrite,
    );
    if (added) internal.size++;
    if (rightChild == null) {
      return (added: added, splitKey: null, rightChild: null);
    }

    internal.keys.insert(childIndex, splitKey as K);
    internal.children.insert(childIndex + 1, rightChild);
    if (internal.children.length > maxEntries) {
      final mid = internal.keys.length ~/ 2;
      final promotedKey = internal.keys[mid];
      final rightKeys = internal.keys.sublist(mid + 1);
      final rightChildren = internal.children.sublist(mid + 1);
      internal.keys.length = mid;
      internal.children.length = mid + 1;
      internal.size = _sumSizes(internal.children);
      final right = BTreeInternalNode<K, V>(
        keys: rightKeys,
        children: rightChildren,
        size: _sumSizes(rightChildren),
      );
      return (added: added, splitKey: promotedKey, rightChild: right);
    }
    return (added: added, splitKey: null, rightChild: null);
  }

  static int _sumSizes<K, V>(List<BTreeNode<K, V>> children) {
    var total = 0;
    for (final child in children) {
      total += child.size;
    }
    return total;
  }

  ({bool removed, V? value}) _removeKey(BTreeNode<K, V> node, K key) {
    if (node is BTreeLeafNode<K, V>) {
      final index = comparator.binarySearchLower(node.keys, key);
      if (index < node.keys.length && comparator(node.keys[index], key) == 0) {
        node.keys.removeAt(index);
        final value = node.values?.removeAt(index);
        _modificationCount++;
        return (removed: true, value: value);
      }
      return (removed: false, value: null);
    }

    final internal = node as BTreeInternalNode<K, V>;
    final childIndex = comparator.binarySearchUpper(internal.keys, key);
    final (:removed, :value) = _removeKey(internal.children[childIndex], key);
    if (!removed) return (removed: false, value: null);
    internal.size--;
    _rebalanceChild(internal, childIndex);
    return (removed: true, value: value);
  }

  ({K key, V? value}) _removeAt(BTreeNode<K, V> node, int index) {
    if (node is BTreeLeafNode<K, V>) {
      final key = node.keys.removeAt(index);
      final value = node.values?.removeAt(index);
      _modificationCount++;
      return (key: key, value: value);
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
    final result = _removeAt(internal.children[childIndex], remaining);
    internal.size--;
    _rebalanceChild(internal, childIndex);
    return result;
  }

  void _rebalanceChild(BTreeInternalNode<K, V> parent, int childIndex) {
    final child = parent.children[childIndex];
    if (child is BTreeLeafNode<K, V>) {
      if (child.keys.length >= minEntries) return;
      if (childIndex > 0) {
        final left = parent.children[childIndex - 1] as BTreeLeafNode<K, V>;
        if (left.keys.length > minEntries) {
          child.keys.insert(0, left.keys.removeLast());
          final leftValues = left.values;
          final childValues = child.values;
          if (leftValues != null && childValues != null) {
            childValues.insert(0, leftValues.removeLast());
          }
          parent.keys[childIndex - 1] = child.keys.first;
          return;
        }
      }
      if (childIndex + 1 < parent.children.length) {
        final right = parent.children[childIndex + 1] as BTreeLeafNode<K, V>;
        if (right.keys.length > minEntries) {
          child.keys.add(right.keys.removeAt(0));
          final rightValues = right.values;
          final childValues = child.values;
          if (rightValues != null && childValues != null) {
            childValues.add(rightValues.removeAt(0));
          }
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
    final leftValues = left.values;
    final rightValues = right.values;
    if (leftValues != null && rightValues != null) {
      leftValues.addAll(rightValues);
    }
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

sealed class _BTreeRangeIterable<K, V, T> extends IterableBase<T> {
  new(
    this._map, {
    this.min,
    this.max,
    this.includeMin = true,
    this.includeMax = true,
    this.reversed = false,
  });

  final BTreeMap<K, V> _map;
  final K? min;
  final K? max;
  final bool includeMin;
  final bool includeMax;
  final bool reversed;

  T _extract(BTreeLeafNode<K, V> leaf, int index);

  ({int start, int end}) _bounds() {
    final total = _map.length;
    if (total == 0) return (start: 0, end: 0);
    final minKey = min;
    final maxKey = max;
    if (minKey == null && maxKey == null) {
      return (start: 0, end: total);
    }
    final start = minKey == null
        ? 0
        : includeMin
        ? _map._lowerBoundIndex(minKey)
        : _map._upperBoundIndex(minKey);
    final end = maxKey == null
        ? total
        : includeMax
        ? _map._upperBoundIndex(maxKey)
        : _map._lowerBoundIndex(maxKey);
    if (start >= end) return (start: 0, end: 0);
    return (start: start, end: end);
  }

  @override
  int get length {
    final (:start, :end) = _bounds();
    return end - start;
  }

  @override
  bool get isEmpty {
    final (:start, :end) = _bounds();
    return start == end;
  }

  @override
  bool get isNotEmpty {
    final (:start, :end) = _bounds();
    return start < end;
  }

  @override
  T get first {
    final (:start, :end) = _bounds();
    if (start == end) throw StateError('No element');
    final target = reversed ? end - 1 : start;
    if (target == 0) return _extract(_map._firstLeaf, 0);
    if (target == _map.length - 1) {
      final lastLeaf = _map._lastLeaf;
      return _extract(lastLeaf, lastLeaf.keys.length - 1);
    }
    final (:leaf, :offset) = _map._leafAndOffsetAt(target);
    return _extract(leaf, offset);
  }

  @override
  T get last {
    final (:start, :end) = _bounds();
    if (start == end) throw StateError('No element');
    final target = reversed ? start : end - 1;
    if (target == 0) return _extract(_map._firstLeaf, 0);
    if (target == _map.length - 1) {
      final lastLeaf = _map._lastLeaf;
      return _extract(lastLeaf, lastLeaf.keys.length - 1);
    }
    final (:leaf, :offset) = _map._leafAndOffsetAt(target);
    return _extract(leaf, offset);
  }

  @override
  T elementAt(int index) {
    RangeError.checkNotNegative(index, 'index');
    final (:start, :end) = _bounds();
    final count = end - start;
    if (index >= count) {
      throw RangeError.index(index, this, 'index', null, count);
    }
    final target = reversed ? end - 1 - index : start + index;
    final (:leaf, :offset) = _map._leafAndOffsetAt(target);
    return _extract(leaf, offset);
  }

  @override
  Iterator<T> get iterator => _BTreeRangeIterator<K, V, T>(
    _map,
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
    extract: _extract,
  );
}

final class _BTreeKeyRangeIterable<K, V> extends _BTreeRangeIterable<K, V, K> {
  new(
    super._map, {
    super.min,
    super.max,
    super.includeMin,
    super.includeMax,
    super.reversed,
  });

  @override
  K _extract(BTreeLeafNode<K, V> leaf, int index) => leaf.keys[index];

  @override
  bool contains(Object? element) {
    if (element is! K) return false;
    final minKey = min;
    if (minKey != null) {
      final cmp = _map.comparator(element, minKey);
      if (cmp < 0 || (cmp == 0 && !includeMin)) return false;
    }
    final maxKey = max;
    if (maxKey != null) {
      final cmp = _map.comparator(element, maxKey);
      if (cmp > 0 || (cmp == 0 && !includeMax)) return false;
    }
    return _map.containsKey(element);
  }
}

final class _BTreeValueRangeIterable<K, V>
    extends _BTreeRangeIterable<K, V, V> {
  new(
    super._map, {
    super.min,
    super.max,
    super.includeMin,
    super.includeMax,
    super.reversed,
  });

  @override
  V _extract(BTreeLeafNode<K, V> leaf, int index) =>
      (leaf.values as List<V>)[index];
}

final class _BTreeEntryRangeIterable<K, V>
    extends _BTreeRangeIterable<K, V, MapEntry<K, V>> {
  new(
    super._map, {
    super.min,
    super.max,
    super.includeMin,
    super.includeMax,
    super.reversed,
  });

  @override
  MapEntry<K, V> _extract(BTreeLeafNode<K, V> leaf, int index) =>
      MapEntry(leaf.keys[index], (leaf.values as List<V>)[index]);
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
    final minKey = min;
    final maxKey = max;
    if (minKey != null && maxKey != null) {
      final cmp = _map.comparator(minKey, maxKey);
      if (cmp > 0 || (cmp == 0 && (!includeMin || !includeMax))) {
        _leaf = null;
        _index = 0;
        return;
      }
    }
    if (!reversed) {
      if (minKey == null) {
        _leaf = _map._firstLeaf;
        _index = 0;
      } else {
        final leaf = _map._descendToLeaf(minKey);
        final idx = includeMin
            ? _map.comparator.binarySearchLower(leaf.keys, minKey)
            : _map.comparator.binarySearchUpper(leaf.keys, minKey);
        if (idx < leaf.keys.length) {
          _leaf = leaf;
          _index = idx;
        } else {
          _leaf = leaf.next;
          _index = 0;
        }
      }
    } else {
      if (maxKey == null) {
        final lastLeaf = _map._lastLeaf;
        _leaf = lastLeaf;
        _index = lastLeaf.keys.length - 1;
      } else {
        final leaf = _map._descendToLeaf(maxKey);
        final pos = includeMax
            ? _map.comparator.binarySearchUpper(leaf.keys, maxKey)
            : _map.comparator.binarySearchLower(leaf.keys, maxKey);
        if (pos > 0) {
          _leaf = leaf;
          _index = pos - 1;
        } else {
          final previous = leaf.previous;
          _leaf = previous;
          _index = previous == null ? -1 : previous.keys.length - 1;
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
  final T Function(BTreeLeafNode<K, V> leaf, int index) extract;
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
      final key = leaf.keys[_index];
      final maxKey = max;
      if (maxKey != null) {
        final cmp = _map.comparator(key, maxKey);
        if (cmp > 0 || (cmp == 0 && !includeMax)) {
          _leaf = null;
          return false;
        }
      }
      current = extract(leaf, _index);
      _index++;
      if (_index >= leaf.keys.length) {
        _leaf = leaf.next;
        _index = 0;
      }
      return true;
    } else {
      final key = leaf.keys[_index];
      final minKey = min;
      if (minKey != null) {
        final cmp = _map.comparator(key, minKey);
        if (cmp < 0 || (cmp == 0 && !includeMin)) {
          _leaf = null;
          return false;
        }
      }
      current = extract(leaf, _index);
      _index--;
      if (_index < 0) {
        final previous = leaf.previous;
        _leaf = previous;
        _index = previous == null ? -1 : previous.keys.length - 1;
      }
      return true;
    }
  }
}
