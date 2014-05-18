part of char_matcher;

class _DisjunctiveCharMatcher extends CharMatcher {

  final List<CharMatcher> _matchers;

  const _DisjunctiveCharMatcher(this._matchers);

  @override
  CharMatcher operator | (CharMatcher other) {
    if (other == _ANY) {
      return other;
    } else if (other == _NONE) {
      return this;
    } else if (other is _DisjunctiveCharMatcher) {
      return new _DisjunctiveCharMatcher(new List()
        ..addAll(_matchers)
        ..addAll(other._matchers));
    } else {
      return new _DisjunctiveCharMatcher(new List()
        ..addAll(_matchers)
        ..add(other));
    }
  }

  @override
  bool match(int value) {
    return _matchers.any((matcher) => matcher.match(value));
  }

}