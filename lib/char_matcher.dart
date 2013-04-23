// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library char_matcher;

abstract class CharMatcher {

  const CharMatcher();

  CharMatcher negate() => new _NegateCharMatcher(this);

  CharMatcher or(CharMatcher matcher) {
    if (matcher == ANY) {
      return matcher;
    } else if (matcher == NONE) {
      return this;
    } else if (matcher is _DisjunctiveCharMatcher) {
      return new _DisjunctiveCharMatcher(new List()
          ..add(this)
          ..addAll(matcher._matchers));
    } else {
      new _DisjunctiveCharMatcher([this, matcher]);
    }
  }

  bool matches(int char);

  int firstIndexIn(String sequence, [int start = 0]) {
    List<int> units = sequence.codeUnits;
    for (int i = start; i < units.length; i++) {
      if (matches(units[i])) {
        return i;
      }
    }
    return -1;
  }

  int lastIndexIn(String sequence, [int start]) {
    List<int> units = sequence.codeUnits;
    if (start == null) {
      start = units.length - 1;
    }
    for (int i = start; i >= 0; i--) {
      if (matches(units[i])) {
        return i;
      }
    }
    return -1;
  }

  String trim(String sequence) {
    int startIndex = negate().firstIndexIn(sequence);
    int endIndex = negate().lastIndexIn(sequence);
    return sequence.substring(startIndex == -1 ? 0 : startIndex,
        endIndex == -1 ? sequence.length - 1 : endIndex);
  }

  String trimLeft(String sequence) {
    int startIndex = negate().firstIndexIn(sequence);
    return startIndex == -1 ? sequence : sequence.substring(startIndex);
  }

  String trimRight(String sequence) {
    int endIndex = negate().lastIndexIn(sequence);
    return endIndex == -1 ? sequence : sequence.substring(0, endIndex);
  }

}

class _NegateCharMatcher extends CharMatcher {

  final CharMatcher _matcher;

  const _NegateCharMatcher(this._matcher);

  String toString() => '$_matcher.negate()';

  CharMatcher negate() => _matcher;

  bool matches(int value) => !_matcher.matches(value);

}

class _DisjunctiveCharMatcher extends CharMatcher {

  final List<CharMatcher> _matchers;

  const _DisjunctiveCharMatcher(this._matchers);

  CharMatcher or(CharMatcher matcher) {
    if (matcher == ANY) {
      return matcher;
    } else if (matcher == NONE) {
      return this;
    } else if (matcher is _DisjunctiveCharMatcher) {
      return new _DisjunctiveCharMatcher(new List()
        ..addAll(_matchers)
        ..addAll(matcher._matchers));
    } else {
      return new _DisjunctiveCharMatcher(new List()
        ..addAll(_matchers)
        ..add(matcher));
    }
  }

  bool matches(int char) {
    for (CharMatcher matcher in _matchers) {
      if (matcher.matches(char)) {
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
  bool matches(int char) => true;
  CharMatcher negate() => NONE;
  CharMatcher or(CharMatcher matcher) => this;
}

/** Matches no characters. */
final CharMatcher NONE = const _NoneCharMatcher();

class _NoneCharMatcher extends CharMatcher {
  const _NoneCharMatcher();
  String toString() => 'NONE';
  bool matches(int char) => false;
  CharMatcher negate() => ANY;
  CharMatcher or(CharMatcher matcher) => matcher;
}

/** Matches a specifc character. */
CharMatcher isChar(char) {
  return new _SingleCharMatcher(_toCharCode(char));
}

class _SingleCharMatcher extends CharMatcher {
  final int _value;
  const _SingleCharMatcher(this._value);
  String toString() => 'isChar("' + new String.fromCharCode(_value) + '")';
  bool matches(int value) => _value == value;
}

/** Matches a character range. */
CharMatcher inRange(start, stop) {
  return new _RangeCharMatcher(_toCharCode(start), _toCharCode(stop));
}

class _RangeCharMatcher extends CharMatcher {
  final int _start;
  final int _stop;
  const _RangeCharMatcher(this._start, this._stop);
  String toString() => 'inRange("' + new String.fromCharCode(_start) +
      '", "' + new String.fromCharCode(_stop) + '")';
  bool matches(int value) => _start <= value && value <= _stop;
}

/** Matches digits. */
final CharMatcher DIGIT = const _DigitCharMatcher();

class _DigitCharMatcher extends CharMatcher {
  const _DigitCharMatcher();
  String toString() => 'DIGIT';
  bool matches(int value) => 48 <= value && value <= 57;
}

/** Matches letters. */
final CharMatcher LETTER = const _LetterCharMatcher();

class _LetterCharMatcher extends CharMatcher {
  const _LetterCharMatcher();
  String toString() => 'LETTER';
  bool matches(int value) => (65 <= value && value <= 90)
      || (97 <= value && value <= 122);
}

/** Matches lower-case letters. */
final CharMatcher LOWER_CASE_LETTER = const _LowerCaseLetterCharMatcher();

class _LowerCaseLetterCharMatcher extends CharMatcher {
  const _LowerCaseLetterCharMatcher();
  String toString() => 'LOWER_CASE_LETTER';
  bool matches(int value) => 97 <= value && value <= 122;
}

/** Matches upper-case letters. */
final CharMatcher UPPER_CASE_LETTER = const _UpperCaseLetterCharMatcher();

class _UpperCaseLetterCharMatcher extends CharMatcher {
  const _UpperCaseLetterCharMatcher();
  String toString() => 'UPPER_CASE_LETTER';
  bool matches(int value) => 65 <= value && value <= 90;
}

/** Matches letter or digit characters. */
final CharMatcher LETTER_OR_DIGIT = const _LetterOrDigitCharMatcher();

class _LetterOrDigitCharMatcher extends CharMatcher {
  const _LetterOrDigitCharMatcher();
  String toString() => 'LETTER_OR_DIGIT';
  bool matches(int value) => (65 <= value && value <= 90)
      || (97 <= value && value <= 122) || (48 <= value && value <= 57)
      || (value == 95);
}

/** Matches whitespaces. */
final CharMatcher WHITESPACE = const _WhitespaceCharMatcher();

class _WhitespaceCharMatcher extends CharMatcher {
  const _WhitespaceCharMatcher();
  String toString() => 'WHITESPACE';
  bool matches(int value) => (9 <= value && value <= 13) || (value == 32)
      || (value == 160) || (value == 5760) || (value == 6158)
      || (8192 <= value && value <= 8202) || (value == 8232) || (value == 8233)
      || (value == 8239) || (value == 8287) || (value == 12288);
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