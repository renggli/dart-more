part of more.char_matcher;

const CharMatcher _none = const _NoneCharMatcher();

class _NoneCharMatcher extends CharMatcher {
  const _NoneCharMatcher();

  @override
  bool match(int value) => false;

  @override
  CharMatcher operator ~() => _any;

  @override
  CharMatcher operator |(CharMatcher other) => other;
}
