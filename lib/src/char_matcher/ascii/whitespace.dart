import '../char_matcher.dart';

class WhitespaceCharMatcher extends CharMatcher {
  const WhitespaceCharMatcher();

  @override
  bool match(int value) => (9 <= value && value <= 13) || (value == 32);
}
