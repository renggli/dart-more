import '../../printer.dart';

/// Delegates a printer to another one.
class DelegatePrinter extends Printer {
  final Printer delegate;

  const DelegatePrinter(this.delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) =>
      delegate.printOn(object, buffer);
}
