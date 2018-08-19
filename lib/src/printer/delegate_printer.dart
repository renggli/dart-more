library more.printer.crop_printer;

import '../../printer.dart';

class DelegatePrinter extends Printer {
  final Printer _delegate;

  const DelegatePrinter(this._delegate);

  @override
  String call(Object object) => _delegate(object);
}
