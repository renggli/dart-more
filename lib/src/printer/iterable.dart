import 'printer.dart';

/// Standard separator between elements.
const String iterableSeparator = ', ';

/// Standard ellipsis separator.
const String iterableEllipsis = '\u2026';

/// Prints an iterable of values.
class IterablePrinter extends Printer {
  /// Printer to be used for the elements.
  final Printer delegate;

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

  const IterablePrinter(
    this.delegate, {
    this.separator = iterableSeparator,
    this.lastSeparator,
    this.leadingItems,
    this.trailingItems,
    this.ellipses = iterableEllipsis,
  });

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final list = [...object];
    final length = list.length;
    for (var i = 0; i < length; i++) {
      if (i > 0) {
        if (lastSeparator != null && i == length - 1) {
          buffer.write(lastSeparator);
        } else if (separator != null) {
          buffer.write(separator);
        }
      }
      final isLeading =
          leadingItems != null && trailingItems == null && leadingItems! <= i;
      final isTrailing = trailingItems != null &&
          leadingItems == null &&
          i < length - trailingItems!;
      final isBoth = leadingItems != null &&
          trailingItems != null &&
          leadingItems! <= i &&
          i < length - trailingItems!;
      if (isLeading || isTrailing || isBoth) {
        if (ellipses != null) {
          buffer.write(ellipses);
        }
        i = isLeading ? list.length : length - trailingItems! - 1;
      } else {
        delegate.printOn(list[i], buffer);
      }
    }
  }
}
