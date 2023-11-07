import '../../../printer.dart';
import '../char_matcher.dart';

class SingleCharMatcher extends CharMatcher {
  const SingleCharMatcher(this.codePoint);

  final int codePoint;

  @override
  bool match(int value) => identical(codePoint, value);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(codePoint, name: 'codePoint', printer: unicodeCodePointPrinter);
}
