import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show immutable, nonVirtual;

import '../../printer.dart';
import 'ascii/ascii.dart';
import 'ascii/digit.dart';
import 'ascii/letter.dart';
import 'ascii/letter_or_digit.dart';
import 'ascii/lower_case.dart';
import 'ascii/punctuation.dart';
import 'ascii/upper_case.dart';
import 'ascii/whitespace.dart';
import 'basic/range.dart';
import 'basic/single.dart';
import 'char_match.dart';
import 'custom/char_set.dart';
import 'custom/pattern.dart';
import 'operator/any.dart';
import 'operator/conjunctive.dart';
import 'operator/disjunctive.dart';
import 'operator/negate.dart';
import 'operator/none.dart';
import 'unicode/unicode.dart';

/// Abstract character matcher function.
///
/// The [CharMatcher] is a boolean predicate on Unicode code-points. The
/// inclusion of a character can be determined by calling the char matcher with
/// the code-unit as the function argument, for example:
///
/// ```dart
/// CharMatcher.whitespace().match(' '.runes.first); // true
/// CharMatcher.digit().match('a'.runes.first); // false
/// ```
///
/// A large collection of helper methods let you perform string operations on
/// the occurrences of the specified class of characters: trimming, collapsing,
/// replacing, removing, retaining, etc. For example:
///
/// ```dart
/// String withoutWhitespace = CharMatcher.whitespace().removeFrom(string);
/// String onlyDigits = CharMatcher.digit().retainFrom(string);
/// ```
@immutable
abstract class CharMatcher with ToStringPrinter implements Pattern {
  /// A matcher that accepts any character.
  const factory CharMatcher.any() = AnyCharMatcher;

  /// A matcher that accepts no character.
  const factory CharMatcher.none() = NoneCharMatcher;

  /// A matcher that accepts a single [character].
  ///
  /// The argument can be either given as a Unicode code-point or a string
  /// with a single Unicode character.
  factory CharMatcher.isChar(Object character) =>
      SingleCharMatcher(_toCharCode(character, 'character'));

  /// A matcher that accepts a character range from [start] to [stop].
  ///
  /// The arguments can be either given as a Unicode code-points or a strings
  /// with single Unicode character.
  factory CharMatcher.inRange(Object start, Object stop) =>
      RangeCharMatcher(_toCharCode(start, 'start'), _toCharCode(stop, 'stop'));

  /// A matcher that accepts a set of characters.
  factory CharMatcher.charSet(String chars) => fromCharSet(chars);

  /// A matcher that accepts a regular expression character class.
  ///
  /// Characters match themselves. A dash `-` between two characters matches the
  /// range of those characters. A caret `^` at the beginning negates the pattern.
  /// `-[pattern]` at the end of the pattern, subtracts the pattern within the
  /// square brackets.
  ///
  /// For example, the pattern `pattern('aou')` accepts the character 'a', 'o',
  /// or 'u', and fails for any other input. The `pattern('1-3')` accepts either
  /// '1', '2', or '3'; and fails for any other character. The `pattern('^aou')`
  /// accepts any character, but fails for the characters 'a', 'o', or 'u'. The
  /// `pattern('a-z-[aeiou]')` accepts lower-case letters, but fails for
  /// consonants.
  factory CharMatcher.pattern(String pattern) => fromPattern(pattern);

  /// A matcher that accepts ASCII characters.
  const factory CharMatcher.ascii() = AsciiCharMatcher;

  /// A matcher that accepts ASCII upper-case letters, see
  /// [UnicodeCharMatcher.letterUppercase] for the Unicode variant.
  const factory CharMatcher.upperCaseLetter() = UpperCaseLetterCharMatcher;

  /// A matcher that accepts ASCII lower-case letters, see
  /// [UnicodeCharMatcher.letterLowercase] for the Unicode variant.
  const factory CharMatcher.lowerCaseLetter() = LowerCaseLetterCharMatcher;

  /// A matcher that accepts ASCII letters or digits.
  const factory CharMatcher.letterOrDigit() = LetterOrDigitCharMatcher;

  /// A matcher that accepts ASCII letters, see
  /// [UnicodeCharMatcher.letter] for the Unicode variant.
  const factory CharMatcher.letter() = LetterCharMatcher;

  /// A matcher that accepts ASCII digits, see
  /// [UnicodeCharMatcher.numberDecimalDigit] for the Unicode variant.
  const factory CharMatcher.digit() = DigitCharMatcher;

  /// A matcher that accepts ASCII punctuation characters, see
  /// [UnicodeCharMatcher.punctuation] for the Unicode variant.
  const factory CharMatcher.punctuation() = PunctuationCharMatcher;

  /// A matcher that accepts ASCII whitespaces, see
  /// [UnicodeCharMatcher.whiteSpace] for the Unicode variant.
  const factory CharMatcher.whitespace() = WhitespaceCharMatcher;

  /// Internal constructor.
  const CharMatcher();

  /// Returns a matcher that matches any character not matched by this matcher.
  CharMatcher operator ~() => NegateCharMatcher(this);

  /// Returns a matcher that matches any character matched by either this
  /// matcher or [other].
  CharMatcher operator |(CharMatcher other) => switch (other) {
        AnyCharMatcher() => other,
        NoneCharMatcher() => this,
        DisjunctiveCharMatcher(matchers: final matchers) =>
          DisjunctiveCharMatcher([this, ...matchers]),
        _ => DisjunctiveCharMatcher([this, other])
      };

