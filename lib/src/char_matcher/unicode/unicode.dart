import 'dart:typed_data';

import '../char_matcher.dart';
import 'bidi_class.dart' as bidi_class;
import 'category.dart' as category;
import 'property.dart' as property;

/// Character matcher function that classifies characters using official Unicode
/// categories and properties.
final class UnicodeCharMatcher extends CharMatcher {
  const UnicodeCharMatcher(this.data, this.mask)
      : assert(data.length == _unicodeCharCount),
        assert(mask <= 0xffffffff);

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
      UnicodeCharMatcher(_propertyData1, property.whiteSpace);

  factory UnicodeCharMatcher.bidiControl() =>
      UnicodeCharMatcher(_propertyData1, property.bidiControl);

  factory UnicodeCharMatcher.joinControl() =>
      UnicodeCharMatcher(_propertyData1, property.joinControl);

  factory UnicodeCharMatcher.dash() =>
      UnicodeCharMatcher(_propertyData1, property.dash);

  factory UnicodeCharMatcher.hyphen() =>
      UnicodeCharMatcher(_propertyData1, property.hyphen);

  factory UnicodeCharMatcher.quotationMark() =>
      UnicodeCharMatcher(_propertyData1, property.quotationMark);

  factory UnicodeCharMatcher.terminalPunctuation() =>
      UnicodeCharMatcher(_propertyData1, property.terminalPunctuation);

  factory UnicodeCharMatcher.otherMath() =>
      UnicodeCharMatcher(_propertyData1, property.otherMath);

  factory UnicodeCharMatcher.hexDigit() =>
      UnicodeCharMatcher(_propertyData1, property.hexDigit);

  factory UnicodeCharMatcher.asciiHexDigit() =>
      UnicodeCharMatcher(_propertyData1, property.asciiHexDigit);

  factory UnicodeCharMatcher.otherAlphabetic() =>
      UnicodeCharMatcher(_propertyData1, property.otherAlphabetic);

  factory UnicodeCharMatcher.ideographic() =>
      UnicodeCharMatcher(_propertyData1, property.ideographic);

  factory UnicodeCharMatcher.diacritic() =>
      UnicodeCharMatcher(_propertyData1, property.diacritic);

  factory UnicodeCharMatcher.extender() =>
      UnicodeCharMatcher(_propertyData1, property.extender);

  factory UnicodeCharMatcher.otherLowercase() =>
      UnicodeCharMatcher(_propertyData1, property.otherLowercase);

  factory UnicodeCharMatcher.otherUppercase() =>
      UnicodeCharMatcher(_propertyData1, property.otherUppercase);

  factory UnicodeCharMatcher.noncharacterCodePoint() =>
      UnicodeCharMatcher(_propertyData1, property.noncharacterCodePoint);

  factory UnicodeCharMatcher.otherGraphemeExtend() =>
      UnicodeCharMatcher(_propertyData1, property.otherGraphemeExtend);

  factory UnicodeCharMatcher.idsBinaryOperator() =>
      UnicodeCharMatcher(_propertyData1, property.idsBinaryOperator);

  factory UnicodeCharMatcher.idsTrinaryOperator() =>
      UnicodeCharMatcher(_propertyData1, property.idsTrinaryOperator);

  factory UnicodeCharMatcher.idsUnaryOperator() =>
      UnicodeCharMatcher(_propertyData1, property.idsUnaryOperator);

  factory UnicodeCharMatcher.radical() =>
      UnicodeCharMatcher(_propertyData1, property.radical);

  factory UnicodeCharMatcher.unifiedIdeograph() =>
      UnicodeCharMatcher(_propertyData1, property.unifiedIdeograph);

  factory UnicodeCharMatcher.otherDefaultIgnorableCodePoint() =>
      UnicodeCharMatcher(
          _propertyData1, property.otherDefaultIgnorableCodePoint);

  factory UnicodeCharMatcher.deprecated() =>
      UnicodeCharMatcher(_propertyData1, property.deprecated);

  factory UnicodeCharMatcher.softDotted() =>
      UnicodeCharMatcher(_propertyData1, property.softDotted);

  factory UnicodeCharMatcher.logicalOrderException() =>
      UnicodeCharMatcher(_propertyData1, property.logicalOrderException);

  factory UnicodeCharMatcher.otherIdStart() =>
      UnicodeCharMatcher(_propertyData1, property.otherIdStart);

  factory UnicodeCharMatcher.otherIdContinue() =>
      UnicodeCharMatcher(_propertyData1, property.otherIdContinue);

  factory UnicodeCharMatcher.idCompatMathContinue() =>
      UnicodeCharMatcher(_propertyData1, property.idCompatMathContinue);

