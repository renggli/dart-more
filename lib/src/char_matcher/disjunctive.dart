import '../../char_matcher.dart';
import 'any.dart';
import 'none.dart';

class DisjunctiveCharMatcher extends CharMatcher {
  final List<CharMatcher> matchers;

  factory DisjunctiveCharMatcher(Iterable<CharMatcher> matchers) =>
      DisjunctiveCharMatcher._(List.of(matchers, growable: false));

  const DisjunctiveCharMatcher._(this.matchers);

  @override
  CharMatcher operator |(CharMatcher other) {
    if (other is AnyCharMatcher) {
      return other;
    } else if (other is NoneCharMatcher) {
      return this;
    } else if (other is DisjunctiveCharMatcher) {
      return DisjunctiveCharMatcher([...matchers, ...other.matchers]);
    } else {
      return DisjunctiveCharMatcher([...matchers, other]);
    }
  }

  @override
  bool match(int value) => matchers.any((matcher) => matcher.match(value));
}
