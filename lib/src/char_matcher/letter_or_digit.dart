library more.char_matcher.letter_or_digit;

import 'package:more/char_matcher.dart';

const CharMatcher letterOrDigit = const LetterOrDigitCharMatcher();

class LetterOrDigitCharMatcher extends CharMatcher {
  const LetterOrDigitCharMatcher();

  @override
  bool match(int value) =>
      (65 <= value && value <= 90) ||
          (97 <= value && value <= 122) ||
          (48 <= value && value <= 57) ||
          (value == 95);
}
