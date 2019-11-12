library more.char_matcher.range;

import '../../char_matcher.dart';

class RangeCharMatcher extends CharMatcher {
  final int start;
  final int stop;

  RangeCharMatcher(this.start, this.stop) {
    if (start > stop) {
      throw ArgumentError('Invalid range: $start-$stop');
    }
  }

  @override
  bool match(int value) => start <= value && value <= stop;
}
