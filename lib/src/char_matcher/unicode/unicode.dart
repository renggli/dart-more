import '../../shared/rle.dart';
import '../char_matcher.dart';
import 'bidi_class.dart' as bidi_class;
import 'category.dart' as category;
import 'property.dart' as property;
import 'scripts.dart' as scripts;

/// Character matcher function that classifies characters using official Unicode
/// categories and properties.
final class UnicodeCharMatcher extends CharMatcher {
  const UnicodeCharMatcher(this.data, this.mask)
    : assert(data.length == 0x10ffff + 1),
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
    _categoryData,
    category.lu | category.ll | category.lt,
  );

  factory UnicodeCharMatcher.letter() => UnicodeCharMatcher(
    _categoryData,
    category.lu | category.ll | category.lt | category.lm | category.lo,
  );

  factory UnicodeCharMatcher.mark() => UnicodeCharMatcher(
    _categoryData,
    category.mn | category.mc | category.me,
  );

  factory UnicodeCharMatcher.number() => UnicodeCharMatcher(
    _categoryData,
    category.nd | category.nl | category.no,
  );

  factory UnicodeCharMatcher.punctuation() => UnicodeCharMatcher(
    _categoryData,
    category.pc |
        category.pd |
        category.ps |
        category.pe |
        category.pi |
        category.pf |
        category.po,
  );

  factory UnicodeCharMatcher.symbol() => UnicodeCharMatcher(
    _categoryData,
    category.sm | category.sc | category.sk | category.so,
  );

  factory UnicodeCharMatcher.separator() => UnicodeCharMatcher(
    _categoryData,
    category.zs | category.zl | category.zp,
  );

  factory UnicodeCharMatcher.other() => UnicodeCharMatcher(
    _categoryData,
    category.cc | category.cf | category.cs | category.co | category.cn,
  );

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
        _propertyData1,
        property.otherDefaultIgnorableCodePoint,
      );

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
    _bidiClassData,
    bidi_class.l | bidi_class.r | bidi_class.al,
  );

  factory UnicodeCharMatcher.bidiWeak() => UnicodeCharMatcher(
    _bidiClassData,
    bidi_class.en |
        bidi_class.es |
        bidi_class.et |
        bidi_class.an |
        bidi_class.cs |
        bidi_class.nsm |
        bidi_class.bn,
  );

  factory UnicodeCharMatcher.bidiNeutral() => UnicodeCharMatcher(
    _bidiClassData,
    bidi_class.b | bidi_class.s | bidi_class.ws | bidi_class.on,
  );

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
        bidi_class.pdi,
  );

  // Scripts
  factory UnicodeCharMatcher.scriptCommon() =>
      UnicodeCharMatcher(_scriptsData1, scripts.common);
  factory UnicodeCharMatcher.scriptLatin() =>
      UnicodeCharMatcher(_scriptsData1, scripts.latin);
  factory UnicodeCharMatcher.scriptGreek() =>
      UnicodeCharMatcher(_scriptsData1, scripts.greek);
  factory UnicodeCharMatcher.scriptCyrillic() =>
      UnicodeCharMatcher(_scriptsData1, scripts.cyrillic);
  factory UnicodeCharMatcher.scriptArmenian() =>
      UnicodeCharMatcher(_scriptsData1, scripts.armenian);
  factory UnicodeCharMatcher.scriptHebrew() =>
      UnicodeCharMatcher(_scriptsData1, scripts.hebrew);
  factory UnicodeCharMatcher.scriptArabic() =>
      UnicodeCharMatcher(_scriptsData1, scripts.arabic);
  factory UnicodeCharMatcher.scriptSyriac() =>
      UnicodeCharMatcher(_scriptsData1, scripts.syriac);
  factory UnicodeCharMatcher.scriptThaana() =>
      UnicodeCharMatcher(_scriptsData1, scripts.thaana);
  factory UnicodeCharMatcher.scriptDevanagari() =>
      UnicodeCharMatcher(_scriptsData1, scripts.devanagari);
  factory UnicodeCharMatcher.scriptBengali() =>
      UnicodeCharMatcher(_scriptsData1, scripts.bengali);
  factory UnicodeCharMatcher.scriptGurmukhi() =>
      UnicodeCharMatcher(_scriptsData1, scripts.gurmukhi);
  factory UnicodeCharMatcher.scriptGujarati() =>
      UnicodeCharMatcher(_scriptsData1, scripts.gujarati);
  factory UnicodeCharMatcher.scriptOriya() =>
      UnicodeCharMatcher(_scriptsData1, scripts.oriya);
  factory UnicodeCharMatcher.scriptTamil() =>
      UnicodeCharMatcher(_scriptsData1, scripts.tamil);
  factory UnicodeCharMatcher.scriptTelugu() =>
      UnicodeCharMatcher(_scriptsData1, scripts.telugu);
  factory UnicodeCharMatcher.scriptKannada() =>
      UnicodeCharMatcher(_scriptsData1, scripts.kannada);
  factory UnicodeCharMatcher.scriptMalayalam() =>
      UnicodeCharMatcher(_scriptsData1, scripts.malayalam);
  factory UnicodeCharMatcher.scriptSinhala() =>
      UnicodeCharMatcher(_scriptsData1, scripts.sinhala);
  factory UnicodeCharMatcher.scriptThai() =>
      UnicodeCharMatcher(_scriptsData1, scripts.thai);
  factory UnicodeCharMatcher.scriptLao() =>
      UnicodeCharMatcher(_scriptsData1, scripts.lao);
  factory UnicodeCharMatcher.scriptTibetan() =>
      UnicodeCharMatcher(_scriptsData1, scripts.tibetan);
  factory UnicodeCharMatcher.scriptMyanmar() =>
      UnicodeCharMatcher(_scriptsData1, scripts.myanmar);
  factory UnicodeCharMatcher.scriptGeorgian() =>
      UnicodeCharMatcher(_scriptsData1, scripts.georgian);
  factory UnicodeCharMatcher.scriptHangul() =>
      UnicodeCharMatcher(_scriptsData1, scripts.hangul);
  factory UnicodeCharMatcher.scriptEthiopic() =>
      UnicodeCharMatcher(_scriptsData1, scripts.ethiopic);
  factory UnicodeCharMatcher.scriptCherokee() =>
      UnicodeCharMatcher(_scriptsData1, scripts.cherokee);
  factory UnicodeCharMatcher.scriptCanadianAboriginal() =>
      UnicodeCharMatcher(_scriptsData1, scripts.canadianAboriginal);
  factory UnicodeCharMatcher.scriptOgham() =>
      UnicodeCharMatcher(_scriptsData1, scripts.ogham);
  factory UnicodeCharMatcher.scriptRunic() =>
      UnicodeCharMatcher(_scriptsData1, scripts.runic);
  factory UnicodeCharMatcher.scriptKhmer() =>
      UnicodeCharMatcher(_scriptsData1, scripts.khmer);
  factory UnicodeCharMatcher.scriptMongolian() =>
      UnicodeCharMatcher(_scriptsData1, scripts.mongolian);

  factory UnicodeCharMatcher.scriptHiragana() =>
      UnicodeCharMatcher(_scriptsData2, scripts.hiragana);
  factory UnicodeCharMatcher.scriptKatakana() =>
      UnicodeCharMatcher(_scriptsData2, scripts.katakana);
  factory UnicodeCharMatcher.scriptBopomofo() =>
      UnicodeCharMatcher(_scriptsData2, scripts.bopomofo);
  factory UnicodeCharMatcher.scriptHan() =>
      UnicodeCharMatcher(_scriptsData2, scripts.han);
  factory UnicodeCharMatcher.scriptYi() =>
      UnicodeCharMatcher(_scriptsData2, scripts.yi);
  factory UnicodeCharMatcher.scriptOldItalic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.oldItalic);
  factory UnicodeCharMatcher.scriptGothic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.gothic);
  factory UnicodeCharMatcher.scriptDeseret() =>
      UnicodeCharMatcher(_scriptsData2, scripts.deseret);
  factory UnicodeCharMatcher.scriptInherited() =>
      UnicodeCharMatcher(_scriptsData2, scripts.inherited);
  factory UnicodeCharMatcher.scriptTagalog() =>
      UnicodeCharMatcher(_scriptsData2, scripts.tagalog);
  factory UnicodeCharMatcher.scriptHanunoo() =>
      UnicodeCharMatcher(_scriptsData2, scripts.hanunoo);
  factory UnicodeCharMatcher.scriptBuhid() =>
      UnicodeCharMatcher(_scriptsData2, scripts.buhid);
  factory UnicodeCharMatcher.scriptTagbanwa() =>
      UnicodeCharMatcher(_scriptsData2, scripts.tagbanwa);
  factory UnicodeCharMatcher.scriptLimbu() =>
      UnicodeCharMatcher(_scriptsData2, scripts.limbu);
  factory UnicodeCharMatcher.scriptTaiLe() =>
      UnicodeCharMatcher(_scriptsData2, scripts.taiLe);
  factory UnicodeCharMatcher.scriptLinearB() =>
      UnicodeCharMatcher(_scriptsData2, scripts.linearB);
  factory UnicodeCharMatcher.scriptUgaritic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.ugaritic);
  factory UnicodeCharMatcher.scriptShavian() =>
      UnicodeCharMatcher(_scriptsData2, scripts.shavian);
  factory UnicodeCharMatcher.scriptOsmanya() =>
      UnicodeCharMatcher(_scriptsData2, scripts.osmanya);
  factory UnicodeCharMatcher.scriptCypriot() =>
      UnicodeCharMatcher(_scriptsData2, scripts.cypriot);
  factory UnicodeCharMatcher.scriptBraille() =>
      UnicodeCharMatcher(_scriptsData2, scripts.braille);
  factory UnicodeCharMatcher.scriptBuginese() =>
      UnicodeCharMatcher(_scriptsData2, scripts.buginese);
  factory UnicodeCharMatcher.scriptCoptic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.coptic);
  factory UnicodeCharMatcher.scriptNewTaiLue() =>
      UnicodeCharMatcher(_scriptsData2, scripts.newTaiLue);
  factory UnicodeCharMatcher.scriptGlagolitic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.glagolitic);
  factory UnicodeCharMatcher.scriptTifinagh() =>
      UnicodeCharMatcher(_scriptsData2, scripts.tifinagh);
  factory UnicodeCharMatcher.scriptSylotiNagri() =>
      UnicodeCharMatcher(_scriptsData2, scripts.sylotiNagri);
  factory UnicodeCharMatcher.scriptOldPersian() =>
      UnicodeCharMatcher(_scriptsData2, scripts.oldPersian);
  factory UnicodeCharMatcher.scriptKharoshthi() =>
      UnicodeCharMatcher(_scriptsData2, scripts.kharoshthi);
  factory UnicodeCharMatcher.scriptBalinese() =>
      UnicodeCharMatcher(_scriptsData2, scripts.balinese);
  factory UnicodeCharMatcher.scriptCuneiform() =>
      UnicodeCharMatcher(_scriptsData2, scripts.cuneiform);
  factory UnicodeCharMatcher.scriptPhoenician() =>
      UnicodeCharMatcher(_scriptsData2, scripts.phoenician);

  factory UnicodeCharMatcher.scriptPhagsPa() =>
      UnicodeCharMatcher(_scriptsData3, scripts.phagsPa);
  factory UnicodeCharMatcher.scriptNko() =>
      UnicodeCharMatcher(_scriptsData3, scripts.nko);
  factory UnicodeCharMatcher.scriptSundanese() =>
      UnicodeCharMatcher(_scriptsData3, scripts.sundanese);
  factory UnicodeCharMatcher.scriptLepcha() =>
      UnicodeCharMatcher(_scriptsData3, scripts.lepcha);
  factory UnicodeCharMatcher.scriptOlChiki() =>
      UnicodeCharMatcher(_scriptsData3, scripts.olChiki);
  factory UnicodeCharMatcher.scriptVai() =>
      UnicodeCharMatcher(_scriptsData3, scripts.vai);
  factory UnicodeCharMatcher.scriptSaurashtra() =>
      UnicodeCharMatcher(_scriptsData3, scripts.saurashtra);
  factory UnicodeCharMatcher.scriptKayahLi() =>
      UnicodeCharMatcher(_scriptsData3, scripts.kayahLi);
  factory UnicodeCharMatcher.scriptRejang() =>
      UnicodeCharMatcher(_scriptsData3, scripts.rejang);
  factory UnicodeCharMatcher.scriptLycian() =>
      UnicodeCharMatcher(_scriptsData3, scripts.lycian);
  factory UnicodeCharMatcher.scriptCarian() =>
      UnicodeCharMatcher(_scriptsData3, scripts.carian);
  factory UnicodeCharMatcher.scriptLydian() =>
      UnicodeCharMatcher(_scriptsData3, scripts.lydian);
  factory UnicodeCharMatcher.scriptCham() =>
      UnicodeCharMatcher(_scriptsData3, scripts.cham);
  factory UnicodeCharMatcher.scriptTaiTham() =>
      UnicodeCharMatcher(_scriptsData3, scripts.taiTham);
  factory UnicodeCharMatcher.scriptTaiViet() =>
      UnicodeCharMatcher(_scriptsData3, scripts.taiViet);
  factory UnicodeCharMatcher.scriptAvestan() =>
      UnicodeCharMatcher(_scriptsData3, scripts.avestan);
  factory UnicodeCharMatcher.scriptEgyptianHieroglyphs() =>
      UnicodeCharMatcher(_scriptsData3, scripts.egyptianHieroglyphs);
  factory UnicodeCharMatcher.scriptSamaritan() =>
      UnicodeCharMatcher(_scriptsData3, scripts.samaritan);
  factory UnicodeCharMatcher.scriptLisu() =>
      UnicodeCharMatcher(_scriptsData3, scripts.lisu);
  factory UnicodeCharMatcher.scriptBamum() =>
      UnicodeCharMatcher(_scriptsData3, scripts.bamum);
  factory UnicodeCharMatcher.scriptJavanese() =>
      UnicodeCharMatcher(_scriptsData3, scripts.javanese);
  factory UnicodeCharMatcher.scriptMeeteiMayek() =>
      UnicodeCharMatcher(_scriptsData3, scripts.meeteiMayek);
  factory UnicodeCharMatcher.scriptImperialAramaic() =>
      UnicodeCharMatcher(_scriptsData3, scripts.imperialAramaic);
  factory UnicodeCharMatcher.scriptOldSouthArabian() =>
      UnicodeCharMatcher(_scriptsData3, scripts.oldSouthArabian);
  factory UnicodeCharMatcher.scriptInscriptionalParthian() =>
      UnicodeCharMatcher(_scriptsData3, scripts.inscriptionalParthian);
  factory UnicodeCharMatcher.scriptInscriptionalPahlavi() =>
      UnicodeCharMatcher(_scriptsData3, scripts.inscriptionalPahlavi);
  factory UnicodeCharMatcher.scriptOldTurkic() =>
      UnicodeCharMatcher(_scriptsData3, scripts.oldTurkic);
  factory UnicodeCharMatcher.scriptKaithi() =>
      UnicodeCharMatcher(_scriptsData3, scripts.kaithi);
  factory UnicodeCharMatcher.scriptBatak() =>
      UnicodeCharMatcher(_scriptsData3, scripts.batak);
  factory UnicodeCharMatcher.scriptBrahmi() =>
      UnicodeCharMatcher(_scriptsData3, scripts.brahmi);
  factory UnicodeCharMatcher.scriptMandaic() =>
      UnicodeCharMatcher(_scriptsData3, scripts.mandaic);
  factory UnicodeCharMatcher.scriptChakma() =>
      UnicodeCharMatcher(_scriptsData3, scripts.chakma);

  factory UnicodeCharMatcher.scriptMeroiticCursive() =>
      UnicodeCharMatcher(_scriptsData4, scripts.meroiticCursive);
  factory UnicodeCharMatcher.scriptMeroiticHieroglyphs() =>
      UnicodeCharMatcher(_scriptsData4, scripts.meroiticHieroglyphs);
  factory UnicodeCharMatcher.scriptMiao() =>
      UnicodeCharMatcher(_scriptsData4, scripts.miao);
  factory UnicodeCharMatcher.scriptSharada() =>
      UnicodeCharMatcher(_scriptsData4, scripts.sharada);
  factory UnicodeCharMatcher.scriptSoraSompeng() =>
      UnicodeCharMatcher(_scriptsData4, scripts.soraSompeng);
  factory UnicodeCharMatcher.scriptTakri() =>
      UnicodeCharMatcher(_scriptsData4, scripts.takri);
  factory UnicodeCharMatcher.scriptCaucasianAlbanian() =>
      UnicodeCharMatcher(_scriptsData4, scripts.caucasianAlbanian);
  factory UnicodeCharMatcher.scriptBassaVah() =>
      UnicodeCharMatcher(_scriptsData4, scripts.bassaVah);
  factory UnicodeCharMatcher.scriptDuployan() =>
      UnicodeCharMatcher(_scriptsData4, scripts.duployan);
  factory UnicodeCharMatcher.scriptElbasan() =>
      UnicodeCharMatcher(_scriptsData4, scripts.elbasan);
  factory UnicodeCharMatcher.scriptGrantha() =>
      UnicodeCharMatcher(_scriptsData4, scripts.grantha);
  factory UnicodeCharMatcher.scriptPahawhHmong() =>
      UnicodeCharMatcher(_scriptsData4, scripts.pahawhHmong);
  factory UnicodeCharMatcher.scriptKhojki() =>
      UnicodeCharMatcher(_scriptsData4, scripts.khojki);
  factory UnicodeCharMatcher.scriptLinearA() =>
      UnicodeCharMatcher(_scriptsData4, scripts.linearA);
  factory UnicodeCharMatcher.scriptMahajani() =>
      UnicodeCharMatcher(_scriptsData4, scripts.mahajani);
  factory UnicodeCharMatcher.scriptManichaean() =>
      UnicodeCharMatcher(_scriptsData4, scripts.manichaean);
  factory UnicodeCharMatcher.scriptMendeKikakui() =>
      UnicodeCharMatcher(_scriptsData4, scripts.mendeKikakui);
  factory UnicodeCharMatcher.scriptModi() =>
      UnicodeCharMatcher(_scriptsData4, scripts.modi);
  factory UnicodeCharMatcher.scriptMro() =>
      UnicodeCharMatcher(_scriptsData4, scripts.mro);
  factory UnicodeCharMatcher.scriptOldNorthArabian() =>
      UnicodeCharMatcher(_scriptsData4, scripts.oldNorthArabian);
  factory UnicodeCharMatcher.scriptNabataean() =>
      UnicodeCharMatcher(_scriptsData4, scripts.nabataean);
  factory UnicodeCharMatcher.scriptPalmyrene() =>
      UnicodeCharMatcher(_scriptsData4, scripts.palmyrene);
  factory UnicodeCharMatcher.scriptPauCinHau() =>
      UnicodeCharMatcher(_scriptsData4, scripts.pauCinHau);
  factory UnicodeCharMatcher.scriptOldPermic() =>
      UnicodeCharMatcher(_scriptsData4, scripts.oldPermic);
  factory UnicodeCharMatcher.scriptPsalterPahlavi() =>
      UnicodeCharMatcher(_scriptsData4, scripts.psalterPahlavi);
  factory UnicodeCharMatcher.scriptSiddham() =>
      UnicodeCharMatcher(_scriptsData4, scripts.siddham);
  factory UnicodeCharMatcher.scriptKhudawadi() =>
      UnicodeCharMatcher(_scriptsData4, scripts.khudawadi);
  factory UnicodeCharMatcher.scriptTirhuta() =>
      UnicodeCharMatcher(_scriptsData4, scripts.tirhuta);
  factory UnicodeCharMatcher.scriptWarangCiti() =>
      UnicodeCharMatcher(_scriptsData4, scripts.warangCiti);
  factory UnicodeCharMatcher.scriptAhom() =>
      UnicodeCharMatcher(_scriptsData4, scripts.ahom);
  factory UnicodeCharMatcher.scriptAnatolianHieroglyphs() =>
      UnicodeCharMatcher(_scriptsData4, scripts.anatolianHieroglyphs);
  factory UnicodeCharMatcher.scriptHatran() =>
      UnicodeCharMatcher(_scriptsData4, scripts.hatran);

  factory UnicodeCharMatcher.scriptMultani() =>
      UnicodeCharMatcher(_scriptsData5, scripts.multani);
  factory UnicodeCharMatcher.scriptOldHungarian() =>
      UnicodeCharMatcher(_scriptsData5, scripts.oldHungarian);
  factory UnicodeCharMatcher.scriptSignwriting() =>
      UnicodeCharMatcher(_scriptsData5, scripts.signwriting);
  factory UnicodeCharMatcher.scriptAdlam() =>
      UnicodeCharMatcher(_scriptsData5, scripts.adlam);
  factory UnicodeCharMatcher.scriptBhaiksuki() =>
      UnicodeCharMatcher(_scriptsData5, scripts.bhaiksuki);
  factory UnicodeCharMatcher.scriptMarchen() =>
      UnicodeCharMatcher(_scriptsData5, scripts.marchen);
  factory UnicodeCharMatcher.scriptNewa() =>
      UnicodeCharMatcher(_scriptsData5, scripts.newa);
  factory UnicodeCharMatcher.scriptOsage() =>
      UnicodeCharMatcher(_scriptsData5, scripts.osage);
  factory UnicodeCharMatcher.scriptTangut() =>
      UnicodeCharMatcher(_scriptsData5, scripts.tangut);
  factory UnicodeCharMatcher.scriptMasaramGondi() =>
      UnicodeCharMatcher(_scriptsData5, scripts.masaramGondi);
  factory UnicodeCharMatcher.scriptNushu() =>
      UnicodeCharMatcher(_scriptsData5, scripts.nushu);
  factory UnicodeCharMatcher.scriptSoyombo() =>
      UnicodeCharMatcher(_scriptsData5, scripts.soyombo);
  factory UnicodeCharMatcher.scriptZanabazarSquare() =>
      UnicodeCharMatcher(_scriptsData5, scripts.zanabazarSquare);
  factory UnicodeCharMatcher.scriptDogra() =>
      UnicodeCharMatcher(_scriptsData5, scripts.dogra);
  factory UnicodeCharMatcher.scriptGunjalaGondi() =>
      UnicodeCharMatcher(_scriptsData5, scripts.gunjalaGondi);
  factory UnicodeCharMatcher.scriptMakasar() =>
      UnicodeCharMatcher(_scriptsData5, scripts.makasar);
  factory UnicodeCharMatcher.scriptMedefaidrin() =>
      UnicodeCharMatcher(_scriptsData5, scripts.medefaidrin);
  factory UnicodeCharMatcher.scriptHanifiRohingya() =>
      UnicodeCharMatcher(_scriptsData5, scripts.hanifiRohingya);
  factory UnicodeCharMatcher.scriptSogdian() =>
      UnicodeCharMatcher(_scriptsData5, scripts.sogdian);
  factory UnicodeCharMatcher.scriptOldSogdian() =>
      UnicodeCharMatcher(_scriptsData5, scripts.oldSogdian);
  factory UnicodeCharMatcher.scriptElymaic() =>
      UnicodeCharMatcher(_scriptsData5, scripts.elymaic);
  factory UnicodeCharMatcher.scriptNandinagari() =>
      UnicodeCharMatcher(_scriptsData5, scripts.nandinagari);
  factory UnicodeCharMatcher.scriptNyiakengPuachueHmong() =>
      UnicodeCharMatcher(_scriptsData5, scripts.nyiakengPuachueHmong);
  factory UnicodeCharMatcher.scriptWancho() =>
      UnicodeCharMatcher(_scriptsData5, scripts.wancho);
  factory UnicodeCharMatcher.scriptChorasmian() =>
      UnicodeCharMatcher(_scriptsData5, scripts.chorasmian);
  factory UnicodeCharMatcher.scriptDivesAkuru() =>
      UnicodeCharMatcher(_scriptsData5, scripts.divesAkuru);
  factory UnicodeCharMatcher.scriptKhitanSmallScript() =>
      UnicodeCharMatcher(_scriptsData5, scripts.khitanSmallScript);
  factory UnicodeCharMatcher.scriptYezidi() =>
      UnicodeCharMatcher(_scriptsData5, scripts.yezidi);
  factory UnicodeCharMatcher.scriptCyproMinoan() =>
      UnicodeCharMatcher(_scriptsData5, scripts.cyproMinoan);
  factory UnicodeCharMatcher.scriptOldUyghur() =>
      UnicodeCharMatcher(_scriptsData5, scripts.oldUyghur);
  factory UnicodeCharMatcher.scriptTangsa() =>
      UnicodeCharMatcher(_scriptsData5, scripts.tangsa);
  factory UnicodeCharMatcher.scriptToto() =>
      UnicodeCharMatcher(_scriptsData5, scripts.toto);

  factory UnicodeCharMatcher.scriptVithkuqi() =>
      UnicodeCharMatcher(_scriptsData6, scripts.vithkuqi);
  factory UnicodeCharMatcher.scriptKawi() =>
      UnicodeCharMatcher(_scriptsData6, scripts.kawi);
  factory UnicodeCharMatcher.scriptNagMundari() =>
      UnicodeCharMatcher(_scriptsData6, scripts.nagMundari);
  factory UnicodeCharMatcher.scriptGaray() =>
      UnicodeCharMatcher(_scriptsData6, scripts.garay);
  factory UnicodeCharMatcher.scriptGurungKhema() =>
      UnicodeCharMatcher(_scriptsData6, scripts.gurungKhema);
  factory UnicodeCharMatcher.scriptKiratRai() =>
      UnicodeCharMatcher(_scriptsData6, scripts.kiratRai);
  factory UnicodeCharMatcher.scriptOlOnal() =>
      UnicodeCharMatcher(_scriptsData6, scripts.olOnal);
  factory UnicodeCharMatcher.scriptSunuwar() =>
      UnicodeCharMatcher(_scriptsData6, scripts.sunuwar);
  factory UnicodeCharMatcher.scriptTodhri() =>
      UnicodeCharMatcher(_scriptsData6, scripts.todhri);
  factory UnicodeCharMatcher.scriptTuluTigalari() =>
      UnicodeCharMatcher(_scriptsData6, scripts.tuluTigalari);
  factory UnicodeCharMatcher.scriptSidetic() =>
      UnicodeCharMatcher(_scriptsData6, scripts.sidetic);
  factory UnicodeCharMatcher.scriptTaiYo() =>
      UnicodeCharMatcher(_scriptsData6, scripts.taiYo);
  factory UnicodeCharMatcher.scriptTolongSiki() =>
      UnicodeCharMatcher(_scriptsData6, scripts.tolongSiki);
  factory UnicodeCharMatcher.scriptBeriaErfe() =>
      UnicodeCharMatcher(_scriptsData6, scripts.beriaErfe);

  final List<int> data;
  final int mask;

  @override
  bool match(int value) => data[value] & mask != 0;
}

final _categoryData = decodeRle(category.data);
final _propertyData1 = decodeRle(property.data1);
final _propertyData2 = decodeRle(property.data2);
final _bidiClassData = decodeRle(bidi_class.data);
final _scriptsData1 = decodeRle(scripts.data1);
final _scriptsData2 = decodeRle(scripts.data2);
final _scriptsData3 = decodeRle(scripts.data3);
final _scriptsData4 = decodeRle(scripts.data4);
final _scriptsData5 = decodeRle(scripts.data5);
final _scriptsData6 = decodeRle(scripts.data6);
