part of char_matcher;

class _SingleCharMatcher extends CharMatcher {
  final int _value;

  const _SingleCharMatcher(this._value);

  @override
  bool match(int value) => _value == value;
}
