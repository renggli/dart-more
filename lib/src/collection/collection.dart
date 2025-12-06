import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// A mutable collection interface exposing the common operations of [List] and
/// [Set].
///
/// This interface bridges the gap between [Iterable], which is read-only, and
/// mutable collections like [List] and [Set] by exposing the shared methods for
/// modification: [add], [addAll], and [remove].
abstract class Collection<E> extends DelegatingIterable<E> {
  /// Constructs a [Collection] wrapping a [List].
  factory Collection.forList([List<E>? list]) => _ListCollection(list ?? <E>[]);

  /// Constructs a [Collection] wrapping a [Set].
  factory Collection.forSet([Set<E>? set]) => _SetCollection(set ?? <E>{});

  /// Constructor for use by subclasses.
  @protected
  Collection(super.base);

  /// Adds [value] to the collection.
  void add(E value);

  /// Adds all [values] to the collection.
  void addAll(Iterable<E> values);

  /// Removes [value] from the collection.
  ///
  /// Returns `true` if [value] was in the collection, and `false` if not.
  /// The method has no effect if [value] was not in the collection.
  bool remove(Object? value);

  /// Removes all elements from the collection.
  void clear();
}

class _ListCollection<E> extends Collection<E> {
  _ListCollection(this._list) : super(_list);

  final List<E> _list;

  @override
  void add(E value) => _list.add(value);

  @override
  void addAll(Iterable<E> values) => _list.addAll(values);

  @override
  bool remove(Object? value) => _list.remove(value);

  @override
  void clear() => _list.clear();
}

class _SetCollection<E> extends Collection<E> {
  _SetCollection(this._set) : super(_set);

  final Set<E> _set;

  @override
  void add(E value) => _set.add(value);

  @override
  void addAll(Iterable<E> values) => _set.addAll(values);

  @override
  bool remove(Object? value) => _set.remove(value);

  @override
  void clear() => _set.clear();
}