  factory UnicodeCharMatcher.idCompatMathStart() =>
      UnicodeCharMatcher(_propertyData1, property.idCompatMathStart);

  factory UnicodeCharMatcher.sentenceTerminal() =>
      UnicodeCharMatcher(_propertyData1, property.sentenceTerminal);

  factory UnicodeCharMatcher.variationSelector() =>
      UnicodeCharMatcher(_propertyData2, property.variationSelector);

  factory UnicodeCharMatcher.patternWhiteSpace() =>
      UnicodeCharMatcher(_propertyData2, property.patternWhiteSpace);

  factory UnicodeCharMatcher.patternSyntax() =>
      UnicodeCharMatcher(_propertyData2, property.patternSyntax);

  factory UnicodeCharMatcher.prependedConcatenationMark() =>
      UnicodeCharMatcher(_propertyData2, property.prependedConcatenationMark);

  factory UnicodeCharMatcher.regionalIndicator() =>
      UnicodeCharMatcher(_propertyData2, property.regionalIndicator);

  /// Bidi Classes
  factory UnicodeCharMatcher.bidiLeftToRight() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.l);

  factory UnicodeCharMatcher.bidiRightToLeft() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.r);

  factory UnicodeCharMatcher.bidiRightToLeftArabic() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.al);

  factory UnicodeCharMatcher.bidiEuropeanNumber() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.en);

  factory UnicodeCharMatcher.bidiEuropeanNumberSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.es);

  factory UnicodeCharMatcher.bidiEuropeanNumberTerminator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.et);

  factory UnicodeCharMatcher.bidiArabicNumber() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.an);

  factory UnicodeCharMatcher.bidiCommonNumberSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.cs);

  factory UnicodeCharMatcher.bidiNonspacingMark() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.nsm);

  factory UnicodeCharMatcher.bidiBoundaryNeutral() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.bn);

  factory UnicodeCharMatcher.bidiParagraphSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.b);

  factory UnicodeCharMatcher.bidiSegmentSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.s);

  factory UnicodeCharMatcher.bidiWhitespace() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.ws);

  factory UnicodeCharMatcher.bidiOtherNeutrals() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.on);

  factory UnicodeCharMatcher.bidiLeftToRightEmbedding() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.lre);

  factory UnicodeCharMatcher.bidiLeftToRightOverride() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.lro);

  factory UnicodeCharMatcher.bidiRightToLeftEmbedding() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.rle);

  factory UnicodeCharMatcher.bidiRightToLeftOverride() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.rlo);

  factory UnicodeCharMatcher.bidiPopDirectionalFormat() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.pdf);

  factory UnicodeCharMatcher.bidiLeftToRightIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.lri);

  factory UnicodeCharMatcher.bidiRightToLeftIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.rli);

  factory UnicodeCharMatcher.bidiFirstStrongIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.fsi);

  factory UnicodeCharMatcher.bidiPopDirectionalIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.pdi);

  /// Bidi Class Categories
  factory UnicodeCharMatcher.bidiStrong() => UnicodeCharMatcher(
      _bidiClassData, bidi_class.l | bidi_class.r | bidi_class.al);

  factory UnicodeCharMatcher.bidiWeak() => UnicodeCharMatcher(
      _bidiClassData,
      bidi_class.en |
          bidi_class.es |
          bidi_class.et |
          bidi_class.an |
          bidi_class.cs |
          bidi_class.nsm |
          bidi_class.bn);

  factory UnicodeCharMatcher.bidiNeutral() => UnicodeCharMatcher(_bidiClassData,
      bidi_class.b | bidi_class.s | bidi_class.ws | bidi_class.on);

  factory UnicodeCharMatcher.bidiExplicitFormatting() => UnicodeCharMatcher(
      _bidiClassData,
      bidi_class.lre |
          bidi_class.lro |
          bidi_class.rle |
          bidi_class.rlo |
          bidi_class.pdf |
          bidi_class.lri |
          bidi_class.rli |
          bidi_class.fsi |
          bidi_class.pdi);

  final List<int> data;
  final int mask;

  @override
  bool match(int value) => data[value] & mask != 0;
}

const _unicodeCharCount = 0x10ffff + 1;
final _categoryData = _decode(category.data);
final _propertyData1 = _decode(property.data1);
final _propertyData2 = _decode(property.data2);
final _bidiClassData = _decode(bidi_class.data);

List<int> _decode(List<int> input) {
  final output = Int32List(_unicodeCharCount);
  for (var i = 0, o = 0; o < output.length;) {
    final i1 = input[i++];
    if (i1 < 0) {
      output.fillRange(o, o -= i1, input[i++]);
    } else {
      output[o++] = i1;
    }
  }
  return output;
}
