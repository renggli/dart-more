part of char_matcher;

const CharMatcher _LOWER_CASE_LETTER = const _LowerCaseLetterCharMatcher();

class _LowerCaseLetterCharMatcher extends CharMatcher {
  const _LowerCaseLetterCharMatcher();

  @override
  bool match(int value) => 97 <= value && value <= 122;
}
