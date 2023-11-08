import 'dart:typed_data';

import '../char_matcher.dart';
import 'category.dart' as category;
import 'property.dart' as property;

/// Character matcher function that classifies characters using official Unicode
/// categories and properties.
class UnicodeCharMatcher extends CharMatcher {
  const UnicodeCharMatcher(this.data, this.mask);

  /// General Category
  factory UnicodeCharMatcher.letterUppercase() =>
      UnicodeCharMatcher(_categoryData, category.lu);

  factory UnicodeCharMatcher.letterLowercase() =>
      UnicodeCharMatcher(_categoryData, category.ll);

  factory UnicodeCharMatcher.letterTitlecase() =>
      UnicodeCharMatcher(_categoryData, category.lt);

  factory UnicodeCharMatcher.letterModifier() =>
      UnicodeCharMatcher(_categoryData, category.lm);

  factory UnicodeCharMatcher.letterOther() =>
      UnicodeCharMatcher(_categoryData, category.lo);

  factory UnicodeCharMatcher.markNonspacing() =>
      UnicodeCharMatcher(_categoryData, category.mn);

  factory UnicodeCharMatcher.markSpacingCombining() =>
      UnicodeCharMatcher(_categoryData, category.mc);

  factory UnicodeCharMatcher.markEnclosing() =>
      UnicodeCharMatcher(_categoryData, category.me);

  factory UnicodeCharMatcher.numberDecimalDigit() =>
      UnicodeCharMatcher(_categoryData, category.nd);

  factory UnicodeCharMatcher.numberLetter() =>
      UnicodeCharMatcher(_categoryData, category.nl);

  factory UnicodeCharMatcher.numberOther() =>
      UnicodeCharMatcher(_categoryData, category.no);

  factory UnicodeCharMatcher.punctuationConnector() =>
      UnicodeCharMatcher(_categoryData, category.pc);

  factory UnicodeCharMatcher.punctuationDash() =>
      UnicodeCharMatcher(_categoryData, category.pd);

  factory UnicodeCharMatcher.punctuationOpen() =>
      UnicodeCharMatcher(_categoryData, category.ps);

  factory UnicodeCharMatcher.punctuationClose() =>
      UnicodeCharMatcher(_categoryData, category.pe);

  factory UnicodeCharMatcher.punctuationInitialQuote() =>
      UnicodeCharMatcher(_categoryData, category.pi);

  factory UnicodeCharMatcher.punctuationFinalQuote() =>
      UnicodeCharMatcher(_categoryData, category.pf);

  factory UnicodeCharMatcher.punctuationOther() =>
      UnicodeCharMatcher(_categoryData, category.po);

  factory UnicodeCharMatcher.symbolMath() =>
      UnicodeCharMatcher(_categoryData, category.sm);

  factory UnicodeCharMatcher.symbolCurrency() =>
      UnicodeCharMatcher(_categoryData, category.sc);

  factory UnicodeCharMatcher.symbolModifier() =>
      UnicodeCharMatcher(_categoryData, category.sk);

  factory UnicodeCharMatcher.symbolOther() =>
      UnicodeCharMatcher(_categoryData, category.so);

  factory UnicodeCharMatcher.separatorSpace() =>
      UnicodeCharMatcher(_categoryData, category.zs);

  factory UnicodeCharMatcher.separatorLine() =>
      UnicodeCharMatcher(_categoryData, category.zl);

  factory UnicodeCharMatcher.separatorParagraph() =>
      UnicodeCharMatcher(_categoryData, category.zp);

  factory UnicodeCharMatcher.otherControl() =>
      UnicodeCharMatcher(_categoryData, category.cc);

  factory UnicodeCharMatcher.otherFormat() =>
      UnicodeCharMatcher(_categoryData, category.cf);

  factory UnicodeCharMatcher.otherSurrogate() =>
      UnicodeCharMatcher(_categoryData, category.cs);

  factory UnicodeCharMatcher.otherPrivateUse() =>
      UnicodeCharMatcher(_categoryData, category.co);

  factory UnicodeCharMatcher.otherNotAssigned() =>
      UnicodeCharMatcher(_categoryData, category.cn);

  /// General Category Groups
  factory UnicodeCharMatcher.casedLetter() => UnicodeCharMatcher(
      _categoryData, category.lu | category.ll | category.lt);

  factory UnicodeCharMatcher.letter() => UnicodeCharMatcher(_categoryData,
      category.lu | category.ll | category.lt | category.lm | category.lo);

  factory UnicodeCharMatcher.mark() => UnicodeCharMatcher(
      _categoryData, category.mn | category.mc | category.me);

  factory UnicodeCharMatcher.number() => UnicodeCharMatcher(
      _categoryData, category.nd | category.nl | category.no);

  factory UnicodeCharMatcher.punctuation() => UnicodeCharMatcher(
      _categoryData,
      category.pc |
          category.pd |
          category.ps |
          category.pe |
          category.pi |
          category.pf |
          category.po);

  factory UnicodeCharMatcher.symbol() => UnicodeCharMatcher(
      _categoryData, category.sm | category.sc | category.sk | category.so);

  factory UnicodeCharMatcher.separator() => UnicodeCharMatcher(
      _categoryData, category.zs | category.zl | category.zp);

  factory UnicodeCharMatcher.other() => UnicodeCharMatcher(_categoryData,
      category.cc | category.cf | category.cs | category.co | category.cn);

  /// Properties
  factory UnicodeCharMatcher.whiteSpace() =>
      UnicodeCharMatcher(_propertyData, property.whiteSpace);

