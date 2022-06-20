import 'dart:math';

extension TakeSkipStringExtension on String {
  /// Returns all but the first [count] characters.
  String skip(int count) => substring(min(count, length), length);

  /// Returns the first [count] characters.
  String take(int count) => substring(0, min(count, length));

  /// Returns all but the last [count] characters.
  String skipLast(int count) => substring(0, max(length - count, 0));

  /// Returns the last [count] characters.
  String takeLast(int count) => substring(max(length - count, 0), length);
}
