import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('human', () {
    group('decimal', () {
      test('default', () {
        final printer = HumanNumberPrinter.decimal();
        check(printer(0)).equals('0');
        check(printer(10)).equals('10');
        check(printer(200)).equals('200');
        check(printer(3000)).equals('3 k');
        check(printer(4e4)).equals('40 k');
        check(printer(-5e5)).equals('-500 k');
        check(printer(-6e6)).equals('-6 M');
        check(printer(7e-7)).equals('700 n');
        check(printer(8e-8)).equals('80 n');
        check(printer(-9e-9)).equals('-9 n');
        check(printer(-1e-10)).equals('-100 p');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.decimal(nan: 'n/a');
        check(printer(double.nan)).equals('n/a');
      });
      test('infinity', () {
        final printer = HumanNumberPrinter.decimal(infinity: 'huge');
        check(printer(double.infinity)).equals('huge');
        check(printer(double.negativeInfinity)).equals('-huge');
      });
      test('precision', () {
        final printer = HumanNumberPrinter.decimal(precision: 1);
        check(printer(0)).equals('0');
        check(printer(27)).equals('27');
        check(printer(999)).equals('999');
        check(printer(1000)).equals('1.0 k');
        check(printer(1023)).equals('1.0 k');
        check(printer(1024)).equals('1.0 k');
        check(printer(1728)).equals('1.7 k');
        check(printer(1855425871872)).equals('1.9 T');
      });
      test('unitPrecision', () {
        final printer = HumanNumberPrinter.decimal(
          precision: 2,
          unitPrecision: 1,
        );
        check(printer(0)).equals('0.0');
        check(printer(27)).equals('27.0');
        check(printer(999)).equals('999.0');
        check(printer(1000)).equals('1.00 k');
        check(printer(1023)).equals('1.02 k');
        check(printer(1024)).equals('1.02 k');
        check(printer(1728)).equals('1.73 k');
        check(printer(1855425871872)).equals('1.86 T');
      });
      test('unitPrefix', () {
        final printer = HumanNumberPrinter.decimal(unitPrefix: true);
        check(printer(4)).equals('4');
        check(printer(4e3)).equals('k 4');
        check(printer(4e7)).equals('M 40');
        check(printer(-4)).equals('-4');
        check(printer(-4e3)).equals('k -4');
        check(printer(-4e7)).equals('M -40');
      });
      test('unitSeparator', () {
        final printer = HumanNumberPrinter.decimal(unitSeparator: '*');
        check(printer(4)).equals('4');
        check(printer(4e3)).equals('4*k');
        check(printer(4e7)).equals('40*M');
        check(printer(-4)).equals('-4');
        check(printer(-4e3)).equals('-4*k');
        check(printer(-4e7)).equals('-40*M');
      });
      test('long (double)', () {
        final base = 1000.toDouble();
        final printer = HumanNumberPrinter.decimal(long: true);
        final units = List.generate(19, (i) => printer(base.pow(i - 9)));
        check(units).deepEquals([
          '0 yocto',
          '1 yocto',
          '1 zepto',
          '1 atto',
          '1 femto',
          '1 pico',
          '1 nano',
          '1 micro',
          '1 milli',
          '1',
          '1 kilo',
          '1 mega',
          '1 giga',
          '1 tera',
          '1 peta',
          '1 exa',
          '1 zetta',
          '1 yotta',
          '1000 yotta',
        ]);
      });
    });
    group('binary', () {
      test('default', () {
        final printer = HumanNumberPrinter.binary();
        check(printer(0)).equals('0');
        check(printer(10)).equals('10');
        check(printer(200)).equals('200');
        check(printer(3000)).equals('3 Ki');
        check(printer(4e4)).equals('39 Ki');
        check(printer(-5e5)).equals('-488 Ki');
        check(printer(-6e6)).equals('-6 Mi');
        check(printer(7e-7)).equals('0');
        check(printer(-8e-8)).equals('-0');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.binary(nan: 'n/a');
        check(printer(double.nan)).equals('n/a');
      });
      test('infinity', () {
        final printer = HumanNumberPrinter.binary(infinity: 'huge');
        check(printer(double.infinity)).equals('huge');
        check(printer(double.negativeInfinity)).equals('-huge');
      });
      test('precision', () {
        final printer = HumanNumberPrinter.binary(precision: 1);
        check(printer(0)).equals('0');
        check(printer(27)).equals('27');
        check(printer(999)).equals('999');
        check(printer(1000)).equals('1000');
        check(printer(1023)).equals('1023');
        check(printer(1024)).equals('1.0 Ki');
        check(printer(1728)).equals('1.7 Ki');
        check(printer(1855425871872)).equals('1.7 Ti');
      });
      test('unitPrecision', () {
        final printer = HumanNumberPrinter.binary(
          precision: 2,
          unitPrecision: 1,
        );
        check(printer(0)).equals('0.0');
        check(printer(27)).equals('27.0');
        check(printer(999)).equals('999.0');
        check(printer(1000)).equals('1000.0');
        check(printer(1023)).equals('1023.0');
        check(printer(1024)).equals('1.00 Ki');
        check(printer(1728)).equals('1.69 Ki');
        check(printer(1855425871872)).equals('1.69 Ti');
      });
      test('unitPrefix', () {
        final printer = HumanNumberPrinter.binary(unitPrefix: true);
        check(printer(4)).equals('4');
        check(printer(4e3)).equals('Ki 4');
        check(printer(4e7)).equals('Mi 38');
        check(printer(-4)).equals('-4');
        check(printer(-4e3)).equals('Ki -4');
        check(printer(-4e7)).equals('Mi -38');
      });
      test('unitSeparator', () {
        final printer = HumanNumberPrinter.binary(unitSeparator: '*');
        check(printer(4)).equals('4');
        check(printer(4e3)).equals('4*Ki');
        check(printer(4e7)).equals('38*Mi');
        check(printer(-4)).equals('-4');
        check(printer(-4e3)).equals('-4*Ki');
        check(printer(-4e7)).equals('-38*Mi');
      });
      test('long (double)', () {
        final base = 1024.toDouble();
        final printer = HumanNumberPrinter.binary(long: true);
        final units = List.generate(10, (i) => printer(base.pow(i)));
        check(units).deepEquals([
          '1',
          '1 kibi',
          '1 mebi',
          '1 gibi',
          '1 tebi',
          '1 pebi',
          '1 exbi',
          '1 zebi',
          '1 yobi',
          '1024 yobi',
        ]);
      });
    });
    test('toString', () {
      final printer = HumanNumberPrinter.decimal();
      check(printer.toString()).startsWith('HumanNumberPrinter<num>');
    });
  });
}
