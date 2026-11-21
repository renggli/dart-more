import 'dart:collection' show IterableBase, UnmodifiableMapView;
import 'dart:math' show min;

import 'iterable/repeat_element.dart';

/// A generalized [Set] (or Bag) in which members are allowed to appear more
/// than once.
class Multiset<E> extends IterableBase<E> {
  /// Creates an empty [Multiset].
  factory() => Multiset<E>._({}, 0, isIdentity: false);

  /// Creates an empty identity [Multiset].
  factory identity() =>
      Multiset<E>._(Map<E, int>.identity(), 0, isIdentity: true);

  /// Creates a [Multiset] that contains all elements of [other].
  factory of(Iterable<E> other) {
    if (other is Multiset<E> && !other._isIdentity) {
      return Multiset<E>._(
        Map<E, int>.of(other._container),
        other._length,
        isIdentity: false,
      );
    }
    return Multiset<E>()..addAll(other);
  }

  /// Creates a [Multiset] that contains all elements of [other].
  factory from(Iterable<E> other) => Multiset.of(other);

  /// Creates a [Multiset] where the elements and their occurrence count is
  /// computed from an [iterable].
  ///
  /// The [key] function specifies the actual elements added to the collection.
  /// The default implementation is the identity function. Repetitions are
  /// possible and merge into the previously added elements.
  ///
  /// The [count] function specifies the number of elements added to the
  /// collection. The default function returns the constant `1`. Throws an
  /// [ArgumentError] if [count] returns a negative value.
  factory fromIterable(
    Iterable<Object?> iterable, {
    E Function(Object? element)? key,
    int Function(Object? element)? count,
  }) {
    final result = Multiset<E>();
    key ??= (element) => element as E;
    count ??= (element) => 1;
    for (final element in iterable) {
      result.add(key(element), count(element));
    }
    return result;
  }

  /// Internal constructor.
  new _(this._container, this._length, {required this._isIdentity});

  /// Internal backing container of the set.
  final Map<E, int> _container;

  /// Internal cache of the size of the set.
  int _length;

  final bool _isIdentity;

  Multiset<E> _createEmpty() =>
      _isIdentity ? Multiset<E>.identity() : Multiset<E>();

  Multiset<E> _clone() => _isIdentity
      ? Multiset<E>._(
          Map<E, int>.identity()..addAll(_container),
          _length,
          isIdentity: true,
        )
      : Multiset<E>._(Map<E, int>.of(_container), _length, isIdentity: false);

  /// Adds [element] to the receiver [occurrences] number of times.
  ///
  /// Throws an [ArgumentError] if [occurrences] is negative.
  void add(E element, [int occurrences = 1]) {
    if (occurrences < 0) {
      throw ArgumentError.value(
        occurrences,
        'occurrences',
        'Negative number of occurrences',
      );
    } else if (occurrences > 0) {
      _container[element] = (_container[element] ?? 0) + occurrences;
      _length += occurrences;
    }
  }

  /// Adds all of [elements] to the receiver.
  void addAll(Iterable<E> elements) {
    if (identical(elements, this)) {
      _container.updateAll((_, count) => count * 2);
      _length *= 2;
      return;
    }
    if (elements is Multiset<E>) {
      for (final entry in elements._container.entries) {
        add(entry.key, entry.value);
      }
      return;
    }
    for (final element in elements) {
      add(element);
    }
  }

  /// Removes [element] from the receiver [occurrences] number of times.
  ///
  /// Throws an [ArgumentError] if [occurrences] is negative.
  void remove(Object? element, [int occurrences = 1]) {
    if (occurrences < 0) {
      throw ArgumentError.value(
        occurrences,
        'occurrences',
        'Negative number of occurrences',
      );
    }
    if (occurrences > 0) {
      final current = _container[element];
      if (current == null) return;
      if (current <= occurrences) {
        _container.remove(element);
        _length -= current;
      } else {
        final key = element is E
            ? element
            : _container.keys.firstWhere((k) => k == element);
        _container[key] = current - occurrences;
        _length -= occurrences;
      }
    }
  }

  /// Removes each element of [elements] from the receiver.
  void removeAll(Iterable<Object?> elements) {
    if (identical(elements, this)) {
      clear();
      return;
    }
    if (elements is Multiset) {
      for (final entry in elements._container.entries) {
        remove(entry.key, entry.value);
      }
      return;
    }
    for (final element in elements) {
      remove(element);
    }
  }

  /// Removes all elements from the receiver.
  void clear() {
    _container.clear();
    _length = 0;
  }

  /// Gets the number of occurrences of an [element].
  int operator [](Object? element) => _container[element] ?? 0;

  /// Sets the number of [occurrences] of an [element].
  ///
  /// Throws an [ArgumentError] if [occurrences] is negative.
  void operator []=(E element, int occurrences) {
    if (occurrences < 0) {
      throw ArgumentError.value(
        occurrences,
        'occurrences',
        'Negative number of occurrences',
      );
    } else {
      final current = _container[element] ?? 0;
      if (occurrences > 0) {
        _container[element] = occurrences;
        _length += occurrences - current;
      } else if (current > 0) {
        _container.remove(element);
        _length -= current;
      }
    }
  }

