library more.char_matcher.char_set;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/optimize.dart';
import 'package:more/src/char_matcher/range.dart';

CharMatcher fromCharSet(String chars) {
  return optimize(chars.codeUnits.map((codeUnit) => new RangeCharMatcher(codeUnit, codeUnit)));
}
