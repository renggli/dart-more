// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 * Some fancy iterables.
 */
library iterable;

import 'dart:collection';

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
  Iterator<int> get iterator {
    return new _FibonacciIterator(2 * _f0 - _f1, _f1 - _f0);
  }
}

class _FibonacciIterator extends Iterator<int> {
  int _previous, _current;
  _FibonacciIterator(this._previous, this._current);
  int get current => _current;
  bool moveNext() {
    var temporary = _previous;
    _previous = _current;
    _current += temporary;
    return true;
  }
}

/**
 * Returns an iterable over the lexographic permutations of [list] using
 * the optional [comparator].
 */
Iterable<List> permutations(List list, [Comparator comparator]) {
  return new _PermutationIterable(list, comparator != null
      ? comparator : Comparable.compare);
}

class _PermutationIterable extends IterableBase<List> {
  final List _list;
  final Comparator _comparator;
  _PermutationIterable(this._list, this._comparator);
  Iterator<List> get iterator {
    return new _PermutationIterator(_list, _comparator);
  }
}

class _PermutationIterator extends Iterator<List> {
  final List _list;
  final Comparator _comparator;
  List _current;
  bool _completed = false;
  _PermutationIterator(this._list, this._comparator);
  List get current => _current;
  bool moveNext() {
    if (_completed) {
      return false;
    } else if (_current == null) {
      _current = new List.from(_list, growable: false);
      return true;
    }
    var k = _current.length - 2;
    while (k >= 0 && _comparator(_current[k], _current[k + 1]) >= 0) {
      k--;
    }
    if (k == -1) {
      _completed = true;
      _current = null;
      return false;
    }
    var l = _current.length - 1;
    while (_comparator(_current[k], _current[l]) >= 0) {
      l--;
    }
    _swap(k, l);
    for (var i = k + 1, j = _current.length - 1; i < j; i++, j--) {
      _swap(i, j);
    }
    return true;
  }
  void _swap(int i, int j) {
    var temp = _current[i];
    _current[i] = _current[j];
    _current[j] = temp;
  }
}