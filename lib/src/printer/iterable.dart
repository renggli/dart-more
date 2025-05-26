import 'object/object.dart';
import 'printer.dart';

extension IterablePrinterExtension<T> on Printer<T> {
  /// Joins the items in an [Iterable] with a separator, and possibly limits
  /// the total amount of items to be printed.
  Printer<Iterable<T>> iterable({
    Printer<Iterable<T>>? emptyPrinter,
    Printer<Iterable<T>>? beforePrinter,
    Printer<Iterable<T>>? afterPrinter,
    String separator = ', ',
    String? lastSeparator,
    int? leadingItems,
    int? trailingItems,
    String? ellipses = '\u2026',
  }) => IterablePrinter<T>(
    this,
    emptyPrinter: emptyPrinter,
    beforePrinter: beforePrinter,
    afterPrinter: afterPrinter,
    separator: separator,
    lastSeparator: lastSeparator,
    leadingItems: leadingItems,
    trailingItems: trailingItems,
    ellipses: ellipses,
  );
}

/// Prints an iterable of values.
class IterablePrinter<T> extends Printer<Iterable<T>> {
  const IterablePrinter(
    this.printer, {
    this.emptyPrinter,
    this.beforePrinter,
    this.afterPrinter,
    this.separator,
    this.lastSeparator,
    this.leadingItems,
    this.trailingItems,
    this.ellipses,
  });

  /// Printer to be used for the elements.
  final Printer<T> printer;

  /// Printer to be used if there are no elements.
  final Printer<Iterable<T>>? emptyPrinter;

  /// Printer to be used before the non-empty elements.
  final Printer<Iterable<T>>? beforePrinter;

  /// Printer to be used after the non-empty elements.
  final Printer<Iterable<T>>? afterPrinter;

  /// String to be used as a separator between items.
  final String? separator;

  /// String to be used as a separator between last items.
  final String? lastSeparator;

  /// Maximum number of leading items to print.
  final int? leadingItems;

  /// Maximum number of trailing items to print.
  final int? trailingItems;

  /// Ellipses to print when skipping printing of elements.
  final String? ellipses;

  @override
  void printOn(Iterable<T> object, StringBuffer buffer) {
    final list = object.toList(growable: false);
    if (list.isEmpty) {
      emptyPrinter?.printOn(object, buffer);
      return;
    }
    beforePrinter?.printOn(object, buffer);
    for (var i = 0; i < list.length; i++) {
      if (i > 0) {
        if (lastSeparator != null && i == list.length - 1) {
          buffer.write(lastSeparator);
        } else if (separator != null) {
          buffer.write(separator);
        }
      }
      final isLeading =
          leadingItems != null && trailingItems == null && leadingItems! <= i;
      final isTrailing =
          trailingItems != null &&
          leadingItems == null &&
          i < list.length - trailingItems!;
      final isBoth =
          leadingItems != null &&
          trailingItems != null &&
          leadingItems! <= i &&
          i < list.length - trailingItems!;
      if (isLeading || isTrailing || isBoth) {
        if (ellipses != null) {
          buffer.write(ellipses);
        }
        i = isLeading ? list.length : list.length - trailingItems! - 1;
      } else {
        printer.printOn(list[i], buffer);
      }
    }
    afterPrinter?.printOn(object, buffer);
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(emptyPrinter, name: 'emptyPrinter')
    ..addValue(beforePrinter, name: 'beforePrinter')
    ..addValue(afterPrinter, name: 'afterPrinter')
    ..addValue(separator, name: 'separator')
    ..addValue(lastSeparator, name: 'lastSeparator')
    ..addValue(leadingItems, name: 'leadingItems')
    ..addValue(trailingItems, name: 'trailingItems')
    ..addValue(ellipses, name: 'ellipses');
}
