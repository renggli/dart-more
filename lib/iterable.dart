/**
 * Some fancy iterables.
 */
library iterable;

part 'src/iterable/cycle.dart';
part 'src/iterable/emtpy.dart';
part 'src/iterable/permutations.dart';

import 'dart:collection';
import 'src/utils.dart';

/**
 * Returns an iterable over the fibonacci sequence starting with with [f0]
 * and [f1]. The default sequence is indefinitely long and by default starts
 * with 0, 1, 1, 2, 3, 5, 8, 13, ...
 */
Iterable<int> fibonacci([int f0 = 0, int f1 = 1]) {
  return new _FibonacciIterable(f0, f1);
}

class _FibonacciIterable extends IterableBase<int> {

  final int _f0, _f1;

  _FibonacciIterable(this._f0, this._f1);

  @override
  Iterator<int> get iterator {
    return new _FibonacciIterator(2 * _f0 - _f1, _f1 - _f0);
  }

}

class _FibonacciIterator extends Iterator<int> {

  int _previous, _current;

  _FibonacciIterator(this._previous, this._current);

  @override
  int get current => _current;

  @override
  bool moveNext() {
    var temporary = _previous;
    _previous = _current;
    _current += temporary;
    return true;
  }

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
