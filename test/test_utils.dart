import 'package:checks/context.dart';
import 'package:more/number.dart';

/// Default tolerance for approximate comparisons.
const defaultEpsilon = 1.0e-5;

/// Extension on [Subject] of [num] providing approximate equality checks.
extension CloseToNumChecks<T extends num> on Subject<T> {
  /// Asserts that the numeric value is within [delta] of [expected].
  void isCloseTo(num expected, [num delta = defaultEpsilon]) {
    context.expect(() => ['is within $delta of $expected'], (actual) {
      final diff = (actual - expected).abs();
      if (diff <= delta) return null;
      return Rejection(which: ['differs by $diff']);
    });
  }

  /// Asserts that the numeric value is relatively close to [expected] within [epsilon].
  void isRelativeCloseTo(num expected, num epsilon) {
    context.expect(
      () => ['is relatively close to $expected (epsilon $epsilon)'],
      (actual) {
        final difference = (expected - actual).abs();
        final relative = difference > 0 ? difference / actual : 0;
        if (relative <= epsilon) return null;
        return Rejection(which: ['differs by relative error $relative']);
      },
    );
  }
}

/// Extension on [Subject] of [CloseTo] providing approximate equality checks.
extension CloseToChecks<T extends CloseTo<T>> on Subject<T> {
  /// Asserts that the value is close to [other] within [delta].
  void isCloseTo(T other, [num delta = defaultEpsilon]) {
    context.expect(() => ['is close to $other with epsilon $delta'], (actual) {
      if (actual.closeTo(other, delta)) return null;
      return Rejection(which: ['was $actual']);
    });
  }
}
