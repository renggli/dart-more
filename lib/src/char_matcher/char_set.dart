import 'char_matcher.dart';
import 'optimize.dart';
import 'range.dart';

CharMatcher fromCharSet(String chars) =>
    optimize(chars.runes.map((value) => RangeCharMatcher(value, value)));
