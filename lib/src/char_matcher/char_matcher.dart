import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show immutable;

import '../../printer.dart';
import 'any.dart';
import 'ascii.dart';
import 'char_match.dart';
import 'char_set.dart';
import 'conjunctive.dart';
import 'digit.dart';
import 'disjunctive.dart';
import 'generated/general_categories.dart' as unicode;
import 'letter_or_digit.dart';
import 'negate.dart';
import 'none.dart';
import 'pattern.dart';
import 'range.dart';
import 'single.dart';
import 'whitespace.dart';

/// Abstract character matcher function.
///
/// The [CharMatcher] is a boolean predicate on Unicode code-units. The
/// inclusion of a character can be determined by calling [match] with the
/// code-unit as the function argument, for example:
///
///     CharMatcher.whitespace().match(' '.runes.first); // true
///     CharMatcher.digit().match('a'.runes.first); // false
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
  ///
  /// The argument can be either given as a [String] or a Unicode code-point.
  factory CharMatcher.isChar(Object character) =>
      SingleCharMatcher(_toCharCode(character, 'character'));

  /// A matcher that accepts a character range from [start] to [stop].
  factory CharMatcher.inRange(Object start, Object stop) =>
      RangeCharMatcher(_toCharCode(start, 'start'), _toCharCode(stop, 'stop'));

  /// A matcher that accepts a set of characters.
  factory CharMatcher.charSet(String chars) => fromCharSet(chars);

  /// A matcher that accepts a regular expression character class.
  factory CharMatcher.pattern(String pattern) => fromPattern(pattern);

  /// A matcher that accepts ASCII characters.
  const factory CharMatcher.ascii() = AsciiCharMatcher;

  /// A matcher that accepts a lowercase letter.
  factory CharMatcher.letterLowercase() => unicode.letterLowercase;

  /// A matcher that accepts a modifier letter.
  factory CharMatcher.letterModifier() => unicode.letterModifier;

  /// A matcher that accepts other letters, including syllables and ideographs.
  factory CharMatcher.letterOther() => unicode.letterOther;

  /// A matcher that accepts a digraph encoded as a single character, with first
  /// part uppercase.
  factory CharMatcher.letterTitlecase() => unicode.letterTitlecase;

  /// A matcher that accepts an uppercase letter.
  factory CharMatcher.letterUppercase() => unicode.letterUppercase;

  ///  A matcher that accept any cased letter.
  factory CharMatcher.letterCased() => unicode.letterCased;

  /// A matcher that accepts any letter.
  factory CharMatcher.letter() => unicode.letter;

  /// A matcher that accepts an enclosing combining mark.
  factory CharMatcher.markEnclosing() => unicode.markEnclosing;

  /// A matcher that accepts a non-spacing combining mark (zero advance width).
  factory CharMatcher.markNonSpacing() => unicode.markNonSpacing;

  /// A matcher that accepts a spacing combining mark (positive advance width).
  factory CharMatcher.markSpacingCombining() => unicode.markSpacingCombining;

  /// A matcher that accepts any mark.
  factory CharMatcher.mark() => unicode.mark;

  /// A matcher that accepts a decimal digit.
  factory CharMatcher.numberDecimalDigit() => unicode.numberDecimalDigit;

  /// A matcher that accepts a letter-like numeric character.
  factory CharMatcher.numberLetter() => unicode.numberLetter;

  /// A matcher that accepts a numeric character of other type.
  factory CharMatcher.numberOther() => unicode.numberOther;

  /// A matcher that accepts any number.
  factory CharMatcher.number() => unicode.number;

  /// A matcher that accepts a C0 or C1 control code.
  factory CharMatcher.control() => unicode.control;

  /// A matcher that accepts a format control character.
  factory CharMatcher.format() => unicode.format;

  /// A matcher that accepts a private-use character.
  factory CharMatcher.privateUse() => unicode.privateUse;

  /// A matcher that accepts a surrogate code point.
  factory CharMatcher.surrogate() => unicode.surrogate;

  /// A matcher that accepts a closing punctuation mark.
  factory CharMatcher.punctuationClose() => unicode.punctuationClose;

  /// A matcher that accepts a connecting punctuation mark.
  factory CharMatcher.punctuationConnector() => unicode.punctuationConnector;

  /// A matcher that accepts a dash or hyphen punctuation mark.
  factory CharMatcher.punctuationDash() => unicode.punctuationDash;

  /// A matcher that accepts a final quotation mark.
  factory CharMatcher.punctuationFinalQuote() => unicode.punctuationFinalQuote;

  /// A matcher that accepts an initial quotation mark.
  factory CharMatcher.punctuationInitialQuote() =>
      unicode.punctuationInitialQuote;

  /// A matcher that accepts an opening punctuation mark.
  factory CharMatcher.punctuationOpen() => unicode.punctuationOpen;

  /// A matcher that accepts a punctuation mark of other type.
  factory CharMatcher.punctuationOther() => unicode.punctuationOther;

  /// A matcher that accepts any punctuation mark.
  factory CharMatcher.punctuation() => unicode.punctuation;

  /// A matcher that accepts a line separator.
  factory CharMatcher.separatorLine() => unicode.separatorLine;

  /// A matcher that accepts a paragraph separator.
  factory CharMatcher.separatorParagraph() => unicode.separatorParagraph;

  /// A matcher that accepts a space character (of various non-zero widths).
  factory CharMatcher.separatorSpace() => unicode.separatorSpace;

  // A matcher that accept any space separator.
  factory CharMatcher.separator() => unicode.separator;

  /// A matcher that accepts a currency sign.
  factory CharMatcher.symbolCurrency() => unicode.symbolCurrency;

  /// A matcher that accepts a symbol of mathematical use.
  factory CharMatcher.symbolMath() => unicode.symbolMath;

  /// A matcher that accepts a non-letter-like modifier symbol.
  factory CharMatcher.symbolModifier() => unicode.symbolModifier;

  /// A matcher that accepts a symbol of other type.
  factory CharMatcher.symbolOther() => unicode.symbolOther;

  /// A matcher that accepts a symbol of any type.
  factory CharMatcher.symbol() => unicode.symbol;

  /// A matcher that accepts upper-case letters.
  @Deprecated('Use `CharMatcher.letterUppercase` instead.')
  factory CharMatcher.upperCaseLetter() = CharMatcher.letterUppercase;

  /// A matcher that accepts lower-case letters.
  @Deprecated('Use `CharMatcher.letterLowercase` instead.')
  factory CharMatcher.lowerCaseLetter() = CharMatcher.letterLowercase;

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
  bool match(int value);

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
