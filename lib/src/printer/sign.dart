import '../../printer.dart';
import 'literal.dart';
import 'utils.dart';

/// A printer that omits the positive sign.
const Printer omitPositiveSign = SignPrinter();

/// A printer that puts a leading space, instead of a positive sign.
const Printer spacePositiveSign = SignPrinter(positive: LiteralPrinter(' '));

/// A printer that prints a sign for both positive and negative numbers.
const Printer negativeAndPositiveSign =
    SignPrinter(positive: LiteralPrinter('+'));

/// Prints numbers in various formats.
class SignPrinter extends Printer {
  final Printer negative;
  final Printer positive;

  const SignPrinter({
    this.negative = const LiteralPrinter('-'),
    this.positive = const LiteralPrinter(''),
  });

  @override
  String call(Object? object) {
    final isNegative = checkNumericType(
      object,
      (value) => value.isNegative,
      (value) => value.isNegative,
    );
    final delegate = isNegative ? negative : positive;
    return delegate(object);
  }
}
