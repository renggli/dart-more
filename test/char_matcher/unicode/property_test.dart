import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('property', () {
    test('whiteSpace', () {
      final string = String.fromCharCodes([
        9, 10, 11, 12, 13, 32, 133, 160, 5760, 8192, 8193, 8194, 8195, 8196,
        8197, 8198, 8199, 8200, 8201, 8202, 8232, 8233, 8239, 8287, 12288, //
      ]);
      verify(UnicodeCharMatcher.whiteSpace(), string, '012abcABC_!@#');
    });
    test('bidiControl', () {
      verify(
        UnicodeCharMatcher.bidiControl(),
        '\u{061C}\u{200F}\u{202E}\u{2066}',
        '012abcABC_!@# ',
      );
    });
    test('joinControl', () {
      verify(
        UnicodeCharMatcher.joinControl(),
        '\u{200C}\u{200D}',
        '012abcABC_!@# ',
      );
    });
    test('dash', () {
      verify(
        UnicodeCharMatcher.dash(),
        '\u{002D}\u{2053}\u{2E3B}\u{FE31}\u{10EAD}',
        '012abcABC_!@# ',
      );
    });
    test('hyphen', () {
      verify(
        UnicodeCharMatcher.hyphen(),
        '\u{002D}\u{058A}\u{2011}\u{30FB}\u{FF65}',
        '012abcABC_!@# ',
      );
    });
    test('quotationMark', () {
      verify(
        UnicodeCharMatcher.quotationMark(),
        '\u{0022}\u{00AB}\u{00BB}\u{301F}\u{FF63}',
        '012abcABC_!@# ',
      );
    });
    test('terminalPunctuation', () {
      verify(
        UnicodeCharMatcher.terminalPunctuation(),
        '!,.:;\u{060C}\u{0700}\u{203C}\u{A6F7}\u{11944}',
        '012abcABC_@# ',
      );
    });
    test('otherMath', () {
      verify(
        UnicodeCharMatcher.otherMath(),
        '\u{005E}\u{2040}\u{2149}\u{1EE52}\u{1EEBB}',
        '012abcABC_!@# ',
      );
    });
    test('hexDigit', () {
      verify(
        UnicodeCharMatcher.hexDigit(),
        '\u{0030}\u{FF10}\u{FF24}\u{FF26}\u{FF41}',
        'xyzXYZ_!@# ',
      );
    });
    test('asciiHexDigit', () {
      verify(
        UnicodeCharMatcher.asciiHexDigit(),
        '0123456789abcdefABCDEF',
        'xyzXYZ_!@# ',
      );
    });
    test('otherAlphabetic', () {
      verify(
        UnicodeCharMatcher.otherAlphabetic(),
        '\u{0345}\u{0730}\u{0981}\u{0BCB}\u{1A55}',
        '012abcABC_!@# ',
      );
    });
    test('ideographic', () {
      verify(
        UnicodeCharMatcher.ideographic(),
        '\u{3006}\u{16FE4}\u{2B820}\u{2B740}\u{323AF}',
        '012abcABC_!@# ',
      );
    });
    test('diacritic', () {
      verify(
        UnicodeCharMatcher.diacritic(),
        '\u{005E}\u{05C4}\u{0C4D}\u{11D45}\u{1E2AE}',
        '012abcABC_!@# ',
      );
    });
    test('extender', () {
      verify(
        UnicodeCharMatcher.extender(),
        '\u{00B7}\u{1843}\u{30FC}\u{10781}\u{16FE3}',
        '012abcABC_!@# ',
      );
    });
    test('otherLowercase', () {
      verify(
        UnicodeCharMatcher.otherLowercase(),
        '\u{00AA}\u{0345}\u{A770}\u{1E06D}',
        '012abcABC_!@# ',
      );
    });
    test('otherUppercase', () {
      verify(
        UnicodeCharMatcher.otherUppercase(),
        '\u{2160}\u{24B6}\u{1F149}\u{1F170}\u{1F189}',
        '012abcABC_!@# ',
      );
    });
    test('noncharacterCodePoint', () {
      verify(
        UnicodeCharMatcher.noncharacterCodePoint(),
        '\u{FDD0}\u{1FFFE}\u{CFFFE}\u{10FFFF}',
        '012abcABC_!@# ',
      );
    });
    test('otherGraphemeExtend', () {
      verify(
        UnicodeCharMatcher.otherGraphemeExtend(),
        '\u{09BE}\u{0CD5}\u{FF9E}\u{1D16E}\u{E0020}',
        '012abcABC_!@# ',
      );
    });
    test('idsBinaryOperator', () {
      verify(
        UnicodeCharMatcher.idsBinaryOperator(),
        '\u{2FF0}\u{2FF1}\u{2FF4}\u{2FFD}\u{31EF}',
        '012abcABC_!@# ',
      );
    });
    test('idsTrinaryOperator', () {
      verify(
        UnicodeCharMatcher.idsTrinaryOperator(),
        '\u{2FF2}\u{2FF3}',
        '012abcABC_!@# ',
      );
    });
    test('idsUnaryOperator', () {
      verify(
        UnicodeCharMatcher.idsUnaryOperator(),
        '\u{2FFE}\u{2FFF}',
        '012abcABC_!@# ',
      );
    });
    test('radical', () {
      verify(
        UnicodeCharMatcher.radical(),
        '\u{2E80}\u{2E99}\u{2E9B}\u{2FD5}',
        '012abcABC_!@# ',
      );
    });
    test('unifiedIdeograph', () {
      verify(
        UnicodeCharMatcher.unifiedIdeograph(),
        '\u{3400}\u{FA21}\u{2EE5D}\u{323AF}',
        '012abcABC_!@# ',
      );
    });
    test('otherDefaultIgnorableCodePoint', () {
      verify(
        UnicodeCharMatcher.otherDefaultIgnorableCodePoint(),
        '\u{034F}\u{FFF7}\u{E0002}\u{E0FFF}',
        '012abcABC_!@# ',
      );
    });
    test('deprecated', () {
      verify(
        UnicodeCharMatcher.deprecated(),
        '\u{0149}\u{0F77}\u{206C}\u{E0001}',
        '012abcABC_!@# ',
      );
    });
    test('softDotted', () {
      verify(
        UnicodeCharMatcher.softDotted(),
        '\u{0069}\u{1D62}\u{1D422}\u{1D65F}',
        '012abcABC_!@# ',
      );
    });
    test('logicalOrderException', () {
      verify(
        UnicodeCharMatcher.logicalOrderException(),
        '\u{19BA}\u{AAB6}\u{AABB}\u{AABC}',
        '012abcABC_!@# ',
      );
    });
    test('otherIdStart', () {
      verify(
        UnicodeCharMatcher.otherIdStart(),
        '\u{1885}\u{1886}\u{2118}\u{309C}',
        '012abcABC_!@# ',
      );
    });
    test('otherIdContinue', () {
      verify(
        UnicodeCharMatcher.otherIdContinue(),
        '\u{00B7}\u{1371}\u{30FB}\u{FF65}',
        '012abcABC_!@# ',
      );
    });
    test('idCompatMathContinue', () {
      verify(
        UnicodeCharMatcher.idCompatMathContinue(),
        '\u{00B2}\u{2080}\u{1D6C1}\u{1D76F}',
        '012abcABC_!@# ',
      );
    });
    test('idCompatMathStart', () {
      verify(
        UnicodeCharMatcher.idCompatMathStart(),
        '\u{2202}\u{1D735}\u{1D76F}\u{1D7C3}',
        '012abcABC_!@# ',
      );
    });
    test('sentenceTerminal', () {
      verify(
        UnicodeCharMatcher.sentenceTerminal(),
        '\u{002E}\u{0700}\u{0964}\u{16E98}',
        '012abcABC_@# ',
      );
    });
    test('variationSelector', () {
      verify(
        UnicodeCharMatcher.variationSelector(),
        '\u{180B}\u{180F}\u{FE0F}\u{E0100}',
        '012abcABC_!@# ',
      );
    });
    test('patternWhiteSpace', () {
      verify(
        UnicodeCharMatcher.patternWhiteSpace(),
        '\u{0020}\u{200E}\u{200F}\u{2029}',
        '012abcABC_!@#',
      );
    });
    test('patternSyntax', () {
      verify(
        UnicodeCharMatcher.patternSyntax(),
        '\u{0029}\u{007B}\u{00A7}\u{FD3F}',
        '012abcABC_ ',
      );
    });
    test('prependedConcatenationMark', () {
      verify(
        UnicodeCharMatcher.prependedConcatenationMark(),
        '\u{0600}\u{0890}\u{110BD}\u{110CD}',
        '012abcABC_!@# ',
      );
    });
    test('regionalIndicator', () {
      verify(
        UnicodeCharMatcher.regionalIndicator(),
        '\u{1F1E6}\u{1F1EE}\u{1F1F2}\u{1F1FF}',
        '012abcABC_!@# ',
      );
    });
  });
}
