library more.printer.crop_printer;

import '../../printer.dart';
import 'delegate_printer.dart';
import 'utils.dart';

enum Crop {
  left,
  right,
  both,
}

class CropPrinter extends DelegatePrinter {
  final Crop _crop;

  final int _width;

  const CropPrinter(Printer delegate, this._crop, this._width)
      : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    if (result.length > _width) {
      switch (_crop) {
        case Crop.left:
          return result.substring(result.length - _width);
        case Crop.right:
          return result.substring(0, _width);
        case Crop.both:
          int excess = result.length - _width;
          return result.substring(
              excess ~/ 2, result.length - (excess + excess % 2));
      }
    }
    return result;
  }
}
