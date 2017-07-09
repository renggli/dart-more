library more.char_matcher.none;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/any.dart';

const CharMatcher none = const NoneCharMatcher();

class NoneCharMatcher extends CharMatcher {
  const NoneCharMatcher();

  @override
  bool match(int value) => false;

  @override
  CharMatcher operator ~() => any;

  @override
  CharMatcher operator |(CharMatcher other) => other;
}
