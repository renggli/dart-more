import 'char_matcher.dart';

class NegateCharMatcher extends CharMatcher {
  const NegateCharMatcher(this.matcher);

  final CharMatcher matcher;

  @override
  CharMatcher operator ~() => matcher;

  @override
  bool match(int value) => !matcher.match(value);
}
