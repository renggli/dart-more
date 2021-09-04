import '../../../printer.dart';
import '../literal.dart';
import '../number.dart';

/// A printer that omits the positive sign.
const Printer omitPositiveSign = SignPrinter();

/// A printer that puts a leading space, instead of a positive sign.
const Printer spacePositiveSign = SignPrinter(positive: LiteralPrinter(' '));

/// A printer that prints a sign for both positive and negative numbers.
const Printer negativeAndPositiveSign =
    SignPrinter(positive: LiteralPrinter('+'));

/// Prints numbers in various formats.
class SignPrinter extends NumberPrinter {
  final Printer negative;
  final Printer positive;

  const SignPrinter({
    this.negative = const LiteralPrinter('-'),
    this.positive = const LiteralPrinter(''),
  });

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final isNegative = object is num
        ? object.isNegative
        : object is BigInt
            ? object.isNegative
            : invalidNumericType(object);
    final delegate = isNegative ? negative : positive;
    delegate.printOn(object, buffer);
  }
}
