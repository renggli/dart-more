part of char_matcher;

const CharMatcher _NONE = const _NoneCharMatcher();

class _NoneCharMatcher extends CharMatcher {

  const _NoneCharMatcher();

  @override
  bool match(int value) => false;

  @override
  CharMatcher operator ~() => _ANY;

  @override
  CharMatcher operator |(CharMatcher other) => other;

}