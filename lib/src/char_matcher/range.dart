library more.char_matcher.range;

import 'package:more/char_matcher.dart';

class RangeCharMatcher extends CharMatcher {
  final int start;
  final int stop;

  const RangeCharMatcher(this.start, this.stop);

  @override
  bool match(int value) => start <= value && value <= stop;
}
