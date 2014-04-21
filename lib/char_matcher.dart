/**
 * A first-class model of character classes, their composition and operations
 * on strings.
 *
 * The implementation is inspired by [Guava](http://goo.gl/xXROX), the Google
 * collection of libraries for Java-based projects.
 */
library char_matcher;

/**
 * Abstract character matcher function.
 *
 * The [CharMatcher] is a boolean predicate on characters. The inclusion of a
 * character can be determined by calling the matcher with the code-unit
 * of a character as the function argument, for example:
 *
 *     WHITESPACE(' '.codeUnitAt(0)); // true
 *     DIGIT('a'.codeUnitAt(0)); // false
 *
 * A large collection of helper methods let you perform string operations on
 * the occurences of the specified class of characters: trimming, collapsing,
 * replacing, removing, retaining, etc. For example:
 *
 *     String withoutWhitespace = WHITESPACE.removeFrom(string);
 *     String onlyDigits = DIGIT.retainFrom(string);
 *
 */
abstract class CharMatcher {

  /** A matcher that accepts any character. */
  factory CharMatcher.any() => _ANY;

  /** A matcher that accepts no character. */
  factory CharMatcher.none() => _NONE;

  /** A matcher that accepts a single [character]. */
  factory CharMatcher.isChar(character) {
    return new _SingleCharMatcher(_toCharCode(character));
  }

  /** A matcher that accepts a character range from [start] to [stop]. */
  factory CharMatcher.inRange(start, stop) {
    return new _RangeCharMatcher(_toCharCode(start), _toCharCode(stop));
  }

  /** A matcher that accepts ASCII characters. */
  factory CharMatcher.ascii() => _ASCII;

  /** A matcher that accepts letters. */
  factory CharMatcher.letter() => _LETTER;

  /** A matcher that accepts upper-case letters. */
  factory CharMatcher.upperCaseLetter() => _UPPER_CASE_LETTER;

  /** A matcher that accepts lower-case letters. */
  factory CharMatcher.lowerCaseLetter() => _LOWER_CASE_LETTER;

  /** A matcher that accepts letters or digits. */
  factory CharMatcher.letterOrDigit() => _LETTER_OR_DIGIT;

  /** A matcher that accepts digits. */
  factory CharMatcher.digit() => _DIGIT;

  /** A matcher that accepts whitespaces. */
  factory CharMatcher.whitespace() => _WHITESPACE;

  const CharMatcher();

  /**
   * Returns a matcher that matches any character not matched by this matcher.
   */
  CharMatcher operator ~() => new _NegateCharMatcher(this);

  /**
   * Returns a matcher that matches any character matched by either this
   * matcher or [other].
   */
  CharMatcher operator |(CharMatcher other) {
    if (other == _ANY) {
      return other;
    } else if (other == _NONE) {
      return this;
    } else if (other is _DisjunctiveCharMatcher) {
      return new _DisjunctiveCharMatcher(new List()
          ..add(this)
          ..addAll(other._matchers));
    } else {
      return new _DisjunctiveCharMatcher([this, other]);
    }
  }

  /**
   * Determines if the given character code belongs to the character class.
   */
  bool match(int value);

  /**
   * Returns `true` if the [sequence] contains only matching characters.
   */
  bool everyOf(String sequence) {
    return sequence.codeUnits.every(match);
  }

  /**
   * Returns `true` if the [sequence] contains at least one matching character.
   */
  bool anyOf(String sequence) {
    return sequence.codeUnits.any(match);
  }

  /**
   * Returns the first matching index in [sequence], searching backward
   * starting at [start] (inclusive). Returns `-1` if it could not be found.
   */
  int firstIndexIn(String sequence, [int start = 0]) {
    var codeUnits = sequence.codeUnits;
    for (var i = start; i < codeUnits.length; i++) {
      if (match(codeUnits[i])) {
        return i;
      }
    }
    return -1;
  }

