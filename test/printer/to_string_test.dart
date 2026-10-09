import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

class _CustomObject with ToStringPrinter {
  new(this.foo, this.bar);

  final String foo;
  final int bar;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(foo, name: 'foo')
    ..addValue(bar, name: 'bar');
}

void main() {
  group('ToStringPrinter', () {
    test('default toString', () {
      final object = _CustomObject('hello', 42);
      check(object.toString()).equals('_CustomObject(foo: hello, bar: 42)');
    });
  });
}
