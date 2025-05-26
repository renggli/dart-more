import '../../../math.dart';
import '../object/object.dart';
import '../printer.dart';
import 'fixed.dart';
import 'numeral.dart';

/// Prints numbers in an ordinal format.
class OrdinalNumberPrinter extends Printer<int> {
  /// Prints numbers in an ordinal format.
  OrdinalNumberPrinter({
    this.base = 10,
    this.characters = NumeralSystem.latin,
    this.padding = 0,
    this.separator = '',
    this.separatorWidth = 3,
    this.separatorOffset = 0,
    this.sign,
  }) : _number = FixedNumberPrinter<int>(
         base: base,
         characters: characters,
         padding: padding,
         separator: separator,
         separatorWidth: separatorWidth,
         separatorOffset: separatorOffset,
         sign: sign,
       );

  /// The numeric base to which the number should be printed.
  final int base;

  /// The characters to be used to convert a number to a string.
  final List<String> characters;

  /// The number of digits to be printed in the number part.
  final int padding;

  /// The separator character to be used to group digits.
  final String separator;

  /// The number of characters to be separated in a group.
  final int separatorWidth;

  /// The offset of characters to be separated in a group.
  final int separatorOffset;

  /// The printer used for negative or positive numbers.
  final Printer<int>? sign;

  /// Internal number printer.
  final Printer<int> _number;

  @override
  void printOn(int object, StringBuffer buffer) {
    _number.printOn(object, buffer);
    if (!(object % 100).between(10, 20)) {
      switch (object % 10) {
        case 1:
          return buffer.write('st');
        case 2:
          return buffer.write('nd');
        case 3:
          return buffer.write('rd');
      }
    }
    buffer.write('th');
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(base, name: 'base')
    ..addValue(characters, name: 'characters')
    ..addValue(padding, name: 'padding')
    ..addValue(separator, name: 'separator')
    ..addValue(sign, name: 'sign');
}
