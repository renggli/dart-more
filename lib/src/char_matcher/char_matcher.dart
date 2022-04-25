/// A first-class model of character classes, their composition and operations
/// on strings.
import 'package:meta/meta.dart' show immutable;

import '../../printer.dart';
import '../collection/range/integer.dart';
import 'any.dart';
import 'ascii.dart';
import 'char_match.dart';
import 'char_set.dart';
import 'digit.dart';
import 'disjunctive.dart';
import 'letter.dart';
import 'letter_or_digit.dart';
import 'lower_case.dart';
import 'negate.dart';
import 'none.dart';
import 'pattern.dart';
import 'range.dart';
import 'single.dart';
import 'upper_case.dart';
import 'whitespace.dart';

/// Abstract character matcher function.
///
/// The [CharMatcher] is a boolean predicate on UTF-16 code units. The
/// inclusion of a character can be determined by calling [match] with the
/// code-unit as the function argument, for example:
///
///     CharMatcher.whitespace().match(' '.codeUnitAt(0)); // true
///     CharMatcher.digit().match('a'.codeUnitAt(0)); // false
///
/// A large collection of helper methods let you perform string operations on
/// the occurrences of the specified class of characters: trimming, collapsing,
/// replacing, removing, retaining, etc. For example:
///
///     String withoutWhitespace = CharMatcher.whitespace().removeFrom(string);
///     String onlyDigits = CharMatcher.digit().retainFrom(string);
///
@immutable
abstract class CharMatcher with ToStringPrinter implements Pattern {
  /// A matcher that accepts any character.
  const factory CharMatcher.any() = AnyCharMatcher;

  /// A matcher that accepts no character.
  const factory CharMatcher.none() = NoneCharMatcher;

  /// A matcher that accepts a single [character].
  factory CharMatcher.isChar(Object character) =>
      SingleCharMatcher(_toCharCode(character));

  /// A matcher that accepts a character range from [start] to [stop].
  factory CharMatcher.inRange(Object start, Object stop) =>
      RangeCharMatcher(_toCharCode(start), _toCharCode(stop));

  /// A matcher that accepts a set of characters.
  factory CharMatcher.charSet(String chars) => fromCharSet(chars);

  /// A matcher that accepts a regular expression character class.
  factory CharMatcher.pattern(String pattern) => fromPattern(pattern);

  /// A matcher that accepts ASCII characters.
  const factory CharMatcher.ascii() = AsciiCharMatcher;

  /// A matcher that accepts letters.
  const factory CharMatcher.letter() = LetterCharMatcher;

  /// A matcher that accepts upper-case letters.
  const factory CharMatcher.upperCaseLetter() = UpperCaseLetterCharMatcher;

  /// A matcher that accepts lower-case letters.
  const factory CharMatcher.lowerCaseLetter() = LowerCaseLetterCharMatcher;

  /// A matcher that accepts letters or digits.
  const factory CharMatcher.letterOrDigit() = LetterOrDigitCharMatcher;

  /// A matcher that accepts digits.
  const factory CharMatcher.digit() = DigitCharMatcher;

  /// A matcher that accepts whitespaces.
  const factory CharMatcher.whitespace() = WhitespaceCharMatcher;

  /// Internal constructor.
  const CharMatcher();

  /// Returns a matcher that matches any character not matched by this matcher.
  CharMatcher operator ~() => NegateCharMatcher(this);

  /// Returns a matcher that matches any character matched by either this
  /// matcher or [other].
  CharMatcher operator |(CharMatcher other) {
    if (other is AnyCharMatcher) {
      return other;
    } else if (other is NoneCharMatcher) {
      return this;
    } else if (other is DisjunctiveCharMatcher) {
      return DisjunctiveCharMatcher([this, ...other.matchers]);
    } else {
      return DisjunctiveCharMatcher([this, other]);
    }
  }

  /// Determines if the given character code belongs to the character class.
  bool match(int value);

  /// Returns `true` if the [sequence] contains only matching characters.
  bool everyOf(String sequence) => sequence.codeUnits.every(match);

  /// Returns `true` if the [sequence] contains at least one matching character.
  bool anyOf(String sequence) => sequence.codeUnits.any(match);

  /// Returns the last matching index in [sequence] starting at [start]
  /// (inclusive). Returns `-1` if it could not be found.
  int firstIndexIn(String sequence, [int start = 0]) {
    final codeUnits = sequence.codeUnits;
    for (var i = start; i < codeUnits.length; i++) {
      if (match(codeUnits[i])) {
        return i;
      }
    }
    return -1;
  }

  /// Returns the first matching index in [sequence], searching backward
  /// starting at [start] (inclusive). Returns `-1` if it could not be found.
  int lastIndexIn(String sequence, [int? start]) {
    final codeUnits = sequence.codeUnits;
    start ??= codeUnits.length - 1;
    for (var i = start; i >= 0; i--) {
      if (match(codeUnits[i])) {
        return i;
      }
    }
    return -1;
  }

  /// Counts the number of matches in [sequence].
  int countIn(String sequence) => sequence.codeUnits.where(match).length;

  /// Replaces each group of consecutive matched characters in [sequence]
  /// with the specified [replacement].
  String collapseFrom(String sequence, String replacement) {
    var i = 0;
    final list = <int>[];
    final codeUnits = sequence.codeUnits;
    final replacementCodes = replacement.codeUnits;
    while (i < codeUnits.length) {
      final codeUnit = codeUnits[i];
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
    return String.fromCharCodes(list);
  }

  /// Replaces each matched character in [sequence] with the specified
  /// [replacement].
  String replaceFrom(String sequence, String replacement) {
    final replacementCodes = replacement.codeUnits;
    return String.fromCharCodes(sequence.codeUnits
        .expand((value) => match(value) ? replacementCodes : [value]));
  }

  /// Removes all matched characters in [sequence].
  String removeFrom(String sequence) => (~this).retainFrom(sequence);

  /// Retains all matched characters in [sequence].
  String retainFrom(String sequence) =>
      String.fromCharCodes(sequence.codeUnits.where(match));

  /// Removes leading and trailing matching characters in [sequence].
  String trimFrom(String sequence) {
    final codeUnits = sequence.codeUnits;
    var left = 0, right = codeUnits.length - 1;
    while (left <= right && match(codeUnits[left])) {
      left++;
    }
    while (left <= right && match(codeUnits[right])) {
      right--;
    }
    return sequence.substring(left, right + 1);
  }

  /// Removes leading matching characters in [sequence].
  String trimLeadingFrom(String sequence) {
    final codeUnits = sequence.codeUnits;
    var left = 0;
    final right = codeUnits.length - 1;
    while (left <= right && match(codeUnits[left])) {
      left++;
    }
    return sequence.substring(left, right + 1);
  }

  /// Removes tailing matching characters in [sequence].
  String trimTailingFrom(String sequence) {
    final codeUnits = sequence.codeUnits;
    var right = codeUnits.length - 1;
    while (0 <= right && match(codeUnits[right])) {
      right--;
    }
    return sequence.substring(0, right + 1);
  }

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    final codeUnits = string.codeUnits;
    return start
        .to(codeUnits.length - 1)
        .where((index) => match(codeUnits[index]))
        .map((index) => CharMatch(index, string, this));
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) =>
      start < string.length && match(string.codeUnits[start])
          ? CharMatch(start, string, this)
          : null;
}

int _toCharCode(Object char) {
  if (char is num) {
    return char.round();
  }
  final value = '$char';
  if (value.length != 1) {
    throw ArgumentError.value(value, 'value', 'Invalid character');
  }
  return value.codeUnitAt(0);
}
