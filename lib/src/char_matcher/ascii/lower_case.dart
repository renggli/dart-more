import '../char_matcher.dart';

final class LowerCaseLetterCharMatcher extends CharMatcher {
  const LowerCaseLetterCharMatcher();

  @override
  bool match(int value) => 97 <= value && value <= 122;
}
