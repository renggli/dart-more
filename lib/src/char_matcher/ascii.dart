part of more.char_matcher;

const CharMatcher _ascii = const _AsciiCharMatcher();

class _AsciiCharMatcher extends CharMatcher {
  const _AsciiCharMatcher();

  @override
  bool match(int value) => value < 128;
}
