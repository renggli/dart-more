import 'char_matcher.dart';

class LowerCaseLetterCharMatcher extends CharMatcher {
  const LowerCaseLetterCharMatcher();

  @override
  bool match(int value) => 97 <= value && value <= 122;
}
