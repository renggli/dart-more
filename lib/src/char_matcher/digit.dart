part of more.char_matcher;

const CharMatcher _digit = const _DigitCharMatcher();

class _DigitCharMatcher extends CharMatcher {
  const _DigitCharMatcher();

  @override
  bool match(int value) => 48 <= value && value <= 57;
}