  /// Returns `true` if [element] is in the receiver.
  @override
  bool contains(Object? element) => _container.containsKey(element);

  /// Returns `true` if all elements of [other] are contained in the receiver.
  bool containsAll(Iterable<Object?> other) {
    if (other is Multiset) {
      if (_length < other._length) return false;
      if (other._isIdentity == _isIdentity) {
        for (final entry in other._container.entries) {
          if (this[entry.key] < entry.value) {
            return false;
          }
        }
        return true;
      }
    }
    final counts = _isIdentity
        ? Map<Object?, int>.identity()
        : <Object?, int>{};
    for (final element in other) {
      final available = this[element];
      if (available == 0) return false;
      final needed = (counts[element] ?? 0) + 1;
      if (needed > available) return false;
      counts[element] = needed;
    }
    return true;
  }

  /// Returns a new [Multiset] by evaluating [callback] element-wise for each
  /// distinct element of `this` and [other].
  ///
  /// Throws an [ArgumentError] if [callback] returns a negative count.
  Multiset<E> combine(
    Iterable<E> other,
    int Function(E element, int a, int b) callback,
  ) {
    if (other is Multiset<E> && other._isIdentity == _isIdentity) {
      final result = _createEmpty();
      for (final entry in _container.entries) {
        result.add(
          entry.key,
          callback(entry.key, entry.value, other[entry.key]),
        );
      }
      for (final entry in other._container.entries) {
        if (!_container.containsKey(entry.key)) {
          result.add(entry.key, callback(entry.key, 0, entry.value));
        }
      }
      return result;
    } else {
      final otherSet = _createEmpty()..addAll(other);
      return combine(otherSet, callback);
    }
  }

  /// Returns a new [Multiset] with the elements that are in the receiver as
  /// well as those in [other].
  Multiset<E> intersection(Iterable<Object?> other) {
    final result = _createEmpty();
    if (isEmpty) return result;
    if (other is Multiset && other._isIdentity == _isIdentity) {
      for (final entry in _container.entries) {
        final otherCount = other[entry.key];
        if (otherCount > 0) {
          result.add(entry.key, min(entry.value, otherCount));
        }
      }
      return result;
    }
    for (final element in other) {
      final limit = this[element];
      if (limit > 0) {
        final current = result[element];
        if (current < limit) {
          final key = element is E
              ? element
              : _container.keys.firstWhere((k) => k == element);
          result.add(key);
        }
      }
    }
    return result;
  }

  /// Returns a new [Multiset] with all the elements of the receiver and those
  /// in [other].
  Multiset<E> union(Iterable<E> other) => _clone()..addAll(other);

  /// Returns a new [Multiset] with all the elements of the receiver that are
  /// not in [other].
  Multiset<E> difference(Iterable<Object?> other) => _clone()..removeAll(other);

  /// Iterator over the repeated elements of the receiver.
  @override
  Iterator<E> get iterator => _container.entries
      .expand((entry) => repeat(entry.key, count: entry.value))
      .iterator;

  /// Returns an unmodifiable view of the underlying data in a [Map] with the
  /// elements as the key and their counts as the value.
  Map<E, int> asMap() => UnmodifiableMapView<E, int>(_container);

  /// Returns an iterable over the distinct elements `key` and their respective
  /// count `value`.
  Iterable<MapEntry<E, int>> get entrySet => _container.entries;

  /// Returns an iterable over the distinct elements of the receiver.
  Iterable<E> get elementSet => _container.keys;

  /// Returns an iterable over the counts of the distinct elements of the
  /// receiver.
  Iterable<int> get elementCounts => _container.values;

  /// Returns an iterable over the distinct elements of the receiver.
  @Deprecated('Use `elementSet` instead.')
  Iterable<E> get distinct => _container.keys;

  /// Returns an iterable over the counts of the distinct elements of the
  /// receiver.
  @Deprecated('Use `elementCounts` instead.')
  Iterable<int> get counts => _container.values;

  /// Returns the total number of elements in the receiver.
  @override
  int get length => _length;

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length > 0;

  @override
  E get first =>
      _length == 0 ? throw StateError('No element') : _container.keys.first;

  @override
  E get last =>
      _length == 0 ? throw StateError('No element') : _container.keys.last;

  @override
  E get single {
    if (_length == 0) throw StateError('No element');
    if (_length > 1) throw StateError('Too many elements');
    return _container.keys.first;
  }

  @override
  E elementAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', _length);
    var remaining = index;
    for (final entry in _container.entries) {
      if (remaining < entry.value) return entry.key;
      remaining -= entry.value;
    }
    throw RangeError.index(index, this, 'index', null, _length);
  }

  @override
  Set<E> toSet() => _isIdentity
      ? (Set<E>.identity()..addAll(_container.keys))
      : Set<E>.of(_container.keys);
}

/// Extension on [Iterable] to convert to a [Multiset].
extension MultisetExtension<T> on Iterable<T> {
  /// Converts this [Iterable] to a [Multiset].
  Multiset<T> toMultiset() => Multiset.of(this);
}
