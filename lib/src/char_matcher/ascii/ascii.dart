import '../char_matcher.dart';

final class AsciiCharMatcher extends CharMatcher {
  const new();

  @override
  bool match(int value) => value < 128;
}
