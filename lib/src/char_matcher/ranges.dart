library more.char_matcher.ranges;

import 'package:more/char_matcher.dart';

class RangesCharMatcher extends CharMatcher {
  final int length;
  final List<int> starts;
  final List<int> stops;

  RangesCharMatcher(this.length, this.starts, this.stops) {
    if (length != starts.length || length != stops.length) {
      throw new ArgumentError("Invalid range sizes.");
    }
    for (int i = 0; i < length; i++) {
      if (starts[i] > stops[i]) {
        throw new ArgumentError('Invalid range: ${starts[i]}-${stops[i]}.');
      }
      if (i + 1 < length && starts[i + 1] <= stops[i]) {
        throw new ArgumentError("Invalid sequence.");
      }
    }
  }

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
