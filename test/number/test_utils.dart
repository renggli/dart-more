import 'package:checks/context.dart';
import 'package:more/number.dart';

const epsilon = 1e-5;

extension CloseToExtension<T extends CloseTo<T>> on Subject<T> {
  void isCloseTo(T other, [num delta = epsilon]) {
    context.expect(() => ['is close to $other with epsilon $delta'], (actual) {
      if (actual.closeTo(other, delta)) return null;
      return Rejection(which: ['was $actual']);
    });
  }
}

extension CloseToNumChecks<T extends num> on Subject<T> {
  void isCloseTo(num expected, [num delta = epsilon]) {
    context.expect(() => ['is within $delta of $expected'], (actual) {
      final diff = (actual - expected).abs();
      if (diff <= delta) return null;
      return Rejection(which: ['differs by $diff']);
    });
  }
}