  /**
   * Returns the last matching index in [sequence] starting at [start]
   * (inclusive). Returns `-1` if it could not be found.
   */
  int lastIndexIn(String sequence, [int start]) {
    var codeUnits = sequence.codeUnits;
    if (start == null) {
      start = codeUnits.length - 1;
    }
    for (var i = start; i >= 0; i--) {
      if (match(codeUnits[i])) {
        return i;
      }
    }
    return -1;
  }

  /**
   * Counts the number of matches in [sequence].
   */
  int countIn(String sequence) {
    return sequence.codeUnits.where(match).length;
  }

  /**
   * Replaces each group of consecutive matched characters in [sequence]
   * with the specified [replacement].
   */
  String collapseFrom(String sequence, String replacement) {
    var i = 0;
    var list = new List();
    var codeUnits = sequence.codeUnits;
    var replacementCodes = replacement.codeUnits;
    while (i < codeUnits.length) {
      var codeUnit = codeUnits[i];
      if (match(codeUnit)) {
        do {
          i++;
        } while (i < codeUnits.length && match(codeUnits[i]));
        list.addAll(replacementCodes);
      } else {
        list.add(codeUnit);
        i++;
      }
    }
    return new String.fromCharCodes(list);
  }

  /**
   * Replaces each matched character in [sequence] with the sepcified
   * [replacement].
   */
  String replaceFrom(String sequence, String replacement) {
    var replacementCodes = replacement.codeUnits;
    return new String.fromCharCodes(sequence.codeUnits.expand((value) {
      return match(value) ? replacementCodes : [value];
    }));
  }

  /**
   * Removes all matched characters in [sequence].
   */
  String removeFrom(String sequence) {
    return new String.fromCharCodes(sequence.codeUnits.where((~this).match));
  }

  /**
   * Retains all matched characters in [sequence].
   */
  String retainFrom(String sequence) {
    return new String.fromCharCodes(sequence.codeUnits.where(match));
  }

  /**
   * Removes leading and trailing matching characters in [sequence].
   */
  String trimFrom(String sequence) {
    var codeUnits = sequence.codeUnits;
    var left = 0, right = codeUnits.length - 1;
    while (left <= right && match(codeUnits[left])) {
      left++;
    }
    while (left <= right && match(codeUnits[right])) {
      right--;
    }
    return sequence.substring(left, right + 1);
  }

  /**
   * Removes leading matching characters in [sequence].
   */
  String trimLeadingFrom(String sequence) {
    var codeUnits = sequence.codeUnits;
    var left = 0, right = codeUnits.length - 1;
    while (left <= right && match(codeUnits[left])) {
      left++;
    }
    return sequence.substring(left, right + 1);
  }

  /**
   * Removes tailing matching characters in [sequence].
   */
  String trimTailingFrom(String sequence) {
    var codeUnits = sequence.codeUnits;
    var left = 0, right = codeUnits.length - 1;
    while (left <= right && match(codeUnits[right])) {
      right--;
    }
    return sequence.substring(left, right + 1);
  }

}

class _NegateCharMatcher extends CharMatcher {

  final CharMatcher _matcher;

  const _NegateCharMatcher(this._matcher);

  @override
  CharMatcher operator ~() => _matcher;

  @override
  bool match(int value) => !_matcher.match(value);

}

class _DisjunctiveCharMatcher extends CharMatcher {

  final List<CharMatcher> _matchers;

  const _DisjunctiveCharMatcher(this._matchers);

  @override
  CharMatcher operator | (CharMatcher other) {
    if (other == _ANY) {
      return other;
    } else if (other == _NONE) {
      return this;
    } else if (other is _DisjunctiveCharMatcher) {
      return new _DisjunctiveCharMatcher(new List()
        ..addAll(_matchers)
        ..addAll(other._matchers));
    } else {
      return new _DisjunctiveCharMatcher(new List()
        ..addAll(_matchers)
        ..add(other));
    }
  }

