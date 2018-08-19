library more.printer.unit_printer;

import '../../printer.dart';
import 'utils.dart';

/// Prints numbers in various formats.
class UnitPrinter extends Printer {
  final num base;

  final List<String> units;

  final Printer integerPrinter;

  final Printer fractionPrinter;

  UnitPrinter(this.base, this.units);

  @override
  String call(Object object) {
    var value = checkNumericType(
      object,
      (value) => value.toDouble(),
      (value) => value.toDouble(),
    );
    if (object == 1) {
      return _printUnit(value, 0);
    }
    for (var i = 1; i < units.length; i++) {
      if (value < base) {
        value /= base;
      } else {
        return _printUnit(value, i);
      }
    }
    return _printUnit(value, units.length - 1);
  }

  String _printUnit(double object, int unitIndex) {
    final buffer = StringBuffer();
    if (unitIndex < 2) {
      buffer.write(integerPrinter(object));
    } else {
      buffer.write(fractionPrinter(object));
    }
    buffer.write(' ');
    buffer.write(units[unitIndex]);
    return buffer.toString();
  }
}
