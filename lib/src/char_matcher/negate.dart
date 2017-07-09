library more.char_matcher.negate;

import 'package:more/char_matcher.dart';

class NegateCharMatcher extends CharMatcher {
  final CharMatcher matcher;

  const NegateCharMatcher(this.matcher);

  @override
  CharMatcher operator ~() => matcher;

  @override
  bool match(int value) => !matcher.match(value);
}
