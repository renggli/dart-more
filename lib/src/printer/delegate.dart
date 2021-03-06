import '../../printer.dart';

/// Delegates a printer to another one.
class DelegatePrinter extends Printer {
  final Printer delegate;

  const DelegatePrinter(this.delegate);

  @override
  String call(dynamic object) => delegate(object);
}
