import '../../../printer.dart';
import '../char_matcher.dart';
import 'any.dart';
import 'none.dart';

class ConjunctiveCharMatcher extends CharMatcher {
  factory ConjunctiveCharMatcher(Iterable<CharMatcher> matchers) =>
      ConjunctiveCharMatcher._(List.of(matchers, growable: false));

  const ConjunctiveCharMatcher._(this.matchers);

  final List<CharMatcher> matchers;

  @override
  CharMatcher operator &(CharMatcher other) => switch (other) {
        AnyCharMatcher() => this,
        NoneCharMatcher() => other,
        ConjunctiveCharMatcher(matchers: final otherMatchers) =>
          ConjunctiveCharMatcher([...matchers, ...otherMatchers]),
        _ => ConjunctiveCharMatcher([...matchers, other])
      };

  @override
  bool match(int value) => matchers.every((matcher) => matcher.match(value));

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(matchers, name: 'matchers');
}
