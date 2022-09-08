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

  /// The step size (non-zero).
  T get step;

  @override
  bool contains(Object? element) => indexOf(element) >= 0;

  @override
  int indexOf(Object? element, [int startIndex = 0]);

  @override
  int lastIndexOf(Object? element, [int? endIndex]) {
    // Since elements appear only once, we can use `indexOf`.
    final index = indexOf(element);
    return 0 <= index && index <= (endIndex ?? length - 1) ? index : -1;
  }

  @override
  Range<T> get reversed;

  @override
  Range<T> sublist(int startIndex, [int? endIndex]) =>
      getRange(startIndex, endIndex ?? length);

  @override
  Range<T> getRange(int startIndex, int endIndex);
}
