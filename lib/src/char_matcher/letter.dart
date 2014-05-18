part of char_matcher;

const CharMatcher _LETTER = const _LetterCharMatcher();

class _LetterCharMatcher extends CharMatcher {

  const _LetterCharMatcher();

  @override
  bool match(int value) => (65 <= value && value <= 90) || (97 <= value && value <= 122);

}