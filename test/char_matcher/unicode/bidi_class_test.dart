import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('bidi_class', () {
    group('class', () {
      test('leftToRight', () {
        verify(
          UnicodeCharMatcher.bidiLeftToRight(),
          'ABCabcあ亜ㄅ아',
          '012@#!, אבגابج',
        );
      });
      test('rightToLeft', () {
        verify(
          UnicodeCharMatcher.bidiRightToLeft(),
          'אבג',
          'ABCabcあ亜ㄅ아012@#!, ابج',
        );
      });
      test('rightToLeftArabic', () {
        verify(
          UnicodeCharMatcher.bidiRightToLeftArabic(),
          'ابج',
          'ABCabcあ亜ㄅ아012@#!, אבג',
        );
      });
      test('europeanNumber', () {
        verify(
          UnicodeCharMatcher.bidiEuropeanNumber(),
          '0123456789',
          'ABCabcあ亜ㄅ아@#!, אבגابج',
        );
      });
      test('europeanNumberSeparator', () {
        verify(
          UnicodeCharMatcher.bidiEuropeanNumberSeparator(),
          '+-',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('europeanNumberTerminator', () {
        verify(
          UnicodeCharMatcher.bidiEuropeanNumberTerminator(),
          r'°$€#',
          'ABCabcあ亜ㄅ아012@!, אבגابج',
        );
      });
      test('arabicNumber', () {
        verify(
          UnicodeCharMatcher.bidiArabicNumber(),
          '٠١٢٣٤٥٦٧٨٩',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('commonNumberSeparator', () {
        verify(
          UnicodeCharMatcher.bidiCommonNumberSeparator(),
          ':,.\u00a0',
          'ABCabcあ亜ㄅ아012@#! אבגابج',
        );
      });
      test('nonspacingMark', () {
        verify(
          UnicodeCharMatcher.bidiNonspacingMark(),
          '\u0300\u0483\u0591\u0610\u0900\u0eb1\u1ab0\ufe00',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('boundaryNeutral', () {
        verify(
          UnicodeCharMatcher.bidiBoundaryNeutral(),
          '\u0000\u00ad\u180e\u200b\u{e0030}',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('paragraphSeparator', () {
        verify(
          UnicodeCharMatcher.bidiParagraphSeparator(),
          '\u2029',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('segmentSeparator', () {
        verify(
          UnicodeCharMatcher.bidiSegmentSeparator(),
          '\t\u0009\u000b\u001f',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('whitespace', () {
        verify(
          UnicodeCharMatcher.bidiWhitespace(),
          '\u000c \u1680\u2000\u3000',
          'ABCabcあ亜ㄅ아012@#!,אבגابج',
        );
      });
      test('otherNeutrals', () {
        verify(
          UnicodeCharMatcher.bidiOtherNeutrals(),
          '''!"&'()*;<=>?@[\\]￼''',
          'ABCabcあ亜ㄅ아012#, אבגابج',
        );
      });
      test('leftToRightEmbedding', () {
        verify(
          UnicodeCharMatcher.bidiLeftToRightEmbedding(),
          '\u202a',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('leftToRightOverride', () {
        verify(
          UnicodeCharMatcher.bidiLeftToRightOverride(),
          '\u202d',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('rightToLeftEmbedding', () {
        verify(
          UnicodeCharMatcher.bidiRightToLeftEmbedding(),
          '\u202b',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('rightToLeftOverride', () {
        verify(
          UnicodeCharMatcher.bidiRightToLeftOverride(),
          '\u202e',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('popDirectionalFormat', () {
        verify(
          UnicodeCharMatcher.bidiPopDirectionalFormat(),
          '\u202c',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('leftToRightIsolate', () {
        verify(
          UnicodeCharMatcher.bidiLeftToRightIsolate(),
          '\u2066',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('rightToLeftIsolate', () {
        verify(
          UnicodeCharMatcher.bidiRightToLeftIsolate(),
          '\u2067',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('firstStrongIsolate', () {
        verify(
          UnicodeCharMatcher.bidiFirstStrongIsolate(),
          '\u2068',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
      test('popDirectionalIsolate', () {
        verify(
          UnicodeCharMatcher.bidiPopDirectionalIsolate(),
          '\u2069',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
    });
    group('category', () {
      test('strong', () {
        verify(UnicodeCharMatcher.bidiStrong(), 'ABCabcあ亜ㄅ아אבגابج', '012@#!, ');
      });
      test('weak', () {
        verify(UnicodeCharMatcher.bidiWeak(), '012#,', 'ABCabcあ亜ㄅ아@! אבגابج');
      });
      test('neutral', () {
        verify(
          UnicodeCharMatcher.bidiNeutral(),
          '\u2029\t ￼',
          'ABCabcあ亜ㄅ아012#,אבגابج',
        );
      });
      test('explicitFormatting', () {
        verify(
          UnicodeCharMatcher.bidiExplicitFormatting(),
          '\u202a\u202b\u202c\u202d\u202e\u2066\u2067\u2068\u2069',
          'ABCabcあ亜ㄅ아012@#!, אבגابج',
        );
      });
    });
  });
}
