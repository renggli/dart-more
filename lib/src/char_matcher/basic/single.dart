import '../../../printer.dart';
import '../char_matcher.dart';

final class SingleCharMatcher extends CharMatcher {
  const new(this.codePoint);

  final int codePoint;

  @override
  bool match(int value) => identical(codePoint, value);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(codePoint, name: 'codePoint', printer: unicodeCodePointPrinter);
}
