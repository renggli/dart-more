import 'package:characters/characters.dart';

import '../object/object.dart';
import '../printer.dart';

/// Horizontal Ellipsis (U+2026).
const defaultEllipsis = '…';

/// Method to truncate.
enum TruncateMethod { characters, words, sentences }

extension TruncatePrinterExtension<T> on Printer<T> {
  /// Truncates the string from the left side if it is longer than width.
  Printer<T> truncateLeft(
    int width, {
    String ellipsis = defaultEllipsis,
    TruncateMethod method = TruncateMethod.characters,
  }) => TruncateLeftPrinter<T>(this, width, ellipsis, method);

  /// Truncates the string from the right side if it is longer than width.
  Printer<T> truncateRight(
    int width, {
    String ellipsis = defaultEllipsis,
    TruncateMethod method = TruncateMethod.characters,
  }) => TruncateRightPrinter<T>(this, width, ellipsis, method);

  /// Truncates the string from the center if it is longer than width.
  Printer<T> truncateCenter(
    int width, {
    String ellipsis = defaultEllipsis,
    TruncateMethod method = TruncateMethod.characters,
  }) => TruncateCenterPrinter<T>(this, width, ellipsis, method);
}

/// Truncates the string if it is longer than width.
abstract class TruncatePrinter<T> extends Printer<T> {
  TruncatePrinter(this.printer, this.width, this.ellipsis, this.method)
    : ellipsisLength = ellipsis.characters.length;

  final Printer<T> printer;
  final int width;
  final String ellipsis;
  final int ellipsisLength;
  final TruncateMethod method;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(width, name: 'width')
    ..addValue(ellipsis, name: 'ellipsis')
    ..addValue(method, name: 'method');
}

/// Truncates the string from the left side if it is longer than width.
class TruncateLeftPrinter<T> extends TruncatePrinter<T> {
  TruncateLeftPrinter(super.printer, super.width, super.ellipsis, super.method);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    if (input.length <= width) {
      buffer.write(input);
    } else if (ellipsisLength <= width) {
      buffer.write(ellipsis);
      buffer.write(truncateLeft(input, method, width - ellipsisLength));
    }
  }
}

/// Truncates the string from the right side if it is longer than width.
class TruncateRightPrinter<T> extends TruncatePrinter<T> {
  TruncateRightPrinter(
    super.printer,
    super.width,
    super.ellipsis,
    super.method,
  );

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    if (input.length <= width) {
      buffer.write(input);
    } else if (ellipsisLength <= width) {
      buffer.write(truncateRight(input, method, width - ellipsisLength));
      buffer.write(ellipsis);
    }
  }
}

/// Truncates the string from the center if it is longer than width.
class TruncateCenterPrinter<T> extends TruncatePrinter<T> {
  TruncateCenterPrinter(
    super.printer,
    super.width,
    super.ellipsis,
    super.method,
  );

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    if (input.length <= width) {
      buffer.write(input);
    } else if (ellipsisLength <= width) {
      final left = width ~/ 2 - ellipsisLength ~/ 2;
      final right = left + width % 2 - ellipsisLength % 2;
      buffer.write(truncateRight(input, method, left));
      buffer.write(ellipsis);
      buffer.write(truncateLeft(input, method, right));
    }
  }
}

const whitespace = {
  '\u0009',
  '\u000A',
  '\u000B',
  '\u000C',
  '\u000D',
  '\u0020',
  '\u0085',
  '\u00A0',
  '\u1680',
  '\u2000',
  '\u2001',
  '\u2002',
  '\u2003',
  '\u2004',
  '\u2005',
  '\u2006',
  '\u2007',
  '\u2008',
  '\u2009',
  '\u200A',
  '\u2028',
  '\u2029',
  '\u202F',
  '\u205F',
  '\u3000',
  '\uFEFF',
};
const punctuation = {'.', '!', '?'};

String truncateRight(Characters input, TruncateMethod method, int width) {
  switch (method) {
    case TruncateMethod.characters:
      return input.take(width).string;
    case TruncateMethod.words:
      final iterator = input.iterator
        ..expandNext(width)
        ..dropBackWhile((each) => !whitespace.contains(each))
        ..dropLast();
      if (iterator.isEmpty) {
        return truncateRight(input, TruncateMethod.characters, width);
      }
      return iterator.current;
    case TruncateMethod.sentences:
      final iterator = input.iterator
        ..expandNext(width)
        ..dropBackWhile((each) => !punctuation.contains(each));
      if (iterator.isEmpty) {
        return truncateRight(input, TruncateMethod.words, width);
      }
      return iterator.current;
  }
}

String truncateLeft(Characters input, TruncateMethod method, int width) {
  switch (method) {
    case TruncateMethod.characters:
      return input.takeLast(width).string;
    case TruncateMethod.words:
      final iterator = input.iteratorAtEnd
        ..expandBack(width)
        ..dropWhile((each) => !whitespace.contains(each))
        ..dropFirst();
      if (iterator.isEmpty) {
        return truncateLeft(input, TruncateMethod.characters, width);
      }
      return iterator.current;
    case TruncateMethod.sentences:
      final iterator = input.iteratorAtEnd
        ..expandBack(width)
        ..dropWhile((each) => !punctuation.contains(each));
      if (iterator.isEmpty) {
        return truncateLeft(input, TruncateMethod.words, width);
      }
      return iterator.current;
  }
}
