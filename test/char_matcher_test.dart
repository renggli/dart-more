// ignore_for_file: deprecated_member_use_from_same_package

import 'package:more/more.dart';
import 'package:test/test.dart';

void verify(CharMatcher matcher, String included, String excluded,
    {bool negate = true}) {
  // Test inclusion and exclusion.
  for (final iterator = included.runes.iterator; iterator.moveNext();) {
    expect(matcher(iterator.current), isTrue,
        reason: '${unicodeCodePointPrinter(iterator.current)} should match');
  }
  for (final iterator = excluded.runes.iterator; iterator.moveNext();) {
    expect(matcher(iterator.current), isFalse,
        reason:
            '${unicodeCodePointPrinter(iterator.current)} should not match');
  }
  // Test basic operators.
  expect(matcher.everyOf(included), isTrue,
      reason: 'all of "$included" should match');
  expect(matcher.noneOf(excluded), isTrue,
      reason: 'none of "$excluded" should match');
  expect(matcher.countIn(included), included.runes.length);
  expect(matcher.replaceFrom(included, ''), '');
  expect(matcher.removeFrom(included), '');
  expect(matcher.retainFrom(included), included);
  expect(matcher.trimLeadingFrom(included), '');
  expect(matcher.trimTailingFrom(included), '');
  expect(matcher.toString(), startsWith(matcher.runtimeType.toString()));
  // Negated version of the matcher.
  if (negate) verify(~matcher, excluded, included, negate: false);
}

