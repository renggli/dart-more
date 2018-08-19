library more.printer.trim_printer;

import '../../printer.dart';
import 'delegate_printer.dart';
import 'utils.dart';

enum Trim {
  left,
  right,
  both,
}

class TrimPrinter extends DelegatePrinter {
  final Trim _trim;

  const TrimPrinter(Printer delegate, this._trim) : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    switch (_trim) {
      case Trim.left:
        return result.trimLeft();
      case Trim.right:
        return result.trimRight();
      case Trim.both:
        return result.trim();
    }
    return result;
  }
}
