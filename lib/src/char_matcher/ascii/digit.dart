import '../char_matcher.dart';

final class DigitCharMatcher extends CharMatcher {
  const DigitCharMatcher();

  @override
  bool match(int value) => 48 <= value && value <= 57;
}
