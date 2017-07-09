library more.char_matcher.ascii;

import 'package:more/char_matcher.dart';

const CharMatcher ascii = const AsciiCharMatcher();

class AsciiCharMatcher extends CharMatcher {
  const AsciiCharMatcher();

  @override
  bool match(int value) => value < 128;
}
