import '../char_matcher.dart';

final class UpperCaseLetterCharMatcher extends CharMatcher {
  const new();

  @override
  bool match(int value) => 65 <= value && value <= 90;
}
