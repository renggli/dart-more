library more.char_matcher.char_set;

import '../../char_matcher.dart';
import 'optimize.dart';
import 'range.dart';

CharMatcher fromCharSet(String chars) => optimize(
    chars.codeUnits.map((codeUnit) => RangeCharMatcher(codeUnit, codeUnit)));
