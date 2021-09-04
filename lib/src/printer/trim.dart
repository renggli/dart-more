import '../../printer.dart';
import 'delegate.dart';

/// Removes any leading and trailing whitespace.
class TrimPrinter extends DelegatePrinter {
  const TrimPrinter(Printer delegate) : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) =>
      buffer.write(delegate(object).trim());
}

/// Removes any leading whitespace.
class TrimLeftPrinter extends DelegatePrinter {
  const TrimLeftPrinter(Printer delegate) : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) =>
      buffer.write(delegate(object).trimLeft());
}

/// Removes any trailing whitespace.
class TrimRightPrinter extends DelegatePrinter {
  const TrimRightPrinter(Printer delegate) : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) =>
      buffer.write(delegate(object).trimRight());
}
