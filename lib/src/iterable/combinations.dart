part of iterable;

/**
 * Returns an iterable over the combinations of [elements] of length [count]. The
 * combinations are emitted in lexicographical order based on the input.
 *
 * If [repetitions] is set to `true` the iterable allows individual elements to be
 * repeated more than once. The number of items returned is:
 *
 *     (elements.length + count - 1)! / count! / (elements.length - 1)!
 *
 * The following expression iterates over xx, xy, xz, yy, yz, and zz:
 *
 *     combinations(string('xyz'), 2, repetitions: true);
 *
 * If [repetitions] is set to `false` the iterable generates all the subsequences
 * of length [count]. The number of items returned is:
 *
 *     elements.length! / count! / (elements.length - count)!
 *
 * The following expression iterates over xy, xz, yz:
 *
 *     combinations(string('xyz'), 2, repetitions: false);
 *
 */
Iterable<List/*<E>*/> combinations(Iterable/*<E>*/ elements, int count,
    {bool repetitions: false}) {
  elements = elements.toList(growable: false);
  if (count < 0) {
    throw new RangeError.value(count);
  } else if (!repetitions && elements.length < count) {
    throw new RangeError.range(count, 0, elements.length);
  } else if (count == 0 || elements.isEmpty) {
    return empty();
  } else if (repetitions) {
    return new _CombinationsWithRepetitionsIterable/*<E>*/(elements, count);
  } else {
    return new _CombinationsWithoutRepetitionsIterable/*<E>*/(elements, count);
  }
}

class _CombinationsWithRepetitionsIterable<E> extends IterableBase<List<E>> {

  final List<E> _elements;
  final int _count;

  _CombinationsWithRepetitionsIterable(this._elements, this._count);

  @override
  Iterator<List<E>> get iterator {
    return new _CombinationsWithRepetitionsIterator<E>(_elements, _count);
  }

}

class _CombinationsWithRepetitionsIterator<E> extends Iterator<List<E>> {

  final List<E> _elements;
  final int _count;

  List<int> _state;
  List<E> _current;
  bool _completed = false;

  _CombinationsWithRepetitionsIterator(this._elements, this._count);

  @override
  List<E> get current => _current;

  @override
  bool moveNext() {
    if (_completed) {
      return false;
    } else if (_current == null) {
      _state = new List.filled(_count, 0);
      _current = new List.filled(_count, _elements[0]);
      return true;
    } else {
      for (var i = _count - 1; i >= 0; i--) {
        var index = _state[i] + 1;
        if (index < _elements.length) {
          for (var j = i; j < _count; j++) {
            _state[j] = index;
            _current[j] = _elements[index];
          }
          return true;
        }
      }
      _state = null;
      _current = null;
      _completed = true;
      return false;
    }
  }

}

class _CombinationsWithoutRepetitionsIterable<E> extends IterableBase<List<E>> {

  final List<E> _elements;
  final int _count;

  _CombinationsWithoutRepetitionsIterable(this._elements, this._count);

  @override
  Iterator<List<E>> get iterator {
    return new _CombinationsWithoutRepetitionsIterator<E>(_elements, _count);
  }

}

class _CombinationsWithoutRepetitionsIterator<E> extends Iterator<List<E>> {

  final List<E> _elements;
  final int _count;

  List<int> _state;
  List<E> _current;
  bool _completed = false;

  _CombinationsWithoutRepetitionsIterator(this._elements, this._count);

  @override
  List<E> get current => _current;

  @override
  bool moveNext() {
    if (_completed) {
      return false;
    } else if (_current == null) {
      _state = new List(_count);
      _current = new List(_count);
      for (var i = 0; i < _count; i++) {
        _state[i] = i;
        _current[i] = _elements[i];
      }
      return true;
    } else {
      for (var i = _count - 1; i >= 0; i--) {
        var index = _state[i];
        if (index + _count - i < _elements.length) {
          for (var j = i; j < _count; j++) {
            _state[j] = index + j - i + 1;
            _current[j] = _elements[_state[j]];
          }
          return true;
        }
      }
      _state = null;
      _current = null;
      _completed = true;
      return false;
    }
  }

}
