library more.printer.sign_printer;

import '../../printer.dart';
import 'utils.dart';

/// Prints numbers in various formats.
class SignPrinter extends Printer {
  final Printer negativePrinter;
  final Printer positivePrinter;

  const SignPrinter(this.negativePrinter, this.positivePrinter);

  @override
  String call(Object object) {
    final isNegative = checkNumericType(
      object,
      (value) => value.isNegative,
      (value) => value.isNegative,
    );
    final delegate = isNegative ? negativePrinter : positivePrinter;
    return delegate(object);
  }
}
