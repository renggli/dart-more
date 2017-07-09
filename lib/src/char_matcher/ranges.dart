part of more.char_matcher;

class _RangesCharMatcher extends CharMatcher {

  final int length;
  final List<int> starts;
  final List<int> stops;

  const _RangesCharMatcher(this.length, this.starts, this.stops);

  @override
  bool match(int value) {
    var min = 0;
    var max = length;
    while (min < max) {
      var mid = min + ((max - min) >> 1);
      var comp = starts[mid] - value;
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