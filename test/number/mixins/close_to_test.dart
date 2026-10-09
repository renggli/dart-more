import 'package:checks/checks.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

class _CustomCloseTo with CloseTo<_CustomCloseTo> {
  new(this.value);

  final num value;

  @override
  bool closeTo(_CustomCloseTo other, num epsilon) =>
      value.closeTo(other.value, epsilon);
}

void main() {
  group('CloseTo', () {
    test('custom implementation', () {
      final a = _CustomCloseTo(10);
      final b = _CustomCloseTo(10.05);
      check(a.closeTo(b, 0.1)).isTrue();
      check(a.closeTo(b, 0.01)).isFalse();
    });
    group('num', () {
      test('int', () {
        check(1.closeTo(1, 0)).isTrue();
        check(1.closeTo(2, 0)).isFalse();
        check(2.closeTo(1, 0)).isFalse();
        check(1.closeTo(2, 2)).isTrue();
        check(2.closeTo(1, 2)).isTrue();
      });
      test('double', () {
        check(1.25.closeTo(1.26, 0.1)).isTrue();
        check(1.26.closeTo(1.25, 0.1)).isTrue();
        check(1.11.closeTo(1.22, 0.1)).isFalse();
        check(1.22.closeTo(1.11, 0.1)).isFalse();
        check(double.nan.closeTo(double.nan, 0.1)).isFalse();
        check(double.infinity.closeTo(double.infinity, 0.1)).isFalse();
        check(double.negativeInfinity.closeTo(double.negativeInfinity, 0.1))
            .isFalse();
      });
    });
  });
}
