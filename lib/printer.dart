/// Provides a first-class model to convert object to strings using composition
/// and highly configurable formatting primitives.
library more.printer;

import 'src/printer/literal_printer.dart';
import 'src/printer/number_printer.dart';
import 'src/printer/pad_printer.dart';
import 'src/printer/pluggable_printer.dart';
import 'src/printer/separate_printer.dart';
import 'src/printer/sequence_printer.dart';
import 'src/printer/sign_printer.dart';
import 'src/printer/standard_printer.dart';
import 'src/printer/trim_printer.dart';
import 'src/printer/truncate_printer.dart';

abstract class Printer {
  const Printer();

  /// Prints an object by simply calling [Object.toString].
  factory Printer.standard() => const StandardPrinter();

  /// Prints a string literal string [value].
  factory Printer.literal([String value = '']) => LiteralPrinter(value);

  /// Prints a sign based on a [negative] and [positive] printer.
  factory Printer.sign({Printer negative, Printer positive}) = SignPrinter;

  /// Prints a sign only for negative numbers (default behavior).
  factory Printer.omitPositiveSign() => omitPositiveSign;

  /// Prints a leading space, instead of a positive sign.
  factory Printer.spacePositiveSign() => spacePositiveSign;

  /// Prints a sign for both positive and negative numbers.
  factory Printer.negativeAndPositiveSign() => negativeAndPositiveSign;

  /// Prints numbers in a custom fixed format.
  factory Printer.fixed({
    double accuracy,
    int base,
    String characters,
    String delimiter,
    String infinity,
    String nan,
    int padding,
    int precision,
    String separator,
    Printer sign,
  }) = FixedNumberPrinter;

  /// Prints numbers in a  custom scientific format.
  factory Printer.scientific({
    int base,
    String characters,
    String delimiter,
    int exponentPadding,
    Printer exponentSign,
    String infinity,
    int mantissaPadding,
    Printer mantissaSign,
    String nan,
    String notation,
    int precision,
    String separator,
    int significant,
  }) = ScientificNumberPrinter;

  /// Prints the object using an appropriate printer.
  factory Printer.of(Object object) {
    if (object is Printer) {
      return object;
    } else if (object is ToString) {
      return PluggablePrinter(object);
    } else {
      return LiteralPrinter(object.toString());
    }
  }

  /// Prints the object.
  String call(Object object);

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

  /// Separates a string from the left side with a [separator] every [width]
  /// characters.
  Printer separateLeft(int width, int offset, String separator) =>
      SeparateLeftPrinter(this, width, offset, separator);

  /// Separates a string from the right side with a [separator] every [width]
  /// characters.
  Printer separateRight(int width, int offset, String separator) =>
      SeparateRightPrinter(this, width, offset, separator);

  /// Helper to modify a printer with a [callback], if a [condition] is met.
  Printer mapIf(bool condition, Printer callback(Printer printer)) =>
      condition ? callback(this) : this;

  /// Concatenates this printer with [other].
  Printer operator +(Object other) =>
      SequencePrinter([]..add(this)..add(Printer.of(other)));
}
