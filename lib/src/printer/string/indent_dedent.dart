import '../../char_matcher/whitespace.dart';
import '../../collection/string/indent_dedent.dart';
import '../printer.dart';

extension IndentDedentPrinterExtension<T> on Printer<T> {
  /// Adds a [prefix] to the beginning of each line.
  Printer<T> indent(
    String prefix, {
    String? firstPrefix,
    bool trimWhitespace = true,
    bool indentEmpty = false,
  }) =>
      IndentPrinter<T>(this, prefix, firstPrefix, trimWhitespace, indentEmpty);

  /// Removes any common leading prefix from every line.
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
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer.print(object).indent(
            prefix,
            firstPrefix: firstPrefix,
            trimWhitespace: trimWhitespace,
            indentEmpty: indentEmpty,
          ));
}

class DedentPrinter<T> extends Printer<T> {
  const DedentPrinter(this.printer, this.whitespace, this.ignoreEmpty);

  final Printer<T> printer;
  final Pattern whitespace;
  final bool ignoreEmpty;

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer.print(object).dedent(
            whitespace: whitespace,
            ignoreEmpty: ignoreEmpty,
          ));
}
