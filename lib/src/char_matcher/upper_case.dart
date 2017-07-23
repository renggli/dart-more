library more.char_matcher.upper_case;

import 'package:more/char_matcher.dart';

class UpperCaseLetterCharMatcher extends CharMatcher {
  const UpperCaseLetterCharMatcher();

  @override
  bool match(int value) => 65 <= value && value <= 90;
}
