// AUTO-GENERATED CODE: DO NOT EDIT

// https://www.unicode.org/Public/18.0.0/ucd/Blocks.txt

import '../basic/range.dart';
import '../char_matcher.dart';

abstract final class UnicodeBlockCharMatcher {
  static const CharMatcher basicLatin = RangeCharMatcher(0x0000, 0x007f);
  static const CharMatcher latin1Supplement = RangeCharMatcher(0x0080, 0x00ff);
  static const CharMatcher latinExtendedA = RangeCharMatcher(0x0100, 0x017f);
  static const CharMatcher latinExtendedB = RangeCharMatcher(0x0180, 0x024f);
  static const CharMatcher ipaExtensions = RangeCharMatcher(0x0250, 0x02af);
  static const CharMatcher spacingModifierLetters = RangeCharMatcher(
    0x02b0,
    0x02ff,
  );
  static const CharMatcher combiningDiacriticalMarks = RangeCharMatcher(
    0x0300,
    0x036f,
  );
  static const CharMatcher greekAndCoptic = RangeCharMatcher(0x0370, 0x03ff);
  static const CharMatcher cyrillic = RangeCharMatcher(0x0400, 0x04ff);
  static const CharMatcher cyrillicSupplement = RangeCharMatcher(
    0x0500,
    0x052f,
  );
  static const CharMatcher armenian = RangeCharMatcher(0x0530, 0x058f);
  static const CharMatcher hebrew = RangeCharMatcher(0x0590, 0x05ff);
  static const CharMatcher arabic = RangeCharMatcher(0x0600, 0x06ff);
  static const CharMatcher syriac = RangeCharMatcher(0x0700, 0x074f);
  static const CharMatcher arabicSupplement = RangeCharMatcher(0x0750, 0x077f);
  static const CharMatcher thaana = RangeCharMatcher(0x0780, 0x07bf);
  static const CharMatcher nko = RangeCharMatcher(0x07c0, 0x07ff);
  static const CharMatcher samaritan = RangeCharMatcher(0x0800, 0x083f);
  static const CharMatcher mandaic = RangeCharMatcher(0x0840, 0x085f);
  static const CharMatcher syriacSupplement = RangeCharMatcher(0x0860, 0x086f);
  static const CharMatcher arabicExtendedB = RangeCharMatcher(0x0870, 0x089f);
  static const CharMatcher arabicExtendedA = RangeCharMatcher(0x08a0, 0x08ff);
  static const CharMatcher devanagari = RangeCharMatcher(0x0900, 0x097f);
  static const CharMatcher bengali = RangeCharMatcher(0x0980, 0x09ff);
  static const CharMatcher gurmukhi = RangeCharMatcher(0x0a00, 0x0a7f);
  static const CharMatcher gujarati = RangeCharMatcher(0x0a80, 0x0aff);
  static const CharMatcher oriya = RangeCharMatcher(0x0b00, 0x0b7f);
  static const CharMatcher tamil = RangeCharMatcher(0x0b80, 0x0bff);
  static const CharMatcher telugu = RangeCharMatcher(0x0c00, 0x0c7f);
  static const CharMatcher kannada = RangeCharMatcher(0x0c80, 0x0cff);
  static const CharMatcher malayalam = RangeCharMatcher(0x0d00, 0x0d7f);
  static const CharMatcher sinhala = RangeCharMatcher(0x0d80, 0x0dff);
  static const CharMatcher thai = RangeCharMatcher(0x0e00, 0x0e7f);
  static const CharMatcher lao = RangeCharMatcher(0x0e80, 0x0eff);
  static const CharMatcher tibetan = RangeCharMatcher(0x0f00, 0x0fff);
  static const CharMatcher myanmar = RangeCharMatcher(0x1000, 0x109f);
  static const CharMatcher georgian = RangeCharMatcher(0x10a0, 0x10ff);
  static const CharMatcher hangulJamo = RangeCharMatcher(0x1100, 0x11ff);
  static const CharMatcher ethiopic = RangeCharMatcher(0x1200, 0x137f);
  static const CharMatcher ethiopicSupplement = RangeCharMatcher(
    0x1380,
    0x139f,
  );
  static const CharMatcher cherokee = RangeCharMatcher(0x13a0, 0x13ff);
  static const CharMatcher unifiedCanadianAboriginalSyllabics =
      RangeCharMatcher(0x1400, 0x167f);
  static const CharMatcher ogham = RangeCharMatcher(0x1680, 0x169f);
  static const CharMatcher runic = RangeCharMatcher(0x16a0, 0x16ff);
  static const CharMatcher tagalog = RangeCharMatcher(0x1700, 0x171f);
  static const CharMatcher hanunoo = RangeCharMatcher(0x1720, 0x173f);
  static const CharMatcher buhid = RangeCharMatcher(0x1740, 0x175f);
  static const CharMatcher tagbanwa = RangeCharMatcher(0x1760, 0x177f);
  static const CharMatcher khmer = RangeCharMatcher(0x1780, 0x17ff);
  static const CharMatcher mongolian = RangeCharMatcher(0x1800, 0x18af);
  static const CharMatcher unifiedCanadianAboriginalSyllabicsExtended =
      RangeCharMatcher(0x18b0, 0x18ff);
  static const CharMatcher limbu = RangeCharMatcher(0x1900, 0x194f);
  static const CharMatcher taiLe = RangeCharMatcher(0x1950, 0x197f);
  static const CharMatcher newTaiLue = RangeCharMatcher(0x1980, 0x19df);
  static const CharMatcher khmerSymbols = RangeCharMatcher(0x19e0, 0x19ff);
  static const CharMatcher buginese = RangeCharMatcher(0x1a00, 0x1a1f);
  static const CharMatcher taiTham = RangeCharMatcher(0x1a20, 0x1aaf);
  static const CharMatcher combiningDiacriticalMarksExtended = RangeCharMatcher(
    0x1ab0,
    0x1aff,
  );
  static const CharMatcher balinese = RangeCharMatcher(0x1b00, 0x1b7f);
  static const CharMatcher sundanese = RangeCharMatcher(0x1b80, 0x1bbf);
  static const CharMatcher batak = RangeCharMatcher(0x1bc0, 0x1bff);
  static const CharMatcher lepcha = RangeCharMatcher(0x1c00, 0x1c4f);
  static const CharMatcher olChiki = RangeCharMatcher(0x1c50, 0x1c7f);
  static const CharMatcher cyrillicExtendedC = RangeCharMatcher(0x1c80, 0x1c8f);
  static const CharMatcher georgianExtended = RangeCharMatcher(0x1c90, 0x1cbf);
  static const CharMatcher sundaneseSupplement = RangeCharMatcher(
    0x1cc0,
    0x1ccf,
  );
  static const CharMatcher vedicExtensions = RangeCharMatcher(0x1cd0, 0x1cff);
  static const CharMatcher phoneticExtensions = RangeCharMatcher(
    0x1d00,
    0x1d7f,
  );
  static const CharMatcher phoneticExtensionsSupplement = RangeCharMatcher(
    0x1d80,
    0x1dbf,
  );
  static const CharMatcher combiningDiacriticalMarksSupplement =
      RangeCharMatcher(0x1dc0, 0x1dff);
  static const CharMatcher latinExtendedAdditional = RangeCharMatcher(
    0x1e00,
    0x1eff,
  );
  static const CharMatcher greekExtended = RangeCharMatcher(0x1f00, 0x1fff);
  static const CharMatcher generalPunctuation = RangeCharMatcher(
    0x2000,
    0x206f,
  );
  static const CharMatcher superscriptsAndSubscripts = RangeCharMatcher(
    0x2070,
    0x209f,
  );
  static const CharMatcher currencySymbols = RangeCharMatcher(0x20a0, 0x20cf);
  static const CharMatcher combiningDiacriticalMarksForSymbols =
      RangeCharMatcher(0x20d0, 0x20ff);
  static const CharMatcher letterlikeSymbols = RangeCharMatcher(0x2100, 0x214f);
  static const CharMatcher numberForms = RangeCharMatcher(0x2150, 0x218f);
  static const CharMatcher arrows = RangeCharMatcher(0x2190, 0x21ff);
  static const CharMatcher mathematicalOperators = RangeCharMatcher(
    0x2200,
    0x22ff,
  );
  static const CharMatcher miscellaneousTechnical = RangeCharMatcher(
    0x2300,
    0x23ff,
  );
  static const CharMatcher controlPictures = RangeCharMatcher(0x2400, 0x243f);
  static const CharMatcher opticalCharacterRecognition = RangeCharMatcher(
    0x2440,
    0x245f,
  );
  static const CharMatcher enclosedAlphanumerics = RangeCharMatcher(
    0x2460,
    0x24ff,
  );
  static const CharMatcher boxDrawing = RangeCharMatcher(0x2500, 0x257f);
  static const CharMatcher blockElements = RangeCharMatcher(0x2580, 0x259f);
  static const CharMatcher geometricShapes = RangeCharMatcher(0x25a0, 0x25ff);
  static const CharMatcher miscellaneousSymbols = RangeCharMatcher(
    0x2600,
    0x26ff,
  );
  static const CharMatcher dingbats = RangeCharMatcher(0x2700, 0x27bf);
  static const CharMatcher miscellaneousMathematicalSymbolsA = RangeCharMatcher(
    0x27c0,
    0x27ef,
  );
  static const CharMatcher supplementalArrowsA = RangeCharMatcher(
    0x27f0,
    0x27ff,
  );
  static const CharMatcher braillePatterns = RangeCharMatcher(0x2800, 0x28ff);
  static const CharMatcher supplementalArrowsB = RangeCharMatcher(
    0x2900,
    0x297f,
  );
  static const CharMatcher miscellaneousMathematicalSymbolsB = RangeCharMatcher(
    0x2980,
    0x29ff,
  );
  static const CharMatcher supplementalMathematicalOperators = RangeCharMatcher(
    0x2a00,
    0x2aff,
  );
  static const CharMatcher miscellaneousSymbolsAndArrows = RangeCharMatcher(
    0x2b00,
    0x2bff,
  );
  static const CharMatcher glagolitic = RangeCharMatcher(0x2c00, 0x2c5f);
  static const CharMatcher latinExtendedC = RangeCharMatcher(0x2c60, 0x2c7f);
  static const CharMatcher coptic = RangeCharMatcher(0x2c80, 0x2cff);
  static const CharMatcher georgianSupplement = RangeCharMatcher(
    0x2d00,
    0x2d2f,
  );
  static const CharMatcher tifinagh = RangeCharMatcher(0x2d30, 0x2d7f);
  static const CharMatcher ethiopicExtended = RangeCharMatcher(0x2d80, 0x2ddf);
  static const CharMatcher cyrillicExtendedA = RangeCharMatcher(0x2de0, 0x2dff);
  static const CharMatcher supplementalPunctuation = RangeCharMatcher(
    0x2e00,
    0x2e7f,
  );
  static const CharMatcher cjkRadicalsSupplement = RangeCharMatcher(
    0x2e80,
    0x2eff,
  );
  static const CharMatcher kangxiRadicals = RangeCharMatcher(0x2f00, 0x2fdf);
  static const CharMatcher ideographicDescriptionCharacters = RangeCharMatcher(
    0x2ff0,
    0x2fff,
  );
  static const CharMatcher cjkSymbolsAndPunctuation = RangeCharMatcher(
    0x3000,
    0x303f,
  );
  static const CharMatcher hiragana = RangeCharMatcher(0x3040, 0x309f);
  static const CharMatcher katakana = RangeCharMatcher(0x30a0, 0x30ff);
  static const CharMatcher bopomofo = RangeCharMatcher(0x3100, 0x312f);
  static const CharMatcher hangulCompatibilityJamo = RangeCharMatcher(
    0x3130,
    0x318f,
  );
  static const CharMatcher kanbun = RangeCharMatcher(0x3190, 0x319f);
  static const CharMatcher bopomofoExtended = RangeCharMatcher(0x31a0, 0x31bf);
  static const CharMatcher cjkStrokes = RangeCharMatcher(0x31c0, 0x31ef);
  static const CharMatcher katakanaPhoneticExtensions = RangeCharMatcher(
    0x31f0,
    0x31ff,
  );
  static const CharMatcher enclosedCjkLettersAndMonths = RangeCharMatcher(
    0x3200,
    0x32ff,
  );
  static const CharMatcher cjkCompatibility = RangeCharMatcher(0x3300, 0x33ff);
  static const CharMatcher cjkUnifiedIdeographsExtensionA = RangeCharMatcher(
    0x3400,
    0x4dbf,
  );
  static const CharMatcher yijingHexagramSymbols = RangeCharMatcher(
    0x4dc0,
    0x4dff,
  );
  static const CharMatcher cjkUnifiedIdeographs = RangeCharMatcher(
    0x4e00,
    0x9fff,
  );
  static const CharMatcher yiSyllables = RangeCharMatcher(0xa000, 0xa48f);
  static const CharMatcher yiRadicals = RangeCharMatcher(0xa490, 0xa4cf);
  static const CharMatcher lisu = RangeCharMatcher(0xa4d0, 0xa4ff);
  static const CharMatcher vai = RangeCharMatcher(0xa500, 0xa63f);
  static const CharMatcher cyrillicExtendedB = RangeCharMatcher(0xa640, 0xa69f);
  static const CharMatcher bamum = RangeCharMatcher(0xa6a0, 0xa6ff);
  static const CharMatcher modifierToneLetters = RangeCharMatcher(
    0xa700,
    0xa71f,
  );
  static const CharMatcher latinExtendedD = RangeCharMatcher(0xa720, 0xa7ff);
  static const CharMatcher sylotiNagri = RangeCharMatcher(0xa800, 0xa82f);
  static const CharMatcher commonIndicNumberForms = RangeCharMatcher(
    0xa830,
    0xa83f,
  );
  static const CharMatcher phagsPa = RangeCharMatcher(0xa840, 0xa87f);
  static const CharMatcher saurashtra = RangeCharMatcher(0xa880, 0xa8df);
  static const CharMatcher devanagariExtended = RangeCharMatcher(
    0xa8e0,
    0xa8ff,
  );
  static const CharMatcher kayahLi = RangeCharMatcher(0xa900, 0xa92f);
  static const CharMatcher rejang = RangeCharMatcher(0xa930, 0xa95f);
  static const CharMatcher hangulJamoExtendedA = RangeCharMatcher(
    0xa960,
    0xa97f,
  );
  static const CharMatcher javanese = RangeCharMatcher(0xa980, 0xa9df);
  static const CharMatcher myanmarExtendedB = RangeCharMatcher(0xa9e0, 0xa9ff);
  static const CharMatcher cham = RangeCharMatcher(0xaa00, 0xaa5f);
  static const CharMatcher myanmarExtendedA = RangeCharMatcher(0xaa60, 0xaa7f);
  static const CharMatcher taiViet = RangeCharMatcher(0xaa80, 0xaadf);
  static const CharMatcher meeteiMayekExtensions = RangeCharMatcher(
    0xaae0,
    0xaaff,
  );
  static const CharMatcher ethiopicExtendedA = RangeCharMatcher(0xab00, 0xab2f);
  static const CharMatcher latinExtendedE = RangeCharMatcher(0xab30, 0xab6f);
  static const CharMatcher cherokeeSupplement = RangeCharMatcher(
    0xab70,
    0xabbf,
  );
  static const CharMatcher meeteiMayek = RangeCharMatcher(0xabc0, 0xabff);
  static const CharMatcher hangulSyllables = RangeCharMatcher(0xac00, 0xd7af);
  static const CharMatcher hangulJamoExtendedB = RangeCharMatcher(
    0xd7b0,
    0xd7ff,
  );
  static const CharMatcher highSurrogates = RangeCharMatcher(0xd800, 0xdb7f);
  static const CharMatcher highPrivateUseSurrogates = RangeCharMatcher(
    0xdb80,
    0xdbff,
  );
  static const CharMatcher lowSurrogates = RangeCharMatcher(0xdc00, 0xdfff);
  static const CharMatcher privateUseArea = RangeCharMatcher(0xe000, 0xf8ff);
  static const CharMatcher cjkCompatibilityIdeographs = RangeCharMatcher(
    0xf900,
    0xfaff,
  );
  static const CharMatcher alphabeticPresentationForms = RangeCharMatcher(
    0xfb00,
    0xfb4f,
  );
  static const CharMatcher arabicPresentationFormsA = RangeCharMatcher(
    0xfb50,
    0xfdff,
  );
  static const CharMatcher variationSelectors = RangeCharMatcher(
    0xfe00,
    0xfe0f,
  );
  static const CharMatcher verticalForms = RangeCharMatcher(0xfe10, 0xfe1f);
  static const CharMatcher combiningHalfMarks = RangeCharMatcher(
    0xfe20,
    0xfe2f,
  );
  static const CharMatcher cjkCompatibilityForms = RangeCharMatcher(
    0xfe30,
    0xfe4f,
  );
  static const CharMatcher smallFormVariants = RangeCharMatcher(0xfe50, 0xfe6f);
  static const CharMatcher arabicPresentationFormsB = RangeCharMatcher(
    0xfe70,
    0xfeff,
  );
  static const CharMatcher halfwidthAndFullwidthForms = RangeCharMatcher(
    0xff00,
    0xffef,
  );
  static const CharMatcher specials = RangeCharMatcher(0xfff0, 0xffff);
  static const CharMatcher linearBSyllabary = RangeCharMatcher(
    0x10000,
    0x1007f,
  );
  static const CharMatcher linearBIdeograms = RangeCharMatcher(
    0x10080,
    0x100ff,
  );
  static const CharMatcher aegeanNumbers = RangeCharMatcher(0x10100, 0x1013f);
  static const CharMatcher ancientGreekNumbers = RangeCharMatcher(
    0x10140,
    0x1018f,
  );
  static const CharMatcher ancientSymbols = RangeCharMatcher(0x10190, 0x101cf);
  static const CharMatcher phaistosDisc = RangeCharMatcher(0x101d0, 0x101ff);
  static const CharMatcher lycian = RangeCharMatcher(0x10280, 0x1029f);
  static const CharMatcher carian = RangeCharMatcher(0x102a0, 0x102df);
  static const CharMatcher copticEpactNumbers = RangeCharMatcher(
    0x102e0,
    0x102ff,
  );
  static const CharMatcher oldItalic = RangeCharMatcher(0x10300, 0x1032f);
  static const CharMatcher gothic = RangeCharMatcher(0x10330, 0x1034f);
  static const CharMatcher oldPermic = RangeCharMatcher(0x10350, 0x1037f);
  static const CharMatcher ugaritic = RangeCharMatcher(0x10380, 0x1039f);
  static const CharMatcher oldPersian = RangeCharMatcher(0x103a0, 0x103df);
  static const CharMatcher deseret = RangeCharMatcher(0x10400, 0x1044f);
  static const CharMatcher shavian = RangeCharMatcher(0x10450, 0x1047f);
  static const CharMatcher osmanya = RangeCharMatcher(0x10480, 0x104af);
  static const CharMatcher osage = RangeCharMatcher(0x104b0, 0x104ff);
  static const CharMatcher elbasan = RangeCharMatcher(0x10500, 0x1052f);
  static const CharMatcher caucasianAlbanian = RangeCharMatcher(
    0x10530,
    0x1056f,
  );
  static const CharMatcher vithkuqi = RangeCharMatcher(0x10570, 0x105bf);
  static const CharMatcher todhri = RangeCharMatcher(0x105c0, 0x105ff);
  static const CharMatcher linearA = RangeCharMatcher(0x10600, 0x1077f);
  static const CharMatcher latinExtendedF = RangeCharMatcher(0x10780, 0x107bf);
  static const CharMatcher cypriotSyllabary = RangeCharMatcher(
    0x10800,
    0x1083f,
  );
  static const CharMatcher imperialAramaic = RangeCharMatcher(0x10840, 0x1085f);
  static const CharMatcher palmyrene = RangeCharMatcher(0x10860, 0x1087f);
  static const CharMatcher nabataean = RangeCharMatcher(0x10880, 0x108af);
  static const CharMatcher hatran = RangeCharMatcher(0x108e0, 0x108ff);
  static const CharMatcher phoenician = RangeCharMatcher(0x10900, 0x1091f);
  static const CharMatcher lydian = RangeCharMatcher(0x10920, 0x1093f);
  static const CharMatcher sidetic = RangeCharMatcher(0x10940, 0x1095f);
  static const CharMatcher meroiticHieroglyphs = RangeCharMatcher(
    0x10980,
    0x1099f,
  );
  static const CharMatcher meroiticCursive = RangeCharMatcher(0x109a0, 0x109ff);
  static const CharMatcher kharoshthi = RangeCharMatcher(0x10a00, 0x10a5f);
  static const CharMatcher oldSouthArabian = RangeCharMatcher(0x10a60, 0x10a7f);
  static const CharMatcher oldNorthArabian = RangeCharMatcher(0x10a80, 0x10a9f);
  static const CharMatcher manichaean = RangeCharMatcher(0x10ac0, 0x10aff);
  static const CharMatcher avestan = RangeCharMatcher(0x10b00, 0x10b3f);
  static const CharMatcher inscriptionalParthian = RangeCharMatcher(
    0x10b40,
    0x10b5f,
  );
  static const CharMatcher inscriptionalPahlavi = RangeCharMatcher(
    0x10b60,
    0x10b7f,
  );
  static const CharMatcher psalterPahlavi = RangeCharMatcher(0x10b80, 0x10baf);
  static const CharMatcher oldTurkic = RangeCharMatcher(0x10c00, 0x10c4f);
  static const CharMatcher oldHungarian = RangeCharMatcher(0x10c80, 0x10cff);
  static const CharMatcher hanifiRohingya = RangeCharMatcher(0x10d00, 0x10d3f);
  static const CharMatcher garay = RangeCharMatcher(0x10d40, 0x10d8f);
  static const CharMatcher rumiNumeralSymbols = RangeCharMatcher(
    0x10e60,
    0x10e7f,
  );
  static const CharMatcher yezidi = RangeCharMatcher(0x10e80, 0x10ebf);
  static const CharMatcher arabicExtendedC = RangeCharMatcher(0x10ec0, 0x10eff);
  static const CharMatcher oldSogdian = RangeCharMatcher(0x10f00, 0x10f2f);
  static const CharMatcher sogdian = RangeCharMatcher(0x10f30, 0x10f6f);
  static const CharMatcher oldUyghur = RangeCharMatcher(0x10f70, 0x10faf);
  static const CharMatcher chorasmian = RangeCharMatcher(0x10fb0, 0x10fdf);
  static const CharMatcher elymaic = RangeCharMatcher(0x10fe0, 0x10fff);
  static const CharMatcher brahmi = RangeCharMatcher(0x11000, 0x1107f);
  static const CharMatcher kaithi = RangeCharMatcher(0x11080, 0x110cf);
  static const CharMatcher soraSompeng = RangeCharMatcher(0x110d0, 0x110ff);
  static const CharMatcher chakma = RangeCharMatcher(0x11100, 0x1114f);
  static const CharMatcher mahajani = RangeCharMatcher(0x11150, 0x1117f);
  static const CharMatcher sharada = RangeCharMatcher(0x11180, 0x111df);
  static const CharMatcher sinhalaArchaicNumbers = RangeCharMatcher(
    0x111e0,
    0x111ff,
  );
  static const CharMatcher khojki = RangeCharMatcher(0x11200, 0x1124f);
  static const CharMatcher multani = RangeCharMatcher(0x11280, 0x112af);
  static const CharMatcher khudawadi = RangeCharMatcher(0x112b0, 0x112ff);
  static const CharMatcher grantha = RangeCharMatcher(0x11300, 0x1137f);
  static const CharMatcher tuluTigalari = RangeCharMatcher(0x11380, 0x113ff);
  static const CharMatcher newa = RangeCharMatcher(0x11400, 0x1147f);
  static const CharMatcher tirhuta = RangeCharMatcher(0x11480, 0x114df);
  static const CharMatcher siddham = RangeCharMatcher(0x11580, 0x115ff);
  static const CharMatcher modi = RangeCharMatcher(0x11600, 0x1165f);
  static const CharMatcher mongolianSupplement = RangeCharMatcher(
    0x11660,
    0x1167f,
  );
  static const CharMatcher takri = RangeCharMatcher(0x11680, 0x116cf);
  static const CharMatcher myanmarExtendedC = RangeCharMatcher(
    0x116d0,
    0x116ff,
  );
  static const CharMatcher ahom = RangeCharMatcher(0x11700, 0x1174f);
  static const CharMatcher dogra = RangeCharMatcher(0x11800, 0x1184f);
  static const CharMatcher warangCiti = RangeCharMatcher(0x118a0, 0x118ff);
  static const CharMatcher divesAkuru = RangeCharMatcher(0x11900, 0x1195f);
  static const CharMatcher nandinagari = RangeCharMatcher(0x119a0, 0x119ff);
  static const CharMatcher zanabazarSquare = RangeCharMatcher(0x11a00, 0x11a4f);
  static const CharMatcher soyombo = RangeCharMatcher(0x11a50, 0x11aaf);
  static const CharMatcher unifiedCanadianAboriginalSyllabicsExtendedA =
      RangeCharMatcher(0x11ab0, 0x11abf);
  static const CharMatcher pauCinHau = RangeCharMatcher(0x11ac0, 0x11aff);
  static const CharMatcher devanagariExtendedA = RangeCharMatcher(
    0x11b00,
    0x11b5f,
  );
  static const CharMatcher sharadaSupplement = RangeCharMatcher(
    0x11b60,
    0x11b7f,
  );
  static const CharMatcher sunuwar = RangeCharMatcher(0x11bc0, 0x11bff);
  static const CharMatcher bhaiksuki = RangeCharMatcher(0x11c00, 0x11c6f);
  static const CharMatcher marchen = RangeCharMatcher(0x11c70, 0x11cbf);
  static const CharMatcher masaramGondi = RangeCharMatcher(0x11d00, 0x11d5f);
  static const CharMatcher gunjalaGondi = RangeCharMatcher(0x11d60, 0x11daf);
  static const CharMatcher tolongSiki = RangeCharMatcher(0x11db0, 0x11def);
  static const CharMatcher bengaliSupplement = RangeCharMatcher(
    0x11df0,
    0x11dff,
  );
  static const CharMatcher makasar = RangeCharMatcher(0x11ee0, 0x11eff);
  static const CharMatcher kawi = RangeCharMatcher(0x11f00, 0x11f5f);
  static const CharMatcher lisuSupplement = RangeCharMatcher(0x11fb0, 0x11fbf);
  static const CharMatcher tamilSupplement = RangeCharMatcher(0x11fc0, 0x11fff);
  static const CharMatcher cuneiform = RangeCharMatcher(0x12000, 0x123ff);
  static const CharMatcher cuneiformNumbersAndPunctuation = RangeCharMatcher(
    0x12400,
    0x1247f,
  );
  static const CharMatcher earlyDynasticCuneiform = RangeCharMatcher(
    0x12480,
    0x1254f,
  );
  static const CharMatcher archaicCuneiformNumerals = RangeCharMatcher(
    0x12550,
    0x1268f,
  );
  static const CharMatcher cyproMinoan = RangeCharMatcher(0x12f90, 0x12fff);
  static const CharMatcher egyptianHieroglyphs = RangeCharMatcher(
    0x13000,
    0x1342f,
  );
  static const CharMatcher egyptianHieroglyphFormatControls = RangeCharMatcher(
    0x13430,
    0x1345f,
  );
  static const CharMatcher egyptianHieroglyphsExtendedA = RangeCharMatcher(
    0x13460,
    0x143ff,
  );
  static const CharMatcher anatolianHieroglyphs = RangeCharMatcher(
    0x14400,
    0x1467f,
  );
  static const CharMatcher gurungKhema = RangeCharMatcher(0x16100, 0x1613f);
  static const CharMatcher bamumSupplement = RangeCharMatcher(0x16800, 0x16a3f);
  static const CharMatcher mro = RangeCharMatcher(0x16a40, 0x16a6f);
  static const CharMatcher tangsa = RangeCharMatcher(0x16a70, 0x16acf);
  static const CharMatcher bassaVah = RangeCharMatcher(0x16ad0, 0x16aff);
  static const CharMatcher pahawhHmong = RangeCharMatcher(0x16b00, 0x16b8f);
  static const CharMatcher kiratRai = RangeCharMatcher(0x16d40, 0x16d7f);
  static const CharMatcher medefaidrin = RangeCharMatcher(0x16e40, 0x16e9f);
  static const CharMatcher beriaErfe = RangeCharMatcher(0x16ea0, 0x16edf);
  static const CharMatcher miao = RangeCharMatcher(0x16f00, 0x16f9f);
  static const CharMatcher ideographicSymbolsAndPunctuation = RangeCharMatcher(
    0x16fe0,
    0x16fff,
  );
  static const CharMatcher tangut = RangeCharMatcher(0x17000, 0x187ff);
  static const CharMatcher tangutComponents = RangeCharMatcher(
    0x18800,
    0x18aff,
  );
  static const CharMatcher khitanSmallScript = RangeCharMatcher(
    0x18b00,
    0x18cff,
  );
  static const CharMatcher tangutSupplement = RangeCharMatcher(
    0x18d00,
    0x18d7f,
  );
  static const CharMatcher tangutComponentsSupplement = RangeCharMatcher(
    0x18d80,
    0x18dff,
  );
  static const CharMatcher jurchen = RangeCharMatcher(0x18e00, 0x1919f);
  static const CharMatcher jurchenRadicals = RangeCharMatcher(0x191a0, 0x191df);
  static const CharMatcher kanaExtendedB = RangeCharMatcher(0x1aff0, 0x1afff);
  static const CharMatcher kanaSupplement = RangeCharMatcher(0x1b000, 0x1b0ff);
  static const CharMatcher kanaExtendedA = RangeCharMatcher(0x1b100, 0x1b12f);
  static const CharMatcher smallKanaExtension = RangeCharMatcher(
    0x1b130,
    0x1b16f,
  );
  static const CharMatcher nushu = RangeCharMatcher(0x1b170, 0x1b2ff);
  static const CharMatcher duployan = RangeCharMatcher(0x1bc00, 0x1bc9f);
  static const CharMatcher shorthandFormatControls = RangeCharMatcher(
    0x1bca0,
    0x1bcaf,
  );
  static const CharMatcher symbolsForLegacyComputingSupplement =
      RangeCharMatcher(0x1cc00, 0x1cebf);
  static const CharMatcher miscellaneousSymbolsSupplement = RangeCharMatcher(
    0x1cec0,
    0x1ceff,
  );
  static const CharMatcher znamennyMusicalNotation = RangeCharMatcher(
    0x1cf00,
    0x1cfcf,
  );
  static const CharMatcher byzantineMusicalSymbols = RangeCharMatcher(
    0x1d000,
    0x1d0ff,
  );
  static const CharMatcher musicalSymbols = RangeCharMatcher(0x1d100, 0x1d1ff);
  static const CharMatcher ancientGreekMusicalNotation = RangeCharMatcher(
    0x1d200,
    0x1d24f,
  );
  static const CharMatcher musicalSymbolsSupplement = RangeCharMatcher(
    0x1d250,
    0x1d28f,
  );
  static const CharMatcher kaktovikNumerals = RangeCharMatcher(
    0x1d2c0,
    0x1d2df,
  );
  static const CharMatcher mayanNumerals = RangeCharMatcher(0x1d2e0, 0x1d2ff);
  static const CharMatcher taiXuanJingSymbols = RangeCharMatcher(
    0x1d300,
    0x1d35f,
  );
  static const CharMatcher countingRodNumerals = RangeCharMatcher(
    0x1d360,
    0x1d37f,
  );
  static const CharMatcher mathematicalAlphanumericSymbols = RangeCharMatcher(
    0x1d400,
    0x1d7ff,
  );
  static const CharMatcher suttonSignwriting = RangeCharMatcher(
    0x1d800,
    0x1daaf,
  );
  static const CharMatcher miscellaneousSymbolsAndArrowsExtended =
      RangeCharMatcher(0x1db00, 0x1dbff);
  static const CharMatcher latinExtendedG = RangeCharMatcher(0x1df00, 0x1dfff);
  static const CharMatcher glagoliticSupplement = RangeCharMatcher(
    0x1e000,
    0x1e02f,
  );
  static const CharMatcher cyrillicExtendedD = RangeCharMatcher(
    0x1e030,
    0x1e08f,
  );
  static const CharMatcher nyiakengPuachueHmong = RangeCharMatcher(
    0x1e100,
    0x1e14f,
  );
  static const CharMatcher toto = RangeCharMatcher(0x1e290, 0x1e2bf);
  static const CharMatcher wancho = RangeCharMatcher(0x1e2c0, 0x1e2ff);
  static const CharMatcher nagMundari = RangeCharMatcher(0x1e4d0, 0x1e4ff);
  static const CharMatcher olOnal = RangeCharMatcher(0x1e5d0, 0x1e5ff);
  static const CharMatcher taiYo = RangeCharMatcher(0x1e6c0, 0x1e6ff);
  static const CharMatcher ethiopicExtendedB = RangeCharMatcher(
    0x1e7e0,
    0x1e7ff,
  );
  static const CharMatcher mendeKikakui = RangeCharMatcher(0x1e800, 0x1e8df);
  static const CharMatcher adlam = RangeCharMatcher(0x1e900, 0x1e95f);
  static const CharMatcher indicSiyaqNumbers = RangeCharMatcher(
    0x1ec70,
    0x1ecbf,
  );
  static const CharMatcher ottomanSiyaqNumbers = RangeCharMatcher(
    0x1ed00,
    0x1ed4f,
  );
  static const CharMatcher arabicMathematicalAlphabeticSymbols =
      RangeCharMatcher(0x1ee00, 0x1eeff);
  static const CharMatcher mahjongTiles = RangeCharMatcher(0x1f000, 0x1f02f);
  static const CharMatcher dominoTiles = RangeCharMatcher(0x1f030, 0x1f09f);
  static const CharMatcher playingCards = RangeCharMatcher(0x1f0a0, 0x1f0ff);
  static const CharMatcher enclosedAlphanumericSupplement = RangeCharMatcher(
    0x1f100,
    0x1f1ff,
  );
  static const CharMatcher enclosedIdeographicSupplement = RangeCharMatcher(
    0x1f200,
    0x1f2ff,
  );
  static const CharMatcher miscellaneousSymbolsAndPictographs =
      RangeCharMatcher(0x1f300, 0x1f5ff);
  static const CharMatcher emoticons = RangeCharMatcher(0x1f600, 0x1f64f);
  static const CharMatcher ornamentalDingbats = RangeCharMatcher(
    0x1f650,
    0x1f67f,
  );
  static const CharMatcher transportAndMapSymbols = RangeCharMatcher(
    0x1f680,
    0x1f6ff,
  );
  static const CharMatcher alchemicalSymbols = RangeCharMatcher(
    0x1f700,
    0x1f77f,
  );
  static const CharMatcher geometricShapesExtended = RangeCharMatcher(
    0x1f780,
    0x1f7ff,
  );
  static const CharMatcher supplementalArrowsC = RangeCharMatcher(
    0x1f800,
    0x1f8ff,
  );
  static const CharMatcher supplementalSymbolsAndPictographs = RangeCharMatcher(
    0x1f900,
    0x1f9ff,
  );
  static const CharMatcher chessSymbols = RangeCharMatcher(0x1fa00, 0x1fa6f);
  static const CharMatcher symbolsAndPictographsExtendedA = RangeCharMatcher(
    0x1fa70,
    0x1faff,
  );
  static const CharMatcher symbolsForLegacyComputing = RangeCharMatcher(
    0x1fb00,
    0x1fbff,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionB = RangeCharMatcher(
    0x20000,
    0x2a6df,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionC = RangeCharMatcher(
    0x2a700,
    0x2b73f,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionD = RangeCharMatcher(
    0x2b740,
    0x2b81f,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionE = RangeCharMatcher(
    0x2b820,
    0x2ceaf,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionF = RangeCharMatcher(
    0x2ceb0,
    0x2ebef,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionI = RangeCharMatcher(
    0x2ebf0,
    0x2ee5f,
  );
  static const CharMatcher cjkCompatibilityIdeographsSupplement =
      RangeCharMatcher(0x2f800, 0x2fa1f);
  static const CharMatcher cjkUnifiedIdeographsExtensionG = RangeCharMatcher(
    0x30000,
    0x3134f,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionH = RangeCharMatcher(
    0x31350,
    0x323af,
  );
  static const CharMatcher cjkUnifiedIdeographsExtensionJ = RangeCharMatcher(
    0x323b0,
    0x3347f,
  );
  static const CharMatcher seal = RangeCharMatcher(0x3d000, 0x3fc3f);
  static const CharMatcher tags = RangeCharMatcher(0xe0000, 0xe007f);
  static const CharMatcher variationSelectorsSupplement = RangeCharMatcher(
    0xe0100,
    0xe01ef,
  );
  static const CharMatcher supplementaryPrivateUseAreaA = RangeCharMatcher(
    0xf0000,
    0xfffff,
  );
  static const CharMatcher supplementaryPrivateUseAreaB = RangeCharMatcher(
    0x100000,
    0x10ffff,
  );
}