void main() {
  group('ascii', () {
    test('ascii', () {
      verify(const CharMatcher.ascii(), 'def123_!@#', '\u2665');
    });
    test('upperCaseLetter', () {
      verify(const CharMatcher.upperCaseLetter(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz123_!@# ');
    });
    test('lowerCaseLetter', () {
      verify(const CharMatcher.lowerCaseLetter(), 'abcdefghijklmnopqrstuvwxyz',
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ123_!@# ');
    });
    test('letterOrDigit', () {
      verify(
          const CharMatcher.letterOrDigit(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_',
          '!@# ');
    });
    test('digit', () {
      verify(const CharMatcher.digit(), '0123456789', 'abc_!@# ');
    });
    test('letter', () {
      verify(const CharMatcher.letter(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '123_!@# ');
    });
    test('punctuation', () {
      verify(const CharMatcher.punctuation(),
          '!"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~', 'abc123 ');
    });
    test('whitespace', () {
      verify(const CharMatcher.whitespace(), '\t\n\r\v\f ', 'abcABC_!@#\u0000');
    });
  });
  group('basic', () {
    test('isChar', () {
      verify(CharMatcher.isChar('*'), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar('👱'), '👱', 'abc123_!@# 💩');
    });
    test('isChar (code-point)', () {
      verify(CharMatcher.isChar(42), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar(42.0), '*', 'abc123_!@# ');
    });
    test('isChar (error)', () {
      expect(() => CharMatcher.isChar('ab'), throwsArgumentError,
          reason: 'multiple characters');
      expect(() => CharMatcher.isChar('🧑🏼'), throwsArgumentError,
          reason: 'composite emoji');
    });
    test('inRange', () {
      verify(CharMatcher.inRange('a', 'c'), 'abc', 'def123_!@# ');
    });
  });
  group('custom', () {
    group('char set', () {
      test('empty', () {
        verify(CharMatcher.charSet(''), '', 'abc');
      });
      test('single', () {
        verify(CharMatcher.charSet('b'), 'b', 'ac');
      });
      test('many single', () {
        verify(CharMatcher.charSet('bcd'), 'bcd', 'ae');
        verify(CharMatcher.charSet('dcb'), 'bcd', 'ae');
      });
      test('many separate', () {
        verify(CharMatcher.charSet('bdf'), 'bdf', 'aceg');
        verify(CharMatcher.charSet('fdb'), 'bdf', 'aceg');
      });
      test('special chars', () {
        verify(CharMatcher.charSet('^a-z[]'), '^a-z[]', 'by');
      });
      test('unicode', () {
        verify(CharMatcher.charSet('↖⇨'), '↖⇨', 'abc←↯');
      });
    });
    group('pattern', () {
      test('empty', () {
        verify(CharMatcher.pattern(''), '', 'abc');
      });
      test('single', () {
        verify(CharMatcher.pattern('a'), 'a', 'b');
      });
      test('many single', () {
        verify(CharMatcher.pattern('abc'), 'abc', 'd');
      });
      test('range', () {
        verify(CharMatcher.pattern('a-c'), 'abc', 'd');
      });
      test('overlapping range', () {
        verify(CharMatcher.pattern('b-da-c'), 'abcd', 'e');
      });
      test('adjacent range', () {
        verify(CharMatcher.pattern('c-ea-c'), 'abcde', 'f');
      });
      test('prefix range', () {
        verify(CharMatcher.pattern('a-ea-c'), 'abcde', 'f');
      });
      test('postfix range', () {
        verify(CharMatcher.pattern('a-ec-e'), 'abcde', 'f');
      });
      test('repeated range', () {
        verify(CharMatcher.pattern('a-ea-e'), 'abcde', 'f');
      });
      test('composed range', () {
        verify(CharMatcher.pattern('ac-df-'), 'acdf-', 'beg');
      });
      test('negated single', () {
        verify(CharMatcher.pattern('^a'), 'b', 'a');
      });
      test('negated range', () {
        verify(CharMatcher.pattern('^a-c'), 'd', 'abc');
      });
      test('negated composed', () {
        verify(CharMatcher.pattern('^ac-df-'), 'beg', 'acdf-');
      });
      test('full range', () {
        verify(CharMatcher.pattern('\u0000-\uffff'), '\u0000\u7777\uffff', '');
      });
      test('large range', () {
        verify(CharMatcher.pattern('\u2200-\u22ff\u27c0-\u27ef\u2980-\u29ff'),
            '∉⟃⦻', 'a');
      });
      test('far range', () {
        verify(CharMatcher.pattern('\u0000\uffff'), '\u0000\uffff',
            '\u0001\ufffe');
      });
      test('class subtraction', () {
        verify(CharMatcher.pattern('a-z-[aeiuo]'), 'bcdfghjklmnpqrstvwxyz',
            '123aeiuo');
        verify(CharMatcher.pattern('^1234-[3456]'), 'abc7890', '123456');
        verify(CharMatcher.pattern('0-9-[0-6-[0-3]]'), '0123789', 'abc456');
      });
    });
  });
  group('operator', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    const letter = CharMatcher.letter();
    const digit = CharMatcher.digit();
    const whitespace = CharMatcher.whitespace();
    final hex = CharMatcher.pattern('0-9a-f');
    final even = CharMatcher.pattern('02468');
    test('any', () {
      verify(any, 'abc123_!@# 💩', '');
      verify(any, '👱🧑🏼', '');
    });
    test('none', () {
      verify(none, '', 'abc123_!@# 💩');
      verify(none, '', '👱🧑🏼');
    });
    test('negation', () {
      expect(~any, equals(none));
      expect(~none, equals(any));
      expect(~~whitespace, equals(whitespace));
    });
    test('disjunctive', () {
      expect(any | letter, equals(any));
      expect(letter | any, equals(any));
      expect(none | letter, equals(letter));
      expect(letter | none, equals(letter));
      verify(letter | digit, 'abc123', '_!@# ');
      verify(digit | letter, 'abc123', '_!@# ');
      verify(letter | digit | whitespace, 'abc123 ', '_!@#');
      verify(letter | (digit | whitespace), 'abc123 ', '_!@#');
      verify((letter | digit) | whitespace, 'abc123 ', '_!@#');
      verify((letter | digit) | (whitespace | digit), 'abc123 ', '_!@#');
    });
    test('conjunctive', () {
      expect(any & letter, equals(letter));
      expect(letter & any, equals(letter));
      expect(none & letter, equals(none));
      expect(letter & none, equals(none));
      verify(hex & letter, 'abcdef', '012_!@# ');
      verify(letter & hex, 'abcdef', '012_!@# ');
      verify(hex & digit & even, '0248', 'abc13_!@# ');
      verify(hex & (digit & even), '0248', 'abc13_!@# ');
      verify((hex & digit) & even, '0248', 'abc13_!@# ');
    });
  });
  group('unicode', () {
    group('general category', () {
      test('otherControl', () {
        verify(
            UnicodeCharMatcher.otherControl(),
            '\u{13}\u{b}\u{9c}\u{8}\u{11}\u{8d}\u{8a}\u{17}\u{91}\u{10}',
            '012abcABC_!@# ');
      });
      test('otherFormat', () {
        verify(
            UnicodeCharMatcher.otherFormat(),
            '\u{206a}\u{200c}\u{feff}\u{e0053}\u{200f}\u{e0031}\u{e0030}',
            '012abcABC_!@# ');
      });
      test('otherPrivateUse', () {
        verify(
            UnicodeCharMatcher.otherPrivateUse(),
            '\u{f384a}\u{100e70}\u{1010a4}\u{10c920}\u{1090f4}\u{f280d}\u{fccb9}',
            '012abcABC_!@# ');
      });
      test('otherNotAssigned', () {
        verify(UnicodeCharMatcher.otherNotAssigned(), '', '012abcABC_!@# ');
      });
      test('otherSurrogate', () {
        final matcher = UnicodeCharMatcher.otherSurrogate();
        for (final code in [0xd851, 0xd97c, 0xdcc4, 0xd96c, 0xded6, 0xd948]) {
          expect(matcher.match(code), isTrue);
        }
      });
      test('letterLowercase', () {
        // 𝼀, 𝒿, ᵹ, 𐐴, ꞿ, ъ, ꟶ, ꚕ, ꞟ, 𝕤
        verify(
            UnicodeCharMatcher.letterLowercase(),
            '\u{1df00}\u{1d4bf}\u{1d79}\u{10434}\u{a7bf}\u{44a}\u{a7f6}\u{a695}',
            '012ABC_!@# ');
      });
      test('letterModifier', () {
        // ߵ, ᶯ, ₖ, ᵢ, 𖭁, 𖿡, 𞁃, ࣉ, ᶩ, ꚝ
        verify(
            UnicodeCharMatcher.letterModifier(),
            '\u{7f5}\u{1daf}\u{2096}\u{1d62}\u{16b41}\u{16fe1}\u{1e043}\u{8c9}',
            '012abcABC_!@# ');
      });
      test('letterOther', () {
        // 𪞉, 鮁, ജ, 𨖫, 䵅, ᗎ, 𤳾, 㢎, 𢓧, 𧫀
        verify(
            UnicodeCharMatcher.letterOther(),
            '\u{2a789}\u{9b81}\u{d1c}\u{285ab}\u{4d45}\u{15ce}\u{24cfe}\u{388e}',
            '012abcABC_!@# ');
      });
      test('letterTitlecase', () {
        // ǅ, ᾞ, ᾫ, ᾮ, ᾙ, ᾌ, ǈ, ᾭ, ᾝ, ᾜ
        verify(
            UnicodeCharMatcher.letterTitlecase(),
            '\u{1c5}\u{1f9e}\u{1fab}\u{1fae}\u{1f99}\u{1f8c}\u{1c8}\u{1fad}',
            '012abcABC_!@# ');
      });
      test('letterUppercase', () {
        // Ɨ, 𐐌, 𝔒, ϔ, Ꮉ, Ⴊ, Ｑ, 𝑵, 𝕳, Ҵ
        verify(
            UnicodeCharMatcher.letterUppercase(),
            '\u{197}\u{1040c}\u{1d512}\u{3d4}\u{13b9}\u{10aa}\u{ff31}\u{1d475}',
            '012abc_!@# ');
      });
      test('markSpacingCombining', () {
        // ೖ, 𑤱, 𑧤, 𖽫, 𖽜, 𑶔, 〮, 𑧓, ឿ, ೕ
        verify(
            UnicodeCharMatcher.markSpacingCombining(),
            '\u{cd6}\u{11931}\u{119e4}\u{16f6b}\u{16f5c}\u{11d94}\u{302e}',
            '012abcABC_!@# ');
      });
      test('markEnclosing', () {
        // ⃟, ⃠, ⃝, ꙲, ⃞, ꙱, ҈, ꙰, ⃣, ⃢
        verify(
            UnicodeCharMatcher.markEnclosing(),
            '\u{20df}\u{20e0}\u{20dd}\u{a672}\u{20de}\u{a671}\u{488}\u{a670}',
            '012abcABC_!@# ');
      });
      test('markNonspacing', () {
        // ఼, ᝳ, ྵ, ᩛ, ꪿, 󠄩, 𑒸, ૿, ۢ, ਂ
        verify(
            UnicodeCharMatcher.markNonspacing(),
            '\u{c3c}\u{1773}\u{fb5}\u{1a5b}\u{aabf}\u{e0129}\u{114b8}\u{aff}',
            '012abcABC_!@# ');
      });
      test('numberDecimalDigit', () {
        // 𑣦, 𝟖, 𝟟, 𑃴, 🯶, ꘣, 𑇑, ᪙, ๕, ६
        verify(
            UnicodeCharMatcher.numberDecimalDigit(),
            '\u{118e6}\u{1d7d6}\u{1d7df}\u{110f4}\u{1fbf6}\u{a623}\u{111d1}',
            'abcABC_!@# ');
      });
      test('numberLetter', () {
        // ⅵ, 𐍁, 𐏒, 𐅝, 𒐛, ⅴ, 𐅐, ᛮ, 𒑛, 𐅤
        verify(
            UnicodeCharMatcher.numberLetter(),
            '\u{2175}\u{10341}\u{103d2}\u{1015d}\u{1241b}\u{2174}\u{10150}',
            '012abcABC_!@# ');
      });
      test('numberOther', () {
        // 𞱶, ❷, 𐢧, 𐌢, ൝, ൱, 𑿎, 𐣻, 𐤘, 𞣏
        verify(
            UnicodeCharMatcher.numberOther(),
            '\u{1ec76}\u{2777}\u{108a7}\u{10322}\u{d5d}\u{d71}\u{11fce}',
            '012abcABC_!@# ');
      });
      test('punctuationConnector', () {
        // ︴, _, ﹎, ﹍, ⁔, ⁀, ﹏, ＿, ‿, ︳
        verify(
            UnicodeCharMatcher.punctuationConnector(),
            '\u{fe34}\u{5f}\u{fe4e}\u{fe4d}\u{2054}\u{2040}\u{fe4f}\u{ff3f}',
            '012abcABC!@# ');
      });
      test('punctuationDash', () {
        // ⸗, ᠆, ⸚, 〜, 〰, ―, ⹀, —, ⸻, 𐺭
        verify(
            UnicodeCharMatcher.punctuationDash(),
            '\u{2e17}\u{1806}\u{2e1a}\u{301c}\u{3030}\u{2015}\u{2e40}\u{2014}',
            '012abcABC_!@# ');
      });
      test('punctuationClose', () {
        // 〞, ⁾, ❩, ⧽, ）, 』, ⁆, ︶, ⦔, ⟧
        verify(
            UnicodeCharMatcher.punctuationClose(),
            '\u{301e}\u{207e}\u{2769}\u{29fd}\u{ff09}\u{300f}\u{2046}\u{fe36}',
            '012abcABC_!@# ');
      });
      test('punctuationFinalQuote', () {
        // ⸍, ⸃, ⸝, ›, ⸊, ⸡, ⸅, ’, ”, »
        verify(
            UnicodeCharMatcher.punctuationFinalQuote(),
            '\u{2e0d}\u{2e03}\u{2e1d}\u{203a}\u{2e0a}\u{2e21}\u{2e05}\u{2019}',
            '012abcABC_!@# ');
      });
      test('punctuationInitialQuote', () {
        // ⸌, ‟, ⸜, «, ⸂, ⸉, ⸄, ‹, ⸠, “
        verify(
            UnicodeCharMatcher.punctuationInitialQuote(),
            '\u{2e0c}\u{201f}\u{2e1c}\u{ab}\u{2e02}\u{2e09}\u{2e04}\u{2039}',
            '012abcABC_!@# ');
      });
      test('punctuationOther', () {
        // ⳻, ᠊, ။, ᪩, 𑗕, ¶, ࠺, 𖺗, ꩝, '
        verify(
            UnicodeCharMatcher.punctuationOther(),
            '\u{2cfb}\u{180a}\u{104b}\u{1aa9}\u{115d5}\u{b6}\u{83a}\u{16e97}',
            '012abcABC_ ');
      });
      test('punctuationOpen', () {
        // ︿, ︵, ⸦, ⹂, 〝, ⸨, ❰, ｟, ⹙, 〈
        verify(
            UnicodeCharMatcher.punctuationOpen(),
            '\u{fe3f}\u{fe35}\u{2e26}\u{2e42}\u{301d}\u{2e28}\u{2770}\u{ff5f}',
            '012abcABC_!@# ');
      });
      test('symbolCurrency', () {
        // $, £, ￡, ₻, ₿, ₠, €, ₵, ﹩, ￥
        verify(
            UnicodeCharMatcher.symbolCurrency(),
            '\u{24}\u{a3}\u{ffe1}\u{20bb}\u{20bf}\u{20a0}\u{20ac}\u{20b5}',
            '012abcABC_!@# ');
      });
      test('symbolModifier', () {
        // ꜋, ˫, `, ﮷, ꜕, ﯀, ᾿, ˓, ꜖, ῎
        verify(
            UnicodeCharMatcher.symbolModifier(),
            '\u{a70b}\u{2eb}\u{60}\u{fbb7}\u{a715}\u{fbc0}\u{1fbf}\u{2d3}',
            '012abcABC_!@# ');
      });
      test('symbolMath', () {
        // ⊺, ≎, ≫, ＋, ⊚, ⨜, ⩙, ⬽, ⏜, ⩑
        verify(
            UnicodeCharMatcher.symbolMath(),
            '\u{22ba}\u{224e}\u{226b}\u{ff0b}\u{229a}\u{2a1c}\u{2a59}\u{2b3d}',
            '012abcABC_!@# ');
      });
      test('symbolOther', () {
        // 𝈷, ╖, 🌾, 𐅹, ☛, 🀟, 🀛, ⍰, 𝉁, 𐆜
        verify(
            UnicodeCharMatcher.symbolOther(),
            '\u{1d237}\u{2556}\u{1f33e}\u{10179}\u{261b}\u{1f01f}\u{1f01b}',
            '012abcABC_!@# ');
      });
      test('separatorLine', () {
        verify(
            UnicodeCharMatcher.separatorLine(), '\u{2028}', '012abcABC_!@# ');
      });
      test('separatorParagraph', () {
        verify(UnicodeCharMatcher.separatorParagraph(), '\u{2029}',
            '012abcABC_!@# ');
      });
      test('separatorSpace', () {
        verify(
            UnicodeCharMatcher.separatorSpace(),
            ' \u{2008}\u{2007}\u{202f}\u{2005}\u{2000}\u{2001}\u{2006}\u{2002}',
            '012abcABC_!@#');
      });
    });
    group('general category group', () {
      test('other', () {
        verify(
            UnicodeCharMatcher.other(),
            '\u{13}\u{b}\u{206a}\u{200c}\u{f384a}\u{100e70}\u{07bf}\u{10fff}',
            '012abcABC_!@# ');
      });
      test('letter', () {
        verify(
            UnicodeCharMatcher.letter(),
            '\u{1df00}\u{1daf}\u{9b81}\u{1fab}\u{3d4}\u{24cfe}\u{388e}',
            '012_!@# ');
      });
      test('casedLetter', () {
        verify(
            UnicodeCharMatcher.casedLetter(),
            '\u{1fae}\u{1f99}\u{3d4}\u{13b9}\u{10aa}\u{10434}\u{a7bf}',
            '\u{d1c}\u{285ab}\u{2096}\u{1d62}012_!@# ');
      });
      test('mark', () {
        verify(
            UnicodeCharMatcher.mark(),
            '\u{16f6b}\u{16f5c}\u{a672}\u{20de}\u{1a5b}\u{aabf}',
            '012abcABC_!@# ');
      });
      test('number', () {
        verify(
            UnicodeCharMatcher.number(),
            '\u{110f4}\u{1fbf6}\u{103d2}\u{1015d}\u{1015d}\u{d5d}\u{d71}',
            'abcABC_!@# ');
      });
      test('punctuation', () {
        verify(
            UnicodeCharMatcher.punctuation(),
            '\u{2040}\u{2015}\u{300f}\u{2e0a}\u{ab}\u{115d5}\u{301d}',
            'abcABC ');
      });
      test('symbol', () {
        verify(
            UnicodeCharMatcher.symbol(),
            '\u{20bb}\u{20bf}\u{fbb7}\u{a715}\u{ff0b}\u{229a}\u{10179}\u{261b}',
            'abcABC_!@# ');
      });
      test('separator', () {
        verify(
            UnicodeCharMatcher.separator(),
            ' \u{2028}\u{2029}\u{202f}\u{2005}\u{2000}\u{2001}\u{2006}\u{2002}',
            '012abcABC_!@#');
      });
    });
    group('property', () {
      test('whiteSpace', () {
        final string = String.fromCharCodes([
          9, 10, 11, 12, 13, 32, 133, 160, 5760, 8192, 8193, 8194, 8195, 8196,
          8197, 8198, 8199, 8200, 8201, 8202, 8232, 8233, 8239, 8287, 12288, //
        ]);
        verify(UnicodeCharMatcher.whiteSpace(), string, '012abcABC_!@#');
      });
      test('bidiControl', () {
        verify(UnicodeCharMatcher.bidiControl(),
            '\u{061C}\u{200F}\u{202E}\u{2066}', '012abcABC_!@# ');
      });
      test('joinControl', () {
        verify(UnicodeCharMatcher.joinControl(), '\u{200C}\u{200D}',
            '012abcABC_!@# ');
      });
      test('dash', () {
        verify(UnicodeCharMatcher.dash(),
            '\u{002D}\u{2053}\u{2E3B}\u{FE31}\u{10EAD}', '012abcABC_!@# ');
      });
      test('hyphen', () {
        verify(UnicodeCharMatcher.hyphen(),
            '\u{002D}\u{058A}\u{2011}\u{30FB}\u{FF65}', '012abcABC_!@# ');
      });
      test('quotationMark', () {
        verify(UnicodeCharMatcher.quotationMark(),
            '\u{0022}\u{00AB}\u{00BB}\u{301F}\u{FF63}', '012abcABC_!@# ');
      });
      test('terminalPunctuation', () {
        verify(UnicodeCharMatcher.terminalPunctuation(),
            '!,.:;\u{060C}\u{0700}\u{203C}\u{A6F7}\u{11944}', '012abcABC_@# ');
      });
      test('otherMath', () {
        verify(UnicodeCharMatcher.otherMath(),
            '\u{005E}\u{2040}\u{2149}\u{1EE52}\u{1EEBB}', '012abcABC_!@# ');
      });
      test('hexDigit', () {
        verify(UnicodeCharMatcher.hexDigit(),
            '\u{0030}\u{FF10}\u{FF24}\u{FF26}\u{FF41}', 'xyzXYZ_!@# ');
      });
      test('asciiHexDigit', () {
        verify(UnicodeCharMatcher.asciiHexDigit(), '0123456789abcdefABCDEF',
            'xyzXYZ_!@# ');
      });
      test('otherAlphabetic', () {
        verify(UnicodeCharMatcher.otherAlphabetic(),
            '\u{0345}\u{0730}\u{0981}\u{0BCB}\u{1A55}', '012abcABC_!@# ');
      });
      test('ideographic', () {
        verify(UnicodeCharMatcher.ideographic(),
            '\u{3006}\u{16FE4}\u{2B820}\u{2B740}\u{323AF}', '012abcABC_!@# ');
      });
      test('diacritic', () {
        verify(UnicodeCharMatcher.diacritic(),
            '\u{005E}\u{05C4}\u{0C4D}\u{11D45}\u{1E2AE}', '012abcABC_!@# ');
      });
      test('extender', () {
        verify(UnicodeCharMatcher.extender(),
            '\u{00B7}\u{1843}\u{30FC}\u{10781}\u{16FE3}', '012abcABC_!@# ');
      });
      test('otherLowercase', () {
        verify(UnicodeCharMatcher.otherLowercase(),
            '\u{00AA}\u{0345}\u{A770}\u{1E06D}', '012abcABC_!@# ');
      });
      test('otherUppercase', () {
        verify(UnicodeCharMatcher.otherUppercase(),
            '\u{2160}\u{24B6}\u{1F149}\u{1F170}\u{1F189}', '012abcABC_!@# ');
      });
      test('noncharacterCodePoint', () {
        verify(UnicodeCharMatcher.noncharacterCodePoint(),
            '\u{FDD0}\u{1FFFE}\u{CFFFE}\u{10FFFF}', '012abcABC_!@# ');
      });
      test('otherGraphemeExtend', () {
        verify(UnicodeCharMatcher.otherGraphemeExtend(),
            '\u{09BE}\u{0CD5}\u{FF9E}\u{1D16E}\u{E0020}', '012abcABC_!@# ');
      });
      test('idsBinaryOperator', () {
        verify(UnicodeCharMatcher.idsBinaryOperator(),
            '\u{2FF0}\u{2FF1}\u{2FF4}\u{2FFD}\u{31EF}', '012abcABC_!@# ');
      });
      test('idsTrinaryOperator', () {
        verify(UnicodeCharMatcher.idsTrinaryOperator(), '\u{2FF2}\u{2FF3}',
            '012abcABC_!@# ');
      });
      test('idsUnaryOperator', () {
        verify(UnicodeCharMatcher.idsUnaryOperator(), '\u{2FFE}\u{2FFF}',
            '012abcABC_!@# ');
      });
      test('radical', () {
        verify(UnicodeCharMatcher.radical(), '\u{2E80}\u{2E99}\u{2E9B}\u{2FD5}',
            '012abcABC_!@# ');
      });
      test('unifiedIdeograph', () {
        verify(UnicodeCharMatcher.unifiedIdeograph(),
            '\u{3400}\u{FA21}\u{2EE5D}\u{323AF}', '012abcABC_!@# ');
      });
      test('otherDefaultIgnorableCodePoint', () {
        verify(UnicodeCharMatcher.otherDefaultIgnorableCodePoint(),
            '\u{034F}\u{FFF7}\u{E0002}\u{E0FFF}', '012abcABC_!@# ');
      });
      test('deprecated', () {
        verify(UnicodeCharMatcher.deprecated(),
            '\u{0149}\u{0F77}\u{206C}\u{E0001}', '012abcABC_!@# ');
      });
      test('softDotted', () {
        verify(UnicodeCharMatcher.softDotted(),
            '\u{0069}\u{1D62}\u{1D422}\u{1D65F}', '012abcABC_!@# ');
      });
      test('logicalOrderException', () {
        verify(UnicodeCharMatcher.logicalOrderException(),
            '\u{19BA}\u{AAB6}\u{AABB}\u{AABC}', '012abcABC_!@# ');
      });
      test('otherIdStart', () {
        verify(UnicodeCharMatcher.otherIdStart(),
            '\u{1885}\u{1886}\u{2118}\u{309C}', '012abcABC_!@# ');
      });
      test('otherIdContinue', () {
        verify(UnicodeCharMatcher.otherIdContinue(),
            '\u{00B7}\u{1371}\u{30FB}\u{FF65}', '012abcABC_!@# ');
      });
      test('idCompatMathContinue', () {
        verify(UnicodeCharMatcher.idCompatMathContinue(),
            '\u{00B2}\u{2080}\u{1D6C1}\u{1D76F}', '012abcABC_!@# ');
      });
      test('idCompatMathStart', () {
        verify(UnicodeCharMatcher.idCompatMathStart(),
            '\u{2202}\u{1D735}\u{1D76F}\u{1D7C3}', '012abcABC_!@# ');
      });
      test('sentenceTerminal', () {
        verify(UnicodeCharMatcher.sentenceTerminal(),
            '\u{002E}\u{0700}\u{0964}\u{16E98}', '012abcABC_@# ');
      });
      test('variationSelector', () {
        verify(UnicodeCharMatcher.variationSelector(),
            '\u{180B}\u{180F}\u{FE0F}\u{E0100}', '012abcABC_!@# ');
      });
      test('patternWhiteSpace', () {
        verify(UnicodeCharMatcher.patternWhiteSpace(),
            '\u{0020}\u{200E}\u{200F}\u{2029}', '012abcABC_!@#');
      });
      test('patternSyntax', () {
        verify(UnicodeCharMatcher.patternSyntax(),
            '\u{0029}\u{007B}\u{00A7}\u{FD3F}', '012abcABC_ ');
      });
      test('prependedConcatenationMark', () {
        verify(UnicodeCharMatcher.prependedConcatenationMark(),
            '\u{0600}\u{0890}\u{110BD}\u{110CD}', '012abcABC_!@# ');
      });
      test('regionalIndicator', () {
        verify(UnicodeCharMatcher.regionalIndicator(),
            '\u{1F1E6}\u{1F1EE}\u{1F1F2}\u{1F1FF}', '012abcABC_!@# ');
      });
    });
  });
  group('action', () {
    final star = CharMatcher.isChar('*');
    test('anyOf', () {
      expect(star.anyOf(''), isFalse);
      expect(star.anyOf('a'), isFalse);
      expect(star.anyOf('*'), isTrue);
      expect(star.anyOf('ab'), isFalse);
      expect(star.anyOf('a*'), isTrue);
      expect(star.anyOf('*b'), isTrue);
      expect(star.anyOf('**'), isTrue);
    });
    test('everyOf', () {
      expect(star.everyOf(''), isTrue);
      expect(star.everyOf('a'), isFalse);
      expect(star.everyOf('*'), isTrue);
      expect(star.everyOf('ab'), isFalse);
      expect(star.everyOf('a*'), isFalse);
      expect(star.everyOf('*b'), isFalse);
      expect(star.everyOf('**'), isTrue);
    });

    test('noneOf', () {
      expect(star.noneOf(''), isTrue);
      expect(star.noneOf('a'), isTrue);
      expect(star.noneOf('*'), isFalse);
      expect(star.noneOf('ab'), isTrue);
      expect(star.noneOf('a*'), isFalse);
      expect(star.noneOf('*b'), isFalse);
      expect(star.noneOf('**'), isFalse);
    });
    test('firstIndexIn', () {
      expect(star.firstIndexIn(''), -1);
      expect(star.firstIndexIn('*'), 0);
      expect(star.firstIndexIn('**'), 0);
      expect(star.firstIndexIn('a'), -1);
      expect(star.firstIndexIn('a*'), 1);
      expect(star.firstIndexIn('a**'), 1);
      expect(star.firstIndexIn('*', 1), -1);
      expect(star.firstIndexIn('**', 1), 1);
    });
    test('lastIndexIn', () {
      expect(star.lastIndexIn(''), -1);
      expect(star.lastIndexIn('*'), 0);
      expect(star.lastIndexIn('**'), 1);
      expect(star.lastIndexIn('a'), -1);
      expect(star.lastIndexIn('*a'), 0);
      expect(star.lastIndexIn('**a'), 1);
      expect(star.lastIndexIn('*', 0), 0);
      expect(star.lastIndexIn('**', 0), 0);
    });
    test('countIn', () {
      expect(star.countIn(''), 0);
      expect(star.countIn('*'), 1);
      expect(star.countIn('**'), 2);
      expect(star.countIn('a'), 0);
      expect(star.countIn('ab'), 0);
      expect(star.countIn('a*b'), 1);
      expect(star.countIn('*a*b'), 2);
      expect(star.countIn('*a*b*'), 3);
    });
    test('collapseFrom', () {
      expect(star.collapseFrom('', ''), '');
      expect(star.collapseFrom('', '!'), '');
      expect(star.collapseFrom('', '!!'), '');
      expect(star.collapseFrom('*', ''), '');
      expect(star.collapseFrom('*', '!'), '!');
      expect(star.collapseFrom('*', '!!'), '!!');
      expect(star.collapseFrom('**', ''), '');
      expect(star.collapseFrom('**', '!'), '!');
      expect(star.collapseFrom('**', '!!'), '!!');
      expect(star.collapseFrom('*a*', ''), 'a');
      expect(star.collapseFrom('*a*', '!'), '!a!');
      expect(star.collapseFrom('*a*', '!!'), '!!a!!');
      expect(star.collapseFrom('**a**', ''), 'a');
      expect(star.collapseFrom('**a**', '!'), '!a!');
      expect(star.collapseFrom('**a**', '!!'), '!!a!!');
      expect(star.collapseFrom('a*b*c', ''), 'abc');
      expect(star.collapseFrom('a*b*c', '!'), 'a!b!c');
      expect(star.collapseFrom('a*b*c', '!!'), 'a!!b!!c');
      expect(star.collapseFrom('a**b**c', ''), 'abc');
      expect(star.collapseFrom('a**b**c', '!'), 'a!b!c');
      expect(star.collapseFrom('a**b**c', '!!'), 'a!!b!!c');
    });
    test('replaceFrom', () {
      expect(star.replaceFrom('', ''), '');
      expect(star.replaceFrom('', '!'), '');
      expect(star.replaceFrom('', '!!'), '');
      expect(star.replaceFrom('*', ''), '');
      expect(star.replaceFrom('*', '!'), '!');
      expect(star.replaceFrom('*', '!!'), '!!');
      expect(star.replaceFrom('**', ''), '');
      expect(star.replaceFrom('**', '!'), '!!');
      expect(star.replaceFrom('**', '!!'), '!!!!');
      expect(star.replaceFrom('*a*', ''), 'a');
      expect(star.replaceFrom('*a*', '!'), '!a!');
      expect(star.replaceFrom('*a*', '!!'), '!!a!!');
      expect(star.replaceFrom('**a**', ''), 'a');
      expect(star.replaceFrom('**a**', '!'), '!!a!!');
      expect(star.replaceFrom('**a**', '!!'), '!!!!a!!!!');
      expect(star.replaceFrom('a*b*c', ''), 'abc');
      expect(star.replaceFrom('a*b*c', '!'), 'a!b!c');
      expect(star.replaceFrom('a*b*c', '!!'), 'a!!b!!c');
      expect(star.replaceFrom('a**b**c', ''), 'abc');
      expect(star.replaceFrom('a**b**c', '!'), 'a!!b!!c');
      expect(star.replaceFrom('a**b**c', '!!'), 'a!!!!b!!!!c');
    });
    test('removeFrom', () {
      expect(star.removeFrom(''), '');
      expect(star.removeFrom('*'), '');
      expect(star.removeFrom('**'), '');
      expect(star.removeFrom('*a'), 'a');
      expect(star.removeFrom('*a*'), 'a');
      expect(star.removeFrom('*a*b'), 'ab');
      expect(star.removeFrom('*a*b*'), 'ab');
      expect(star.removeFrom('a*b*'), 'ab');
      expect(star.removeFrom('ab*'), 'ab');
      expect(star.removeFrom('ab'), 'ab');
    });
    test('retainFrom', () {
      expect(star.retainFrom(''), '');
      expect(star.retainFrom('*'), '*');
      expect(star.retainFrom('**'), '**');
      expect(star.retainFrom('*a'), '*');
      expect(star.retainFrom('*a*'), '**');
      expect(star.retainFrom('*a*b'), '**');
      expect(star.retainFrom('*a*b*'), '***');
      expect(star.retainFrom('a*b*'), '**');
      expect(star.retainFrom('ab*'), '*');
      expect(star.retainFrom('ab'), '');
    });
    test('trimFrom', () {
      expect(star.trimFrom(''), '');
      expect(star.trimFrom('*'), '');
      expect(star.trimFrom('**'), '');
      expect(star.trimFrom('*a'), 'a');
      expect(star.trimFrom('**a'), 'a');
      expect(star.trimFrom('*ab'), 'ab');
      expect(star.trimFrom('a*'), 'a');
      expect(star.trimFrom('a**'), 'a');
      expect(star.trimFrom('ab*'), 'ab');
      expect(star.trimFrom('*a*'), 'a');
      expect(star.trimFrom('**a**'), 'a');
      expect(star.trimFrom('*ab*'), 'ab');
    });
    test('trimLeadingFrom', () {
      expect(star.trimLeadingFrom(''), '');
      expect(star.trimLeadingFrom('*'), '');
      expect(star.trimLeadingFrom('**'), '');
      expect(star.trimLeadingFrom('*a'), 'a');
      expect(star.trimLeadingFrom('**a'), 'a');
      expect(star.trimLeadingFrom('*ab'), 'ab');
      expect(star.trimLeadingFrom('a*'), 'a*');
      expect(star.trimLeadingFrom('a**'), 'a**');
      expect(star.trimLeadingFrom('ab*'), 'ab*');
      expect(star.trimLeadingFrom('*a*'), 'a*');
      expect(star.trimLeadingFrom('**a**'), 'a**');
      expect(star.trimLeadingFrom('*ab*'), 'ab*');
    });
    test('trimTailingFrom', () {
      expect(star.trimTailingFrom(''), '');
      expect(star.trimTailingFrom('*'), '');
      expect(star.trimTailingFrom('**'), '');
      expect(star.trimTailingFrom('*a'), '*a');
      expect(star.trimTailingFrom('**a'), '**a');
      expect(star.trimTailingFrom('*ab'), '*ab');
      expect(star.trimTailingFrom('a*'), 'a');
      expect(star.trimTailingFrom('a**'), 'a');
      expect(star.trimTailingFrom('ab*'), 'ab');
      expect(star.trimTailingFrom('*a*'), '*a');
      expect(star.trimTailingFrom('**a**'), '**a');
      expect(star.trimTailingFrom('*ab*'), '*ab');
    });
  });
  group('pattern', () {
    const input = 'a1b2c';
    const pattern = CharMatcher.digit();
    test('allMatches()', () {
      final matches = pattern.allMatches(input);
      expect(matches.map((matcher) => matcher.pattern), [pattern, pattern]);
      expect(matches.map((matcher) => matcher.input), [input, input]);
      expect(matches.map((matcher) => matcher.start), [1, 3]);
      expect(matches.map((matcher) => matcher.end), [2, 4]);
      expect(matches.map((matcher) => matcher.groupCount), [0, 0]);
      expect(matches.map((matcher) => matcher[0]), ['1', '2']);
      expect(matches.map((matcher) => matcher.group(0)), ['1', '2']);
      expect(matches.map((matcher) => matcher.groups([0, 1])), [
        ['1', null],
        ['2', null],
      ]);
    });
    test('matchAsPrefix()', () {
      final match1 = pattern.matchAsPrefix(input);
      expect(match1, isNull);
      final match2 = pattern.matchAsPrefix(input, 1)!;
      expect(match2.pattern, pattern);
      expect(match2.input, input);
      expect(match2.start, 1);
      expect(match2.end, 2);
      expect(match2.groupCount, 0);
      expect(match2[0], '1');
      expect(match2.group(0), '1');
      expect(match2.groups([0, 1]), ['1', null]);
    });
    test('startsWith()', () {
      expect(input.startsWith(pattern), isFalse);
      expect(input.startsWith(pattern), isFalse);
      expect(input.startsWith(pattern, 1), isTrue);
      expect(input.startsWith(pattern, 2), isFalse);
      expect(input.startsWith(pattern, 3), isTrue);
      expect(input.startsWith(pattern, 4), isFalse);
    });
    test('indexOf()', () {
      expect(input.indexOf(pattern), 1);
      expect(input.indexOf(pattern), 1);
      expect(input.indexOf(pattern, 1), 1);
      expect(input.indexOf(pattern, 2), 3);
      expect(input.indexOf(pattern, 3), 3);
      expect(input.indexOf(pattern, 4), -1);
    });
    test('lastIndexOf()', () {
      expect(input.lastIndexOf(pattern), 3);
      expect(input.lastIndexOf(pattern, 0), -1);
      expect(input.lastIndexOf(pattern, 1), 1);
      expect(input.lastIndexOf(pattern, 2), 1);
      expect(input.lastIndexOf(pattern, 3), 3);
      expect(input.lastIndexOf(pattern, 4), 3);
    });
    test('contains()', () {
      expect(input.contains(pattern), isTrue);
    });
    test('replaceFirst()', () {
      expect(input.replaceFirst(pattern, '!'), 'a!b2c');
      expect(input.replaceFirst(pattern, '!'), 'a!b2c');
      expect(input.replaceFirst(pattern, '!', 1), 'a!b2c');
      expect(input.replaceFirst(pattern, '!', 2), 'a1b!c');
      expect(input.replaceFirst(pattern, '!', 3), 'a1b!c');
      expect(input.replaceFirst(pattern, '!', 4), 'a1b2c');
    });
    test('replaceFirstMapped()', () {
      expect(input.replaceFirstMapped(pattern, (match) => '!${match[0]}!'),
          'a!1!b2c');
    });
    test('replaceAll()', () {
      expect(input.replaceAll(pattern, '!'), 'a!b!c');
    });
    test('replaceAllMapped()', () {
      expect(input.replaceAllMapped(pattern, (match) => '!${match[0]}!'),
          'a!1!b!2!c');
    });
    test('split()', () {
      expect(input.split(pattern), ['a', 'b', 'c']);
    });
    test('splitMapJoin()', () {
      expect(
          input.splitMapJoin(pattern,
              onMatch: (match) => '!${match[0]}!',
              onNonMatch: (nonMatch) => '?$nonMatch?'),
          '?a?!1!?b?!2!?c?');
    });
  });
}
