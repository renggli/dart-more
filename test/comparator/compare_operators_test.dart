import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

class _Box with CompareOperators<_Box> implements Comparable<_Box> {
  const new(this.value);

  final int value;

  @override
  int compareTo(_Box other) => value.compareTo(other.value);
}

void main() {
  group('compare operators', () {
    const b1 = _Box(1);
    const b2 = _Box(2);
    const b1b = _Box(1);

    test('less than', () {
      check(b1 < b2).isTrue();
      check(b2 < b1).isFalse();
      check(b1 < b1b).isFalse();
    });

    test('less than or equal', () {
      check(b1 <= b2).isTrue();
      check(b2 <= b1).isFalse();
      check(b1 <= b1b).isTrue();
    });

    test('greater than', () {
      check(b2 > b1).isTrue();
      check(b1 > b2).isFalse();
      check(b1 > b1b).isFalse();
    });

    test('greater than or equal', () {
      check(b2 >= b1).isTrue();
      check(b1 >= b2).isFalse();
      check(b1 >= b1b).isTrue();
    });
  });
}
