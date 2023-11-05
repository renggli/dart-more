import 'char_matcher.dart';
import 'none.dart';

class AnyCharMatcher extends CharMatcher {
  const AnyCharMatcher();

  @override
  bool match(int value) => true;

  @override
  CharMatcher operator ~() => const NoneCharMatcher();

  @override
  CharMatcher operator |(CharMatcher other) => this;

  @override
  CharMatcher operator &(CharMatcher other) => other;
}
