// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library range;

import 'dart:collection';

/**
 * Creates a virtual range of numbers containing an arithmetic progressions.
 *
 * The implementation closely follows the semantics of the range object known
 * in [Python](http://goo.gl/XVdjp).
 *
 * The range function called without any arguments returns the empty range.
 * For example, `range()` yields `[]`.
 *
 * The range function called with one argument returns the range of all
 * integers up to but not including the given integer. For example, `range(3)`
 * yields `[0, 1, 2]`.
 *
 * The range function called with two arguments returns the range between
 * the two integers (including the start, but excluding the end). For example,
 * `range(3, 6)` yields `[3, 4, 5]`.
 *
 * The range function called with tree arguments returns the range between
 * the first two integers (including the start, but excluding the end) and the
 * step value. For example, `range(2, 7, 2)` yields `[2, 4, 6]`.
 */
List<int> range([int a, int b, int c]) {
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
    throw new ArgumentError('Negative step-size expected');
  } else if (start > stop && step > 0) {
    throw new ArgumentError('Positive step-size expected');
  }
  var length = (stop - start) ~/ step;
  if ((stop - start) % step > 0) length++;
  return new _RangeList(start, step, length);
}

/**
 * List of integers following an arithmetic progression.
 */
class _RangeList extends ListBase<int> implements List<int> {

  final int _start;
  final int _step;
  final int _length;

  _RangeList(this._start, this._step, this._length);

  Iterator<int> get iterator {
    return new _RangeIterator(_start, _step, _length);
  }

  int get length => _length;

  int operator [] (int index) {
    if (0 <= index && index < _length) {
      return _start + _step * index;
    } else {
      throw new RangeError.value(index);
    }
  }

  _RangeList sublist(int start, [int end]) {
    if (end == null) {
      end = length - 1;
    }
    return new _RangeList(_start + start * _step, end - start, _step);
  }

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
class _RangeIterator extends Iterator<int> {

  final int _start;
  final int _step;
  final int _length;

  int _index = 0;
  int _current;

  _RangeIterator(this._start, this._step, this._length);

  int get current => _current;

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
