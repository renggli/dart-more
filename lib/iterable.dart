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

  @override
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

  @override
  List get current => _current;

  @override
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

/**
 * Returns an iterable view on the characters of a [string]. For a mutable
 * copy of the string see [mutableString(String)].
 */
Iterable<String> string(String string) {
  return string.codeUnits.map((code) => new String.fromCharCode(code));
}

/**
 * Returns a mutable list of the characters of a [string].
 */
List<String> mutableString(String string, { growable: true }) {
  return new _MutableString(new List.from(string.codeUnits, growable: growable));
}

class _MutableString extends ListBase<String> {

  final List<int> _codeUnits;

  _MutableString(this._codeUnits);

  @override
  int get length => _codeUnits.length;

  @override
  void set length(int newLength) {
    _codeUnits.length = newLength;
  }

  @override
  String operator [] (int index) => new String.fromCharCode(_codeUnits[index]);

  @override
  void operator []= (int index, String character) {
    if (character.length == 1) {
      _codeUnits[index] = character.codeUnitAt(0);
    } else {
      throw new ArgumentError('Invalid character: $character');
    }
  }

  @override
  String toString() => new String.fromCharCodes(_codeUnits);

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