import 'interval.dart';

extension LengthIntervalIntExtension on Interval<int> {
  /// Returns the length an [Interval] as [int].
  ///
  /// Returns `0` if the interval is empty or `1` if the interval contains a
  /// single value. Throws an [StateError] if one of  the bounds is unbounded
  /// (infinite).
  int toIntLength() {
    if (isEmpty) {
      return 0;
    } else if (isSingle) {
      return 1;
    } else {
      final lowerEndpoint = lower.isOpen ? lower.endpoint + 1 : lower.endpoint;
      final upperEndpoint = upper.isOpen ? upper.endpoint - 1 : upper.endpoint;
      return comparator(lowerEndpoint, upperEndpoint) < 0
          ? upperEndpoint - lowerEndpoint
          : 0;
    }
  }
}

extension LengthIntervalNumExtension on Interval<num> {
  /// Returns the length an [Interval] as [double].
  ///
  /// Returns `0.0` if the interval is empty or contains a single value. Returns
  /// `double.infinity` if one of the bounds is unbounded (infinite).
  double toDoubleLength() {
    if (isEmpty || isSingle) {
      return 0.0;
    } else if (lower.isUnbounded || upper.isUnbounded) {
      return double.infinity;
    } else {
      return upper.endpoint.toDouble() - lower.endpoint.toDouble();
    }
  }
}
