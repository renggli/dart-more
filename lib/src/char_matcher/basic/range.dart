import '../../../printer.dart';
import '../char_matcher.dart';

class RangeCharMatcher extends CharMatcher {
  const RangeCharMatcher(this.start, this.stop)
      : assert(start <= stop, 'Invalid range: $start-$stop');

  final int start;
  final int stop;

  @override
  bool match(int value) => start <= value && value <= stop;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(start, name: 'start', printer: unicodeCodePointPrinter)
    ..addValue(stop, name: 'stop', printer: unicodeCodePointPrinter);
}
