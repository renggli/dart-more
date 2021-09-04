import '../../printer.dart';
import 'delegate.dart';

/// Prints an object different if `null`.
class UndefinedPrinter extends DelegatePrinter {
  final Printer undefinedPrinter;

  const UndefinedPrinter(Printer delegate, this.undefinedPrinter)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) => object == null
      ? undefinedPrinter.printOn(object, buffer)
      : super.printOn(object, buffer);
}