  /// Returns a matcher that matches any character matched by either this
  /// matcher or [other].
  CharMatcher operator &(CharMatcher other) => switch (other) {
        AnyCharMatcher() => this,
        NoneCharMatcher() => other,
        ConjunctiveCharMatcher(matchers: final matchers) =>
          ConjunctiveCharMatcher([this, ...matchers]),
        _ => ConjunctiveCharMatcher([this, other])
      };

  /// Determines if the given Unicode code-point [value] belongs to this
  /// character class.
  ///
  /// The behavior is undefined if the value is outside of the valid unicode
  /// code range.
  bool match(int value);

  /// Determines if the given Unicode code-point [value] belongs to this
  /// character class. See [match] for details.
  @nonVirtual
  bool call(int value) => match(value);

  /// Returns `true` if the [sequence] contains only matching characters.
  bool everyOf(String sequence) => sequence.runes.every(match);

  /// Returns `true` if the [sequence] contains at least one matching character.
  bool anyOf(String sequence) => sequence.runes.any(match);

  /// Returns `true` if the [sequence] contains no matching character.
  bool noneOf(String sequence) => sequence.runes.none(match);

  /// Returns the first matching index in [sequence] starting at [start]
  /// (inclusive). Returns `-1` if it could not be found.
  int firstIndexIn(String sequence, [int start = 0]) {
    final iterator = _runeIteratorAt(sequence, start);
    while (iterator.moveNext()) {
      if (match(iterator.current)) {
        return iterator.rawIndex;
      }
    }
    return -1;
  }

  /// Returns the first matching index in [sequence], searching backward
  /// starting at [start] (inclusive). Returns `-1` if it could not be found.
  int lastIndexIn(String sequence, [int? start]) {
    final index = start == null ? sequence.length : start + 1;
    final iterator = _runeIteratorAt(sequence, index);
    while (iterator.movePrevious()) {
      if (match(iterator.current)) {
        return iterator.rawIndex;
      }
    }
    return -1;
  }

  /// Counts the number of matches in [sequence].
  int countIn(String sequence) => sequence.runes.where(match).length;

  /// Replaces each group of consecutive matched characters in [sequence]
  /// with the specified [replacement].
  String collapseFrom(String sequence, String replacement) {
    final result = <int>[];
    final iterator = _runeIteratorAt(sequence, 0);
    while (iterator.moveNext()) {
      if (match(iterator.current)) {
        while (iterator.moveNext() && match(iterator.current)) {}
        result.addAll(replacement.runes);
        iterator.movePrevious();
      } else {
        result.add(iterator.current);
      }
    }
    return String.fromCharCodes(result);
  }

  /// Replaces each matched character in [sequence] with the specified
  /// [replacement].
  String replaceFrom(String sequence, String replacement) =>
      String.fromCharCodes(sequence.runes
          .expand((value) => match(value) ? replacement.runes : [value]));

  /// Removes all matched characters in [sequence].
  String removeFrom(String sequence) => (~this).retainFrom(sequence);

  /// Retains all matched characters in [sequence].
  String retainFrom(String sequence) =>
      String.fromCharCodes(sequence.runes.where(match));

  /// Removes leading and trailing matching characters in [sequence].
  String trimFrom(String sequence) =>
      trimTailingFrom(trimLeadingFrom(sequence));

  /// Removes leading matching characters in [sequence].
  String trimLeadingFrom(String sequence) {
    if (sequence.isEmpty) return sequence;
    final iterator = _runeIteratorAt(sequence, 0);
    while (iterator.moveNext() && match(iterator.current)) {}
    return iterator.currentSize > 0
        ? sequence.substring(iterator.rawIndex)
        : '';
  }

  /// Removes tailing matching characters in [sequence].
  String trimTailingFrom(String sequence) {
    if (sequence.isEmpty) return sequence;
    final iterator = _runeIteratorAt(sequence, sequence.length);
    while (iterator.movePrevious() && match(iterator.current)) {}
    return iterator.currentSize > 0
        ? sequence.substring(0, iterator.rawIndex + 1)
        : '';
  }

  @override
  Iterable<Match> allMatches(String sequence, [int start = 0]) sync* {
    final iterator = _runeIteratorAt(sequence, start);
    while (iterator.moveNext()) {
      if (match(iterator.current)) {
        final start = iterator.rawIndex;
        yield CharMatch(start, start + iterator.currentSize, sequence, this);
      }
    }
  }

  @override
  Match? matchAsPrefix(String sequence, [int start = 0]) {
    final iterator = _runeIteratorAt(sequence, start);
    if (iterator.moveNext() && match(iterator.current)) {
      final start = iterator.rawIndex;
      return CharMatch(start, start + iterator.currentSize, sequence, this);
    }
    return null;
  }
}

RuneIterator _runeIteratorAt(String sequence, int index) =>
    index == 0 ? RuneIterator(sequence) : RuneIterator.at(sequence, index);

int _toCharCode(Object value, String name) {
  if (value is int) return value;
  if (value is num) return value.truncate();
  final codePoint = value.toString().runes.singleOrNull;
  if (codePoint != null) return codePoint;
  throw ArgumentError.value(value, name, 'Invalid unicode character');
}
