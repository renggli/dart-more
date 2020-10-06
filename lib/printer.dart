/// Provides a first-class model to convert object to strings using composition
/// and highly configurable formatting primitives.
import 'package:meta/meta.dart' show immutable;

import 'src/printer/literal.dart';
import 'src/printer/number/fixed.dart';
import 'src/printer/number/human.dart';
import 'src/printer/number/scientific.dart';
import 'src/printer/number/sign.dart';
import 'src/printer/pad.dart';
import 'src/printer/pluggable.dart';
import 'src/printer/separate.dart';
import 'src/printer/sequence.dart';
import 'src/printer/standard.dart';
import 'src/printer/trim.dart';
import 'src/printer/truncate.dart';
import 'src/printer/undefined.dart';

@immutable
abstract class Printer {
  const Printer();

  /// Prints an object by simply calling [Object.toString].
  factory Printer.standard() => const StandardPrinter();

  /// Prints a string literal string [value].
  factory Printer.literal([String value = '']) => LiteralPrinter(value);

  /// Prints a sign based on a [negative] and [positive] printer.
  // ignore: prefer_const_constructors_in_immutables
  factory Printer.sign({Printer negative, Printer positive}) = SignPrinter;

  /// Prints a sign only for negative numbers (default behavior).
  factory Printer.omitPositiveSign() => omitPositiveSign;

  /// Prints a leading space, instead of a positive sign.
  factory Printer.spacePositiveSign() => spacePositiveSign;

  /// Prints a sign for both positive and negative numbers.
  factory Printer.negativeAndPositiveSign() => negativeAndPositiveSign;

  /// Prints numbers in a custom fixed format.
  factory Printer.fixed({
    double? accuracy,
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

  /// Prints numbers in a custom scientific format.
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

  /// Prints numbers in a custom human readable string.
  factory Printer.human({
    required List<String> units,
    int base,
    String characters,
    String delimiter,
    String infinity,
    String nan,
    int padding,
    int precision,
    String separator,
    Printer sign,
    int unitBase,
    int unitOffset,
    bool unitPrefix,
    String unitSeparator,
  }) = HumanNumberPrinter;

  /// Prints numbers using a decimal suffix for units measure to indicate a
  /// multiple or sub-multiple of the unit.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Metric_prefix.
  factory Printer.humanDecimal({
    int base,
    String characters,
    String delimiter,
    String infinity,
    bool long,
    String nan,
    int padding,
    int precision,
    String separator,
    Printer sign,
    bool unitPrefix,
    String unitSeparator,
  }) = HumanNumberPrinter.decimal;

  /// Prints numbers using a binary suffix for units in data processing, data
  /// transmission, and digital information.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Binary_prefix.
  factory Printer.humanBinary({
    int base,
    String characters,
    String delimiter,
    String infinity,
    bool long,
    String nan,
    int padding,
    int precision,
    String separator,
    Printer sign,
    bool unitPrefix,
    String unitSeparator,
  }) = HumanNumberPrinter.binary;

  /// Prints the object using an appropriate printer.
  factory Printer.of(Object object) {
    if (object is Printer) {
      return object;
    } else if (object is PrintCallback) {
      return PluggablePrinter(object);
    } else {
      return LiteralPrinter(object.toString());
    }
  }

  /// Prints the object.
  String call(Object? object);

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

  /// Prints [other], if the object to be printed is null.
  Printer undefined([Object other = 'null']) =>
      UndefinedPrinter(this, Printer.of(other));

  /// Helper to modify a printer with a [callback], if a [condition] is met.
  Printer mapIf(bool condition, Printer Function(Printer printer) callback) =>
      condition ? callback(this) : this;

  /// Concatenates this printer with [other].
  Printer operator +(Object other) =>
      SequencePrinter([this, Printer.of(other)]);
}
