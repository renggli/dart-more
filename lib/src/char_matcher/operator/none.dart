import '../char_matcher.dart';
import 'any.dart';

final class NoneCharMatcher extends CharMatcher {
  const new();

  @override
  bool match(int value) => false;

  @override
  CharMatcher operator ~() => const AnyCharMatcher();

  @override
  CharMatcher operator |(CharMatcher other) => other;

  @override
  CharMatcher operator &(CharMatcher other) => this;
}
