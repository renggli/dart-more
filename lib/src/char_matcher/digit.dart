part of char_matcher;

const CharMatcher _DIGIT = const _DigitCharMatcher();

class _DigitCharMatcher extends CharMatcher {

  const _DigitCharMatcher();

  @override
  bool match(int value) => 48 <= value && value <= 57;

}
