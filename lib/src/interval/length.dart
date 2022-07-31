import 'interval.dart';

extension LengthIntervalNumExtension on Interval<num> {
  /// Returns the length an [Interval] as [int].
  ///
  /// Returns `0` if the interval is empty or `1` if the interval contains a
  /// single value. Throws an [ArgumentError] if one of  the bounds is unbounded
  /// (infinite).
  int toIntLength() {
    if (isEmpty) {
      return 0;
    } else if (isSingle) {
      return 1;
    } else if (lower.isUnbounded || upper.isUnbounded) {
      throw ArgumentError.value(this, 'interval', 'Interval is unbounded');
    } else {
      var lowerEndpoint = lower.endpoint!.ceil();
      if (lower.isOpen && lowerEndpoint == lower.endpoint) lowerEndpoint++;
      var upperEndpoint = upper.endpoint!.truncate();
      if (upper.isOpen && upperEndpoint == upper.endpoint) upperEndpoint--;
      return lowerEndpoint < upperEndpoint ? upperEndpoint - lowerEndpoint : 0;
    }
  }

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
      return upper.endpoint!.toDouble() - lower.endpoint!.toDouble();
    }
  }
}
