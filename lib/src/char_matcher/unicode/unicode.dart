import '../../shared/rle.dart';
import '../char_matcher.dart';
import 'bidi_class.dart' as bidi_class;
import 'category.dart' as category;
import 'property.dart' as property;
import 'scripts.dart' as scripts;

/// Character matcher function that classifies characters using official Unicode
/// categories and properties.
final class UnicodeCharMatcher extends CharMatcher {
  const new(this.data, this.mask)
    : assert(data.length == 0x10ffff + 1),
      assert(mask <= 0xffffffff);

  /// General Category
  factory letterUppercase() => UnicodeCharMatcher(_categoryData, category.lu);

  factory letterLowercase() => UnicodeCharMatcher(_categoryData, category.ll);

  factory letterTitlecase() => UnicodeCharMatcher(_categoryData, category.lt);

  factory letterModifier() => UnicodeCharMatcher(_categoryData, category.lm);

  factory letterOther() => UnicodeCharMatcher(_categoryData, category.lo);

  factory markNonspacing() => UnicodeCharMatcher(_categoryData, category.mn);

  factory markSpacingCombining() =>
      UnicodeCharMatcher(_categoryData, category.mc);

  factory markEnclosing() => UnicodeCharMatcher(_categoryData, category.me);

  factory numberDecimalDigit() =>
      UnicodeCharMatcher(_categoryData, category.nd);

  factory numberLetter() => UnicodeCharMatcher(_categoryData, category.nl);

  factory numberOther() => UnicodeCharMatcher(_categoryData, category.no);

  factory punctuationConnector() =>
      UnicodeCharMatcher(_categoryData, category.pc);

  factory punctuationDash() => UnicodeCharMatcher(_categoryData, category.pd);

  factory punctuationOpen() => UnicodeCharMatcher(_categoryData, category.ps);

  factory punctuationClose() => UnicodeCharMatcher(_categoryData, category.pe);

  factory punctuationInitialQuote() =>
      UnicodeCharMatcher(_categoryData, category.pi);

  factory punctuationFinalQuote() =>
      UnicodeCharMatcher(_categoryData, category.pf);

  factory punctuationOther() => UnicodeCharMatcher(_categoryData, category.po);

  factory symbolMath() => UnicodeCharMatcher(_categoryData, category.sm);

  factory symbolCurrency() => UnicodeCharMatcher(_categoryData, category.sc);

  factory symbolModifier() => UnicodeCharMatcher(_categoryData, category.sk);

  factory symbolOther() => UnicodeCharMatcher(_categoryData, category.so);

  factory separatorSpace() => UnicodeCharMatcher(_categoryData, category.zs);

  factory separatorLine() => UnicodeCharMatcher(_categoryData, category.zl);

  factory separatorParagraph() =>
      UnicodeCharMatcher(_categoryData, category.zp);

  factory otherControl() => UnicodeCharMatcher(_categoryData, category.cc);

  factory otherFormat() => UnicodeCharMatcher(_categoryData, category.cf);

  factory otherSurrogate() => UnicodeCharMatcher(_categoryData, category.cs);

  factory otherPrivateUse() => UnicodeCharMatcher(_categoryData, category.co);

  factory otherNotAssigned() => UnicodeCharMatcher(_categoryData, category.cn);

  /// General Category Groups
  factory casedLetter() => UnicodeCharMatcher(
    _categoryData,
    category.lu | category.ll | category.lt,
  );

  factory letter() => UnicodeCharMatcher(
    _categoryData,
    category.lu | category.ll | category.lt | category.lm | category.lo,
  );

  factory mark() => UnicodeCharMatcher(
    _categoryData,
    category.mn | category.mc | category.me,
  );

  factory number() => UnicodeCharMatcher(
    _categoryData,
    category.nd | category.nl | category.no,
  );

  factory punctuation() => UnicodeCharMatcher(
    _categoryData,
    category.pc |
        category.pd |
        category.ps |
        category.pe |
        category.pi |
        category.pf |
        category.po,
  );

  factory symbol() => UnicodeCharMatcher(
    _categoryData,
    category.sm | category.sc | category.sk | category.so,
  );

  factory separator() => UnicodeCharMatcher(
    _categoryData,
    category.zs | category.zl | category.zp,
  );

