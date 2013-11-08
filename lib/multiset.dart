// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 * Provides a [Set] like data structure where elements are allowed to
 * appear more than once.
 */
library multiset;

import 'dart:collection';
import 'dart:math';

/**
 * A generalized [Set] (or Bag) in which members are allowed to appear
 * more than once.
 */
class Multiset<E> extends IterableBase<E> {

  /**
   * Creates an empty [Multiset].
   */
  factory Multiset() => new Multiset<E>._(new Map<E, int>());

  /**
   * Creates an empty identity [Multiset].
   */
  factory Multiset.identity() => new Multiset<E>._(new Map<E, int>.identity());

  /**
   * Creates a multiset that contains all elements of [other].
   */
  factory Multiset.from(Iterable<E> other) {
    if (other is Multiset<E>) {
      return new Multiset<E>._(new Map.from(other._container));
    } else {
      return new Multiset<E>()..addAll(other);
    }
  }

  final Map<E, int> _container;

  Multiset._(this._container);

  /**
   * Adds [element] to the receiver [occurrences] number of times.
   *
   * Throws an [ArgumentError] if [occurences] is negative.
   */
  void add(E element, [int occurences = 1]) {
    if (occurences < 0) {
      throw new ArgumentError('Negative number of occurences');
    } else if (occurences > 0) {
      _container[element] = this[element] + occurences;
    }
  }

  /**
   * Adds all of [elements] to the receiver.
   */
  void addAll(Iterable<E> elements) {
    elements.forEach(add);
  }

  /**
   * Removes [element] from the receiver [occurrences] number of times.
   *
   * Throws an [ArgumentError] if [occurences] is negative.
   */
  void remove(Object element, [int occurences = 1]) {
    if (occurences < 0) {
      throw new ArgumentError('Negative number of occurences');
    } else if (occurences > 0) {
      var current = this[element];
      if (current <= occurences) {
        _container.remove(element);
      } else {
        _container[element] = current - occurences;
      }
    }
  }

  /**
   * Removes each element of [elements] from the receiver.
   */
  void removeAll(Iterable<Object> elements) {
    elements.forEach(remove);
  }

  /**
   * Removes all elements from the receiver.
   */
  void clear() => _container.clear();

  /**
   * Gets the number of occurences of an [element].
   */
  int operator [] (Object element) {
    return _container.containsKey(element) ? _container[element] : 0;
  }

  /**
   * Sets the number of [occurences] of an [element].
   *
   * Throws an [ArgumentError] if [occurences] is negative.
   */
  void operator []= (E element, int occurences) {
    if (occurences < 0) {
      throw new ArgumentError('Negative number of occurences');
    } else if (occurences > 0) {
      _container[element] = occurences;
    } else {
      _container.remove(element);
    }
  }

  /**
   * Returns true if [element] is in the receiver.
   */
  @override
  bool contains(Object element) => _container.containsKey(element);

  /**
   * Returns a new [Multiset] with the elements that are in the receiver as well
   * as those in [other].
   */
  Multiset<E> intersection(Multiset<Object> other) {
    var result = new Multiset<E>();
    for (var element in _container.keys) {
      result.add(element, min(this[element], other[element]));
    }
    return result;
  }

  /**
   * Returns a new [Multiset] with all the elements of the receiver and those
   * in [other].
   */
  Multiset<E> union(Multiset<E> other) {
    return new Multiset<E>.from(this)..addAll(other);
  }

  /**
   * Returns a new [Multiset] with all the elements of the receiver that are
   * not in [other].
   */
  Multiset<E> difference(Multiset<E> other) {
    return new Multiset<E>.from(this)..removeAll(other);
  }

  /**
   * Iterator over the repeated elements of the reciever.
   */
  @override
  Iterator<E> get iterator => new _MultisetIterator<E>(this._container, distinct.iterator);

  /**
   * The distinct elements of the receiver.
   */
  Iterable<E> get distinct => _container.keys;

  @override
  int get length => _container.values.fold(0, (a, b) => a + b);

  @override
  bool get isEmpty => _container.isEmpty;

}

class _MultisetIterator<E> extends Iterator<E> {

  final Map<E, int> _container;
  final Iterator<E> _elements;

  int _remaining = 0;

  _MultisetIterator(this._container, this._elements);

  @override
  bool moveNext() {
    if (_remaining > 0) {
      _remaining--;
      return true;
    } else {
      if (!_elements.moveNext()) {
        return false;
      }
      _remaining = _container[_elements.current] - 1;
      return true;
    }
  }

  @override
  E get current => _elements.current;

}