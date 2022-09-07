/// Abstract superclass of an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a sequence of values of type [T] as a [List].
/// The advantage is that a range uses little memory no matter its size.
abstract class Range<T> implements List<T> {
  /// The (inclusive) start value of the range .
  T get start;

  /// The (exclusive) end value of the range.
  T get end;

  /// The step size.
  T get step;

  /// A [Range] in reverse order.
  @override
  Range<T> get reversed;
}
