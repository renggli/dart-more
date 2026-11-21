/// A Fenwick tree (or binary indexed tree) is a data structure that can
/// efficiently update and calculate prefix sums in an array of values.
///
/// See https://en.wikipedia.org/wiki/Fenwick_tree.
class FenwickTree with Iterable<int> {
  /// Constructs a Fenwick tree with the given [length] initialized to zero.
  ///
  /// Throws a [RangeError] if [length] is negative.
  new(int length) : this._(List.filled(length, 0, growable: false));

  /// Constructs a Fenwick tree from the values of [iterable] in `O(n)` time.
  factory of(Iterable<int> iterable) {
    if (iterable is FenwickTree) {
      return FenwickTree._(iterable._tree.toList(growable: false));
    }
    final list = iterable.toList(growable: false);
    for (var i = 1; i < list.length; i++) {
      final j = i + (i & -i);
      if (j < list.length) list[j] += list[i];
    }
    return FenwickTree._(list);
  }

  /// Internal constructor of a Fenwick tree.
  new _(this._tree);

  final List<int> _tree;

  @override
  int get length => _tree.length;

  @override
  bool get isEmpty => _tree.isEmpty;

  @override
  bool get isNotEmpty => _tree.isNotEmpty;

  @override
  int get first => isEmpty ? throw StateError('No element') : _tree[0];

  @override
  int get last =>
      isEmpty ? throw StateError('No element') : _read(_tree.length - 1);

  @override
  int get single {
    if (_tree.isEmpty) throw StateError('No element');
    if (_tree.length > 1) throw StateError('Too many elements');
    return _tree[0];
  }

  @override
  int elementAt(int index) => this[index];

  @override
  Iterator<int> get iterator => _FenwickTreeIterator(this);

  /// Converts the tree to a list in `O(n)` time.
  @override
  List<int> toList({bool growable = true}) {
    final result = _tree.toList(growable: growable);
    for (var i = _tree.length - 1; i > 0; i--) {
      final j = i + (i & -i);
      if (j < _tree.length) result[j] -= result[i];
    }
    return result;
  }

  /// Returns the element at [index] in `O(log n)` worst-case (`O(1)`
  /// amortized) time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  int operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index');
    return _read(index);
  }

  /// Sets the element at [index] to [value] in `O(log n)` time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  void operator []=(int index, int value) {
    RangeError.checkValidIndex(index, this, 'index');
    update(index, value - _read(index));
  }

  /// Computes the sum of all values from `0` (inclusive) to [index]
  /// (exclusive) in `O(log n)` time.
  ///
  /// Throws a [RangeError] if [index] is not in `0..length`.
  int prefix(int index) {
    RangeError.checkValueInInterval(index, 0, _tree.length, 'index');
    if (index == 0) return 0;
    var value = _tree[0];
    for (--index; index > 0; index -= index & -index) {
      value += _tree[index];
    }
    return value;
  }

  /// Computes the sum of all values from [start] (inclusive) to [end]
  /// (exclusive) in `O(log n)` time.
  ///
  /// Throws a [RangeError] if `0 <= start <= end <= length` does not hold.
  int range(int start, int end) {
    RangeError.checkValidRange(start, end, _tree.length, 'start', 'end');
    if (start == end) return 0;
    return prefix(end) - prefix(start);
  }

  /// Increments the element in the tree at [index] by [value] in `O(log n)`
  /// time.
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  void update(int index, int value) {
    RangeError.checkValidIndex(index, this, 'index');
    if (index == 0) {
      _tree[0] += value;
      return;
    }
    while (index < _tree.length) {
      _tree[index] += value;
      index += index & -index;
    }
  }

  int _read(int index) {
    var value = _tree[index];
    if (index > 0) {
      final parent = index - (index & -index);
      for (var i = index - 1; i > parent; i -= i & -i) {
        value -= _tree[i];
      }
    }
    return value;
  }
}

final class _FenwickTreeIterator implements Iterator<int> {
  new(this._tree);

  final FenwickTree _tree;
  int _index = 0;

  @override
  late int current;

  @override
  bool moveNext() {
    if (_index < _tree.length) {
      current = _tree._read(_index++);
      return true;
    }
    return false;
  }
}
