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
 * Abstract character matcher.
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
    if (other == ANY) {
      return other;
    } else if (other == NONE) {
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
   * Returns a plain [Function] that acts like this matcher.
   */
  Function get matcher => (value) => match(value);

  /**
   * Returns `true` if the [sequence] contains only matching  characters.
   */
  bool everyOf(String sequence) {
    return sequence.codeUnits.every(matcher);
  }

  /**
   * Returns `true` if the [sequence] contains at least one matching character.
   */
  bool anyOf(String sequence) {
    return sequence.codeUnits.any(matcher);
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
    return sequence.codeUnits.where(matcher).length;
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
    return new String.fromCharCodes(sequence.codeUnits.where((~this).matcher));
  }

  /**
   * Retains all matched characters in [sequence].
   */
  String retainFrom(String sequence) {
    return new String.fromCharCodes(sequence.codeUnits.where(matcher));
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
  String toString() => '~$_matcher';
  CharMatcher operator ~ () => _matcher;
  bool match(int value) => !_matcher.match(value);
}

class _DisjunctiveCharMatcher extends CharMatcher {
  final List<CharMatcher> _matchers;
  const _DisjunctiveCharMatcher(this._matchers);
  String toString() => _matchers.join(' | ');
  CharMatcher operator | (CharMatcher other) {
    if (other == ANY) {
      return other;
    } else if (other == NONE) {
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
  bool match(int value) {
    for (var matcher in _matchers) {
      if (matcher.match(value)) {
        return true;
      }
    }
    return false;
  }
}

/** Matches any character. */
final CharMatcher ANY = const _AnyCharMatcher();

class _AnyCharMatcher extends CharMatcher {
  const _AnyCharMatcher();
  String toString() => 'ANY';
  bool match(int value) => true;
  CharMatcher operator ~ () => NONE;
  CharMatcher operator | (CharMatcher other) => this;
}

/** Matches no characters. */
final CharMatcher NONE = const _NoneCharMatcher();

class _NoneCharMatcher extends CharMatcher {
  const _NoneCharMatcher();
  String toString() => 'NONE';
  bool match(int value) => false;
  CharMatcher operator ~ () => ANY;
  CharMatcher operator | (CharMatcher other) => other;
}

/** Matches a character [char]. */
CharMatcher isChar(char) {
  return new _SingleCharMatcher(_toCharCode(char));
}

class _SingleCharMatcher extends CharMatcher {
  final int _value;
  const _SingleCharMatcher(this._value);
  String toString() => 'isChar("' + new String.fromCharCode(_value) + '")';
  bool match(int value) => _value == value;
}

/** Matches a character range from [start] to [stop]. */
CharMatcher inRange(start, stop) {
  return new _RangeCharMatcher(_toCharCode(start), _toCharCode(stop));
}

class _RangeCharMatcher extends CharMatcher {
  final int _start;
  final int _stop;
  const _RangeCharMatcher(this._start, this._stop);
  String toString() => 'inRange("' + new String.fromCharCode(_start) +
      '", "' + new String.fromCharCode(_stop) + '")';
  bool match(int value) => _start <= value && value <= _stop;
}

/** Matches ASCII characters. */
final CharMatcher ASCII = const _AsciiCharMatcher();

class _AsciiCharMatcher extends CharMatcher {
  const _AsciiCharMatcher();
  String toString() => 'ASCII';
  bool match(int value) => value < 128;
}

/** Matches digits. */
final CharMatcher DIGIT = const _DigitCharMatcher();

class _DigitCharMatcher extends CharMatcher {
  const _DigitCharMatcher();
  String toString() => 'DIGIT';
  bool match(int value) => 48 <= value && value <= 57;
}

/** Matches letters. */
final CharMatcher LETTER = const _LetterCharMatcher();

class _LetterCharMatcher extends CharMatcher {
  const _LetterCharMatcher();
  String toString() => 'LETTER';
  bool match(int value) => (65 <= value && value <= 90)
      || (97 <= value && value <= 122);
}

/** Matches lower-case letters. */
final CharMatcher LOWER_CASE_LETTER = const _LowerCaseLetterCharMatcher();

class _LowerCaseLetterCharMatcher extends CharMatcher {
  const _LowerCaseLetterCharMatcher();
  String toString() => 'LOWER_CASE_LETTER';
  bool match(int value) => 97 <= value && value <= 122;
}

/** Matches upper-case letters. */
final CharMatcher UPPER_CASE_LETTER = const _UpperCaseLetterCharMatcher();

class _UpperCaseLetterCharMatcher extends CharMatcher {
  const _UpperCaseLetterCharMatcher();
  String toString() => 'UPPER_CASE_LETTER';
  bool match(int value) => 65 <= value && value <= 90;
}

/** Matches letter or digit characters. */
final CharMatcher LETTER_OR_DIGIT = const _LetterOrDigitCharMatcher();

class _LetterOrDigitCharMatcher extends CharMatcher {
  const _LetterOrDigitCharMatcher();
  String toString() => 'LETTER_OR_DIGIT';
  bool match(int value) => (65 <= value && value <= 90)
      || (97 <= value && value <= 122) || (48 <= value && value <= 57)
      || (value == 95);
}

/** Matches whitespaces. */
final CharMatcher WHITESPACE = const _WhitespaceCharMatcher();

class _WhitespaceCharMatcher extends CharMatcher {
  const _WhitespaceCharMatcher();
  String toString() => 'WHITESPACE';
  bool match(int value) => (9 <= value && value <= 13) || (value == 32)
      || (value == 160) || (value == 5760) || (value == 6158)
      || (8192 <= value && value <= 8202) || (value == 8232)
      || (value == 8233) || (value == 8239) || (value == 8287)
      || (value == 12288);
}

/** Internal method to convert an element to a character code. */
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