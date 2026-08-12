import '../char_matcher.dart';
import 'none.dart';

final class AnyCharMatcher extends CharMatcher {
  const new();

  @override
  bool match(int value) => true;

  @override
  CharMatcher operator ~() => const NoneCharMatcher();

  @override
  CharMatcher operator |(CharMatcher other) => this;

  @override
  CharMatcher operator &(CharMatcher other) => other;
}