  factory other() => UnicodeCharMatcher(
    _categoryData,
    category.cc | category.cf | category.cs | category.co | category.cn,
  );

  /// Properties
  factory whiteSpace() =>
      UnicodeCharMatcher(_propertyData1, property.whiteSpace);

  factory bidiControl() =>
      UnicodeCharMatcher(_propertyData1, property.bidiControl);

  factory joinControl() =>
      UnicodeCharMatcher(_propertyData1, property.joinControl);

  factory dash() => UnicodeCharMatcher(_propertyData1, property.dash);

  factory hyphen() => UnicodeCharMatcher(_propertyData1, property.hyphen);

  factory quotationMark() =>
      UnicodeCharMatcher(_propertyData1, property.quotationMark);

  factory terminalPunctuation() =>
      UnicodeCharMatcher(_propertyData1, property.terminalPunctuation);

  factory otherMath() => UnicodeCharMatcher(_propertyData1, property.otherMath);

  factory hexDigit() => UnicodeCharMatcher(_propertyData1, property.hexDigit);

  factory asciiHexDigit() =>
      UnicodeCharMatcher(_propertyData1, property.asciiHexDigit);

  factory otherAlphabetic() =>
      UnicodeCharMatcher(_propertyData1, property.otherAlphabetic);

  factory ideographic() =>
      UnicodeCharMatcher(_propertyData1, property.ideographic);

  factory diacritic() => UnicodeCharMatcher(_propertyData1, property.diacritic);

  factory extender() => UnicodeCharMatcher(_propertyData1, property.extender);

  factory otherLowercase() =>
      UnicodeCharMatcher(_propertyData1, property.otherLowercase);

  factory otherUppercase() =>
      UnicodeCharMatcher(_propertyData1, property.otherUppercase);

  factory noncharacterCodePoint() =>
      UnicodeCharMatcher(_propertyData1, property.noncharacterCodePoint);

  factory otherGraphemeExtend() =>
      UnicodeCharMatcher(_propertyData1, property.otherGraphemeExtend);

  factory idsBinaryOperator() =>
      UnicodeCharMatcher(_propertyData1, property.idsBinaryOperator);

  factory idsTrinaryOperator() =>
      UnicodeCharMatcher(_propertyData1, property.idsTrinaryOperator);

  factory idsUnaryOperator() =>
      UnicodeCharMatcher(_propertyData1, property.idsUnaryOperator);

  factory radical() => UnicodeCharMatcher(_propertyData1, property.radical);

  factory unifiedIdeograph() =>
      UnicodeCharMatcher(_propertyData1, property.unifiedIdeograph);

  factory otherDefaultIgnorableCodePoint() => UnicodeCharMatcher(
    _propertyData1,
    property.otherDefaultIgnorableCodePoint,
  );

  factory deprecated() =>
      UnicodeCharMatcher(_propertyData1, property.deprecated);

  factory softDotted() =>
      UnicodeCharMatcher(_propertyData1, property.softDotted);

  factory logicalOrderException() =>
      UnicodeCharMatcher(_propertyData1, property.logicalOrderException);

  factory otherIdStart() =>
      UnicodeCharMatcher(_propertyData1, property.otherIdStart);

  factory otherIdContinue() =>
      UnicodeCharMatcher(_propertyData1, property.otherIdContinue);

  factory idCompatMathContinue() =>
      UnicodeCharMatcher(_propertyData1, property.idCompatMathContinue);

  factory idCompatMathStart() =>
      UnicodeCharMatcher(_propertyData1, property.idCompatMathStart);

  factory sentenceTerminal() =>
      UnicodeCharMatcher(_propertyData1, property.sentenceTerminal);

  factory variationSelector() =>
      UnicodeCharMatcher(_propertyData2, property.variationSelector);

  factory patternWhiteSpace() =>
      UnicodeCharMatcher(_propertyData2, property.patternWhiteSpace);

  factory patternSyntax() =>
      UnicodeCharMatcher(_propertyData2, property.patternSyntax);

  factory prependedConcatenationMark() =>
      UnicodeCharMatcher(_propertyData2, property.prependedConcatenationMark);

  factory regionalIndicator() =>
      UnicodeCharMatcher(_propertyData2, property.regionalIndicator);

  /// Bidi Classes
  factory bidiLeftToRight() => UnicodeCharMatcher(_bidiClassData, bidi_class.l);

