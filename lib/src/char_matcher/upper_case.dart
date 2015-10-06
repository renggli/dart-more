part of more.char_matcher;

const CharMatcher _upperCaseLetter = const _UpperCaseLetterCharMatcher();

class _UpperCaseLetterCharMatcher extends CharMatcher {
  const _UpperCaseLetterCharMatcher();

  @override
  bool match(int value) => 65 <= value && value <= 90;
}
