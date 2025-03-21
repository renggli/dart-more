import '../modifiers/key_of.dart';
import 'natural.dart';

/// Creates a comparator that compares values of type [T] but delegates the
/// decision to a [Comparable<R>] with the provided [transformation].
Comparator<T> keyOf<T, R extends Comparable<R>>(
  R Function(T value) transformation,
) => naturalComparable<R>.keyOf(transformation);

/// Creates a comparator that compares values of type [T] but delegates the
/// decision to a [Comparable<R>] with the provided [transformation].
@Deprecated('Use `keyOf` instead.')
Comparator<T> delegateComparator<T, R extends Comparable<R>>(
  R Function(T value) transformation,
) => keyOf<T, R>(transformation);
