/**
 * A function to to create lists of arithmetic progressions.
 *
 * The implementation closely follows the range object known
 * in [Python](http://goo.gl/33Ddi).
 */
library range;

import 'dart:collection';

import 'package:more/iterable.dart';

/**
 * Creates a virtual range of numbers containing an arithmetic progressions.
 *
 * The range function called without any arguments returns the empty range.
 * For example, `range()` yields `[]`.
 *
 * The range function called with one argument returns the range of all
 * numbers up to, but excluding the end. For example, `range(3)` yields
 * `[0, 1, 2]`.
 *
 * The range function called with two arguments returns the range between
 * the two numbers (including the start, but excluding the end). For example,
 * `range(3, 6)` yields `[3, 4, 5]`.
 *
 * The range function called with three arguments returns the range between
 * the first two numbers (including the start, but excluding the end) and the
 * step value. For example, `range(1, 7, 2)` yields `[1, 3, 5]`.
 */
List<num> range([num a, num b, num c]) {
  var start = 0, stop = 0, step = 1;
  if (c != null) {
    start = a; stop = b; step = c;
  } else if (b != null) {
    start = a; stop = b;
  } else if (a != null) {
    stop = a;
  }
  if (step == 0) {
    throw new ArgumentError('Non-zero step-size expected');
  } else if (start < stop && step < 0) {
    throw new ArgumentError('Positive step-size expected');
  } else if (start > stop && step > 0) {
    throw new ArgumentError('Negative step-size expected');
  }
  var length = (stop - start) ~/ step;
  if ((stop - start) % step > 1e-10 * step.abs()) length++;
  return new _RangeList(start, step, length);
}

/**
 * An iterable over an arithmetic progression.
 */
class _RangeList extends ListBase<num> with UnmodifiableListMixin<num> {

  final num _start;
  final num _step;
  final int _length;

  _RangeList(this._start, this._step, this._length);

  @override
  Iterator<num> get iterator {
    return new _RangeIterator(_start, _step, _length);
  }

  @override
  int get length => _length;

  @override
  num operator [](int index) {
    if (0 <= index && index < _length) {
      return _start + _step * index;
    } else {
      throw new RangeError.range(index, 0, _length);
    }
  }

  @override
  _RangeList sublist(int start, [int end]) {
    if (end == null) {
      end = length - 1;
    }
    return new _RangeList(_start + start * _step, _step, end - start);
  }

  @override
  String toString() {
    if (_length == 0) {
      return 'range()';
    } else if (_start == 0 && _step == 1) {
      return 'range(${_start + _length})';
    } else if (_step == 1) {
      return 'range($_start, ${_start + _length})';
    } else {
      return 'range($_start, ${_start + _step * _length}, $_step)';
    }
  }

}

/**
 * An iterator over an arithmetic progression.
 */
class _RangeIterator extends Iterator<num> {

  final num _start;
  final num _step;
  final int _length;

  int _index = 0;
  num _current;

  _RangeIterator(this._start, this._step, this._length);

  @override
  num get current => _current;

  @override
  bool moveNext() {
    if (_index == _length) {
      _current = null;
      return false;
    } else {
      _current = _start + _step * _index++;
      return true;
    }
  }

}
