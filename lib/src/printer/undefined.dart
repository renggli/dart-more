import '../../printer.dart';
import 'delegate.dart';

/// Prints an object different if `null`.
class UndefinedPrinter extends DelegatePrinter {
  final Printer undefinedPrinter;

  const UndefinedPrinter(Printer delegate, this.undefinedPrinter)
      : super(delegate);

  @override
  String call(dynamic object) =>
      object == null ? undefinedPrinter(object) : super.call(object);
}
