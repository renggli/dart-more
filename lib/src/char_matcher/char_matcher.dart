import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show immutable;

import '../../printer.dart';
import 'basic/range.dart';
import 'basic/single.dart';
import 'char_match.dart';
import 'classifiers/ascii.dart';
import 'classifiers/char_set.dart';
import 'classifiers/digit.dart';
import 'classifiers/letter_or_digit.dart';
import 'classifiers/pattern.dart';
import 'classifiers/whitespace.dart';
import 'generated/general_categories.dart';
import 'operators/any.dart';
import 'operators/conjunctive.dart';
import 'operators/disjunctive.dart';
import 'operators/negate.dart';
import 'operators/none.dart';

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

  /// A matcher that accepts a C0 or C1 control code.
  const factory CharMatcher.control() = ControlCharMatcher;

  /// A matcher that accepts a format control character.
  const factory CharMatcher.format() = FormatCharMatcher;

  /// A matcher that accepts a private-use character.
  const factory CharMatcher.privateUse() = PrivateUseCharMatcher;

  /// A matcher that accepts a surrogate code point.
  const factory CharMatcher.surrogate() = SurrogateCharMatcher;

  /// A matcher that accepts any unassigned code-point.
  const factory CharMatcher.unassigned() = UnassignedCharMatcher;

  /// A matcher that accepts a lowercase letter.
  const factory CharMatcher.letterLowercase() = LetterLowercaseCharMatcher;

  /// A matcher that accepts a modifier letter.
  const factory CharMatcher.letterModifier() = LetterModifierCharMatcher;

  /// A matcher that accepts other letters, including syllables and ideographs.
  const factory CharMatcher.letterOther() = LetterOtherCharMatcher;

  /// A matcher that accepts a digraph encoded as a single character, with first
  /// part uppercase.
  const factory CharMatcher.letterTitlecase() = LetterTitlecaseCharMatcher;

  /// A matcher that accepts an uppercase letter.
  const factory CharMatcher.letterUppercase() = LetterUppercaseCharMatcher;

  /// A matcher that accepts a spacing combining mark (positive advance width).
  const factory CharMatcher.markSpacingCombining() =
      MarkSpacingCombiningCharMatcher;

  /// A matcher that accepts an enclosing combining mark.
  const factory CharMatcher.markEnclosing() = MarkEnclosingCharMatcher;

  /// A matcher that accepts a non-spacing combining mark (zero advance width).
  const factory CharMatcher.markNonSpacing() = MarkNonSpacingCharMatcher;

  /// A matcher that accepts a decimal digit.
  const factory CharMatcher.numberDecimalDigit() =
      NumberDecimalDigitCharMatcher;

  /// A matcher that accepts a letter-like numeric character.
  const factory CharMatcher.numberLetter() = NumberLetterCharMatcher;

  /// A matcher that accepts a numeric character of other type.
  const factory CharMatcher.numberOther() = NumberOtherCharMatcher;

  /// A matcher that accepts a connecting punctuation mark.
  const factory CharMatcher.punctuationConnector() =
      PunctuationConnectorCharMatcher;

  /// A matcher that accepts a dash or hyphen punctuation mark.
  const factory CharMatcher.punctuationDash() = PunctuationDashCharMatcher;

  /// A matcher that accepts a closing punctuation mark.
  const factory CharMatcher.punctuationClose() = PunctuationCloseCharMatcher;

  /// A matcher that accepts a final quotation mark.
  const factory CharMatcher.punctuationFinalQuote() =
      PunctuationFinalQuoteCharMatcher;

  /// A matcher that accepts an initial quotation mark.
  const factory CharMatcher.punctuationInitialQuote() =
      PunctuationInitialQuoteCharMatcher;

  /// A matcher that accepts a punctuation mark of other type.
  const factory CharMatcher.punctuationOther() = PunctuationOtherCharMatcher;

  /// A matcher that accepts an opening punctuation mark.
  const factory CharMatcher.punctuationOpen() = PunctuationOpenCharMatcher;

  /// A matcher that accepts a currency sign.
  const factory CharMatcher.symbolCurrency() = SymbolCurrencyCharMatcher;

  /// A matcher that accepts a non-letter-like modifier symbol.
  const factory CharMatcher.symbolModifier() = SymbolModifierCharMatcher;

  /// A matcher that accepts a symbol of mathematical use.
  const factory CharMatcher.symbolMath() = SymbolMathCharMatcher;

  /// A matcher that accepts a symbol of other type.
  const factory CharMatcher.symbolOther() = SymbolOtherCharMatcher;

  /// A matcher that accepts a line separator.
  const factory CharMatcher.separatorLine() = SeparatorLineCharMatcher;

  /// A matcher that accepts a paragraph separator.
  const factory CharMatcher.separatorParagraph() =
      SeparatorParagraphCharMatcher;

  /// A matcher that accepts a space character (of various non-zero widths).
  const factory CharMatcher.separatorSpace() = SeparatorSpaceCharMatcher;

  /// A matcher that accepts other control, format, ... and private characters.
  const factory CharMatcher.other() = OtherCharMatcher;

  /// A matcher that accepts any letter.
  const factory CharMatcher.letter() = LetterCharMatcher;

  ///  A matcher that accept any cased letter.
  const factory CharMatcher.letterCased() = LetterCasedCharMatcher;

  /// A matcher that accepts any mark.
  const factory CharMatcher.mark() = MarkCharMatcher;

  /// A matcher that accepts any number.
  const factory CharMatcher.number() = NumberCharMatcher;

  /// A matcher that accepts any punctuation mark.
  const factory CharMatcher.punctuation() = PunctuationCharMatcher;

  /// A matcher that accepts a symbol of any type.
  const factory CharMatcher.symbol() = SymbolCharMatcher;

  // A matcher that accept any space separator.
  const factory CharMatcher.separator() = SeparatorCharMatcher;

  /// A matcher that accepts upper-case letters.
  @Deprecated('Use `CharMatcher.letterUppercase` instead.')
  const factory CharMatcher.upperCaseLetter() = CharMatcher.letterUppercase;

  /// A matcher that accepts lower-case letters.
  @Deprecated('Use `CharMatcher.letterLowercase` instead.')
  const factory CharMatcher.lowerCaseLetter() = CharMatcher.letterLowercase;

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
