// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'package:characters/characters.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

import 'data/normalization_data.dart';

void verifyUnicodeNormalization(
  NormalizationForm form,
  Iterable<int> source,
  Iterable<int> expected,
) {
  final sourceString = String.fromCharCodes(source);
  final actualString = sourceString.normalize(form: form);
  final expectedString = String.fromCharCodes(expected);
  if (actualString == expectedString) {
    expect(actualString, expectedString);
  } else {
    formatCharCodes(Iterable<int> charCodes) => charCodes
        .map((code) => code.toRadixString(16).padLeft(4, '0'))
        .join(' ');
    expect(
      actualString,
      expectedString,
      reason:
          'for "$sourceString" [${formatCharCodes(source)}]\n'
          'expected "$expectedString" [${formatCharCodes(expected)}],\n'
          'but got "$actualString" [${formatCharCodes(actualString.runes)}].',
    );
  }
}

void main() {
  group('toList', () {
    const emptyString = '';
    const plentyString = 'Banana🍌';
    group('immutable standard', () {
      final empty = emptyString.toList();
      final plenty = plentyString.toList();
      test('isEmpty', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 8);
      });
      test('reading', () {
        expect(plenty[0], 'B');
        expect(plenty[1], 'a');
        expect(plenty[2], 'n');
        expect(plenty[3], 'a');
        expect(plenty[4], 'n');
        expect(plenty[5], 'a');
        expect(plenty[6], '\ud83c');
        expect(plenty[7], '\udf4c');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[8], throwsRangeError);
      });
      test('converting', () {
        expect(empty.toList(), isEmpty);
        expect(plenty.toList(), [
          'B',
          'a',
          'n',
          'a',
          'n',
          'a',
          '\ud83c',
          '\udf4c',
        ]);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), {'B', 'a', 'n', '\ud83c', '\udf4c'});
        expect(empty.toString(), emptyString);
        expect(plenty.toString(), plentyString);
      });
      test('read-only', () {
        expect(() => plenty[0] = 'a', throwsUnsupportedError);
        expect(() => plenty.length = 10, throwsUnsupportedError);
        expect(() => plenty.add('a'), throwsUnsupportedError);
        expect(() => plenty.remove('a'), throwsUnsupportedError);
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plentyString.substring(5));
        expect(plenty.sublist(5, 7).toString(), plentyString.substring(5, 7));
      });
    });
    group('mutable standard', () {
      final empty = emptyString.toList(mutable: true);
      final plenty = plentyString.toList(mutable: true);
      test('isEmpty', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 8);
      });
      test('reading', () {
        expect(plenty[0], 'B');
        expect(plenty[1], 'a');
        expect(plenty[2], 'n');
        expect(plenty[3], 'a');
        expect(plenty[4], 'n');
        expect(plenty[5], 'a');
        expect(plenty[6], '\ud83c');
        expect(plenty[7], '\udf4c');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[8], throwsRangeError);
      });
      test('writing', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable[1] = 'd';
        expect(mutable.toString(), 'adc');
      });
      test('writing (range error)', () {
        expect(() => empty[0] = 'a', throwsRangeError);
        expect(() => plenty[-1] = 'a', throwsRangeError);
        expect(() => plenty[9] = 'a', throwsRangeError);
      });
      test('writing (argument error)', () {
        expect(() => plenty[0] = '🍌', throwsArgumentError);
      });
      test('adding', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.add('d');
        expect(mutable.toString(), 'abcd');
      });
      test('removing', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.remove('a');
        expect(mutable.toString(), 'bc');
      });
      test('converting', () {
        expect(empty.toList(), isEmpty);
        expect(plenty.toList(), [
          'B',
          'a',
          'n',
          'a',
          'n',
          'a',
          '\ud83c',
          '\udf4c',
        ]);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), {'B', 'a', 'n', '\ud83c', '\udf4c'});
        expect(empty.toString(), emptyString);
        expect(plenty.toString(), plentyString);
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plentyString.substring(5));
        expect(plenty.sublist(5, 7).toString(), plentyString.substring(5, 7));
      });
    });
    group('immutable unicode', () {
      final empty = emptyString.toList(unicode: true);
      final plenty = plentyString.toList(unicode: true);
      test('isEmpty', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 7);
      });
      test('reading', () {
        expect(plenty[0], 'B');
        expect(plenty[1], 'a');
        expect(plenty[2], 'n');
        expect(plenty[3], 'a');
        expect(plenty[4], 'n');
        expect(plenty[5], 'a');
        expect(plenty[6], '🍌');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[9], throwsRangeError);
      });
      test('converting', () {
        expect(empty.toList(), isEmpty);
        expect(plenty.toList(), ['B', 'a', 'n', 'a', 'n', 'a', '🍌']);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), ['B', 'a', 'n', '🍌']);
        expect(empty.toString(), emptyString);
        expect(plenty.toString(), plentyString);
      });
      test('read-only', () {
        expect(() => plenty[0] = 'a', throwsUnsupportedError);
        expect(() => plenty.length = 10, throwsUnsupportedError);
        expect(() => plenty.add('a'), throwsUnsupportedError);
        expect(() => plenty.remove('a'), throwsUnsupportedError);
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plentyString.substring(5));
        expect(plenty.sublist(5, 7).toString(), plentyString.substring(5, 8));
      });
    });
    group('mutable unicode', () {
      final empty = emptyString.toList(mutable: true, unicode: true);
      final plenty = plentyString.toList(mutable: true, unicode: true);
      test('creating', () {
        final coerced = '123'.toList(mutable: true, unicode: true);
        expect(coerced.length, 3);
        expect(coerced.toString(), '123');
      });
      test('isEmpty', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 7);
      });
      test('reading', () {
        expect(plenty[0], 'B');
        expect(plenty[1], 'a');
        expect(plenty[2], 'n');
        expect(plenty[3], 'a');
        expect(plenty[4], 'n');
        expect(plenty[5], 'a');
        expect(plenty[6], '🍌');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[9], throwsRangeError);
      });
      test('writing', () {
        final mutable = 'abc'.toList(mutable: true, unicode: true);
        mutable[1] = '🍌';
        expect(mutable.toString(), 'a🍌c');
      });
      test('writing (range error)', () {
        expect(() => empty[0] = 'a', throwsRangeError);
        expect(() => plenty[-1] = 'a', throwsRangeError);
        expect(() => plenty[9] = 'a', throwsRangeError);
      });
      test('writing (argument error)', () {
        expect(() => plenty[0] = 'ab', throwsArgumentError);
      });
      test('adding', () {
        final mutable = 'abc'.toList(mutable: true, unicode: true);
        mutable.add('🍌');
        expect(mutable.toString(), 'abc🍌');
      });
      test('removing', () {
        final mutable = '🍇🍌🍓'.toList(mutable: true, unicode: true);
        mutable.remove('🍌');
        expect(mutable.toString(), '🍇🍓');
      });
      test('converting', () {
        expect(empty.toList(), isEmpty);
        expect(plenty.toList(), ['B', 'a', 'n', 'a', 'n', 'a', '🍌']);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), ['B', 'a', 'n', '🍌']);
        expect(empty.toString(), emptyString);
        expect(plenty.toString(), plentyString);
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plentyString.substring(5));
        expect(plenty.sublist(5, 7).toString(), plentyString.substring(5, 8));
      });
    });
  });
  group('partition', () {
    final regexp = RegExp(r',+');
    group('partition', () {
      test('string', () {
        expect('123,456,789'.partition(','), ['123', ',', '456,789']);
        expect('123;456;789'.partition(','), ['123;456;789', '', '']);
      });
      test('regexp', () {
        expect('123,,456,,789'.partition(regexp), ['123', ',,', '456,,789']);
        expect('123;;456;;789'.partition(regexp), ['123;;456;;789', '', '']);
      });
      test('start', () {
        expect('123,456,789'.partition(',', 3), ['123', ',', '456,789']);
        expect('123,456,789'.partition(',', 6), ['123,456', ',', '789']);
        expect('123,456,789'.partition(',', 9), ['123,456,789', '', '']);
      });
    });
    group('last partition', () {
      test('string', () {
        expect('123,456,789'.lastPartition(','), ['123,456', ',', '789']);
        expect('123;456;789'.lastPartition(','), ['', '', '123;456;789']);
      });
      test('regexp', () {
        expect('123,,456,,789'.lastPartition(regexp), [
          '123,,456,',
          ',',
          '789',
        ]);
        expect('123;;456;;789'.lastPartition(regexp), [
          '',
          '',
          '123;;456;;789',
        ]);
      });
      test('start', () {
        expect('123,456,789'.lastPartition(',', 2), ['', '', '123,456,789']);
        expect('123,456,789'.lastPartition(',', 5), ['123', ',', '456,789']);
        expect('123,456,789'.lastPartition(',', 7), ['123,456', ',', '789']);
      });
    });
  });
  group('remove prefix', () {
    test('string', () {
      expect('abcd'.removePrefix(''), 'abcd');
      expect('abcd'.removePrefix('a'), 'bcd');
      expect('abcd'.removePrefix('ab'), 'cd');
      expect('abcd'.removePrefix('abc'), 'd');
      expect('abcd'.removePrefix('abcd'), '');
      expect('abcd'.removePrefix('bcd'), 'abcd');
      expect('abcd'.removePrefix('xyz'), 'abcd');
    });
    test('regexp', () {
      expect('abcd'.removePrefix(RegExp('')), 'abcd');
      expect('abcd'.removePrefix(RegExp('a')), 'bcd');
      expect('abcd'.removePrefix(RegExp('ab')), 'cd');
      expect('abcd'.removePrefix(RegExp('abc')), 'd');
      expect('abcd'.removePrefix(RegExp('abcd')), '');
      expect('abcd'.removePrefix(RegExp('bcd')), 'abcd');
      expect('abcd'.removePrefix(RegExp('xyz')), 'abcd');
    });
  });
  group('remove suffix', () {
    test('string', () {
      expect('abcd'.removeSuffix(''), 'abcd');
      expect('abcd'.removeSuffix('d'), 'abc');
      expect('abcd'.removeSuffix('cd'), 'ab');
      expect('abcd'.removeSuffix('bcd'), 'a');
      expect('abcd'.removeSuffix('abcd'), '');
      expect('abcd'.removeSuffix('abc'), 'abcd');
      expect('abcd'.removeSuffix('xyz'), 'abcd');
    });
    test('regexp', () {
      expect('abcd'.removeSuffix(RegExp('')), 'abcd');
      expect('abcd'.removeSuffix(RegExp('d')), 'abc');
      expect('abcd'.removeSuffix(RegExp('cd')), 'ab');
      expect('abcd'.removeSuffix(RegExp('bcd')), 'a');
      expect('abcd'.removeSuffix(RegExp('abcd')), '');
      expect('abcd'.removeSuffix(RegExp('abc')), 'abcd');
      expect('abcd'.removeSuffix(RegExp('xyz')), 'abcd');
    });
  });
  group('converters', () {
    test('convert first character', () {
      expect(
        ''.convertFirstCharacters((value) {
          fail('Not supposed to be called');
        }),
        '',
      );
      expect(
        'a'.convertFirstCharacters((value) {
          expect(value, 'a');
          return 'A';
        }),
        'A',
      );
      expect(
        'ab'.convertFirstCharacters((value) {
          expect(value, 'a');
          return 'A';
        }),
        'Ab',
      );
      expect(
        'abc'.convertFirstCharacters((value) {
          expect(value, 'a');
          return 'A';
        }),
        'Abc',
      );
    });
    test('convert first two characters', () {
      expect(
        ''.convertFirstCharacters((value) {
          fail('Not supposed to be called');
        }, count: 2),
        '',
      );
      expect(
        'a'.convertFirstCharacters((value) {
          fail('Not supposed to be called');
        }, count: 2),
        'a',
      );
      expect(
        'ab'.convertFirstCharacters((value) {
          expect(value, 'ab');
          return '*';
        }, count: 2),
        '*',
      );
      expect(
        'abc'.convertFirstCharacters((value) {
          expect(value, 'ab');
          return '*';
        }, count: 2),
        '*c',
      );
    });
    test('convert last character', () {
      expect(
        ''.convertLastCharacters((value) {
          fail('Not supposed to be called');
        }),
        '',
      );
      expect(
        'a'.convertLastCharacters((value) {
          expect(value, 'a');
          return 'A';
        }),
        'A',
      );
      expect(
        'ab'.convertLastCharacters((value) {
          expect(value, 'b');
          return 'B';
        }),
        'aB',
      );
      expect(
        'abc'.convertLastCharacters((value) {
          expect(value, 'c');
          return 'C';
        }),
        'abC',
      );
    });
    test('convert last two characters', () {
      expect(
        ''.convertLastCharacters((value) {
          fail('Not supposed to be called');
        }, count: 2),
        '',
      );
      expect(
        'a'.convertLastCharacters((value) {
          fail('Not supposed to be called');
        }, count: 2),
        'a',
      );
      expect(
        'ab'.convertLastCharacters((value) {
          expect(value, 'ab');
          return '*';
        }, count: 2),
        '*',
      );
      expect(
        'abc'.convertLastCharacters((value) {
          expect(value, 'bc');
          return '*';
        }, count: 2),
        'a*',
      );
    });
    test('convert first character to upper-case', () {
      expect(''.toUpperCaseFirstCharacter(), '');
      expect('a'.toUpperCaseFirstCharacter(), 'A');
      expect('ab'.toUpperCaseFirstCharacter(), 'Ab');
      expect('abc'.toUpperCaseFirstCharacter(), 'Abc');
    });
    test('convert first character to lower-case', () {
      expect(''.toLowerCaseFirstCharacter(), '');
      expect('A'.toLowerCaseFirstCharacter(), 'a');
      expect('AB'.toLowerCaseFirstCharacter(), 'aB');
      expect('ABC'.toLowerCaseFirstCharacter(), 'aBC');
    });
  });
  group('indent', () {
    test('default', () {
      expect(''.indent('*'), '');
      expect('foo'.indent('*'), '*foo');
      expect('foo\nbar'.indent('*'), '*foo\n*bar');
      expect('foo\n\nbar'.indent('*'), '*foo\n\n*bar');
      expect(' zork '.indent('*'), '*zork');
    });
    test('firstPrefix', () {
      expect(''.indent('*', firstPrefix: '!'), '');
      expect('foo'.indent('*', firstPrefix: '!'), '!foo');
      expect('foo\nbar'.indent('*', firstPrefix: '!'), '!foo\n*bar');
      expect('foo\n\nbar'.indent('*', firstPrefix: '!'), '!foo\n\n*bar');
      expect(' zork '.indent('*', firstPrefix: '!'), '!zork');
    });
    test('trimWhitespace', () {
      expect(''.indent('*', trimWhitespace: false), '');
      expect('foo'.indent('*', trimWhitespace: false), '*foo');
      expect('foo\nbar'.indent('*', trimWhitespace: false), '*foo\n*bar');
      expect('foo\n\nbar'.indent('*', trimWhitespace: false), '*foo\n\n*bar');
      expect(' zork '.indent('*', trimWhitespace: false), '* zork ');
    });
    test('indentEmpty', () {
      expect(''.indent('*', indentEmpty: true), '*');
      expect('foo'.indent('*', indentEmpty: true), '*foo');
      expect('foo\nbar'.indent('*', indentEmpty: true), '*foo\n*bar');
      expect('foo\n\nbar'.indent('*', indentEmpty: true), '*foo\n*\n*bar');
      expect(' zork '.indent('*', indentEmpty: true), '*zork');
    });
  });
  group('dedent', () {
    test('default', () {
      expect(''.dedent(), '');
      expect('1\n2'.dedent(), '1\n2');
      expect('1\n\n2'.dedent(), '1\n\n2');
      expect(' 1\n\n 2'.dedent(), '1\n\n2');
      expect(' 1\n\n\t2'.dedent(), ' 1\n\n\t2');
      expect(' 1'.dedent(), '1');
      expect(' 1\n  2'.dedent(), '1\n 2');
      expect('  2\n 1'.dedent(), ' 2\n1');
      expect(' 1\n  2\n   3'.dedent(), '1\n 2\n  3');
      expect('   3\n  2\n 1'.dedent(), '  3\n 2\n1');
    });
    test('whitespace', () {
      expect(''.dedent(whitespace: '\t'), '');
      expect('1\n2'.dedent(whitespace: '\t'), '1\n2');
      expect('1\n\n2'.dedent(whitespace: '\t'), '1\n\n2');
      expect('\t1\n\n\t2'.dedent(whitespace: '\t'), '1\n\n2');
      expect('\t1'.dedent(whitespace: '\t'), '1');
      expect('\t1\n\t\t2'.dedent(whitespace: '\t'), '1\n\t2');
      expect('\t\t2\n\t1'.dedent(whitespace: '\t'), '\t2\n1');
      expect('\t1\n\t\t2\n\t\t\t3'.dedent(whitespace: '\t'), '1\n\t2\n\t\t3');
      expect('\t\t\t3\n\t\t2\n\t1'.dedent(whitespace: '\t'), '\t\t3\n\t2\n1');
    });
    test('ignoreEmpty', () {
      expect(''.dedent(ignoreEmpty: false), '');
      expect('1\n2'.dedent(ignoreEmpty: false), '1\n2');
      expect('1\n\n2'.dedent(ignoreEmpty: false), '1\n\n2');
      expect(' 1\n\n 2'.dedent(ignoreEmpty: false), ' 1\n\n 2');
      expect(' 1'.dedent(ignoreEmpty: false), '1');
      expect(' 1\n  2'.dedent(ignoreEmpty: false), '1\n 2');
      expect('  2\n 1'.dedent(ignoreEmpty: false), ' 2\n1');
      expect(' 1\n  2\n   3'.dedent(ignoreEmpty: false), '1\n 2\n  3');
      expect('   3\n  2\n 1'.dedent(ignoreEmpty: false), '  3\n 2\n1');
    });
  });
  group('take/skip', () {
    test('take', () {
      expect('abc'.take(0), '');
      expect('abc'.take(1), 'a');
      expect('abc'.take(2), 'ab');
      expect('abc'.take(3), 'abc');
      expect('abc'.take(4), 'abc');
    });
    test('takeTo', () {
      expect('abc'.takeTo('a'), '');
      expect('abc'.takeTo('b'), 'a');
      expect('abc'.takeTo('c'), 'ab');
      expect('abc'.takeTo('d'), 'abc');
    });
    test('takeLast', () {
      expect('abc'.takeLast(0), '');
      expect('abc'.takeLast(1), 'c');
      expect('abc'.takeLast(2), 'bc');
      expect('abc'.takeLast(3), 'abc');
      expect('abc'.takeLast(4), 'abc');
    });
    test('takeLastTo', () {
      expect('abc'.takeLastTo('a'), 'bc');
      expect('abc'.takeLastTo('b'), 'c');
      expect('abc'.takeLastTo('c'), '');
      expect('abc'.takeLastTo('d'), 'abc');
    });
    test('skip', () {
      expect('abc'.skip(0), 'abc');
      expect('abc'.skip(1), 'bc');
      expect('abc'.skip(2), 'c');
      expect('abc'.skip(3), '');
      expect('abc'.skip(4), '');
    });
    test('skipTo', () {
      expect('abc'.skipTo('a'), 'bc');
      expect('abc'.skipTo('b'), 'c');
      expect('abc'.skipTo('c'), '');
      expect('abc'.skipTo('d'), '');
    });
    test('skipLast', () {
      expect('abc'.skipLast(0), 'abc');
      expect('abc'.skipLast(1), 'ab');
      expect('abc'.skipLast(2), 'a');
      expect('abc'.skipLast(3), '');
      expect('abc'.skipLast(4), '');
    });
    test('skipLastTo', () {
      expect('abc'.skipLastTo('a'), '');
      expect('abc'.skipLastTo('b'), 'a');
      expect('abc'.skipLastTo('c'), 'ab');
      expect('abc'.skipLastTo('d'), '');
    });
  });
  group('wrap', () {
    test('default', () {
      expect('a'.wrap(4), 'a');
      expect('a b'.wrap(4), 'a b');
      expect('a b c'.wrap(4), 'a b\nc');
      expect('aa bb cc'.wrap(4), 'aa\nbb\ncc');
      expect('a\nb'.wrap(4), 'a\nb');
      expect('a\n\nb'.wrap(4), 'a\n\nb');
      expect('1234'.wrap(4), '1234');
      expect('12345'.wrap(4), '1234\n5');
      expect('12345678'.wrap(4), '1234\n5678');
      expect('123456789'.wrap(4), '1234\n5678\n9');
    });
    test('whitespace', () {
      const whitespace = ' ';
      expect('a'.wrap(4, whitespace: whitespace), 'a');
      expect('a b'.wrap(4, whitespace: whitespace), 'a b');
      expect('a  b'.wrap(4, whitespace: whitespace), 'a b');
      expect('a b c'.wrap(4, whitespace: whitespace), 'a b\nc');
      expect('aa bb cc'.wrap(4, whitespace: whitespace), 'aa\nbb\ncc');
      expect('a\nb'.wrap(4, whitespace: whitespace), 'a\nb');
      expect('1234'.wrap(4, whitespace: whitespace), '1234');
      expect('12345'.wrap(4, whitespace: whitespace), '1234\n5');
      expect('12345678'.wrap(4, whitespace: whitespace), '1234\n5678');
      expect('123456789'.wrap(4, whitespace: whitespace), '1234\n5678\n9');
    });
    test('breakLongWords', () {
      expect('a'.wrap(4, breakLongWords: false), 'a');
      expect('a b'.wrap(4, breakLongWords: false), 'a b');
      expect('a b c'.wrap(4, breakLongWords: false), 'a b\nc');
      expect('aa bb cc'.wrap(4, breakLongWords: false), 'aa\nbb\ncc');
      expect('a\nb'.wrap(4, breakLongWords: false), 'a\nb');
      expect('1234'.wrap(4, breakLongWords: false), '1234');
      expect('12345'.wrap(4, breakLongWords: false), '12345');
      expect('12345678'.wrap(4, breakLongWords: false), '12345678');
      expect('123456789'.wrap(4, breakLongWords: false), '123456789');
    });
    test('invalid', () {
      expect(() => 'a'.wrap(-1), throwsRangeError);
      expect(() => 'a'.wrap(0), throwsRangeError);
    });
  });
  group('unwrap', () {
    test('single', () {
      expect('1'.unwrap(), '1');
      expect('1\n2'.unwrap(), '1 2');
      expect('1\n2\n3'.unwrap(), '1 2 3');
    });
    test('multiple', () {
      expect('1\n\na'.unwrap(), '1\n\na');
      expect('1\n2\n\na\nb'.unwrap(), '1 2\n\na b');
      expect('1\n2\n3\n\na\nb\nc'.unwrap(), '1 2 3\n\na b c');
    });
  });
  group('normalization', () {
    final invariants = 0
        .to(0x10ffff)
        .toSet()
        .difference(
          normalizationTestData['@Part1']!
              .map((test) => test.source.single)
              .toSet(),
        )
        .map((value) => [value]);
    group('NFC', () {
      const form = NormalizationForm.nfc;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, 'élève'.runes, 'élève'.runes);
        verifyUnicodeNormalization(form, '한국'.runes, '한국'.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ﬃ'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfc);
            verifyUnicodeNormalization(form, test.nfc, test.nfc);
            verifyUnicodeNormalization(form, test.nfd, test.nfc);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkc);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkc);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });
    group('NFD', () {
      const form = NormalizationForm.nfd;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, 'élève'.runes, 'élève'.runes);
        verifyUnicodeNormalization(form, '한국'.runes, '한국'.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ﬃ'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfd);
            verifyUnicodeNormalization(form, test.nfc, test.nfd);
            verifyUnicodeNormalization(form, test.nfd, test.nfd);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkd);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkd);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });
    group('NFKC', () {
      const form = NormalizationForm.nfkc;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ffi'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfkc);
            verifyUnicodeNormalization(form, test.nfc, test.nfkc);
            verifyUnicodeNormalization(form, test.nfd, test.nfkc);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkc);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkc);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });
    group('NFKD', () {
      const form = NormalizationForm.nfkd;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, '⑴'.runes, '(1)'.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ffi'.runes);
        verifyUnicodeNormalization(form, '²'.runes, '2'.runes);
        verifyUnicodeNormalization(form, '⑴ ﬃ ²'.runes, '(1) ffi 2'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfkd);
            verifyUnicodeNormalization(form, test.nfc, test.nfkd);
            verifyUnicodeNormalization(form, test.nfd, test.nfkd);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkd);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkd);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });
  });
  group('chunked', () {
    test('string', () {
      expect(''.chunked(2), isEmpty);
      expect('a'.chunked(2), ['a']);
      expect('ab'.chunked(2), ['ab']);
      expect('abc'.chunked(2), ['ab', 'c']);
      expect('abcd'.chunked(2), ['ab', 'cd']);
      expect('abcde'.chunked(2), ['ab', 'cd', 'e']);
      expect(() => 'abc'.chunked(0), throwsRangeError);
    });
    test('characters', () {
      expect(''.characters.chunked(2), isEmpty);
      expect('a'.characters.chunked(2), ['a'.characters]);
      expect('ab'.characters.chunked(2), ['ab'.characters]);
      expect('abc'.characters.chunked(2), ['ab'.characters, 'c'.characters]);
      expect('abcd'.characters.chunked(2), ['ab'.characters, 'cd'.characters]);
      expect('abcde'.characters.chunked(2), [
        'ab'.characters,
        'cd'.characters,
        'e'.characters,
      ]);
      expect(() => 'abc'.characters.chunked(0), throwsRangeError);
    });
  });
}
