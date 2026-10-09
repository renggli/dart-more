import 'package:checks/context.dart';

const epsilon = 1.0e-6;

extension CloseToChecks<T extends num> on Subject<T> {
  void isCloseTo(num expected, [num delta = epsilon]) {
    context.expect(() => ['is within $delta of $expected'], (actual) {
      final diff = (actual - expected).abs();
      if (diff <= delta) return null;
      return Rejection(which: ['differs by $diff']);
    });
  }
}
