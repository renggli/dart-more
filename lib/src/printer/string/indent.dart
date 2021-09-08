import 'dart:math';

import '../../char_matcher/whitespace.dart';
import '../../collection/string.dart';
import '../printer.dart';

extension IndentPrinterExtension<T> on Printer<T> {
  /// Adds a [prefix] to the beginning of each line.
  ///
  /// - [firstPrefix] is used to indent the first line.
  /// - [trimWhitespace] trims leading and trailing whitespaces.
  /// - [indentEmpty] indents empty lines as well.
  Printer<T> indent(
    String prefix, {
    String? firstPrefix,
    bool trimWhitespace = true,
    bool indentEmpty = false,
  }) =>
      IndentPrinter<T>(this, prefix, firstPrefix, trimWhitespace, indentEmpty);

  /// Removes any common leading prefix from every line.
  ///
  /// - [whitespace] is used to identify leading prefix.
  /// - [ignoreEmpty] is used to skip over empty lines.
  Printer<T> dedent({
    Pattern whitespace = const WhitespaceCharMatcher(),
    bool ignoreEmpty = true,
  }) =>
      DedentPrinter(this, whitespace, ignoreEmpty);
}

class IndentPrinter<T> extends Printer<T> {
  const IndentPrinter(this.printer, this.prefix, this.firstPrefix,
      this.trimWhitespace, this.indentEmpty);

  final Printer<T> printer;
  final String prefix;
  final String? firstPrefix;
  final bool trimWhitespace;
  final bool indentEmpty;

  @override
  void printOn(T object, StringBuffer buffer) {
    final result = <String>[];
    for (var line in printer.print(object).split('\n')) {
      if (trimWhitespace) {
        line = line.trim();
      }
      if (line.isEmpty && !indentEmpty) {
        result.add(line);
      } else {
        if (result.isEmpty && firstPrefix != null) {
          result.add('$firstPrefix$line');
        } else {
          result.add('$prefix$line');
        }
      }
    }
    buffer.writeAll(result, '\n');
  }
}

class DedentPrinter<T> extends Printer<T> {
  const DedentPrinter(this.printer, this.whitespace, this.ignoreEmpty);

  final Printer<T> printer;
  final Pattern whitespace;
  final bool ignoreEmpty;

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer.print(object);
    final lines = input.split('\n');
    final prefix = findLongestPrefix(lines);
    if (prefix.isEmpty) {
      buffer.write(input);
    } else {
      final result = lines.map((line) => line.removePrefix(prefix));
      buffer.writeAll(result, '\n');
    }
  }

  String findLongestPrefix(List<String> lines) {
    String? prefix;
    for (final line in lines) {
      // Ignore empty lines.
      if (ignoreEmpty && line.trim().isEmpty) {
        continue;
      }
      // Extract the current prefix.
      var index = 0;
      while (index < line.length) {
        final match = whitespace.matchAsPrefix(line, index);
        if (match == null) {
          break;
        }
        index = match.end;
      }
      final current = line.substring(0, index);
      // Find the longest prefix so far.
      if (prefix == null || prefix.startsWith(current)) {
        prefix = current;
      } else if (current.startsWith(prefix)) {
        continue;
      } else {
        for (var i = 0; i < min(prefix!.length, current.length); i++) {
          if (prefix[i] != current[i]) {
            prefix = prefix.substring(0, i);
            break;
          }
        }
      }
      // Give up, if the current prefix is empty.
      if (prefix.isEmpty) {
        return prefix;
      }
    }
    return prefix ?? '';
  }
}
