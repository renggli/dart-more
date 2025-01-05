import '../../../printer.dart';
import '../char_matcher.dart';

final class NegateCharMatcher extends CharMatcher {
  const NegateCharMatcher(this.matcher);

  final CharMatcher matcher;

  @override
  CharMatcher operator ~() => matcher;

  @override
  bool match(int value) => !matcher.match(value);

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(matcher, name: 'matcher');
}
