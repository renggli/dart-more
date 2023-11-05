import 'any.dart';
import 'char_matcher.dart';

class NoneCharMatcher extends CharMatcher {
  const NoneCharMatcher();

  @override
  bool match(int value) => false;

  @override
  CharMatcher operator ~() => const AnyCharMatcher();

  @override
  CharMatcher operator |(CharMatcher other) => other;

  @override
  CharMatcher operator &(CharMatcher other) => this;
}
