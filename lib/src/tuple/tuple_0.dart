library more.tuple.tuple_0;

import 'package:more/tuple.dart';

/// Tuple with 0 elements.
class Tuple0 extends Tuple {
  const Tuple0();

  @override
  int get length => 0;

  @override
  Tuple1<T> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple1<T> addLast<T>(T value) => addAt0(value);

  Tuple1<T> addAt0<T>(T value) => Tuple1(value);

  @override
  Tuple removeFirst() => throw StateError('Too few');

  @override
  Tuple removeLast() => throw StateError('Too few');

  @override
  Iterable get iterable sync* {}

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Tuple0);

  @override
  int get hashCode => 2895809587;
}
