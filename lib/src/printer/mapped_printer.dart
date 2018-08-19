library more.printer.mapped_printer;

import '../../printer.dart';
import 'delegate_printer.dart';

typedef Object _MappedCallback(Object object);

class MappedPrinter extends DelegatePrinter {
  final _MappedCallback _callback;

  const MappedPrinter(Printer delegate, this._callback) : super(delegate);

  @override
  String call(Object object) => super.call(_callback(object));
}
