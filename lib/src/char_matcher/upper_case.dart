part of char_matcher;

const CharMatcher _UPPER_CASE_LETTER = const _UpperCaseLetterCharMatcher();

class _UpperCaseLetterCharMatcher extends CharMatcher {

  const _UpperCaseLetterCharMatcher();

  @override
  bool match(int value) => 65 <= value && value <= 90;

}