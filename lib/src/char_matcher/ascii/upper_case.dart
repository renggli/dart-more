import '../char_matcher.dart';

final class UpperCaseLetterCharMatcher extends CharMatcher {
  const UpperCaseLetterCharMatcher();

  @override
  bool match(int value) => 65 <= value && value <= 90;
}
