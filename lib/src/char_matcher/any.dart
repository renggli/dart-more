part of more.char_matcher;

const CharMatcher _any = const _AnyCharMatcher();

class _AnyCharMatcher extends CharMatcher {
  const _AnyCharMatcher();

  @override
  bool match(int value) => true;

  @override
  CharMatcher operator ~() => _none;

  @override
  CharMatcher operator |(CharMatcher other) => this;
}
