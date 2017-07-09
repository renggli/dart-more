library more.char_matcher.any;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/none.dart';

const CharMatcher any = const AnyCharMatcher();

class AnyCharMatcher extends CharMatcher {
  const AnyCharMatcher();

  @override
  bool match(int value) => true;

  @override
  CharMatcher operator ~() => none;

  @override
  CharMatcher operator |(CharMatcher other) => this;
}
