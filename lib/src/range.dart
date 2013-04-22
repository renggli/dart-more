part of iterables;

class _RangeList<T extends num> extends ListBase<T> {

  final T _start;
  final T _step;
  final int _length;

  _RangeList(this._start, this._step, this._length);

  Iterator<T> get iterator => new _RangeIterator<T>(_start, _step, _length);

  int get length => _length;

  T operator [] (int index) {
    if (0 <= index && index < _length) {
      return _start + _step * index;
    } else {
      throw new RangeError.value(index);
    }
  }

}

/**
 * A bi-directional iterator over integer ranges.
 */
class _RangeIterator<T extends num> extends BidirectionalIterator<T> {

  final T _start;
  final T _step;
  final int _length;

  int _index;
  T _current;

  _RangeIterator(this._start, this._step, this._length);

  T get current => _current;

  bool moveNext() {
    if (_index == _length) {
      _current = null;
      return false;
    }
    _current = _start + _step * _index;
    _index++;
    return true;
  }

  bool movePrevious() {
    if (_index == -1) {
      _current = null;
      return false;
    }
    _current = _start + _step * _index;
    _index--;
    return true;
  }
}

