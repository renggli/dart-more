import 'package:checks/checks.dart';
import 'package:more/number.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

class _CustomCloseTo implements CloseTo<_CustomCloseTo> {
  const new(this.value);

  final double value;

  @override
  bool closeTo(_CustomCloseTo other, num epsilon) =>
      (value - other.value).abs() <= epsilon;

  @override
  String toString() => '_CustomCloseTo($value)';
}

void main() {
  group('CloseToNumChecks', () {
    test('isCloseTo passes', () {
      check(1.0).isCloseTo(1.000001);
      check(1.0).isCloseTo(1.05, 0.1);
    });

    test('isCloseTo fails', () {
      check(() => check(1.0).isCloseTo(1.1)).throws<TestFailure>();
    });

    test('isRelativeCloseTo passes', () {
      check(100.0).isRelativeCloseTo(101.0, 0.02);
      check(0.0).isRelativeCloseTo(0.0, 0.01);
    });

    test('isRelativeCloseTo fails', () {
      check(() => check(100.0).isRelativeCloseTo(110.0, 0.05))
          .throws<TestFailure>();
    });
  });

  group('CloseToChecks', () {
    test('isCloseTo passes', () {
      check(const _CustomCloseTo(1.0))
          .isCloseTo(const _CustomCloseTo(1.000001));
      check(const _CustomCloseTo(1.0))
          .isCloseTo(const _CustomCloseTo(1.05), 0.1);
    });

    test('isCloseTo fails', () {
      check(
        () =>
            check(const _CustomCloseTo(1.0))
                .isCloseTo(const _CustomCloseTo(1.1)),
      ).throws<TestFailure>();
    });
  });
}
