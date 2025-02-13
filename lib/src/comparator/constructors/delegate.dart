import '../modifiers/result_of.dart';
import 'natural.dart';

/// Creates a comparator that compares values of type [T] but delegates the
/// decision to a [Comparable<R>] with the provided [transformation].
Comparator<T> delegateComparator<T, R extends Comparable<R>>(
  R Function(T value) transformation,
) => naturalComparable<R>.onResultOf(transformation);
