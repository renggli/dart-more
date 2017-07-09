library more.char_matcher.digit;

import 'package:more/char_matcher.dart';

const CharMatcher digit = const DigitCharMatcher();

class DigitCharMatcher extends CharMatcher {
  const DigitCharMatcher();

  @override
  bool match(int value) => 48 <= value && value <= 57;
}
