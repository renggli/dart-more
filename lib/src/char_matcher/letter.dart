part of more.char_matcher;

const CharMatcher _letter = const _LetterCharMatcher();

class _LetterCharMatcher extends CharMatcher {
  const _LetterCharMatcher();

  @override
  bool match(int value) =>
      (65 <= value && value <= 90) || (97 <= value && value <= 122);
}