  factory bidiRightToLeft() => UnicodeCharMatcher(_bidiClassData, bidi_class.r);

  factory bidiRightToLeftArabic() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.al);

  factory bidiEuropeanNumber() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.en);

  factory bidiEuropeanNumberSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.es);

  factory bidiEuropeanNumberTerminator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.et);

  factory bidiArabicNumber() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.an);

  factory bidiCommonNumberSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.cs);

  factory bidiNonspacingMark() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.nsm);

  factory bidiBoundaryNeutral() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.bn);

  factory bidiParagraphSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.b);

  factory bidiSegmentSeparator() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.s);

  factory bidiWhitespace() => UnicodeCharMatcher(_bidiClassData, bidi_class.ws);

  factory bidiOtherNeutrals() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.on);

  factory bidiLeftToRightEmbedding() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.lre);

  factory bidiLeftToRightOverride() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.lro);

  factory bidiRightToLeftEmbedding() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.rle);

  factory bidiRightToLeftOverride() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.rlo);

  factory bidiPopDirectionalFormat() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.pdf);

  factory bidiLeftToRightIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.lri);

  factory bidiRightToLeftIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.rli);

  factory bidiFirstStrongIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.fsi);

  factory bidiPopDirectionalIsolate() =>
      UnicodeCharMatcher(_bidiClassData, bidi_class.pdi);

  /// Bidi Class Categories
  factory bidiStrong() => UnicodeCharMatcher(
    _bidiClassData,
    bidi_class.l | bidi_class.r | bidi_class.al,
  );

  factory bidiWeak() => UnicodeCharMatcher(
    _bidiClassData,
    bidi_class.en |
        bidi_class.es |
        bidi_class.et |
        bidi_class.an |
        bidi_class.cs |
        bidi_class.nsm |
        bidi_class.bn,
  );

  factory bidiNeutral() => UnicodeCharMatcher(
    _bidiClassData,
    bidi_class.b | bidi_class.s | bidi_class.ws | bidi_class.on,
  );

  factory bidiExplicitFormatting() => UnicodeCharMatcher(
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
  factory scriptCommon() => UnicodeCharMatcher(_scriptsData1, scripts.common);
  factory scriptLatin() => UnicodeCharMatcher(_scriptsData1, scripts.latin);
  factory scriptGreek() => UnicodeCharMatcher(_scriptsData1, scripts.greek);
  factory scriptCyrillic() =>
      UnicodeCharMatcher(_scriptsData1, scripts.cyrillic);
  factory scriptArmenian() =>
      UnicodeCharMatcher(_scriptsData1, scripts.armenian);
  factory scriptHebrew() => UnicodeCharMatcher(_scriptsData1, scripts.hebrew);
  factory scriptArabic() => UnicodeCharMatcher(_scriptsData1, scripts.arabic);
  factory scriptSyriac() => UnicodeCharMatcher(_scriptsData1, scripts.syriac);
  factory scriptThaana() => UnicodeCharMatcher(_scriptsData1, scripts.thaana);
  factory scriptDevanagari() =>
      UnicodeCharMatcher(_scriptsData1, scripts.devanagari);
  factory scriptBengali() => UnicodeCharMatcher(_scriptsData1, scripts.bengali);
  factory scriptGurmukhi() =>
      UnicodeCharMatcher(_scriptsData1, scripts.gurmukhi);
  factory scriptGujarati() =>
      UnicodeCharMatcher(_scriptsData1, scripts.gujarati);
  factory scriptOriya() => UnicodeCharMatcher(_scriptsData1, scripts.oriya);
  factory scriptTamil() => UnicodeCharMatcher(_scriptsData1, scripts.tamil);
  factory scriptTelugu() => UnicodeCharMatcher(_scriptsData1, scripts.telugu);
  factory scriptKannada() => UnicodeCharMatcher(_scriptsData1, scripts.kannada);
  factory scriptMalayalam() =>
      UnicodeCharMatcher(_scriptsData1, scripts.malayalam);
  factory scriptSinhala() => UnicodeCharMatcher(_scriptsData1, scripts.sinhala);
  factory scriptThai() => UnicodeCharMatcher(_scriptsData1, scripts.thai);
  factory scriptLao() => UnicodeCharMatcher(_scriptsData1, scripts.lao);
  factory scriptTibetan() => UnicodeCharMatcher(_scriptsData1, scripts.tibetan);
  factory scriptMyanmar() => UnicodeCharMatcher(_scriptsData1, scripts.myanmar);
  factory scriptGeorgian() =>
      UnicodeCharMatcher(_scriptsData1, scripts.georgian);
  factory scriptHangul() => UnicodeCharMatcher(_scriptsData1, scripts.hangul);
  factory scriptEthiopic() =>
      UnicodeCharMatcher(_scriptsData1, scripts.ethiopic);
  factory scriptCherokee() =>
      UnicodeCharMatcher(_scriptsData1, scripts.cherokee);
  factory scriptCanadianAboriginal() =>
      UnicodeCharMatcher(_scriptsData1, scripts.canadianAboriginal);
  factory scriptOgham() => UnicodeCharMatcher(_scriptsData1, scripts.ogham);
  factory scriptRunic() => UnicodeCharMatcher(_scriptsData1, scripts.runic);
  factory scriptKhmer() => UnicodeCharMatcher(_scriptsData1, scripts.khmer);
  factory scriptMongolian() =>
      UnicodeCharMatcher(_scriptsData1, scripts.mongolian);

  factory scriptHiragana() =>
      UnicodeCharMatcher(_scriptsData2, scripts.hiragana);
  factory scriptKatakana() =>
      UnicodeCharMatcher(_scriptsData2, scripts.katakana);
  factory scriptBopomofo() =>
      UnicodeCharMatcher(_scriptsData2, scripts.bopomofo);
  factory scriptHan() => UnicodeCharMatcher(_scriptsData2, scripts.han);
  factory scriptYi() => UnicodeCharMatcher(_scriptsData2, scripts.yi);
  factory scriptOldItalic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.oldItalic);
  factory scriptGothic() => UnicodeCharMatcher(_scriptsData2, scripts.gothic);
  factory scriptDeseret() => UnicodeCharMatcher(_scriptsData2, scripts.deseret);
  factory scriptInherited() =>
      UnicodeCharMatcher(_scriptsData2, scripts.inherited);
  factory scriptTagalog() => UnicodeCharMatcher(_scriptsData2, scripts.tagalog);
  factory scriptHanunoo() => UnicodeCharMatcher(_scriptsData2, scripts.hanunoo);
  factory scriptBuhid() => UnicodeCharMatcher(_scriptsData2, scripts.buhid);
  factory scriptTagbanwa() =>
      UnicodeCharMatcher(_scriptsData2, scripts.tagbanwa);
  factory scriptLimbu() => UnicodeCharMatcher(_scriptsData2, scripts.limbu);
  factory scriptTaiLe() => UnicodeCharMatcher(_scriptsData2, scripts.taiLe);
  factory scriptLinearB() => UnicodeCharMatcher(_scriptsData2, scripts.linearB);
  factory scriptUgaritic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.ugaritic);
  factory scriptShavian() => UnicodeCharMatcher(_scriptsData2, scripts.shavian);
  factory scriptOsmanya() => UnicodeCharMatcher(_scriptsData2, scripts.osmanya);
  factory scriptCypriot() => UnicodeCharMatcher(_scriptsData2, scripts.cypriot);
  factory scriptBraille() => UnicodeCharMatcher(_scriptsData2, scripts.braille);
  factory scriptBuginese() =>
      UnicodeCharMatcher(_scriptsData2, scripts.buginese);
  factory scriptCoptic() => UnicodeCharMatcher(_scriptsData2, scripts.coptic);
  factory scriptNewTaiLue() =>
      UnicodeCharMatcher(_scriptsData2, scripts.newTaiLue);
  factory scriptGlagolitic() =>
      UnicodeCharMatcher(_scriptsData2, scripts.glagolitic);
  factory scriptTifinagh() =>
      UnicodeCharMatcher(_scriptsData2, scripts.tifinagh);
  factory scriptSylotiNagri() =>
      UnicodeCharMatcher(_scriptsData2, scripts.sylotiNagri);
  factory scriptOldPersian() =>
      UnicodeCharMatcher(_scriptsData2, scripts.oldPersian);
  factory scriptKharoshthi() =>
      UnicodeCharMatcher(_scriptsData2, scripts.kharoshthi);
  factory scriptBalinese() =>
      UnicodeCharMatcher(_scriptsData2, scripts.balinese);
  factory scriptCuneiform() =>
      UnicodeCharMatcher(_scriptsData2, scripts.cuneiform);
  factory scriptPhoenician() =>
      UnicodeCharMatcher(_scriptsData2, scripts.phoenician);

  factory scriptPhagsPa() => UnicodeCharMatcher(_scriptsData3, scripts.phagsPa);
  factory scriptNko() => UnicodeCharMatcher(_scriptsData3, scripts.nko);
  factory scriptSundanese() =>
      UnicodeCharMatcher(_scriptsData3, scripts.sundanese);
  factory scriptLepcha() => UnicodeCharMatcher(_scriptsData3, scripts.lepcha);
  factory scriptOlChiki() => UnicodeCharMatcher(_scriptsData3, scripts.olChiki);
  factory scriptVai() => UnicodeCharMatcher(_scriptsData3, scripts.vai);
  factory scriptSaurashtra() =>
      UnicodeCharMatcher(_scriptsData3, scripts.saurashtra);
  factory scriptKayahLi() => UnicodeCharMatcher(_scriptsData3, scripts.kayahLi);
  factory scriptRejang() => UnicodeCharMatcher(_scriptsData3, scripts.rejang);
  factory scriptLycian() => UnicodeCharMatcher(_scriptsData3, scripts.lycian);
  factory scriptCarian() => UnicodeCharMatcher(_scriptsData3, scripts.carian);
  factory scriptLydian() => UnicodeCharMatcher(_scriptsData3, scripts.lydian);
  factory scriptCham() => UnicodeCharMatcher(_scriptsData3, scripts.cham);
  factory scriptTaiTham() => UnicodeCharMatcher(_scriptsData3, scripts.taiTham);
  factory scriptTaiViet() => UnicodeCharMatcher(_scriptsData3, scripts.taiViet);
  factory scriptAvestan() => UnicodeCharMatcher(_scriptsData3, scripts.avestan);
  factory scriptEgyptianHieroglyphs() =>
      UnicodeCharMatcher(_scriptsData3, scripts.egyptianHieroglyphs);
  factory scriptSamaritan() =>
      UnicodeCharMatcher(_scriptsData3, scripts.samaritan);
  factory scriptLisu() => UnicodeCharMatcher(_scriptsData3, scripts.lisu);
  factory scriptBamum() => UnicodeCharMatcher(_scriptsData3, scripts.bamum);
  factory scriptJavanese() =>
      UnicodeCharMatcher(_scriptsData3, scripts.javanese);
  factory scriptMeeteiMayek() =>
      UnicodeCharMatcher(_scriptsData3, scripts.meeteiMayek);
  factory scriptImperialAramaic() =>
      UnicodeCharMatcher(_scriptsData3, scripts.imperialAramaic);
  factory scriptOldSouthArabian() =>
      UnicodeCharMatcher(_scriptsData3, scripts.oldSouthArabian);
  factory scriptInscriptionalParthian() =>
      UnicodeCharMatcher(_scriptsData3, scripts.inscriptionalParthian);
  factory scriptInscriptionalPahlavi() =>
      UnicodeCharMatcher(_scriptsData3, scripts.inscriptionalPahlavi);
  factory scriptOldTurkic() =>
      UnicodeCharMatcher(_scriptsData3, scripts.oldTurkic);
  factory scriptKaithi() => UnicodeCharMatcher(_scriptsData3, scripts.kaithi);
  factory scriptBatak() => UnicodeCharMatcher(_scriptsData3, scripts.batak);
  factory scriptBrahmi() => UnicodeCharMatcher(_scriptsData3, scripts.brahmi);
  factory scriptMandaic() => UnicodeCharMatcher(_scriptsData3, scripts.mandaic);
  factory scriptChakma() => UnicodeCharMatcher(_scriptsData3, scripts.chakma);

  factory scriptMeroiticCursive() =>
      UnicodeCharMatcher(_scriptsData4, scripts.meroiticCursive);
  factory scriptMeroiticHieroglyphs() =>
      UnicodeCharMatcher(_scriptsData4, scripts.meroiticHieroglyphs);
  factory scriptMiao() => UnicodeCharMatcher(_scriptsData4, scripts.miao);
  factory scriptSharada() => UnicodeCharMatcher(_scriptsData4, scripts.sharada);
  factory scriptSoraSompeng() =>
      UnicodeCharMatcher(_scriptsData4, scripts.soraSompeng);
  factory scriptTakri() => UnicodeCharMatcher(_scriptsData4, scripts.takri);
  factory scriptCaucasianAlbanian() =>
      UnicodeCharMatcher(_scriptsData4, scripts.caucasianAlbanian);
  factory scriptBassaVah() =>
      UnicodeCharMatcher(_scriptsData4, scripts.bassaVah);
  factory scriptDuployan() =>
      UnicodeCharMatcher(_scriptsData4, scripts.duployan);
  factory scriptElbasan() => UnicodeCharMatcher(_scriptsData4, scripts.elbasan);
  factory scriptGrantha() => UnicodeCharMatcher(_scriptsData4, scripts.grantha);
  factory scriptPahawhHmong() =>
      UnicodeCharMatcher(_scriptsData4, scripts.pahawhHmong);
  factory scriptKhojki() => UnicodeCharMatcher(_scriptsData4, scripts.khojki);
  factory scriptLinearA() => UnicodeCharMatcher(_scriptsData4, scripts.linearA);
  factory scriptMahajani() =>
      UnicodeCharMatcher(_scriptsData4, scripts.mahajani);
  factory scriptManichaean() =>
      UnicodeCharMatcher(_scriptsData4, scripts.manichaean);
  factory scriptMendeKikakui() =>
      UnicodeCharMatcher(_scriptsData4, scripts.mendeKikakui);
  factory scriptModi() => UnicodeCharMatcher(_scriptsData4, scripts.modi);
  factory scriptMro() => UnicodeCharMatcher(_scriptsData4, scripts.mro);
  factory scriptOldNorthArabian() =>
      UnicodeCharMatcher(_scriptsData4, scripts.oldNorthArabian);
  factory scriptNabataean() =>
      UnicodeCharMatcher(_scriptsData4, scripts.nabataean);
  factory scriptPalmyrene() =>
      UnicodeCharMatcher(_scriptsData4, scripts.palmyrene);
  factory scriptPauCinHau() =>
      UnicodeCharMatcher(_scriptsData4, scripts.pauCinHau);
  factory scriptOldPermic() =>
      UnicodeCharMatcher(_scriptsData4, scripts.oldPermic);
  factory scriptPsalterPahlavi() =>
      UnicodeCharMatcher(_scriptsData4, scripts.psalterPahlavi);
  factory scriptSiddham() => UnicodeCharMatcher(_scriptsData4, scripts.siddham);
  factory scriptKhudawadi() =>
      UnicodeCharMatcher(_scriptsData4, scripts.khudawadi);
  factory scriptTirhuta() => UnicodeCharMatcher(_scriptsData4, scripts.tirhuta);
  factory scriptWarangCiti() =>
      UnicodeCharMatcher(_scriptsData4, scripts.warangCiti);
  factory scriptAhom() => UnicodeCharMatcher(_scriptsData4, scripts.ahom);
  factory scriptAnatolianHieroglyphs() =>
      UnicodeCharMatcher(_scriptsData4, scripts.anatolianHieroglyphs);
  factory scriptHatran() => UnicodeCharMatcher(_scriptsData4, scripts.hatran);

  factory scriptMultani() => UnicodeCharMatcher(_scriptsData5, scripts.multani);
  factory scriptOldHungarian() =>
      UnicodeCharMatcher(_scriptsData5, scripts.oldHungarian);
  factory scriptSignwriting() =>
      UnicodeCharMatcher(_scriptsData5, scripts.signwriting);
  factory scriptAdlam() => UnicodeCharMatcher(_scriptsData5, scripts.adlam);
  factory scriptBhaiksuki() =>
      UnicodeCharMatcher(_scriptsData5, scripts.bhaiksuki);
  factory scriptMarchen() => UnicodeCharMatcher(_scriptsData5, scripts.marchen);
  factory scriptNewa() => UnicodeCharMatcher(_scriptsData5, scripts.newa);
  factory scriptOsage() => UnicodeCharMatcher(_scriptsData5, scripts.osage);
  factory scriptTangut() => UnicodeCharMatcher(_scriptsData5, scripts.tangut);
  factory scriptMasaramGondi() =>
      UnicodeCharMatcher(_scriptsData5, scripts.masaramGondi);
  factory scriptNushu() => UnicodeCharMatcher(_scriptsData5, scripts.nushu);
  factory scriptSoyombo() => UnicodeCharMatcher(_scriptsData5, scripts.soyombo);
  factory scriptZanabazarSquare() =>
      UnicodeCharMatcher(_scriptsData5, scripts.zanabazarSquare);
  factory scriptDogra() => UnicodeCharMatcher(_scriptsData5, scripts.dogra);
  factory scriptGunjalaGondi() =>
      UnicodeCharMatcher(_scriptsData5, scripts.gunjalaGondi);
  factory scriptMakasar() => UnicodeCharMatcher(_scriptsData5, scripts.makasar);
  factory scriptMedefaidrin() =>
      UnicodeCharMatcher(_scriptsData5, scripts.medefaidrin);
  factory scriptHanifiRohingya() =>
      UnicodeCharMatcher(_scriptsData5, scripts.hanifiRohingya);
  factory scriptSogdian() => UnicodeCharMatcher(_scriptsData5, scripts.sogdian);
  factory scriptOldSogdian() =>
      UnicodeCharMatcher(_scriptsData5, scripts.oldSogdian);
  factory scriptElymaic() => UnicodeCharMatcher(_scriptsData5, scripts.elymaic);
  factory scriptNandinagari() =>
      UnicodeCharMatcher(_scriptsData5, scripts.nandinagari);
  factory scriptNyiakengPuachueHmong() =>
      UnicodeCharMatcher(_scriptsData5, scripts.nyiakengPuachueHmong);
  factory scriptWancho() => UnicodeCharMatcher(_scriptsData5, scripts.wancho);
  factory scriptChorasmian() =>
      UnicodeCharMatcher(_scriptsData5, scripts.chorasmian);
  factory scriptDivesAkuru() =>
      UnicodeCharMatcher(_scriptsData5, scripts.divesAkuru);
  factory scriptKhitanSmallScript() =>
      UnicodeCharMatcher(_scriptsData5, scripts.khitanSmallScript);
  factory scriptYezidi() => UnicodeCharMatcher(_scriptsData5, scripts.yezidi);
  factory scriptCyproMinoan() =>
      UnicodeCharMatcher(_scriptsData5, scripts.cyproMinoan);
  factory scriptOldUyghur() =>
      UnicodeCharMatcher(_scriptsData5, scripts.oldUyghur);
  factory scriptTangsa() => UnicodeCharMatcher(_scriptsData5, scripts.tangsa);
  factory scriptToto() => UnicodeCharMatcher(_scriptsData5, scripts.toto);

  factory scriptVithkuqi() =>
      UnicodeCharMatcher(_scriptsData6, scripts.vithkuqi);
  factory scriptKawi() => UnicodeCharMatcher(_scriptsData6, scripts.kawi);
  factory scriptNagMundari() =>
      UnicodeCharMatcher(_scriptsData6, scripts.nagMundari);
  factory scriptGaray() => UnicodeCharMatcher(_scriptsData6, scripts.garay);
  factory scriptGurungKhema() =>
      UnicodeCharMatcher(_scriptsData6, scripts.gurungKhema);
  factory scriptKiratRai() =>
      UnicodeCharMatcher(_scriptsData6, scripts.kiratRai);
  factory scriptOlOnal() => UnicodeCharMatcher(_scriptsData6, scripts.olOnal);
  factory scriptSunuwar() => UnicodeCharMatcher(_scriptsData6, scripts.sunuwar);
  factory scriptTodhri() => UnicodeCharMatcher(_scriptsData6, scripts.todhri);
  factory scriptTuluTigalari() =>
      UnicodeCharMatcher(_scriptsData6, scripts.tuluTigalari);
  factory scriptSidetic() => UnicodeCharMatcher(_scriptsData6, scripts.sidetic);
  factory scriptTaiYo() => UnicodeCharMatcher(_scriptsData6, scripts.taiYo);
  factory scriptTolongSiki() =>
      UnicodeCharMatcher(_scriptsData6, scripts.tolongSiki);
  factory scriptBeriaErfe() =>
      UnicodeCharMatcher(_scriptsData6, scripts.beriaErfe);
  factory scriptUnknown() => UnicodeCharMatcher(_scriptsData6, scripts.unknown);

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
