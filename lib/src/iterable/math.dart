part of iterable;

/**
 * Returns an iterable over the fibonacci sequence starting with [f0] and
 * [f1]. The default sequence is indefinitely long and by default starts
 * with 0, 1, 1, 2, 3, 5, 8, 13, ...
 */
Iterable<int> fibonacci([int f0 = 0, int f1 = 1]) {
  return fold([f0, f1], (a, b) => a + b);
}

/**
 * Returns an iterable over the digits of the [number], in the optionally
 * given [base].
 */
Iterable<int> digits(int number, [int base = 10]) {
  return new _DigitIterable(number.abs(), base);
}

class _DigitIterable extends IterableBase<int> {

  final int _number, _base;

  _DigitIterable(this._number, this._base);

  @override
  Iterator<int> get iterator => new _DigitIterator(_number, _base);

}

class _DigitIterator extends Iterator<int> {

  int _current, _number;
  final int _base;

  _DigitIterator(this._number, this._base);

  @override
  int get current => _current;

  @override
  bool moveNext() {
    if (_number == null) {
      _current = null;
      return false;
    } else {
      _current = _number % _base;
      _number = _number ~/ _base;
      if (_number == 0) {
        _number = null;
      }
      return true;
    }
  }

}
