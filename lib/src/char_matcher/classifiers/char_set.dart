import '../basic/range.dart';
import '../char_matcher.dart';
import 'optimize.dart';

CharMatcher fromCharSet(String chars) =>
    optimize(chars.runes.map((value) => RangeCharMatcher(value, value)));
