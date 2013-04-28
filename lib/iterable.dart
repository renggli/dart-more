// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 * Some fancy iterables.
 */
library iterable;

import 'dart:collection';

/**
 * Returns an iterable over the fibonacci sequence starting with starting
 * with [f0] and [f1]. The default sequence is indefinitely long and by
 * default starts with 0, 1, 1, 2, 3, 5, 8, 13, ...
 */
Iterable<int> fib([int f0 = 0, int f1 = 1]) {
  return new _FibonacciIterable(f0, f1);
}

class _FibonacciIterable extends IterableBase<int> {
  final int _f0, _f1;
  _FibonacciIterable(this._f0, this._f1);
  Iterator<int> get iterator {
    return new _FibonacciIterator(2 * _f0 - _f1, _f1 - _f0);
  }
}

class _FibonacciIterator extends Iterator<int> {
  int _prev, _curr;
  _FibonacciIterator(this._prev, this._curr);
  int get current => _curr;
  bool moveNext() {
    var temp = _prev;
    _prev = _curr;
    _curr += temp;
    return true;
  }
}
