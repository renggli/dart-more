import '../../printer.dart';
import 'any.dart';
import 'char_matcher.dart';
import 'none.dart';

class DisjunctiveCharMatcher extends CharMatcher {
  factory DisjunctiveCharMatcher(Iterable<CharMatcher> matchers) =>
      DisjunctiveCharMatcher._(List.of(matchers, growable: false));

  const DisjunctiveCharMatcher._(this.matchers);

  final List<CharMatcher> matchers;

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

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(matchers, name: 'matchers');
}
