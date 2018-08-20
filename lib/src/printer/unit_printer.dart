library more.printer.unit_printer;

import '../../printer.dart';
import 'utils.dart';

/// Converts numbers into human readable units.
class UnitPrinter extends Printer {
  final num _base;
  final List<String> _units;
  final Printer _integerPrinter;
  final Printer _fractionPrinter;

  UnitPrinter(
      this._base, this._units, this._integerPrinter, this._fractionPrinter);

  @override
  String call(Object object) {
    var value = checkNumericType(
      object,
      (value) => value.toDouble(),
      (value) => value.toDouble(),
    );
    if (object == 1) {
      return _convertUnit(value, 0);
    }
    for (var i = 1; i < _units.length; i++) {
      if (value < _base) {
        return _convertUnit(value, i);
      } else {
        value /= _base;
      }
    }
    return _convertUnit(value, _units.length - 1);
  }

  String _convertUnit(double object, int unitIndex) {
    final buffer = StringBuffer();
    if (unitIndex < 2) {
      buffer.write(_integerPrinter(object));
    } else {
      buffer.write(_fractionPrinter(object));
    }
    buffer.write(' ');
    buffer.write(_units[unitIndex]);
    return buffer.toString();
  }
}
