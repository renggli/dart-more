part of monad;

/**
 * The list monad.
 */
class Many<T> extends Object with IterableMixin<T> implements Monad<T> {

  final Iterable<T> _values;

  factory Many.fromValue(T value) => new Many._([value]);

  factory Many.fromIterable(Iterable<T> values) => new Many._(values.toList(growable: false));

  Many._(this._values);

  @override
  Many then(function(T value)) => new Many.fromIterable(_values.expand(function));

  @override
  Iterator<T> get iterator => _values.iterator;

  @override
  int get length => _values.length;

  @override
  bool get isEmpty => _values.isEmpty;

  @override
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  T elementAt(int index) => _values.elementAt(index);

  @override
  String toString() => 'Many.fromIterable($_values)';

}