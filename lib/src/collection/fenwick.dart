/// A fenwick tree (or binary indexed tree) is a data structure that can
/// efficiently update and calculate sums in an array of values.
///
/// See https://en.wikipedia.org/wiki/Fenwick_tree.
class FenwickTree with Iterable<int> {
  /// Constructs a Fenwick tree with the given [length].
  FenwickTree(int length) : this._(List.filled(length, 0, growable: false));

  /// Constructs a Fenwick tree from the values of [iterable] in _O(n)_.
  factory FenwickTree.of(Iterable<int> iterable) {
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
  FenwickTree._(this._tree);

  final List<int> _tree;

  @override
  int get length => _tree.length;

  @override
  bool get isEmpty => _tree.isEmpty;

  @override
  Iterator<int> get iterator => _FenwickTreeIterator(this);

  /// Converts the tree to a list in _O(n)_.
  @override
  List<int> toList({bool growable = true}) {
    final result = _tree.toList(growable: growable);
    for (var i = _tree.length - 1; i > 0; i--) {
      final j = i + (i & -i);
      if (j < _tree.length) result[j] -= result[i];
    }
    return result;
  }

  /// Returns the n-th element of this tree in _O(log n)_.
  int operator [](int index) => range(index, index + 1);

  /// Updates the n-th element of this tree in _O(log n)_.
  void operator []=(int index, int value) => update(index, value - this[index]);

  /// Computes the sum of all values up to [index] (exclusive) in _O(log n)_.
  int prefix(int index) {
    RangeError.checkValueInInterval(index, 0, _tree.length, 'index');
    if (index == 0) return 0;
    var value = _tree[0];
    for (--index; index > 0; index -= index & -index) {
      value += _tree[index];
    }
    return value;
  }

  /// Computes the sum of all values between [start] and [end] (exclusive)
  /// in _O(log n)_.
  int range(int start, int end) => prefix(end) - prefix(start);

  /// Increments the element in the tree at [index] by [value] in _O(log n)_.
  void update(int index, int value) {
    if (index == 0) {
      _tree[0] += value;
      return;
    }
    while (index < _tree.length) {
      _tree[index] += value;
      index += index & -index;
    }
  }
}

final class _FenwickTreeIterator implements Iterator<int> {
  _FenwickTreeIterator(this._tree);

  final FenwickTree _tree;

  int _index = 0;
  int _previous = 0;

  @override
  late int current;

  @override
  bool moveNext() {
    if (_index < _tree.length) {
      final next = _tree.prefix(++_index);
      current = next - _previous;
      _previous = next;
      return true;
    }
    return false;
  }
}
