extension StatisticsIterableExtension on Iterable<num> {
  /// Returns the sum of the values in this [Iterable].
  num sum() {
    num result = 0;
    for (final value in this) {
      result += value;
    }
    return result;
  }

  /// Returns the product of the values in this [Iterable].
  num product() {
    num result = 1;
    for (final value in this) {
      result *= value;
    }
    return result;
  }

  /// Returns the arithmetic mean of the values in this [Iterable].
  double mean() {
    var count = 0;
    num total = 0;
    for (final value in this) {
      count++;
      total += value;
    }
    if (count == 0) {
      throw StateError('Cannot compute the mean of an empty iterable.');
    }
    return total / count;
  }

  /// Returns the median of the values in this [Iterable].
  num median() {
    final values = toList()..sort();
    if (values.isEmpty) {
      throw StateError('Cannot compute the median of an empty iterable.');
    }
    final middle = values.length ~/ 2;
    return values.length.isOdd
        ? values[middle]
        : (values[middle - 1] + values[middle]) / 2;
  }

  /// Returns the most frequent values in this [Iterable].
  ///
  /// If multiple values appear with the same highest frequency, all modes are
  /// returned in the order in which they first appear.
  ///
  /// ```dart
  /// [1, 4, 6, 1, 6].mode(); // [1, 6]
  /// ```
  List<num> mode() {
    final counts = <num, int>{};
    var maxCount = 0;
    for (final value in this) {
      final count = (counts[value] ?? 0) + 1;
      counts[value] = count;
      if (count > maxCount) {
        maxCount = count;
      }
    }
    if (maxCount == 0) {
      throw StateError('Cannot compute the mode of an empty iterable.');
    }
    final result = <num>[];
    for (final entry in counts.entries) {
      if (entry.value == maxCount) {
        result.add(entry.key);
      }
    }
    return result;
  }
}
