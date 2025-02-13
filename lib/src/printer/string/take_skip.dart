import 'package:characters/characters.dart';

import '../object/object.dart';
import '../printer.dart';

extension TakeSkipPrinterExtension<T> on Printer<T> {
  /// Takes the first [count] characters.
  Printer<T> take(int count) => TakePrinter<T>(this, count);

  /// Takes the last [count] characters.
  Printer<T> takeLast(int count) => TakeLastPrinter<T>(this, count);

  /// Skips all but the first [count] characters.
  Printer<T> skip(int count) => SkipPrinter<T>(this, count);

  /// Skips all but the last [count] characters.
  Printer<T> skipLast(int count) => SkipLastPrinter<T>(this, count);
}

/// Cuts the string if it is longer than width.
abstract class TakeSkipPrinter<T> extends Printer<T> {
  const TakeSkipPrinter(this.printer, this.count);

  final Printer<T> printer;
  final int count;

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter
        ..addValue(printer, name: 'printer')
        ..addValue(count, name: 'count');
}

/// Takes the first [count] characters.
class TakePrinter<T> extends TakeSkipPrinter<T> {
  const TakePrinter(super.printer, super.count);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    buffer.write(input.take(count));
  }
}

/// Takes the last [count] characters.
class TakeLastPrinter<T> extends TakeSkipPrinter<T> {
  const TakeLastPrinter(super.printer, super.count);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    buffer.write(input.takeLast(count));
  }
}

/// Skips all but the first [count] characters.
class SkipPrinter<T> extends TakeSkipPrinter<T> {
  const SkipPrinter(super.printer, super.count);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    buffer.write(input.skip(count));
  }
}

/// Skips all but the last [count] characters.
class SkipLastPrinter<T> extends TakeSkipPrinter<T> {
  const SkipLastPrinter(super.printer, super.count);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    buffer.write(input.skipLast(count));
  }
}
