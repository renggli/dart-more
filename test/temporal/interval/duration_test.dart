import 'package:checks/checks.dart';
import 'package:more/interval.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('toDuration', () {
    test('single', () {
      final interval = Interval<DateTime>(DateTime(1980, 6, 11));
      final duration = interval.toDuration();
      check(duration).equals(Duration.zero);
    });
    test('range', () {
      final interval = Interval<DateTime>(
        DateTime(2022, 7, 30),
        DateTime(2022, 7, 31),
      );
      check(interval.toDuration().inHours).equals(24);
    });
  });
}
