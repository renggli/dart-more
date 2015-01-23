part of char_matcher;

class _RangeCharMatcher extends CharMatcher {
  final int _start;
  final int _stop;

  const _RangeCharMatcher(this._start, this._stop);

  @override
  bool match(int value) => _start <= value && value <= _stop;
}
