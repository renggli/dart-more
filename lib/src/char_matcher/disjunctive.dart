library more.char_matcher.disjunctive;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/any.dart';
import 'package:more/src/char_matcher/none.dart';

class DisjunctiveCharMatcher extends CharMatcher {
  final List<CharMatcher> matchers;

  factory DisjunctiveCharMatcher(Iterable<CharMatcher> matchers) {
    return new DisjunctiveCharMatcher._(
        new List.from(matchers, growable: false));
  }

  const DisjunctiveCharMatcher._(this.matchers);

  @override
  CharMatcher operator |(CharMatcher other) {
    if (other is AnyCharMatcher) {
      return other;
    } else if (other is NoneCharMatcher) {
      return this;
    } else if (other is DisjunctiveCharMatcher) {
      return new DisjunctiveCharMatcher(
          []..addAll(matchers)..addAll(other.matchers));
    } else {
      return new DisjunctiveCharMatcher([]
        ..addAll(matchers)
        ..add(other));
    }
  }

  @override
  bool match(int value) {
    return matchers.any((matcher) => matcher.match(value));
  }
}
