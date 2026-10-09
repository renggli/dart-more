import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('printer', () {
    group('wrap', () {
      test('printer', () {
        final printer = Printer<String>.wrap(standardString);
        check(printer).identicalTo(standardString);
        check(printer('1')).equals('1');
      });
      test('callback', () {
        final printer = Printer<int>.wrap(
          (int value) => (2 * value).toString(),
        );
        check(printer(1)).equals('2');
        check(printer(12)).equals('24');
      });
      test('literal', () {
        final printer = Printer<int>.wrap('*');
        check(printer(1)).equals('*');
        check(printer(12)).equals('*');
      });
      test('string', () {
        final printer = Printer<int>.wrap(const [standardInt, standardInt]);
        check(printer(1)).equals('11');
        check(printer(12)).equals('1212');
      });
      test('invalid', () {
        check(() => Printer<String>.wrap(standardInt)).throws<ArgumentError>();
        check(() => Printer<String>.wrap(num.parse)).throws<ArgumentError>();
        check(() => Printer<String>.wrap(12)).throws<ArgumentError>();
      });
    });
  });
}
