import '../object/object.dart';
import '../printer.dart';

/// Prints the sign of numbers using separate printers for negative and
/// non-negative values.
class SignNumberPrinter<T extends num> extends Printer<T> {
  /// A printer that prints a sign based on a [negative] and [positive] printer.
  const new({Printer<T>? negative, Printer<T>? positive})
    : negative = negative ?? const Printer.literal('-'),
      positive = positive ?? const Printer.literal();

  /// A printer that omits the positive sign (default).
  const new omitPositiveSign() : this();

  /// A printer that puts a leading space, instead of a positive sign.
  const new spacePositiveSign() : this(positive: const Printer.literal(' '));

  /// A printer that prints a sign for both positive and negative numbers.
  const new negativeAndPositiveSign()
    : this(positive: const Printer.literal('+'));

  /// The printer used for negative numbers.
  final Printer<T> negative;

  /// The printer used for non-negative numbers.
  final Printer<T> positive;

  @override
  void printOn(T object, StringBuffer buffer) {
    final delegate = object.isNegative ? negative : positive;
    delegate.printOn(object, buffer);
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(negative, name: 'negative')
    ..addValue(positive, name: 'positive');
}