  factory UnicodeCharMatcher.bidiControl() =>
      UnicodeCharMatcher(_propertyData, property.bidiControl);

  factory UnicodeCharMatcher.joinControl() =>
      UnicodeCharMatcher(_propertyData, property.joinControl);

  factory UnicodeCharMatcher.dash() =>
      UnicodeCharMatcher(_propertyData, property.dash);

  factory UnicodeCharMatcher.hyphen() =>
      UnicodeCharMatcher(_propertyData, property.hyphen);

  factory UnicodeCharMatcher.quotationMark() =>
      UnicodeCharMatcher(_propertyData, property.quotationMark);

  factory UnicodeCharMatcher.terminalPunctuation() =>
      UnicodeCharMatcher(_propertyData, property.terminalPunctuation);

  factory UnicodeCharMatcher.otherMath() =>
      UnicodeCharMatcher(_propertyData, property.otherMath);

  factory UnicodeCharMatcher.hexDigit() =>
      UnicodeCharMatcher(_propertyData, property.hexDigit);

  factory UnicodeCharMatcher.asciiHexDigit() =>
      UnicodeCharMatcher(_propertyData, property.asciiHexDigit);

  factory UnicodeCharMatcher.otherAlphabetic() =>
      UnicodeCharMatcher(_propertyData, property.otherAlphabetic);

  factory UnicodeCharMatcher.ideographic() =>
      UnicodeCharMatcher(_propertyData, property.ideographic);

  factory UnicodeCharMatcher.diacritic() =>
      UnicodeCharMatcher(_propertyData, property.diacritic);

  factory UnicodeCharMatcher.extender() =>
      UnicodeCharMatcher(_propertyData, property.extender);

  factory UnicodeCharMatcher.otherLowercase() =>
      UnicodeCharMatcher(_propertyData, property.otherLowercase);

  factory UnicodeCharMatcher.otherUppercase() =>
      UnicodeCharMatcher(_propertyData, property.otherUppercase);

  factory UnicodeCharMatcher.noncharacterCodePoint() =>
      UnicodeCharMatcher(_propertyData, property.noncharacterCodePoint);

  factory UnicodeCharMatcher.otherGraphemeExtend() =>
      UnicodeCharMatcher(_propertyData, property.otherGraphemeExtend);

  factory UnicodeCharMatcher.idsBinaryOperator() =>
      UnicodeCharMatcher(_propertyData, property.idsBinaryOperator);

  factory UnicodeCharMatcher.idsTrinaryOperator() =>
      UnicodeCharMatcher(_propertyData, property.idsTrinaryOperator);

  factory UnicodeCharMatcher.idsUnaryOperator() =>
      UnicodeCharMatcher(_propertyData, property.idsUnaryOperator);

  factory UnicodeCharMatcher.radical() =>
      UnicodeCharMatcher(_propertyData, property.radical);

  factory UnicodeCharMatcher.unifiedIdeograph() =>
      UnicodeCharMatcher(_propertyData, property.unifiedIdeograph);

  factory UnicodeCharMatcher.otherDefaultIgnorableCodePoint() =>
      UnicodeCharMatcher(
          _propertyData, property.otherDefaultIgnorableCodePoint);

  factory UnicodeCharMatcher.deprecated() =>
      UnicodeCharMatcher(_propertyData, property.deprecated);

  factory UnicodeCharMatcher.softDotted() =>
      UnicodeCharMatcher(_propertyData, property.softDotted);

  factory UnicodeCharMatcher.logicalOrderException() =>
      UnicodeCharMatcher(_propertyData, property.logicalOrderException);

  factory UnicodeCharMatcher.otherIdStart() =>
      UnicodeCharMatcher(_propertyData, property.otherIdStart);

  factory UnicodeCharMatcher.otherIdContinue() =>
      UnicodeCharMatcher(_propertyData, property.otherIdContinue);

  factory UnicodeCharMatcher.idCompatMathContinue() =>
      UnicodeCharMatcher(_propertyData, property.idCompatMathContinue);

  factory UnicodeCharMatcher.idCompatMathStart() =>
      UnicodeCharMatcher(_propertyData, property.idCompatMathStart);

  factory UnicodeCharMatcher.sentenceTerminal() =>
      UnicodeCharMatcher(_propertyData, property.sentenceTerminal);

  factory UnicodeCharMatcher.variationSelector() =>
      UnicodeCharMatcher(_propertyData, property.variationSelector);

  factory UnicodeCharMatcher.patternWhiteSpace() =>
      UnicodeCharMatcher(_propertyData, property.patternWhiteSpace);

  factory UnicodeCharMatcher.patternSyntax() =>
      UnicodeCharMatcher(_propertyData, property.patternSyntax);

  factory UnicodeCharMatcher.prependedConcatenationMark() =>
      UnicodeCharMatcher(_propertyData, property.prependedConcatenationMark);

  factory UnicodeCharMatcher.regionalIndicator() =>
      UnicodeCharMatcher(_propertyData, property.regionalIndicator);

  final List<int> data;
  final int mask;

  @override
  bool match(int value) => data[value] & mask != 0;
}

final _categoryData = _decode(category.data);
final _propertyData = _decode(property.data);

List<int> _decode(List<int> input) {
  final output = Int32List(0x10ffff + 1);
  for (var i = 0, o = 0; o < output.length;) {
    final i1 = input[i++];
    if (i1 < 0) {
      final i2 = input[i++];
      for (var j = i1; j < 0; j++) {
        output[o++] = i2;
      }
    } else {
      output[o++] = i1;
    }
  }
  return output;
}
