import '../char_matcher.dart';

final class AsciiCharMatcher extends CharMatcher {
  const AsciiCharMatcher();

  @override
  bool match(int value) => value < 128;
}
