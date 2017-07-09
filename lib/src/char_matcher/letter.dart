library more.char_matcher.letter;

import 'package:more/char_matcher.dart';

const CharMatcher letter = const LetterCharMatcher();

class LetterCharMatcher extends CharMatcher {
  const LetterCharMatcher();

  @override
  bool match(int value) =>
      (65 <= value && value <= 90) || (97 <= value && value <= 122);
}
