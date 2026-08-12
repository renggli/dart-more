import '../char_matcher.dart';

final class DigitCharMatcher extends CharMatcher {
  const new();

  @override
  bool match(int value) => 48 <= value && value <= 57;
}
