library more.char_matcher.single;

import '../../char_matcher.dart';

class SingleCharMatcher extends CharMatcher {
  final int charValue;

  const SingleCharMatcher(this.charValue);

  @override
  bool match(int value) => identical(charValue, value);
}
