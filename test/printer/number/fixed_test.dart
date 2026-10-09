import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('fixed', () {
    group('int', () {
      test('default', () {
        final printer = FixedNumberPrinter<int>();
        check(printer(0)).equals('0');
        check(printer(1234)).equals('1234');
        check(printer(-1234)).equals('-1234');
      });
      test('base', () {
        final printer = FixedNumberPrinter<int>(base: 16);
        check(printer(1234)).equals('4d2');
        check(printer(123123)).equals('1e0f3');
      });
      test('characters', () {
        final printer = FixedNumberPrinter<int>(
          base: 16,
          characters: '0123456789ABCDEF'.split(''),
        );
        check(printer(1234)).equals('4D2');
        check(printer(123123)).equals('1E0F3');
      });
      test('padding', () {
        final printer = FixedNumberPrinter<int>(padding: 3);
        check(printer(1)).equals('001');
        check(printer(-12)).equals('-012');
      });
      test('separator', () {
        final printer = FixedNumberPrinter<int>(separator: '.');
        check(printer(1234)).equals('1.234');
        check(printer(1234567)).equals('1.234.567');
      });
      test('separator width', () {
        final printer = FixedNumberPrinter<int>(
          base: 2,
          separator: '_',
          separatorWidth: 8,
        );
        check(printer(1234)).equals('100_11010010');
        check(printer(1234567)).equals('10010_11010110_10000111');
      });
      test('separator offset', () {
        final printer = FixedNumberPrinter<int>(
          base: 8,
          separator: '*',
          separatorWidth: 4,
          separatorOffset: 2,
        );
        check(printer(1234)).equals('23*22');
        check(printer(1234567)).equals('4*5532*07');
      });
      test('sign', () {
        final printer = FixedNumberPrinter<int>(
          sign: const SignNumberPrinter<int>.negativeAndPositiveSign(),
        );
        check(printer(0)).equals('+0');
        check(printer(1234)).equals('+1234');
        check(printer(-1234)).equals('-1234');
      });
    });
    group('double', () {
      test('precision: 0', () {
        final printer = FixedNumberPrinter<double>();
        check(printer(1.4)).equals('1');
        check(printer(1.5)).equals('2');
        check(printer(-1.4)).equals('-1');
        check(printer(-1.5)).equals('-2');
      });
      test('precision: 2', () {
        final printer = FixedNumberPrinter<double>(precision: 2);
        check(printer(1.009)).equals('1.01');
        check(printer(1.01)).equals('1.01');
        check(printer(1.019)).equals('1.02');
        check(printer(1.25)).equals('1.25');
        check(printer(1.254)).equals('1.25');
        check(printer(1.256)).equals('1.26');
        check(printer(1.009)).equals('1.01');
        check(printer(0.9)).equals('0.90');
        check(printer(0.99)).equals('0.99');
        check(printer(0.999)).equals('1.00');
        check(printer(0.9999)).equals('1.00');
        check(printer(-0.9)).equals('-0.90');
        check(printer(-0.99)).equals('-0.99');
        check(printer(-0.999)).equals('-1.00');
        check(printer(-0.9999)).equals('-1.00');
      });
      test('infinite', () {
        final printer = FixedNumberPrinter<double>();
        check(printer(double.infinity)).equals('Infinity');
        check(printer(double.negativeInfinity)).equals('-Infinity');
      });
      test('infinite custom', () {
        final printer = FixedNumberPrinter<double>(infinity: 'Huge');
        check(printer(double.infinity)).equals('Huge');
        check(printer(double.negativeInfinity)).equals('-Huge');
      });
      test('NaN', () {
        final printer = FixedNumberPrinter<double>();
        check(printer(double.nan)).equals('NaN');
      });
      test('NaN custom', () {
        final printer = FixedNumberPrinter<double>(nan: 'Not a Number');
        check(printer(double.nan)).equals('Not a Number');
      });
      test('separator', () {
        final printer = FixedNumberPrinter<double>(
          precision: 8,
          separator: '!',
        );
        check(printer(12345.0)).equals('12!345.000!000!00');
        check(printer(0.6789)).equals('0.678!900!00');
      });
      test('separator width and offset', () {
        final printer = FixedNumberPrinter<double>(
          base: 2,
          precision: 16,
          separator: '_',
          separatorWidth: 8,
          separatorOffset: 4,
        );
        check(printer(12345.0)).equals('11_00000011_1001.0000_00000000_0000');
        check(printer(0.6789)).equals('0.1010_11011100_1100');
      });
      test('sign', () {
        final printer = FixedNumberPrinter<double>(
          precision: 1,
          sign: const SignNumberPrinter<double>.negativeAndPositiveSign(),
        );
        check(printer(-1)).equals('-1.0');
        check(printer(0)).equals('+0.0');
        check(printer(1)).equals('+1.0');
      });
    });
    group('numeral systems', () {
      const allNumeralSystems = {
        'adlam': NumeralSystem.adlam,
        'ahom': NumeralSystem.ahom,
        'arabicIndic': NumeralSystem.arabicIndic,
        'balinese': NumeralSystem.balinese,
        'bengali': NumeralSystem.bengali,
        'bhaiksuki': NumeralSystem.bhaiksuki,
        'brahmi': NumeralSystem.brahmi,
        'chakma': NumeralSystem.chakma,
        'cham': NumeralSystem.cham,
        'devanagari': NumeralSystem.devanagari,
        'divesAkuru': NumeralSystem.divesAkuru,
        'extendedArabicIndic': NumeralSystem.extendedArabicIndic,
        'fullwidth': NumeralSystem.fullwidth,
        'gujarati': NumeralSystem.gujarati,
        'gunjalaGondi': NumeralSystem.gunjalaGondi,
        'gurmukhi': NumeralSystem.gurmukhi,
        'hanifiRohingya': NumeralSystem.hanifiRohingya,
        'javanese': NumeralSystem.javanese,
        'kannada': NumeralSystem.kannada,
        'kawi': NumeralSystem.kawi,
        'kayahLi': NumeralSystem.kayahLi,
        'khmer': NumeralSystem.khmer,
        'khudawadi:': NumeralSystem.khudawadi,
        'lao': NumeralSystem.lao,
        'latin': NumeralSystem.latin,
        'lepcha': NumeralSystem.lepcha,
        'limbu': NumeralSystem.limbu,
        'lowerCaseLatin': NumeralSystem.lowerCaseLatin,
        'malayalam': NumeralSystem.malayalam,
        'masaramGondi': NumeralSystem.masaramGondi,
        'mathematicalBold': NumeralSystem.mathematicalBold,
        'mathematicalDoubleStruck': NumeralSystem.mathematicalDoubleStruck,
        'mathematicalMonospace': NumeralSystem.mathematicalMonospace,
        'mathematicalSansSerif': NumeralSystem.mathematicalSansSerif,
        'mathematicalSansSerifBold': NumeralSystem.mathematicalSansSerifBold,
        'meeteiMayek': NumeralSystem.meeteiMayek,
        'modi': NumeralSystem.modi,
        'mongolian': NumeralSystem.mongolian,
        'mro': NumeralSystem.mro,
        'myanmar': NumeralSystem.myanmar,
        'myanmarShan': NumeralSystem.myanmarShan,
        'myanmarTaiLaing': NumeralSystem.myanmarTaiLaing,
        'nagMundari': NumeralSystem.nagMundari,
        'newTaiLue': NumeralSystem.newTaiLue,
        'newa': NumeralSystem.newa,
        'nko': NumeralSystem.nko,
        'nyiakengPuachueHmong': NumeralSystem.nyiakengPuachueHmong,
        'olChiki': NumeralSystem.olChiki,
        'oriya': NumeralSystem.oriya,
        'osmanya': NumeralSystem.osmanya,
        'pahawhHmong': NumeralSystem.pahawhHmong,
        'saurashtra': NumeralSystem.saurashtra,
        'segmented': NumeralSystem.segmented,
        'sharada': NumeralSystem.sharada,
        'sinhalaLith': NumeralSystem.sinhalaLith,
        'soraSompeng': NumeralSystem.soraSompeng,
        'sundanese': NumeralSystem.sundanese,
        'taiThamHora': NumeralSystem.taiThamHora,
        'taiThamTham': NumeralSystem.taiThamTham,
        'takri': NumeralSystem.takri,
        'tamil': NumeralSystem.tamil,
        'tangsa': NumeralSystem.tangsa,
        'telugu': NumeralSystem.telugu,
        'thai': NumeralSystem.thai,
        'tibetan': NumeralSystem.tibetan,
        'tirhuta': NumeralSystem.tirhuta,
        'upperCaseLatin': NumeralSystem.upperCaseLatin,
        'vai': NumeralSystem.vai,
        'wancho': NumeralSystem.wancho,
        'warangCiti': NumeralSystem.warangCiti,
      };
      for (final MapEntry(key: name, value: characters)
          in allNumeralSystems.entries) {
        test(name, () {
          check(
            because: 'Expect numeral systems to support base 10.',
            characters,
          ).length.isGreaterOrEqual(10);
          check(
            because: 'Expect each digit to not be empty.',
            characters,
          ).every((c) => c.length.isGreaterOrEqual(1));
          final printer = FixedNumberPrinter<num>(
            characters: characters,
            base: characters.length,
            precision: 10,
          );
          check(printer(pi)).length.isGreaterOrEqual(12);
        });
      }
    });
    test('toString', () {
      final printer = FixedNumberPrinter<num>();
      check(printer.toString()).startsWith('FixedNumberPrinter<num>');
    });
  });
}
