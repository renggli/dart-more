import '../../char_matcher.dart';

class LetterCharMatcher extends CharMatcher {
  const LetterCharMatcher();

  @override
  bool match(int value) =>
      (65 <= value && value <= 90) || (97 <= value && value <= 122);
}
