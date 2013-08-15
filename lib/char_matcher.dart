// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 * Provides a first-class model of character classes, their composition
 * and operations on strings.
 *
 * The implementation closely follows [Guava](http://goo.gl/xXROX), the Google
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
  CharMatcher operator ~ () => new _NegateCharMatcher(this);

  /**
   * Returns a matcher that matches any character matched by either this
   * matcher or [other].
   */
  CharMatcher operator | (CharMatcher other) {
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
  bool call(int value);

  /**
   * Returns `true` if the [sequence] contains only matching  characters.
   */
  bool everyOf(String sequence) {
    return sequence.codeUnits.every(this);
  }

  /**
   * Returns `true` if the [sequence] contains at least one matching character.
   */
  bool anyOf(String sequence) {
    return sequence.codeUnits.any(this);
  }

  /**
   * Returns the first matching index in [sequence], searching backward
   * starting at [start] (inclusive). Returns `-1` if it could not be found.
   */
  int firstIndexIn(String sequence, [int start = 0]) {
    var codeUnits = sequence.codeUnits;
    for (var i = start; i < codeUnits.length; i++) {
      if (this(codeUnits[i])) {
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
      if (this(codeUnits[i])) {
        return i;
      }
    }
    return -1;
  }

  /**
   * Counts the number of matches in [sequence].
   */
  int countIn(String sequence) {
    return sequence.codeUnits.where(this).length;
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
      if (this(codeUnit)) {
        do {
          i++;
        } while (i < codeUnits.length && this(codeUnits[i]));
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
      return this(value) ? replacementCodes : [value];
    }));
  }

  /**
   * Removes all matched characters in [sequence].
   */
  String removeFrom(String sequence) {
    return new String.fromCharCodes(sequence.codeUnits.where(~this));
  }

  /**
   * Retains all matched characters in [sequence].
   */
  String retainFrom(String sequence) {
    return new String.fromCharCodes(sequence.codeUnits.where(this));
  }

  /**
   * Removes leading and trailing matching characters in [sequence].
   */
  String trimFrom(String sequence) {
    var codeUnits = sequence.codeUnits;
    var left = 0, right = codeUnits.length - 1;
    while (left <= right && this(codeUnits[left])) {
      left++;
    }
    while (left <= right && this(codeUnits[right])) {
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
    while (left <= right && this(codeUnits[left])) {
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
    while (left <= right && this(codeUnits[right])) {
      right--;
    }
    return sequence.substring(left, right + 1);
  }

}

class _NegateCharMatcher extends CharMatcher {
  final CharMatcher _matcher;
  const _NegateCharMatcher(this._matcher);
  String toString() => '~$_matcher';
  CharMatcher operator ~ () => _matcher;
  bool call(int value) => !_matcher(value);
}

class _DisjunctiveCharMatcher extends CharMatcher {
  final List<CharMatcher> _matchers;
  const _DisjunctiveCharMatcher(this._matchers);
  String toString() => _matchers.join(' | ');
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
  bool call(int value) {
    return _matchers.any((matcher) => matcher(value));
  }
}

final CharMatcher _ANY = const _AnyCharMatcher();

class _AnyCharMatcher extends CharMatcher {
  const _AnyCharMatcher();
  String toString() => 'any()';
  bool call(int value) => true;
  CharMatcher operator ~ () => _NONE;
  CharMatcher operator | (CharMatcher other) => this;
}

final CharMatcher _NONE = const _NoneCharMatcher();

class _NoneCharMatcher extends CharMatcher {
  const _NoneCharMatcher();
  String toString() => 'none()';
  bool call(int value) => false;
  CharMatcher operator ~ () => _ANY;
  CharMatcher operator | (CharMatcher other) => other;
}

class _SingleCharMatcher extends CharMatcher {
  final int _value;
  const _SingleCharMatcher(this._value);
  String toString() => 'isChar("' + new String.fromCharCode(_value) + '")';
  bool call(int value) => _value == value;
}

class _RangeCharMatcher extends CharMatcher {
  final int _start;
  final int _stop;
  const _RangeCharMatcher(this._start, this._stop);
  String toString() => 'inRange("' + new String.fromCharCode(_start) +
      '", "' + new String.fromCharCode(_stop) + '")';
  bool call(int value) => _start <= value && value <= _stop;
}

final CharMatcher _ASCII = const _AsciiCharMatcher();

class _AsciiCharMatcher extends CharMatcher {
  const _AsciiCharMatcher();
  String toString() => 'ascii()';
  bool call(int value) => value < 128;
}

final CharMatcher _DIGIT = const _DigitCharMatcher();

class _DigitCharMatcher extends CharMatcher {
  const _DigitCharMatcher();
  String toString() => 'digit()';
  bool call(int value) => 48 <= value && value <= 57;
}

final CharMatcher _LETTER = const _LetterCharMatcher();

class _LetterCharMatcher extends CharMatcher {
  const _LetterCharMatcher();
  String toString() => 'letter()';
  bool call(int value) => (65 <= value && value <= 90)
      || (97 <= value && value <= 122);
}

final CharMatcher _LOWER_CASE_LETTER = const _LowerCaseLetterCharMatcher();

class _LowerCaseLetterCharMatcher extends CharMatcher {
  const _LowerCaseLetterCharMatcher();
  String toString() => 'lowerCaseLetter()';
  bool call(int value) => 97 <= value && value <= 122;
}

final CharMatcher _UPPER_CASE_LETTER = const _UpperCaseLetterCharMatcher();

class _UpperCaseLetterCharMatcher extends CharMatcher {
  const _UpperCaseLetterCharMatcher();
  String toString() => 'upperCaseLetter()';
  bool call(int value) => 65 <= value && value <= 90;
}

final CharMatcher _LETTER_OR_DIGIT = const _LetterOrDigitCharMatcher();

class _LetterOrDigitCharMatcher extends CharMatcher {
  const _LetterOrDigitCharMatcher();
  String toString() => 'letterOrDigit()';
  bool call(int value) => (65 <= value && value <= 90)
      || (97 <= value && value <= 122) || (48 <= value && value <= 57)
      || (value == 95);
}

final CharMatcher _WHITESPACE = const _WhitespaceCharMatcher();

class _WhitespaceCharMatcher extends CharMatcher {
  const _WhitespaceCharMatcher();
  String toString() => 'whitespace()';
  bool call(int value) => (9 <= value && value <= 13) || (value == 32)
      || (value == 160) || (value == 5760) || (value == 6158)
      || (8192 <= value && value <= 8202) || (value == 8232)
      || (value == 8233) || (value == 8239) || (value == 8287)
      || (value == 12288);
}

int _toCharCode(char) {
  if (char is int) {
    return char;
  }
  var value = char.toString();
  if (value.length != 1) {
    throw new ArgumentError('$value is not a character');
  }
  return value.codeUnitAt(0);
}