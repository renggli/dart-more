// ignore_for_file: deprecated_member_use_from_same_package

import 'package:more/more.dart';
import 'package:test/test.dart';

void verify(CharMatcher matcher, String included, String excluded,
    {bool negate = true}) {
  for (final iterator = included.runes.iterator; iterator.moveNext();) {
    expect(matcher.match(iterator.current), isTrue,
        reason: '${unicodeCodePointPrinter(iterator.current)} should match');
  }
  for (final iterator = excluded.runes.iterator; iterator.moveNext();) {
    expect(matcher.match(iterator.current), isFalse,
        reason:
            '${unicodeCodePointPrinter(iterator.current)} should not match');
  }
  expect(matcher.everyOf(included), isTrue,
      reason: 'all of "$included" should match');
  expect(matcher.noneOf(excluded), isTrue,
      reason: 'none of "$excluded" should match');
  if (negate) verify(~matcher, excluded, included, negate: false);
}

void main() {
  group('basic', () {
    test('any', () {
      verify(const CharMatcher.any(), 'abc123_!@# 💩', '');
      verify(const CharMatcher.any(), '👱🧑🏼', '');
    });
    test('none', () {
      verify(const CharMatcher.none(), '', 'abc123_!@# 💩');
      verify(const CharMatcher.none(), '', '👱🧑🏼');
    });
    test('isChar', () {
      verify(CharMatcher.isChar('*'), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar('👱'), '👱', 'abc123_!@# 💩');
    });
    test('isChar number', () {
      verify(CharMatcher.isChar(42), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar(42.0), '*', 'abc123_!@# ');
    });
    test('isChar invalid', () {
      expect(() => CharMatcher.isChar('ab'), throwsArgumentError,
          reason: 'multiple characters');
      expect(() => CharMatcher.isChar('🧑🏼'), throwsArgumentError,
          reason: 'composite emoji');
    });
    test('inRange', () {
      verify(CharMatcher.inRange('a', 'c'), 'abc', 'def123_!@# ');
    });
    test('ascii', () {
      verify(const CharMatcher.ascii(), 'def123_!@#', '\u2665');
    });
    test('digit', () {
      verify(const CharMatcher.digit(), '0123456789', 'abc_!@# ');
    });
    test('letter', () {
      verify(const CharMatcher.letter(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '123_!@# ');
    });
    test('lowerCaseLetter', () {
      verify(const CharMatcher.lowerCaseLetter(), 'abcdefghijklmnopqrstuvwxyz',
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ123_!@# ');
    });
    test('upperCaseLetter', () {
      verify(const CharMatcher.upperCaseLetter(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz123_!@# ');
    });
    test('letterOrDigit', () {
      verify(
          const CharMatcher.letterOrDigit(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_',
          '!@# ');
    });
    test('whitespace', () {
      final string = String.fromCharCodes([
        9,
        10,
        11,
        12,
        13,
        32,
        133,
        160,
        5760,
        8192,
        8193,
        8194,
        8195,
        8196,
        8197,
        8198,
        8199,
        8200,
        8201,
        8202,
        8232,
        8233,
        8239,
        8287,
        12288,
      ]);
      verify(const CharMatcher.whitespace(), string, 'abcABC_!@#\u0000');
    });
  });
  group('unicode', () {
    test('control', () {
      verify(
          const CharMatcher.control(),
          '\u{13}\u{b}\u{9c}\u{8}\u{11}\u{8d}\u{8a}\u{17}\u{91}\u{10}',
          '012abcABC_!@# ');
    });
    test('format', () {
      verify(
          const CharMatcher.format(),
          '\u{206a}\u{200c}\u{feff}\u{e0053}\u{200f}\u{e0031}\u{e0030}',
          '012abcABC_!@# ');
    });
    test('privateUse', () {
      verify(
          const CharMatcher.privateUse(),
          '\u{f384a}\u{100e70}\u{1010a4}\u{10c920}\u{1090f4}\u{f280d}\u{fccb9}',
          '012abcABC_!@# ');
    });
    test('surrogate', () {
      for (final code in [0xd851, 0xd97c, 0xdcc4, 0xd96c, 0xded6, 0xd948]) {
        expect(const CharMatcher.surrogate().match(code), isTrue);
      }
    });
    test('unassigned', () {
      verify(const CharMatcher.unassigned(),
          '\u{0590}\u{05ff}\u{07bf}\u{10fff}', '012ABC_!@# \u{feff}\u{fe70}');
    });
    test('letterLowercase', () {
      // 𝼀, 𝒿, ᵹ, 𐐴, ꞿ, ъ, ꟶ, ꚕ, ꞟ, 𝕤
      verify(
          const CharMatcher.letterLowercase(),
          '\u{1df00}\u{1d4bf}\u{1d79}\u{10434}\u{a7bf}\u{44a}\u{a7f6}\u{a695}',
          '012ABC_!@# ');
    });
    test('letterModifier', () {
      // ߵ, ᶯ, ₖ, ᵢ, 𖭁, 𖿡, 𞁃, ࣉ, ᶩ, ꚝ
      verify(
          const CharMatcher.letterModifier(),
          '\u{7f5}\u{1daf}\u{2096}\u{1d62}\u{16b41}\u{16fe1}\u{1e043}\u{8c9}',
          '012abcABC_!@# ');
    });
    test('letterOther', () {
      // 𪞉, 鮁, ജ, 𨖫, 䵅, ᗎ, 𤳾, 㢎, 𢓧, 𧫀
      verify(
          const CharMatcher.letterOther(),
          '\u{2a789}\u{9b81}\u{d1c}\u{285ab}\u{4d45}\u{15ce}\u{24cfe}\u{388e}',
          '012abcABC_!@# ');
    });
    test('letterTitlecase', () {
      // ǅ, ᾞ, ᾫ, ᾮ, ᾙ, ᾌ, ǈ, ᾭ, ᾝ, ᾜ
      verify(
          const CharMatcher.letterTitlecase(),
          '\u{1c5}\u{1f9e}\u{1fab}\u{1fae}\u{1f99}\u{1f8c}\u{1c8}\u{1fad}',
          '012abcABC_!@# ');
    });
    test('letterUppercase', () {
      // Ɨ, 𐐌, 𝔒, ϔ, Ꮉ, Ⴊ, Ｑ, 𝑵, 𝕳, Ҵ
      verify(
          const CharMatcher.letterUppercase(),
          '\u{197}\u{1040c}\u{1d512}\u{3d4}\u{13b9}\u{10aa}\u{ff31}\u{1d475}',
          '012abc_!@# ');
    });
    test('markSpacingCombining', () {
      // ೖ, 𑤱, 𑧤, 𖽫, 𖽜, 𑶔, 〮, 𑧓, ឿ, ೕ
      verify(
          const CharMatcher.markSpacingCombining(),
          '\u{cd6}\u{11931}\u{119e4}\u{16f6b}\u{16f5c}\u{11d94}\u{302e}',
          '012abcABC_!@# ');
    });
    test('markEnclosing', () {
      // ⃟, ⃠, ⃝, ꙲, ⃞, ꙱, ҈, ꙰, ⃣, ⃢
      verify(
          const CharMatcher.markEnclosing(),
          '\u{20df}\u{20e0}\u{20dd}\u{a672}\u{20de}\u{a671}\u{488}\u{a670}',
          '012abcABC_!@# ');
    });
    test('markNonSpacing', () {
      // ఼, ᝳ, ྵ, ᩛ, ꪿, 󠄩, 𑒸, ૿, ۢ, ਂ
      verify(
          const CharMatcher.markNonSpacing(),
          '\u{c3c}\u{1773}\u{fb5}\u{1a5b}\u{aabf}\u{e0129}\u{114b8}\u{aff}',
          '012abcABC_!@# ');
    });
    test('numberDecimalDigit', () {
      // 𑣦, 𝟖, 𝟟, 𑃴, 🯶, ꘣, 𑇑, ᪙, ๕, ६
      verify(
          const CharMatcher.numberDecimalDigit(),
          '\u{118e6}\u{1d7d6}\u{1d7df}\u{110f4}\u{1fbf6}\u{a623}\u{111d1}',
          'abcABC_!@# ');
    });
    test('numberLetter', () {
      // ⅵ, 𐍁, 𐏒, 𐅝, 𒐛, ⅴ, 𐅐, ᛮ, 𒑛, 𐅤
      verify(
          const CharMatcher.numberLetter(),
          '\u{2175}\u{10341}\u{103d2}\u{1015d}\u{1241b}\u{2174}\u{10150}',
          '012abcABC_!@# ');
    });
    test('numberOther', () {
      // 𞱶, ❷, 𐢧, 𐌢, ൝, ൱, 𑿎, 𐣻, 𐤘, 𞣏
      verify(
          const CharMatcher.numberOther(),
          '\u{1ec76}\u{2777}\u{108a7}\u{10322}\u{d5d}\u{d71}\u{11fce}',
          '012abcABC_!@# ');
    });
    test('punctuationConnector', () {
      // ︴, _, ﹎, ﹍, ⁔, ⁀, ﹏, ＿, ‿, ︳
      verify(
          const CharMatcher.punctuationConnector(),
          '\u{fe34}\u{5f}\u{fe4e}\u{fe4d}\u{2054}\u{2040}\u{fe4f}\u{ff3f}',
          '012abcABC!@# ');
    });
    test('punctuationDash', () {
      // ⸗, ᠆, ⸚, 〜, 〰, ―, ⹀, —, ⸻, 𐺭
      verify(
          const CharMatcher.punctuationDash(),
          '\u{2e17}\u{1806}\u{2e1a}\u{301c}\u{3030}\u{2015}\u{2e40}\u{2014}',
          '012abcABC_!@# ');
    });
    test('punctuationClose', () {
      // 〞, ⁾, ❩, ⧽, ）, 』, ⁆, ︶, ⦔, ⟧
      verify(
          const CharMatcher.punctuationClose(),
          '\u{301e}\u{207e}\u{2769}\u{29fd}\u{ff09}\u{300f}\u{2046}\u{fe36}',
          '012abcABC_!@# ');
    });
    test('punctuationFinalQuote', () {
      // ⸍, ⸃, ⸝, ›, ⸊, ⸡, ⸅, ’, ”, »
      verify(
          const CharMatcher.punctuationFinalQuote(),
          '\u{2e0d}\u{2e03}\u{2e1d}\u{203a}\u{2e0a}\u{2e21}\u{2e05}\u{2019}',
          '012abcABC_!@# ');
    });
    test('punctuationInitialQuote', () {
      // ⸌, ‟, ⸜, «, ⸂, ⸉, ⸄, ‹, ⸠, “
      verify(
          const CharMatcher.punctuationInitialQuote(),
          '\u{2e0c}\u{201f}\u{2e1c}\u{ab}\u{2e02}\u{2e09}\u{2e04}\u{2039}',
          '012abcABC_!@# ');
    });
    test('punctuationOther', () {
      // ⳻, ᠊, ။, ᪩, 𑗕, ¶, ࠺, 𖺗, ꩝, '
      verify(
          const CharMatcher.punctuationOther(),
          '\u{2cfb}\u{180a}\u{104b}\u{1aa9}\u{115d5}\u{b6}\u{83a}\u{16e97}',
          '012abcABC_ ');
    });
    test('punctuationOpen', () {
      // ︿, ︵, ⸦, ⹂, 〝, ⸨, ❰, ｟, ⹙, 〈
      verify(
          const CharMatcher.punctuationOpen(),
          '\u{fe3f}\u{fe35}\u{2e26}\u{2e42}\u{301d}\u{2e28}\u{2770}\u{ff5f}',
          '012abcABC_!@# ');
    });
    test('symbolCurrency', () {
      // $, £, ￡, ₻, ₿, ₠, €, ₵, ﹩, ￥
      verify(
          const CharMatcher.symbolCurrency(),
          '\u{24}\u{a3}\u{ffe1}\u{20bb}\u{20bf}\u{20a0}\u{20ac}\u{20b5}',
          '012abcABC_!@# ');
    });
    test('symbolModifier', () {
      // ꜋, ˫, `, ﮷, ꜕, ﯀, ᾿, ˓, ꜖, ῎
      verify(
          const CharMatcher.symbolModifier(),
          '\u{a70b}\u{2eb}\u{60}\u{fbb7}\u{a715}\u{fbc0}\u{1fbf}\u{2d3}',
          '012abcABC_!@# ');
    });
    test('symbolMath', () {
      // ⊺, ≎, ≫, ＋, ⊚, ⨜, ⩙, ⬽, ⏜, ⩑
      verify(
          const CharMatcher.symbolMath(),
          '\u{22ba}\u{224e}\u{226b}\u{ff0b}\u{229a}\u{2a1c}\u{2a59}\u{2b3d}',
          '012abcABC_!@# ');
    });
    test('symbolOther', () {
      // 𝈷, ╖, 🌾, 𐅹, ☛, 🀟, 🀛, ⍰, 𝉁, 𐆜
      verify(
          const CharMatcher.symbolOther(),
          '\u{1d237}\u{2556}\u{1f33e}\u{10179}\u{261b}\u{1f01f}\u{1f01b}',
          '012abcABC_!@# ');
    });
    test('separatorLine', () {
      verify(const CharMatcher.separatorLine(), '\u{2028}', '012abcABC_!@# ');
    });
    test('separatorParagraph', () {
      verify(
          const CharMatcher.separatorParagraph(), '\u{2029}', '012abcABC_!@# ');
    });
    test('separatorSpace', () {
      verify(
          const CharMatcher.separatorSpace(),
          '\u{2008}\u{2007}\u{202f}\u{2005}\u{2000}\u{2001}\u{2006}\u{2002}',
          '012abcABC_!@#');
    });
  });
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
  group('patterns', () {
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
      verify(
          CharMatcher.pattern('\u0000\uffff'), '\u0000\uffff', '\u0001\ufffe');
    });
    test('class subtraction', () {
      verify(CharMatcher.pattern('a-z-[aeiuo]'), 'bcdfghjklmnpqrstvwxyz',
          '123aeiuo');
      verify(CharMatcher.pattern('^1234-[3456]'), 'abc7890', '123456');
      verify(CharMatcher.pattern('0-9-[0-6-[0-3]]'), '0123789', 'abc456');
    });
  });
  group('operators', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    const letter = CharMatcher.letter();
    const digit = CharMatcher.digit();
    const whitespace = CharMatcher.whitespace();
    final hex = CharMatcher.pattern('0-9a-f');
    final even = CharMatcher.pattern('02468');
    test('~ (negation)', () {
      expect(~any, equals(none));
      expect(~none, equals(any));
      expect(~~whitespace, equals(whitespace));
    });
    test('| (disjunctive)', () {
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
    test('& (conjunctive)', () {
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
    }, onPlatform: {
      'js': const Skip('String.replaceAll(Pattern) UNIMPLEMENTED')
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
