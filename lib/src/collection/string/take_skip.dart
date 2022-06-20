import 'dart:math';

extension TakeSkipStringExtension on String {
  /// Returns the string prefix with [count] characters. If [count] is larger
  /// than [length] return the whole string.
  String take(int count) => substring(0, min(count, length));

  /// Returns the string prefix up to the first occurrence of [pattern]. If the
  /// pattern is not found return the whole string.
  String takeTo(String pattern) {
    final index = indexOf(pattern);
    return index < 0 ? substring(0) : substring(0, index);
  }

  /// Returns the string suffix with [count] characters. If [count] is larger
  /// than [length] return the whole string.
  String takeLast(int count) => substring(max(length - count, 0));

  /// Returns the string suffix up to the last occurrence of [pattern]. If the
  /// pattern is not found return the whole string.
  String takeLastTo(String pattern) {
    final index = lastIndexOf(pattern);
    return index < 0 ? substring(0) : substring(index + pattern.length);
  }

  /// Returns the string suffix without the first [count] characters. If [count]
  /// is larger than [length] return the empty string.
  String skip(int count) => substring(min(count, length));

  /// Returns the string suffix after the first occurrence of [pattern]. If the
  /// pattern is not found return the empty string.
  String skipTo(String pattern) {
    final index = indexOf(pattern);
    return index < 0 ? substring(0, 0) : substring(index + pattern.length);
  }

  /// Returns the string prefix without the last [count] characters. If [count]
  /// is larger than [length] return the empty string.
  String skipLast(int count) => substring(0, max(length - count, 0));

  /// Returns the string prefix before the last occurrence of [pattern]. If the
  /// pattern is not found return the empty string.
  String skipLastTo(String pattern) {
    final index = lastIndexOf(pattern);
    return index < 0 ? substring(0, 0) : substring(0, index);
  }
}
