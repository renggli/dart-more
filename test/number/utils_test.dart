import 'package:checks/checks.dart';
import 'package:more/src/number/utils.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('parseWithUnits', () {
    const units = {'', 'i', 'j', 'k'};

    test('valid simple', () {
      check(parseWithUnits('10', units: units))
          .isNotNull()
          .deepEquals({'': 10});
      check(parseWithUnits('10i', units: units))
          .isNotNull()
          .deepEquals({'i': 10});
      check(parseWithUnits('i', units: units)).isNotNull().deepEquals({'i': 1});
      check(parseWithUnits('+i', units: units))
          .isNotNull()
          .deepEquals({'i': 1});
      check(parseWithUnits('-i', units: units))
          .isNotNull()
          .deepEquals({'i': -1});
    });

    test('valid combination', () {
      check(parseWithUnits('10i - 2', units: units))
          .isNotNull()
          .deepEquals({'i': 10, '': -2});
      check(parseWithUnits('1 + 2i - 3j + 4k', units: units))
          .isNotNull()
          .deepEquals({'': 1, 'i': 2, 'j': -3, 'k': 4});
    });

    test('invalid units and numbers', () {
      check(parseWithUnits('', units: units)).isNull();
      check(parseWithUnits('   ', units: units)).isNull();
      check(parseWithUnits('10x', units: units)).isNull();
      check(parseWithUnits('10i + 5i', units: units)).isNull();
      check(parseWithUnits('foo', units: units)).isNull();
    });
  });
}
