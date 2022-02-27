import '../../printer.dart';
import 'char_matcher.dart';

class RangeCharMatcher extends CharMatcher {
  RangeCharMatcher(this.start, this.stop) {
    if (start > stop) {
      throw ArgumentError('Invalid range: $start-$stop');
    }
  }

  final int start;
  final int stop;

  @override
  bool match(int value) => start <= value && value <= stop;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(start, name: 'start')
    ..addValue(stop, name: 'stop');
}