  @override
  bool match(int value) {
    return _matchers.any((matcher) => matcher.match(value));
  }

}

const CharMatcher _ANY = const _AnyCharMatcher();

class _AnyCharMatcher extends CharMatcher {

  const _AnyCharMatcher();

  @override
  bool match(int value) => true;

  @override
  CharMatcher operator ~() => _NONE;

  @override
  CharMatcher operator |(CharMatcher other) => this;

}

const CharMatcher _NONE = const _NoneCharMatcher();

class _NoneCharMatcher extends CharMatcher {

  const _NoneCharMatcher();

  @override
  bool match(int value) => false;

  @override
  CharMatcher operator ~() => _ANY;

  @override
  CharMatcher operator |(CharMatcher other) => other;

}

class _SingleCharMatcher extends CharMatcher {

  final int _value;

  const _SingleCharMatcher(this._value);

  @override
  bool match(int value) => _value == value;

}

class _RangeCharMatcher extends CharMatcher {

  final int _start;
  final int _stop;

  const _RangeCharMatcher(this._start, this._stop);

  @override
  bool match(int value) => _start <= value && value <= _stop;

}

const CharMatcher _ASCII = const _AsciiCharMatcher();

class _AsciiCharMatcher extends CharMatcher {

  const _AsciiCharMatcher();

  @override
  bool match(int value) => value < 128;

}

const CharMatcher _DIGIT = const _DigitCharMatcher();

class _DigitCharMatcher extends CharMatcher {

  const _DigitCharMatcher();

  @override
  bool match(int value) => 48 <= value && value <= 57;

}

const CharMatcher _LETTER = const _LetterCharMatcher();

class _LetterCharMatcher extends CharMatcher {

  const _LetterCharMatcher();

  @override
  bool match(int value) => (65 <= value && value <= 90) || (97 <= value && value <= 122);

}

const CharMatcher _LOWER_CASE_LETTER = const _LowerCaseLetterCharMatcher();

class _LowerCaseLetterCharMatcher extends CharMatcher {

  const _LowerCaseLetterCharMatcher();

  @override
  bool match(int value) => 97 <= value && value <= 122;

}

const CharMatcher _UPPER_CASE_LETTER = const _UpperCaseLetterCharMatcher();

class _UpperCaseLetterCharMatcher extends CharMatcher {

  const _UpperCaseLetterCharMatcher();

  @override
  bool match(int value) => 65 <= value && value <= 90;

}

const CharMatcher _LETTER_OR_DIGIT = const _LetterOrDigitCharMatcher();

class _LetterOrDigitCharMatcher extends CharMatcher {

  const _LetterOrDigitCharMatcher();

  @override
  bool match(int value) => (65 <= value && value <= 90)
      || (97 <= value && value <= 122) || (48 <= value && value <= 57)
      || (value == 95);

}

const CharMatcher _WHITESPACE = const _WhitespaceCharMatcher();

class _WhitespaceCharMatcher extends CharMatcher {

  const _WhitespaceCharMatcher();

  @override
  bool match(int value) {
    if (value < 256) {
      return value == 0x09 || value == 0x0A || value == 0x0B || value == 0x0C
          || value == 0x0D || value == 0x20 || value == 0x85 || value == 0xA0;
    } else {
      return value == 0x1680 || value == 0x180E || value == 0x2000 || value == 0x2001
          || value == 0x2002 || value == 0x2003 || value == 0x2004 || value == 0x2005
          || value == 0x2006 || value == 0x2007 || value == 0x2008 || value == 0x2009
          || value == 0x200A || value == 0x2028 || value == 0x2029 || value == 0x202F
          || value == 0x205F || value == 0x3000 || value == 0xFEFF;
    }
  }

}

int _toCharCode(char) {
  if (char is num) {
    return char.round();
  }
  var value = char.toString();
  if (value.length != 1) {
    throw new ArgumentError('$value is not a character');
  }
  return value.codeUnitAt(0);
}
