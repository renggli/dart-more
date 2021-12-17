import 'char_matcher.dart';

class AsciiCharMatcher extends CharMatcher {
  const AsciiCharMatcher();

  @override
  bool match(int value) => value < 128;
}
