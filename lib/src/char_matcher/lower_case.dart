library more.char_matcher.lower_case;

import 'package:more/char_matcher.dart';

const CharMatcher lowerCaseLetter = const LowerCaseLetterCharMatcher();

class LowerCaseLetterCharMatcher extends CharMatcher {
  const LowerCaseLetterCharMatcher();

  @override
  bool match(int value) => 97 <= value && value <= 122;
}
