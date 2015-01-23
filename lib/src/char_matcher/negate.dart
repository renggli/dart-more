part of char_matcher;

class _NegateCharMatcher extends CharMatcher {
  final CharMatcher _matcher;

  const _NegateCharMatcher(this._matcher);

  @override
  CharMatcher operator ~() => _matcher;

  @override
  bool match(int value) => !_matcher.match(value);
}
