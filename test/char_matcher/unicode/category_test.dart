import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('category', () {
    group('general category', () {
      test('otherControl', () {
        verify(
          UnicodeCharMatcher.otherControl(),
          '\u{13}\u{b}\u{9c}\u{8}\u{11}\u{8d}\u{8a}\u{17}\u{91}\u{10}',
          '012abcABC_!@# ',
        );
      });
      test('otherFormat', () {
        verify(
          UnicodeCharMatcher.otherFormat(),
          '\u{206a}\u{200c}\u{feff}\u{e0053}\u{200f}\u{e0031}\u{e0030}',
          '012abcABC_!@# ',
        );
      });
      test('otherPrivateUse', () {
        verify(
          UnicodeCharMatcher.otherPrivateUse(),
          '\u{f384a}\u{100e70}\u{1010a4}\u{10c920}\u{1090f4}\u{f280d}\u{fccb9}',
          '012abcABC_!@# ',
        );
      });
      test('otherNotAssigned', () {
        verify(UnicodeCharMatcher.otherNotAssigned(), '', '012abcABC_!@# ');
      });
      test('otherSurrogate', () {
        final matcher = UnicodeCharMatcher.otherSurrogate();
        for (final code in [0xd851, 0xd97c, 0xdcc4, 0xd96c, 0xded6, 0xd948]) {
          check(matcher.match(code)).isTrue();
        }
      });
      test('letterLowercase', () {
        // 𝼀, 𝒿, ᵹ, 𐐴, ꞿ, ъ, ꟶ, ꚕ, ꞟ, 𝕤
        verify(
          UnicodeCharMatcher.letterLowercase(),
          '\u{1df00}\u{1d4bf}\u{1d79}\u{10434}\u{a7bf}\u{44a}\u{a7f6}\u{a695}',
          '012ABC_!@# ',
        );
      });
      test('letterModifier', () {
        // ߵ, ᶯ, ₖ, ᵢ, 𖭁, 𖿡, 𞁃, ࣉ, ᶩ, ꚝ
        verify(
          UnicodeCharMatcher.letterModifier(),
          '\u{7f5}\u{1daf}\u{2096}\u{1d62}\u{16b41}\u{16fe1}\u{1e043}\u{8c9}',
          '012abcABC_!@# ',
        );
      });
      test('letterOther', () {
        // 𪞉, 鮁, ജ, 𨖫, 䵅, ᗎ, 𤳾, 㢎, 𢓧, 𧫀
        verify(
          UnicodeCharMatcher.letterOther(),
          '\u{2a789}\u{9b81}\u{d1c}\u{285ab}\u{4d45}\u{15ce}\u{24cfe}\u{388e}',
          '012abcABC_!@# ',
        );
      });
      test('letterTitlecase', () {
        // ǅ, ᾞ, ᾫ, ᾮ, ᾙ, ᾌ, ǈ, ᾭ, ᾝ, ᾜ
        verify(
          UnicodeCharMatcher.letterTitlecase(),
          '\u{1c5}\u{1f9e}\u{1fab}\u{1fae}\u{1f99}\u{1f8c}\u{1c8}\u{1fad}',
          '012abcABC_!@# ',
        );
      });
      test('letterUppercase', () {
        // Ɨ, 𐐌, 𝔒, ϔ, Ꮉ, Ⴊ, Ｑ, 𝑵, 𝕳, Ҵ
        verify(
          UnicodeCharMatcher.letterUppercase(),
          '\u{197}\u{1040c}\u{1d512}\u{3d4}\u{13b9}\u{10aa}\u{ff31}\u{1d475}',
          '012abc_!@# ',
        );
      });
      test('markSpacingCombining', () {
        // ೖ, 𑤱, 𑧤, 𖽫, 𖽜, 𑶔, 〮, 𑧓, ឿ, ೕ
        verify(
          UnicodeCharMatcher.markSpacingCombining(),
          '\u{cd6}\u{11931}\u{119e4}\u{16f6b}\u{16f5c}\u{11d94}\u{302e}',
          '012abcABC_!@# ',
        );
      });
      test('markEnclosing', () {
        // ⃟, ⃠, ⃝, ꙲, ⃞, ꙱, ҈, ꙰, ⃣, ⃢
        verify(
          UnicodeCharMatcher.markEnclosing(),
          '\u{20df}\u{20e0}\u{20dd}\u{a672}\u{20de}\u{a671}\u{488}\u{a670}',
          '012abcABC_!@# ',
        );
      });
      test('markNonspacing', () {
        // ఼, ᝳ, ྵ, ᩛ, ꪿, 󠄩, 𑒸, ૿, ۢ, ਂ
        verify(
          UnicodeCharMatcher.markNonspacing(),
          '\u{c3c}\u{1773}\u{fb5}\u{1a5b}\u{aabf}\u{e0129}\u{114b8}\u{aff}',
          '012abcABC_!@# ',
        );
      });
      test('numberDecimalDigit', () {
        // 𑣦, 𝟖, 𝟟, 𑃴, 🯶, ꘣, 𑇑, ᪙, ๕, ६
        verify(
          UnicodeCharMatcher.numberDecimalDigit(),
          '\u{118e6}\u{1d7d6}\u{1d7df}\u{110f4}\u{1fbf6}\u{a623}\u{111d1}',
          'abcABC_!@# ',
        );
      });
      test('numberLetter', () {
        // ⅵ, 𐍁, 𐏒, 𐅝, 𒐛, ⅴ, 𐅐, ᛮ, 𒑛, 𐅤
        verify(
          UnicodeCharMatcher.numberLetter(),
          '\u{2175}\u{10341}\u{103d2}\u{1015d}\u{1241b}\u{2174}\u{10150}',
          '012abcABC_!@# ',
        );
      });
      test('numberOther', () {
        // 𞱶, ❷, 𐢧, 𐌢, ൝, ൱, 𑿎, 𐣻, 𐤘, 𞣏
        verify(
          UnicodeCharMatcher.numberOther(),
          '\u{1ec76}\u{2777}\u{108a7}\u{10322}\u{d5d}\u{d71}\u{11fce}',
          '012abcABC_!@# ',
        );
      });
      test('punctuationConnector', () {
        // ︴, _, ﹎, ﹍, ⁔, ⁀, ﹏, ＿, ‿, ︳
        verify(
          UnicodeCharMatcher.punctuationConnector(),
          '\u{fe34}\u{5f}\u{fe4e}\u{fe4d}\u{2054}\u{2040}\u{fe4f}\u{ff3f}',
          '012abcABC!@# ',
        );
      });
      test('punctuationDash', () {
        // ⸗, ᠆, ⸚, 〜, 〰, ―, ⹀, —, ⸻, 𐺭
        verify(
          UnicodeCharMatcher.punctuationDash(),
          '\u{2e17}\u{1806}\u{2e1a}\u{301c}\u{3030}\u{2015}\u{2e40}\u{2014}',
          '012abcABC_!@# ',
        );
      });
      test('punctuationClose', () {
        // 〞, ⁾, ❩, ⧽, ）, 』, ⁆, ︶, ⦔, ⟧
        verify(
          UnicodeCharMatcher.punctuationClose(),
          '\u{301e}\u{207e}\u{2769}\u{29fd}\u{ff09}\u{300f}\u{2046}\u{fe36}',
          '012abcABC_!@# ',
        );
      });
      test('punctuationFinalQuote', () {
        // ⸍, ⸃, ⸝, ›, ⸊, ⸡, ⸅, ’, ”, »
        verify(
          UnicodeCharMatcher.punctuationFinalQuote(),
          '\u{2e0d}\u{2e03}\u{2e1d}\u{203a}\u{2e0a}\u{2e21}\u{2e05}\u{2019}',
          '012abcABC_!@# ',
        );
      });
      test('punctuationInitialQuote', () {
        // ⸌, ‟, ⸜, «, ⸂, ⸉, ⸄, ‹, ⸠, “
        verify(
          UnicodeCharMatcher.punctuationInitialQuote(),
          '\u{2e0c}\u{201f}\u{2e1c}\u{ab}\u{2e02}\u{2e09}\u{2e04}\u{2039}',
          '012abcABC_!@# ',
        );
      });
      test('punctuationOther', () {
        // ⳻, ᠊, ။, ᪩, 𑗕, ¶, ࠺, 𖺗, ꩝, '
        verify(
          UnicodeCharMatcher.punctuationOther(),
          '\u{2cfb}\u{180a}\u{104b}\u{1aa9}\u{115d5}\u{b6}\u{83a}\u{16e97}',
          '012abcABC_ ',
        );
      });
      test('punctuationOpen', () {
        // ︿, ︵, ⸦, ⹂, 〝, ⸨, ❰, ｟, ⹙, 〈
        verify(
          UnicodeCharMatcher.punctuationOpen(),
          '\u{fe3f}\u{fe35}\u{2e26}\u{2e42}\u{301d}\u{2e28}\u{2770}\u{ff5f}',
          '012abcABC_!@# ',
        );
      });
      test('symbolCurrency', () {
        // $, £, ￡, ₻, ₿, ₠, €, ₵, ﹩, ￥
        verify(
          UnicodeCharMatcher.symbolCurrency(),
          '\u{24}\u{a3}\u{ffe1}\u{20bb}\u{20bf}\u{20a0}\u{20ac}\u{20b5}',
          '012abcABC_!@# ',
        );
      });
      test('symbolModifier', () {
        // ꜋, ˫, `, ﮷, ꜕, ﯀, ᾿, ˓, ꜖, ῎
        verify(
          UnicodeCharMatcher.symbolModifier(),
          '\u{a70b}\u{2eb}\u{60}\u{fbb7}\u{a715}\u{fbc0}\u{1fbf}\u{2d3}',
          '012abcABC_!@# ',
        );
      });
      test('symbolMath', () {
        // ⊺, ≎, ≫, ＋, ⊚, ⨜, ⩙, ⬽, ⏜, ⩑
        verify(
          UnicodeCharMatcher.symbolMath(),
          '\u{22ba}\u{224e}\u{226b}\u{ff0b}\u{229a}\u{2a1c}\u{2a59}\u{2b3d}',
          '012abcABC_!@# ',
        );
      });
      test('symbolOther', () {
        // 𝈷, ╖, 🌾, 𐅹, ☛, 🀟, 🀛, ⍰, 𝉁, 𐆜
        verify(
          UnicodeCharMatcher.symbolOther(),
          '\u{1d237}\u{2556}\u{1f33e}\u{10179}\u{261b}\u{1f01f}\u{1f01b}',
          '012abcABC_!@# ',
        );
      });
      test('separatorLine', () {
        verify(
          UnicodeCharMatcher.separatorLine(),
          '\u{2028}',
          '012abcABC_!@# ',
        );
      });
      test('separatorParagraph', () {
        verify(
          UnicodeCharMatcher.separatorParagraph(),
          '\u{2029}',
          '012abcABC_!@# ',
        );
      });
      test('separatorSpace', () {
        verify(
          UnicodeCharMatcher.separatorSpace(),
          ' \u{2008}\u{2007}\u{202f}\u{2005}\u{2000}\u{2001}\u{2006}\u{2002}',
          '012abcABC_!@#',
        );
      });
    });
    group('group', () {
      test('other', () {
        verify(
          UnicodeCharMatcher.other(),
          '\u{13}\u{b}\u{206a}\u{200c}\u{f384a}\u{100e70}\u{07bf}\u{10fff}',
          '012abcABC_!@# ',
        );
      });
      test('letter', () {
        verify(
          UnicodeCharMatcher.letter(),
          '\u{1df00}\u{1daf}\u{9b81}\u{1fab}\u{3d4}\u{24cfe}\u{388e}',
          '012_!@# ',
        );
      });
      test('casedLetter', () {
        verify(
          UnicodeCharMatcher.casedLetter(),
          '\u{1fae}\u{1f99}\u{3d4}\u{13b9}\u{10aa}\u{10434}\u{a7bf}',
          '\u{d1c}\u{285ab}\u{2096}\u{1d62}012_!@# ',
        );
      });
      test('mark', () {
        verify(
          UnicodeCharMatcher.mark(),
          '\u{16f6b}\u{16f5c}\u{a672}\u{20de}\u{1a5b}\u{aabf}',
          '012abcABC_!@# ',
        );
      });
      test('number', () {
        verify(
          UnicodeCharMatcher.number(),
          '\u{110f4}\u{1fbf6}\u{103d2}\u{1015d}\u{1015d}\u{d5d}\u{d71}',
          'abcABC_!@# ',
        );
      });
      test('punctuation', () {
        verify(
          UnicodeCharMatcher.punctuation(),
          '\u{2040}\u{2015}\u{300f}\u{2e0a}\u{ab}\u{115d5}\u{301d}',
          'abcABC ',
        );
      });
      test('symbol', () {
        verify(
          UnicodeCharMatcher.symbol(),
          '\u{20bb}\u{20bf}\u{fbb7}\u{a715}\u{ff0b}\u{229a}\u{10179}\u{261b}',
          'abcABC_!@# ',
        );
      });
      test('separator', () {
        verify(
          UnicodeCharMatcher.separator(),
          ' \u{2028}\u{2029}\u{202f}\u{2005}\u{2000}\u{2001}\u{2006}\u{2002}',
          '012abcABC_!@#',
        );
      });
    });
  });
}
