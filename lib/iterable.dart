// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library iterable;

import 'dart:collection';

/**
 * Creates sequence of numbers containing an arithmetic progressions.
 *
 * All arguments must be plain integers. If the step argument is omitted, it
 * defaults to 1. The function returns a [List] of plain integers
 * [start, start + step, start + 2 * step, ...]. If step is positive, the last
 * element is the largest start + i * step less than stop; if step is negative,
 * the last element is the smallest start + i * step greater than stop. step
 * must not be zero (or else ArgumentError is raised).
 *
 * @param start start of the sequence (inclusive)
 * @param stop stop of the sequence (exclusive)
 * @param step step of each step.
 */
List range(int start, int stop, {int step}) {
  if (step == null) {
    step = stop < start ? -1 : 1;
  } else if (start < stop && step <= 0) {
    throw new ArgumentError('expect neagtive step $step for range [$start..$stop)');
  } else if (start > stop && step >= 0) {
    throw new ArgumentError('expect positive step $step for range [$start..$stop)');
  }
  return new _RangeList(start, step, (stop - start) ~/ step);
}

/**
 * List over virtual ranges.
 */
class _RangeList extends ListBase<int> implements List<int> {

  final int _start;
  final int _step;
  final int _length;

  _RangeList(this._start, this._step, this._length);

  BidirectionalIterator<int> get iterator {
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

}

/**
 * A bi-directional iterator over numeric ranges.
 */
class _RangeIterator extends BidirectionalIterator<int> {

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

  bool movePrevious() {
    if (_index == -1) {
      _current = null;
      return false;
    } else {
      _current = _start + _step * _index--;
      return true;
    }
  }

}

