import 'dart:collection' show SetBase, SplayTreeSet;

import 'map.dart';

/// An ordered, in-memory set backed by an order-statistic B+Tree.
///
/// Elements are kept sorted according to a [Comparator]. All elements reside in
/// doubly-linked leaf nodes, while internal nodes store routing keys and subtree
/// element counts.
///
/// ### Advantages over [SplayTreeSet], `SortedList`, and [List]
///
/// - **vs. [SplayTreeSet]**: Stores multiple elements in contiguous node arrays
///   (`O(log_B n)` height), reducing pointer indirection, per-element heap
///   allocations, and GC overhead. Read queries do not mutate tree structure
///   (no splaying), avoiding cache thrashing on uniform or random access
///   patterns. Supports `O(log n)` positional rank/select ([elementAt],
///   [indexOf], [removeAt]) and `O(1)` step doubly-linked leaf iteration instead
///   of `O(n)` index scans or stack-based tree traversal.
/// - **vs. `SortedList`**: Supports `O(log n)` insertions and removals
///   (`SortedList` requires `O(n)` contiguous list shifts on mutation) while
///   retaining `O(log n)` positional access and binary search.
/// - **vs. [List]**: Maintains elements in sorted order automatically on
///   insertion with `O(log n)` membership checks, range queries, and neighbor
///   searches ([floor], [ceiling]), whereas an unsorted [List] requires `O(n)`
///   linear scan or `O(n log n)` full re-sorting.
///
/// ### Sizing [minEntries] and [maxEntries]
///
/// - [maxEntries] (`M`) defines the maximum number of elements in a leaf node
///   and children in an internal node before splitting (`M >= 4`).
/// - [minEntries] (`m`) defines the underflow threshold (`2 <= m <= M ~/ 2`).
/// - Default values (`minEntries = 16`, `maxEntries = 32`) balance CPU cache
///   locality and intra-node array shifting for general in-memory workloads.
///
/// ```dart
/// final set = BTreeSet<int>.of([30, 10, 20, 40]);
/// print(set.elementAt(2)); // 30
/// print(set.indexOf(20)); // 1
/// print(set.ceiling(25)); // 30
/// print(set.range(min: 15, max: 35).toList()); // [20, 30]
/// ```
class BTreeSet<E> extends SetBase<E> {
  /// Constructs an empty [BTreeSet] with an optional [comparator],
  /// [minEntries], and [maxEntries].
  new({Comparator<E>? comparator, int? minEntries, int? maxEntries})
    : _map = BTreeMap<E, E>(
        comparator: comparator,
        minEntries: minEntries,
        maxEntries: maxEntries,
      );

  /// Constructs a [BTreeSet] containing all elements of [elements].
  factory of(
    Iterable<E> elements, {
    Comparator<E>? comparator,
    int? minEntries,
    int? maxEntries,
  }) => BTreeSet<E>(
    comparator: comparator,
    minEntries: minEntries,
    maxEntries: maxEntries,
  )..addAll(elements);

  final BTreeMap<E, E> _map;

  /// Comparator used to order elements in this set.
  Comparator<E> get comparator => _map.comparator;

  /// Minimum number of entries per non-root node.
  int get minEntries => _map.minEntries;

  /// Maximum number of entries per leaf or children per internal node.
  int get maxEntries => _map.maxEntries;

  @override
  int get length => _map.length;

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  E get first => _map.firstKey;

  @override
  E get last => _map.lastKey;

  @override
  Iterator<E> get iterator => _map.keys.iterator;

  /// An iterable of all elements in descending order.
  Iterable<E> get reversed => _map.reversedKeys;

  @override
  bool add(E value) {
    var added = false;
    _map.putIfAbsent(value, () {
      added = true;
      return value;
    });
    return added;
  }

  @override
  bool contains(Object? element) => _map.containsKey(element);

  @override
  E? lookup(Object? element) => _map[element];

  @override
  bool remove(Object? value) {
    if (!_map.containsKey(value)) return false;
    _map.remove(value);
    return true;
  }

  @override
  void clear() => _map.clear();

  @override
  Set<E> toSet() => BTreeSet<E>.of(
    this,
    comparator: comparator,
    minEntries: minEntries,
    maxEntries: maxEntries,
  );

  /// Returns the element at the sorted [index] in `O(log n)` time.
  @override
  E elementAt(int index) => _map.keyAt(index);

  /// Returns the sorted 0-based rank of [element] in `O(log n)` time, or `-1`
  /// if not present.
  int indexOf(E element) => _map.indexOfKey(element);

  /// Removes and returns the element at the sorted [index] in `O(log n)` time.
  E removeAt(int index) => _map.removeAt(index).key;

  /// Removes and returns the smallest element in `O(log n)` time.
  ///
  /// Throws a [StateError] if the set is empty.
  E removeFirst() => _map.removeFirst().key;

  /// Removes and returns the largest element in `O(log n)` time.
  ///
  /// Throws a [StateError] if the set is empty.
  E removeLast() => _map.removeLast().key;

  /// Returns the greatest element strictly less than [element] in `O(log n)`
  /// time, or `null` if no such element exists.
  E? lower(E element) => _map.lowerKey(element);

  /// Returns the greatest element less than or equal to [element] in `O(log n)`
  /// time, or `null` if no such element exists.
  E? floor(E element) => _map.floorKey(element);

  /// Returns the least element greater than or equal to [element] in `O(log n)`
  /// time, or `null` if no such element exists.
  E? ceiling(E element) => _map.ceilingKey(element);

  /// Returns the least element strictly greater than [element] in `O(log n)`
  /// time, or `null` if no such element exists.
  E? higher(E element) => _map.higherKey(element);

  /// Returns a lazy iterable of elements within the bounds [[min], [max]] in
  /// `O(log n + k)` time.
  Iterable<E> range({
    E? min,
    E? max,
    bool includeMin = true,
    bool includeMax = true,
    bool reversed = false,
  }) => _map.keysInRange(
    min: min,
    max: max,
    includeMin: includeMin,
    includeMax: includeMax,
    reversed: reversed,
  );
}

/// Conversion extension on [Iterable] to create a [BTreeSet].
extension BTreeSetExtension<E> on Iterable<E> {
  /// Converts this iterable to a [BTreeSet].
  BTreeSet<E> toBTreeSet({
    Comparator<E>? comparator,
    int? minEntries,
    int? maxEntries,
  }) => BTreeSet<E>.of(
    this,
    comparator: comparator,
    minEntries: minEntries,
    maxEntries: maxEntries,
  );
}
