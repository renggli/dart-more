part of char_matcher;

const CharMatcher _ANY = const _AnyCharMatcher();

class _AnyCharMatcher extends CharMatcher {
  const _AnyCharMatcher();

  @override
  bool match(int value) => true;

  @override
  CharMatcher operator ~() => _NONE;

  @override
  CharMatcher operator |(CharMatcher other) => this;
}
