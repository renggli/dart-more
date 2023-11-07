import '../../../printer.dart';
import '../char_matcher.dart';

class RangesCharMatcher extends CharMatcher {
  const RangesCharMatcher(this.length, this.starts, this.stops)
      : assert(starts.length == length, '`starts` has invalid length'),
        assert(stops.length == length, '`stops` has invalid length');

  final int length;
  final List<int> starts;
  final List<int> stops;

  @override
  bool match(int value) {
    var min = 0;
    var max = length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final comp = starts[mid] - value;
      if (comp == 0) {
        return true;
      } else if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return 0 < min && value <= stops[min - 1];
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(length, name: 'length')
    ..addValue(starts, name: 'starts', printer: unicodeCodePointsPrinter)
    ..addValue(stops, name: 'stops', printer: unicodeCodePointsPrinter);
}

final unicodeCodePointsPrinter =
    unicodeCodePointPrinter.iterable(leadingItems: 3, trailingItems: 3);
