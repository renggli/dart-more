part of char_matcher;

const CharMatcher _LETTER_OR_DIGIT = const _LetterOrDigitCharMatcher();

class _LetterOrDigitCharMatcher extends CharMatcher {
  const _LetterOrDigitCharMatcher();

  @override
  bool match(int value) => (65 <= value && value <= 90) ||
      (97 <= value && value <= 122) ||
      (48 <= value && value <= 57) ||
      (value == 95);
}
