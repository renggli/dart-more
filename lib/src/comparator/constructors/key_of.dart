import '../modifiers/key_of.dart';
import 'natural.dart';

/// Creates a comparator that compares values of type [T] but delegates the
/// decision to a [Comparable] with the provided [transformation].
Comparator<T> keyOf<T, R extends Comparable<Object?>>(
  R Function(T value) transformation,
) => naturalComparable<R>.keyOf(transformation);

/// Creates a comparator that compares values of type [T] but delegates the
/// decision to a [Comparable] with the provided [transformation].
@Deprecated('Use `keyOf` instead.')
Comparator<T> delegateComparator<T, R extends Comparable<Object?>>(
  R Function(T value) transformation,
) => keyOf<T, R>(transformation);
