import '../../char_matcher.dart';

class RangesCharMatcher extends CharMatcher {
  final int length;
  final List<int> starts;
  final List<int> stops;

  const RangesCharMatcher(this.length, this.starts, this.stops);

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
}
