library more.printer.undefined_printer;

import '../../printer.dart';
import 'delegate_printer.dart';

/// Prints an object different if `null`.
class UndefinedPrinter extends DelegatePrinter {
  final Printer undefinedPrinter;

  const UndefinedPrinter(Printer delegate, this.undefinedPrinter)
      : super(delegate);

  @override
  String call(Object object) =>
      object != null ? super.call(object) : undefinedPrinter(object);
}
