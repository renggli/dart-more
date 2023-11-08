import '../char_matcher.dart';

class WhitespaceCharMatcher extends CharMatcher {
  const WhitespaceCharMatcher();

  @override
  bool match(int value) {
    // https://en.wikipedia.org/wiki/Whitespace_character
    if (value < 256) {
      switch (value) {
        case 0x09: // character tabulation
        case 0x0A: // line feed
        case 0x0B: // line tabulation
        case 0x0C: // form feed
        case 0x0D: // carriage return
        case 0x20: // space
        case 0x85: // next line
        case 0xA0: // no-break space
          return true;
        default:
          return false;
      }
    }
    switch (value) {
      case 0x1680: // ogham space mark
      case 0x2000: // en quad
      case 0x2001: // em quad
      case 0x2002: // en space
      case 0x2003: // em space
      case 0x2004: // three-per-em space
      case 0x2005: // four-per-em space
      case 0x2006: // six-per-em space
      case 0x2007: // figure space
      case 0x2008: // punctuation space
      case 0x2009: // thin space
      case 0x200A: // hair space
      case 0x2028: // line separator
      case 0x2029: // paragraph separator
      case 0x202F: // narrow no-break space
      case 0x205F: // medium mathematical space
      case 0x3000: // ideographic space
        return true;
      default:
        return false;
    }
  }
}
