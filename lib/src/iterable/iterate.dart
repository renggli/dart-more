library more.iterable.iterate;

import 'dart:collection';

import 'mixins/infinite.dart';

/// One argument function returning an object of the same type.
typedef E IterateFunction<E>(E value);

/// Returns a lazy infinite list of repeated applications of the
/// [function] to the initial [value].
///
/// For example, the expression
///
///     iterate(0, (n) => n + 1);
///
/// results in the infinite iterable of all natural numbers:
///
///     [0, 1, 2, 3, 4, ...]
///
Iterable<E> iterate<E>(E value, IterateFunction<E> function) {
  return new _IterateIterable<E>(value, function);
}

class _IterateIterable<E> extends IterableBase<E> with InfiniteIterable<E> {
  final E _value;
  final IterateFunction<E> _function;

  _IterateIterable(this._value, this._function);

  @override
  Iterator<E> get iterator => new _IterateIterator<E>(_value, _function);
}

class _IterateIterator<E> extends Iterator<E> {
  final IterateFunction<E> _function;

  E _current;
  E _next;

  _IterateIterator(this._next, this._function);

  @override
  E get current => _current;

  @override
  bool moveNext() {
    _current = _next;
    _next = _function(_next);
    return true;
  }
}
