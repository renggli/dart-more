import '../char_matcher.dart';

final class PunctuationCharMatcher extends CharMatcher {
  const PunctuationCharMatcher();

  @override
  bool match(int value) =>
      (33 <= value && value <= 47) || // !"#\$%&\'()*+,-./
      (58 <= value && value <= 64) || // :;<=>?@
      (91 <= value && value <= 96) || // [\]^_`
      (123 <= value && value <= 126); // {|}~
}
