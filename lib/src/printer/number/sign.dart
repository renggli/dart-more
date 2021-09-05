import '../literal.dart';
import '../printer.dart';

/// Prints numbers in various formats.
class SignNumberPrinter<T extends num> extends Printer<T> {
  /// A printer that prints a sign based on a [negative] and [positive] printer.
  const SignNumberPrinter({Printer<T>? negative, Printer<T>? positive})
      : negative = negative ?? const LiteralPrinter('-'),
        positive = positive ?? const LiteralPrinter();

  /// A printer that omits the positive sign (default).
  const SignNumberPrinter.omitPositiveSign() : this();

  /// A printer that puts a leading space, instead of a positive sign.
  const SignNumberPrinter.spacePositiveSign()
      : this(positive: const LiteralPrinter(' '));

  /// A printer that prints a sign for both positive and negative numbers.
  const SignNumberPrinter.negativeAndPositiveSign()
      : this(positive: const LiteralPrinter('+'));

  final Printer<T> negative;
  final Printer<T> positive;

  @override
  void printOn(T object, StringBuffer buffer) {
    final delegate = object.isNegative ? negative : positive;
    delegate.printOn(object, buffer);
  }
}
