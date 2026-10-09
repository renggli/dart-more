import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('pluggable', () {
    test('default', () {
      final printer = Printer<String>.pluggable((value) => '<$value>');
      check(printer('a')).equals('<a>');
      check(printer('bc')).equals('<bc>');
      check(printer('def')).equals('<def>');
    });
    test('toString', () {
      final printer = Printer<int>.pluggable((value) => '$value');
      check(printer.toString()).startsWith('PluggablePrinter');
    });
  });
}
