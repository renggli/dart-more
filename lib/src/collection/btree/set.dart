part of '../btree.dart';

/// An ordered, in-memory set backed by an order-statistic B+Tree.
///
/// Elements are kept sorted according to a [Comparator]. All elements reside in
/// doubly-linked leaf nodes, while internal nodes store routing keys and subtree
/// element counts.
///
/// ### Advantages over [SplayTreeSet], `SortedList`, and [List]
///
/// - **vs. [SplayTreeSet]**: Delivers `O(log n)` positional rank/select
///   ([elementAt], [indexOf], [removeAt]) instead of `O(n)` scans, and `O(1)`
///   step doubly-linked leaf iteration for faster full iteration and [range]
///   scans. Read queries do not mutate tree structure (no splaying), while
///   single-element lookups remain comparable and mutations trade slightly higher
///   constant-factor array shifts for shallower `O(log_B n)` tree height and
///   fewer heap allocations.
/// - **vs. `SortedList`**: Supports `O(log n)` insertions and removals instead
///   of `O(n)` contiguous list shifts, making bulk construction and mutations
///   much faster while retaining `O(log n)` positional access and binary search
///   (`SortedList` remains faster for static `O(1)` indexing and iteration).
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
  ///
  /// Throws an [ArgumentError] if [maxEntries] is less than `4` or [minEntries]
  /// is not between `2` and `maxEntries ~/ 2`.
  new({Comparator<E>? comparator, int? minEntries, int? maxEntries})
    : _map = BTreeMap<E, Null>._set(
        comparator: comparator,
        minEntries: minEntries,
        maxEntries: maxEntries,
      );

  new _wrap(this._map);

  /// Constructs a [BTreeSet] containing all elements of [elements].
  ///
  /// When [elements] is a [BTreeSet] with the same [comparator], [minEntries],
  /// and [maxEntries], the underlying tree is cloned directly in `O(n)` time.
  ///
  /// Throws an [ArgumentError] if [maxEntries] or [minEntries] is invalid.
  factory of(
    Iterable<E> elements, {
    Comparator<E>? comparator,
    int? minEntries,
    int? maxEntries,
  }) {
    final resolvedComparator = comparator ?? naturalCompare;
    final resolvedMax = maxEntries ?? 32;
    final resolvedMin = minEntries ?? resolvedMax ~/ 2;
    if (elements is BTreeSet<E> &&
        elements.comparator == resolvedComparator &&
        elements.minEntries == resolvedMin &&
        elements.maxEntries == resolvedMax) {
      return BTreeSet<E>._wrap(elements._map._clone());
    }
    return BTreeSet<E>(
      comparator: comparator,
      minEntries: minEntries,
      maxEntries: maxEntries,
    )..addAll(elements);
  }

  /// Constructs a [BTreeSet] containing all elements of [elements], casting
  /// each element to [E].
  ///
  /// Throws an [ArgumentError] if [maxEntries] or [minEntries] is invalid.
  factory from(
    Iterable<Object?> elements, {
    Comparator<E>? comparator,
    int? minEntries,
    int? maxEntries,
  }) {
    final result = BTreeSet<E>(
      comparator: comparator,
      minEntries: minEntries,
      maxEntries: maxEntries,
    );
    for (final element in elements) {
      result.add(element as E);
    }
    return result;
  }

  final BTreeMap<E, Null> _map;

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
  bool add(E value) => _map._addKeyIfAbsent(value);

  @override
  bool contains(Object? element) => _map.containsKey(element);

  @override
  E? lookup(Object? element) => _map._lookupKey(element);

  @override
  bool remove(Object? value) => _map._removeKeyBool(value);

  @override
  void clear() => _map.clear();

  @override
  Set<E> toSet() => BTreeSet<E>._wrap(_map._clone());

  /// Returns the element at the sorted [index] in `O(log n)` time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  @override
  E elementAt(int index) => _map.keyAt(index);

  /// Returns the sorted 0-based rank of [element] in `O(log n)` time, or `-1`
  /// if not present.
  int indexOf(Object? element) => _map.indexOfKey(element);

  /// Removes and returns the element at the sorted [index] in `O(log n)` time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  E removeAt(int index) => _map._removeKeyAt(index);

  /// Removes and returns the smallest element in `O(log n)` time.
  ///
  /// Throws a [StateError] if the set is empty.
  E removeFirst() =>
      isEmpty ? throw StateError('No element') : _map._removeKeyAt(0);

  /// Removes and returns the largest element in `O(log n)` time.
  ///
  /// Throws a [StateError] if the set is empty.
  E removeLast() =>
      isEmpty ? throw StateError('No element') : _map._removeKeyAt(length - 1);

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

  /// Returns a lazy iterable of elements between [min] and [max] in
  /// `O(log n + k)` time.
  ///
  /// When [min] or [max] is `null`, that side of the range is unbounded (note
  /// that `null` cannot be used as an explicit bound for nullable element
  /// types). [includeMin] and [includeMax] control whether elements equal to
  /// [min] or [max] are included. When [reversed] is `true`, elements are
  /// yielded in descending order. Returns an empty iterable if [min] is greater
  /// than [max].
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

/// Exposes internal tree state for structural invariant verification in tests.
@visibleForTesting
extension BTreeSetTestingExtension<E> on BTreeSet<E> {
  /// Backing [BTreeMap] storing the elements of this set.
  BTreeMap<E, Null> get debugMap => _map;
}
