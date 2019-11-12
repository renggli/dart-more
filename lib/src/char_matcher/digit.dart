library more.char_matcher.digit;

import '../../char_matcher.dart';

class DigitCharMatcher extends CharMatcher {
  const DigitCharMatcher();

  @override
  bool match(int value) => 48 <= value && value <= 57;
}
