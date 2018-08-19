library more.printer;

import 'src/printer/literal_printer.dart';
import 'src/printer/mapped_printer.dart';
import 'src/printer/number_printer.dart';
import 'src/printer/pluggable_printer.dart';
import 'src/printer/sequence_printer.dart';
import 'src/printer/sign_printer.dart';
import 'src/printer/standard_printer.dart';
import 'src/printer/crop_printer.dart';
import 'src/printer/pad_printer.dart';
import 'src/printer/trim_printer.dart';
import 'src/printer/unit_printer.dart';
import 'src/printer/utils.dart';

abstract class Printer {
  const Printer();

  /// Standard printer that simply calls [Object.toString()].
  factory Printer.standard() => const StandardPrinter();

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

  factory Printer.units(num base, List<String> units) =>
      UnitPrinter(base, units);

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
        'YiB'
      ]);

  factory Printer.decimalFileSize() => Printer.units(
      1000, ['byte', 'bytes', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']);

  factory Printer.wrap(Object object) {
    if (object is Printer) {
      return object;
    } else if (object is ToString) {
      return PluggablePrinter(object);
    } else {
      return LiteralPrinter(object.toString());
    }
  }

  /// Trims whitespaces from a string.
  Printer trim() => TrimPrinter(this, Trim.both);
  Printer trimLeft() => TrimPrinter(this, Trim.left);
  Printer trimRight() => TrimPrinter(this, Trim.right);

  /// Pads a string to a specific [width].
  Printer padLeft(int width, [String padding = ' ']) =>
      PadPrinter(this, Pad.left, width, padding);
  Printer padRight(int width, [String padding = ' ']) =>
      PadPrinter(this, Pad.right, width, padding);
  Printer padCenter(int width, [String padding = ' ']) =>
      PadPrinter(this, Pad.center, width, padding);

  /// Crops a string to a specific [width].
  Printer cropLeft(int width) => CropPrinter(this, Crop.left, width);
  Printer cropRight(int width) => CropPrinter(this, Crop.right, width);
  Printer cropBoth(int width) => CropPrinter(this, Crop.both, width);


  /// Converts
  Printer map(Object callback(Object value)) => MappedPrinter(this, callback);

  /// Prints the object.
  String call(Object object);

  Printer operator +(Object other) =>
      SequencePrinter([]..add(this)..add(Printer.wrap(other)));
}
