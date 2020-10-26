import '../../printer.dart';
import 'delegate.dart';

/// Lower-case digits and letters by increasing value.
const String commaSeparator = ', ';

const String iterableEllipsis = '\u2026';

/// Prints an iterable of values.
class IterablePrinter extends DelegatePrinter {
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
    Printer delegate, {
    this.separator = commaSeparator,
    this.lastSeparator,
    this.leadingItems,
    this.trailingItems,
    this.ellipses = iterableEllipsis,
  }) : super(delegate);

  @override
  String call(Object? object) {
    if (object is! Iterable) {
      throw ArgumentError.value(object, 'object', 'is not iterable.');
    }
    final list = [...object];
    final length = list.length;
    final buffer = StringBuffer();
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
        buffer.write(super.call(list[i]));
      }
    }
    return buffer.toString();
  }
}
