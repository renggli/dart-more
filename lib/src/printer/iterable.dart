import 'dart:collection' show ListQueue;

import 'object/object.dart';
import 'printer.dart';

/// Extension on [Printer] providing iterable formatting.
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
  const new(
    this.printer, {
    this.emptyPrinter,
    this.beforePrinter,
    this.afterPrinter,
    this.separator,
    this.lastSeparator,
    this.leadingItems,
    this.trailingItems,
    this.ellipses,
  }) : assert(
         leadingItems == null || leadingItems >= 0,
         'leadingItems must be non-negative',
       ),
       assert(
         trailingItems == null || trailingItems >= 0,
         'trailingItems must be non-negative',
       );

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
    final iterator = object.iterator;
    if (!iterator.moveNext()) {
      emptyPrinter?.printOn(object, buffer);
      return;
    }
    beforePrinter?.printOn(object, buffer);
    final leading = leadingItems;
    final trailing = trailingItems;
    if (leading == null && trailing == null) {
      var current = iterator.current;
      var hasNext = iterator.moveNext();
      for (var i = 0; ; i++) {
        if (i > 0) {
          buffer.write(
            (!hasNext && lastSeparator != null)
                ? lastSeparator
                : (separator ?? ''),
          );
        }
        printer.printOn(current, buffer);
        if (!hasNext) break;
        current = iterator.current;
        hasNext = iterator.moveNext();
      }
    } else if (trailing == null) {
      var hasCurrent = true;
      var count = 0;
      while (hasCurrent && count < leading!) {
        final current = iterator.current;
        final hasNext = iterator.moveNext();
        if (count > 0) {
          final isLast = !hasNext || (count + 1 == leading && ellipses == null);
          buffer.write(
            (isLast && lastSeparator != null)
                ? lastSeparator
                : (separator ?? ''),
          );
        }
        printer.printOn(current, buffer);
        hasCurrent = hasNext;
        count++;
      }
      if (hasCurrent && ellipses != null) {
        if (count > 0) {
          buffer.write(lastSeparator ?? separator ?? '');
        }
        buffer.write(ellipses);
      }
    } else {
      final leadLimit = leading ?? 0;
      final tail = ListQueue<T>(trailing);
      var printed = 0;
      var skipped = false;
      var hasCurrent = true;
      while (hasCurrent && printed < leadLimit) {
        final current = iterator.current;
        final hasNext = iterator.moveNext();
        if (printed > 0) {
          buffer.write(
            (!hasNext && lastSeparator != null)
                ? lastSeparator
                : (separator ?? ''),
          );
        }
        printer.printOn(current, buffer);
        hasCurrent = hasNext;
        printed++;
      }
      while (hasCurrent) {
        if (trailing == 0) {
          skipped = true;
        } else {
          if (tail.length == trailing) {
            tail.removeFirst();
            skipped = true;
          }
          tail.addLast(iterator.current);
        }
        hasCurrent = iterator.moveNext();
      }
      if (skipped && ellipses != null) {
        if (printed > 0) {
          buffer.write(separator ?? '');
        }
        buffer.write(ellipses);
        printed++;
      }
      while (tail.isNotEmpty) {
        final current = tail.removeFirst();
        if (printed > 0) {
          buffer.write(
            (tail.isEmpty && lastSeparator != null)
                ? lastSeparator
                : (separator ?? ''),
          );
        }
        printer.printOn(current, buffer);
        printed++;
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
