library more.char_matcher.any;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/none.dart';

class AnyCharMatcher extends CharMatcher {
  const AnyCharMatcher();

  @override
  bool match(int value) => true;

  @override
  CharMatcher operator ~() => const NoneCharMatcher();

  @override
  CharMatcher operator |(CharMatcher other) => this;
}
