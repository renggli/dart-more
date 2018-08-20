library more.printer;

import 'src/printer/literal_printer.dart';
import 'src/printer/mapped_printer.dart';
import 'src/printer/number_printer.dart';
import 'src/printer/pluggable_printer.dart';
import 'src/printer/sequence_printer.dart';
import 'src/printer/sign_printer.dart';
import 'src/printer/standard_printer.dart';
import 'src/printer/truncate_printer.dart';
import 'src/printer/pad_printer.dart';
import 'src/printer/trim_printer.dart';
import 'src/printer/unit_printer.dart';
import 'src/printer/utils.dart';

abstract class Printer {
  const Printer();

  /// Standard printer that simply calls [Object.toString()].
  factory Printer.standard() => const StandardPrinter();

  /// Prints a string literal onto the output.
  factory Printer.literal([String value = '']) => LiteralPrinter(value);

  /// Depending on the sign of a number.
  factory Printer.sign({Printer negative, Printer positive}) => SignPrinter(
        negative ?? Printer.literal('-'),
        positive ?? Printer.literal(''),
      );

  /// Constructs a custom number printer.
  ///
  /// You can customize every single part:
  /// - Rounds towards the nearest number that is a multiple of [accuracy].
  /// - The numeric [base ]to which the number should be printed.
  /// - The [characters] to be used to convert a number to a string.
  /// - The [delimiter] to separate the integer and fraction part of the number.
  /// - The number of [digits] to be printed in the integer part.
  /// - The string that should be displayed if the number is [infinity].
  /// - The string that should be displayed if the number is not a number.
  /// - The [padding] character for the integer part.
  /// - The [precision] of digits to be printed in the fraction part.
  /// - The [separator] character to be used to group digits.
  factory Printer.number({
    double accuracy,
    int base = 10,
    String characters = '0123456789abcdefghijklmnopqrstuvwxyz',
    String delimiter = '.',
    int digits,
    String infinity = 'Infinity',
    String nan = 'NaN',
    String padding = ' ',
    int precision = 0,
    String separator,
  }) =>
      NumberPrinter(accuracy, base, characters, delimiter, digits, infinity,
          nan, padding, precision, separator);

  /// Converts a number into a human readable unit.
  factory Printer.units(num base, List<String> units,
          {Printer integerPrinter, Printer fractionPrinter}) =>
      UnitPrinter(
        base,
        units,
        integerPrinter ?? Printer.number(precision: 0),
        fractionPrinter ?? Printer.number(precision: 1),
      );

  /// Converts file sizes in bytes to a the binary notation.
  factory Printer.binaryFileSize() => Printer.units(1024, [
        'byte',
        'bytes',
        'KiB',
        'MiB',
        'GiB',
        'TiB',
        'PiB',
        'EiB',
        'ZiB',
        'YiB',
      ]);

  /// Converts file sizes in bytes to a the decimal notation.
  factory Printer.decimalFileSize() => Printer.units(1000, [
        'byte',
        'bytes',
        'kB',
        'MB',
        'GB',
        'TB',
        'PB',
        'EB',
        'ZB',
        'YB',
      ]);

  factory Printer.wrap(Object object) {
    if (object is Printer) {
      return object;
    } else if (object is ToString) {
      return PluggablePrinter(object);
    } else {
      return LiteralPrinter(object.toString());
    }
  }

  /// Removes any leading and trailing whitespace.
  Printer trim() => TrimPrinter(this);

  /// Removes any leading whitespace.
  Printer trimLeft() => TrimLeftPrinter(this);

  /// Removes any trailing whitespace.
  Printer trimRight() => TrimRightPrinter(this);

  /// Pads the string on the left if it is shorter than [width].
  Printer padLeft(int width, [String padding = ' ']) =>
      PadLeftPrinter(this, width, padding);

  /// Pads the string on the right if it is shorter than [width].
  Printer padRight(int width, [String padding = ' ']) =>
      PadRightPrinter(this, width, padding);

  /// Pads the string on the left and right if it is shorter than [width].
  Printer padBoth(int width, [String padding = ' ']) =>
      PadBothPrinter(this, width, padding);

  /// Truncates the string from the left side if it is longer than width.
  Printer truncateLeft(int width, [String ellipsis = '']) =>
      TruncateLeftPrinter(this, width, ellipsis);

  /// Truncates the string from the right side if it is longer than width.
  Printer truncateRight(int width, [String ellipsis = '']) =>
      TruncateRightPrinter(this, width, ellipsis);

  /// Converts
  Printer map(Object callback(Object value)) => MappedPrinter(this, callback);

  /// Prints the object.
  String call(Object object);

  Printer operator +(Object other) =>
      SequencePrinter([]..add(this)..add(Printer.wrap(other)));
}
