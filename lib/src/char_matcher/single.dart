import 'char_matcher.dart';

class SingleCharMatcher extends CharMatcher {
  const SingleCharMatcher(this.charValue);

  final int charValue;

  @override
  bool match(int value) => identical(charValue, value);
}
