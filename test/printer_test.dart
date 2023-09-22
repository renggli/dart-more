// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/feature.dart';
import 'package:more/math.dart';
import 'package:more/printer.dart';
import 'package:more/temporal.dart';
import 'package:more/tuple.dart';
import 'package:test/test.dart';

const standardString = Printer<String>.standard();
const standardInt = Printer<int>.standard();

const lorem = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce '
    'euismod varius nisi ac vulputate. Suspendisse potenti. Donec nisi eros, '
    'venenatis et tristique mollis, pretium luctus tortor. In id ipsum diam. '
    'Nulla turpis odio, faucibus id egestas iaculis, lacinia a est. Aliquam ut '
    'ipsum ex. Maecenas ac nisl ante. Ut porta est fermentum maximus aliquet. '
    'Aenean aliquam nisl felis, ac bibendum felis dictum at. Nullam a commodo '
    'felis, vel faucibus ante. Fusce convallis maximus magna, eu interdum '
    'tortor consequat vitae. Donec at hendrerit tellus.';

void main() {
  group('standard', () {
    test('untyped', () {
      const printer = Printer<Object?>.standard();
      expect(printer(123), '123');
      expect(printer('abc'), 'abc');
    });
    test('typed', () {
      const printer = Printer<num>.standard();
      expect(printer(123), '123');
      expect(printer(123.4), '123.4');
    });
    test('toString', () {
      const printer = Printer<double>.standard();
      expect(printer.toString(), startsWith('StandardPrinter<double>'));
    });
  });
  group('literal', () {
    test('default', () {
      const printer = Printer<int>.literal();
      expect(printer(123), '');
    });
    test('untyped', () {
      const printer = Printer<Object?>.literal('hello');
      expect(printer(123), 'hello');
      expect(printer('abc'), 'hello');
    });
    test('typed', () {
      const printer = Printer<num>.literal('hello');
      expect(printer(123), 'hello');
      expect(printer(123.4), 'hello');
    });
    test('toString', () {
      const printer = Printer<double>.literal('hello');
      expect(printer.toString(), startsWith('LiteralPrinter<double>'));
    });
  });
  group('sign', () {
    group('int', () {
      test('default', () {
        const printer = SignNumberPrinter<int>();
        expect(printer(-1), '-');
        expect(printer(1), '');
      });
      test('custom', () {
        const printer = SignNumberPrinter<int>(
          negative: Printer.literal('--'),
          positive: Printer.literal('++'),
        );
        expect(printer(-1), '--');
        expect(printer(1), '++');
      });
      test('omitPositiveSign', () {
        const printer = SignNumberPrinter<int>.omitPositiveSign();
        expect(printer(-1), '-');
        expect(printer(1), '');
      });
      test('spacePositiveSign', () {
        const printer = SignNumberPrinter<int>.spacePositiveSign();
        expect(printer(-1), '-');
        expect(printer(1), ' ');
      });
      test('negativeAndPositiveSign', () {
        const printer = SignNumberPrinter<int>.negativeAndPositiveSign();
        expect(printer(-1), '-');
        expect(printer(1), '+');
      });
    });
    group('double', () {
      test('default', () {
        const printer = SignNumberPrinter<double>();
        expect(printer(-1.1), '-');
        expect(printer(1.1), '');
      });
      test('custom', () {
        const printer = SignNumberPrinter<double>(
          negative: Printer.literal('--'),
          positive: Printer.literal('++'),
        );
        expect(printer(-1.1), '--');
        expect(printer(1.1), '++');
      });
      test('omitPositiveSign', () {
        const printer = SignNumberPrinter<double>.omitPositiveSign();
        expect(printer(-1.1), '-');
        expect(printer(1.1), '');
      });
      test('spacePositiveSign', () {
        const printer = SignNumberPrinter<double>.spacePositiveSign();
        expect(printer(-1.1), '-');
        expect(printer(1.1), ' ');
      });
      test('negativeAndPositiveSign', () {
        const printer = SignNumberPrinter<double>.negativeAndPositiveSign();
        expect(printer(-1.1), '-');
        expect(printer(1.1), '+');
      });
    });
    test('toString', () {
      const printer = SignNumberPrinter<num>.negativeAndPositiveSign();
      expect(
          printer.toString(),
          'SignNumberPrinter<num>{'
          'negative=LiteralPrinter<Never>{value=-}, '
          'positive=LiteralPrinter<Never>{value=+}}');
    });
  });
  group('fixed', () {
    group('int', () {
      test('default', () {
        final printer = FixedNumberPrinter<int>();
        expect(printer(0), '0');
        expect(printer(1234), '1234');
        expect(printer(-1234), '-1234');
      });
      test('base', () {
        final printer = FixedNumberPrinter<int>(base: 16);
        expect(printer(1234), '4d2');
        expect(printer(123123), '1e0f3');
      });
      test('characters', () {
        final printer = FixedNumberPrinter<int>(
            base: 16, characters: '0123456789ABCDEF'.split(''));
        expect(printer(1234), '4D2');
        expect(printer(123123), '1E0F3');
      });
      test('padding', () {
        final printer = FixedNumberPrinter<int>(padding: 3);
        expect(printer(1), '001');
        expect(printer(-12), '-012');
      });
      test('separator', () {
        final printer = FixedNumberPrinter<int>(separator: '.');
        expect(printer(1234), '1.234');
        expect(printer(1234567), '1.234.567');
      });
      test('sign', () {
        final printer = FixedNumberPrinter<int>(
            sign: const SignNumberPrinter<int>.negativeAndPositiveSign());
        expect(printer(0), '+0');
        expect(printer(1234), '+1234');
        expect(printer(-1234), '-1234');
      });
    });
    group('double', () {
      test('precision: 0', () {
        final printer = FixedNumberPrinter<double>();
        expect(printer(1.4), '1');
        expect(printer(1.5), '2');
        expect(printer(-1.4), '-1');
        expect(printer(-1.5), '-2');
      });
      test('precision: 2', () {
        final printer = FixedNumberPrinter<double>(precision: 2);
        expect(printer(1.009), '1.01');
        expect(printer(1.01), '1.01');
        expect(printer(1.019), '1.02');
        expect(printer(1.25), '1.25');
        expect(printer(1.254), '1.25');
        expect(printer(1.256), '1.26');
        expect(printer(1.009), '1.01');
        expect(printer(0.9), '0.90');
        expect(printer(0.99), '0.99');
        expect(printer(0.999), '1.00');
        expect(printer(0.9999), '1.00');
        expect(printer(-0.9), '-0.90');
        expect(printer(-0.99), '-0.99');
        expect(printer(-0.999), '-1.00');
        expect(printer(-0.9999), '-1.00');
      });
      test('infinite', () {
        final printer = FixedNumberPrinter<double>();
        expect(printer(double.infinity), 'Infinity');
        expect(printer(double.negativeInfinity), '-Infinity');
      });
      test('infinite custom', () {
        final printer = FixedNumberPrinter<double>(infinity: 'Huge');
        expect(printer(double.infinity), 'Huge');
        expect(printer(double.negativeInfinity), '-Huge');
      });
      test('NaN', () {
        final printer = FixedNumberPrinter<double>();
        expect(printer(double.nan), 'NaN');
      });
      test('NaN custom', () {
        final printer = FixedNumberPrinter<double>(nan: 'Not a Number');
        expect(printer(double.nan), 'Not a Number');
      });
      test('separator', () {
        final printer =
            FixedNumberPrinter<double>(precision: 8, separator: '!');
        expect(printer(12345.0), '12!345.000!000!00');
        expect(printer(0.6789), '0.678!900!00');
      });
      test('sign', () {
        final printer = FixedNumberPrinter<double>(
            precision: 1,
            sign: const SignNumberPrinter<double>.negativeAndPositiveSign());
        expect(printer(-1), '-1.0');
        expect(printer(0), '+0.0');
        expect(printer(1), '+1.0');
      });
    });
    group('numeral systems', () {
      const allNumeralSystems = {
        #lowerCaseLatin: NumeralSystem.lowerCaseLatin,
        #upperCaseLatin: NumeralSystem.upperCaseLatin,
        #arabicIndic: NumeralSystem.arabicIndic,
        #extendedArabicIndic: NumeralSystem.extendedArabicIndic,
        #nko: NumeralSystem.nko,
        #devanagari: NumeralSystem.devanagari,
        #bengali: NumeralSystem.bengali,
        #gurmukhi: NumeralSystem.gurmukhi,
        #gujarati: NumeralSystem.gujarati,
        #oriya: NumeralSystem.oriya,
        #tamil: NumeralSystem.tamil,
        #telugu: NumeralSystem.telugu,
        #kannada: NumeralSystem.kannada,
        #malayalam: NumeralSystem.malayalam,
        #sinhalaLith: NumeralSystem.sinhalaLith,
        #thai: NumeralSystem.thai,
        #lao: NumeralSystem.lao,
        #tibetan: NumeralSystem.tibetan,
        #myanmar: NumeralSystem.myanmar,
        #myanmarShan: NumeralSystem.myanmarShan,
        #khmer: NumeralSystem.khmer,
        #mongolian: NumeralSystem.mongolian,
        #limbu: NumeralSystem.limbu,
        #newTaiLue: NumeralSystem.newTaiLue,
        #taiThaamHora: NumeralSystem.taiThaamHora,
        #taiThamTham: NumeralSystem.taiThamTham,
        #balinese: NumeralSystem.balinese,
        #sundanese: NumeralSystem.sundanese,
        #lepcha: NumeralSystem.lepcha,
        #olChiki: NumeralSystem.olChiki,
        #vai: NumeralSystem.vai,
        #saurashtra: NumeralSystem.saurashtra,
        #kayahLi: NumeralSystem.kayahLi,
        #javanese: NumeralSystem.javanese,
        #myanmarTatLaing: NumeralSystem.myanmarTatLaing,
        #cham: NumeralSystem.cham,
        #meeteiMayek: NumeralSystem.meeteiMayek,
        #fullwidth: NumeralSystem.fullwidth,
        #osmanya: NumeralSystem.osmanya,
        #hanifiRohigya: NumeralSystem.hanifiRohigya,
        #brahmi: NumeralSystem.brahmi,
        #soraSompeng: NumeralSystem.soraSompeng,
        #chakma: NumeralSystem.chakma,
        #sharada: NumeralSystem.sharada,
        #khudawadi: NumeralSystem.khudawadi,
        #newa: NumeralSystem.newa,
        #tirhuta: NumeralSystem.tirhuta,
        #modi: NumeralSystem.modi,
        #takri: NumeralSystem.takri,
        #ahom: NumeralSystem.ahom,
        #warangCiti: NumeralSystem.warangCiti,
        #divesAkuru: NumeralSystem.divesAkuru,
        #bhaiksuki: NumeralSystem.bhaiksuki,
        #masaramGondi: NumeralSystem.masaramGondi,
        #gunjalaGondi: NumeralSystem.gunjalaGondi,
        #mro: NumeralSystem.mro,
        #tangsa: NumeralSystem.tangsa,
        #pahawhHmong: NumeralSystem.pahawhHmong,
        #mathematicalBold: NumeralSystem.mathematicalBold,
        #mathematicalDoubleStruck: NumeralSystem.mathematicalDoubleStruck,
        #mathematicalSansSerif: NumeralSystem.mathematicalSansSerif,
        #mathematicalSansSerifBold: NumeralSystem.mathematicalSansSerifBold,
        #mathematicalMonospace: NumeralSystem.mathematicalMonospace,
        #nyiakengPuachueHmong: NumeralSystem.nyiakengPuachueHmong,
        #wancho: NumeralSystem.wancho,
        #adlam: NumeralSystem.adlam,
        #segmented: NumeralSystem.segmented,
      };
      final random = Random(42);
      for (final entry in allNumeralSystems.entries) {
        test(entry.key, () {
          expect(entry.value, hasLength(greaterThanOrEqualTo(10)),
              reason: 'Expect numeral systems to support base 10.');
          expect(entry.value, everyElement(hasLength(greaterThanOrEqualTo(1))),
              reason: 'Expect each digit to not be empty.');
          final printer = FixedNumberPrinter<num>(
              characters: entry.value, base: entry.value.length, precision: 10);
          expect(printer(random.nextDouble()),
              hasLength(greaterThanOrEqualTo(12)));
        });
      }
    });
    test('toString', () {
      final printer = FixedNumberPrinter<num>();
      expect(printer.toString(), startsWith('FixedNumberPrinter<num>'));
    });
  });
  group('scientific', () {
    test('default', () {
      final printer = ScientificNumberPrinter();
      expect(printer(0), '0.000e0');
      expect(printer(2), '2.000e0');
      expect(printer(300), '3.000e2');
      expect(printer(4321.768), '4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '6.720e9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('base', () {
      final printer = ScientificNumberPrinter(base: 16);
      expect(printer(0), '0.000e0');
      expect(printer(2), '2.000e0');
      expect(printer(300), '1.2c0e2');
      expect(printer(4321.768), '1.0e2e3');
      expect(printer(-53000), '-c.f08e3');
      expect(printer(6720000000), '1.909e8');
      expect(printer(0.2), '3.333e-1');
      expect(printer(0.00000000751), '2.041e-7');
    });
    test('characters', () {
      final printer = ScientificNumberPrinter(
          base: 16, characters: '0123456789ABCDEF'.split(''));
      expect(printer(0), '0.000e0');
      expect(printer(2), '2.000e0');
      expect(printer(300), '1.2C0e2');
      expect(printer(4321.768), '1.0E2e3');
      expect(printer(-53000), '-C.F08e3');
      expect(printer(6720000000), '1.909e8');
      expect(printer(0.2), '3.333e-1');
      expect(printer(0.00000000751), '2.041e-7');
    });
    test('delimiter', () {
      final printer = ScientificNumberPrinter(delimiter: ',');
      expect(printer(0), '0,000e0');
      expect(printer(2), '2,000e0');
      expect(printer(300), '3,000e2');
      expect(printer(4321.768), '4,322e3');
      expect(printer(-53000), '-5,300e4');
      expect(printer(6720000000), '6,720e9');
      expect(printer(0.2), '2,000e-1');
      expect(printer(0.00000000751), '7,510e-9');
    });
    test('exponentPadding', () {
      final printer = ScientificNumberPrinter(exponentPadding: 3);
      expect(printer(0), '0.000e000');
      expect(printer(2), '2.000e000');
      expect(printer(300), '3.000e002');
      expect(printer(4321.768), '4.322e003');
      expect(printer(-53000), '-5.300e004');
      expect(printer(6720000000), '6.720e009');
      expect(printer(0.2), '2.000e-001');
      expect(printer(0.00000000751), '7.510e-009');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('exponentSign', () {
      final printer = ScientificNumberPrinter(
          exponentSign: const SignNumberPrinter.negativeAndPositiveSign());
      expect(printer(0), '0.000e+0');
      expect(printer(2), '2.000e+0');
      expect(printer(300), '3.000e+2');
      expect(printer(4321.768), '4.322e+3');
      expect(printer(-53000), '-5.300e+4');
      expect(printer(6720000000), '6.720e+9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
    });
    test('infinity', () {
      final printer = ScientificNumberPrinter(infinity: 'huge');
      expect(printer(0), '0.000e0');
      expect(printer(2), '2.000e0');
      expect(printer(300), '3.000e2');
      expect(printer(4321.768), '4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '6.720e9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
    });
    test('mantissaPadding', () {
      final printer = ScientificNumberPrinter(mantissaPadding: 3);
      expect(printer(0), '000.000e0');
      expect(printer(2), '002.000e0');
      expect(printer(300), '003.000e2');
      expect(printer(4321.768), '004.322e3');
      expect(printer(-53000), '-005.300e4');
      expect(printer(6720000000), '006.720e9');
      expect(printer(0.2), '002.000e-1');
      expect(printer(0.00000000751), '007.510e-9');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('mantissaSign', () {
      final printer = ScientificNumberPrinter(
          mantissaSign: const SignNumberPrinter.negativeAndPositiveSign());
      expect(printer(0), '+0.000e0');
      expect(printer(2), '+2.000e0');
      expect(printer(300), '+3.000e2');
      expect(printer(4321.768), '+4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '+6.720e9');
      expect(printer(0.2), '+2.000e-1');
      expect(printer(0.00000000751), '+7.510e-9');
    });
    test('nan', () {
      final printer = ScientificNumberPrinter(nan: 'n/a');
      expect(printer(0), '0.000e0');
      expect(printer(2), '2.000e0');
      expect(printer(300), '3.000e2');
      expect(printer(4321.768), '4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '6.720e9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
    });
    test('notation', () {
      final printer = ScientificNumberPrinter(notation: 'E');
      expect(printer(0), '0.000E0');
      expect(printer(2), '2.000E0');
      expect(printer(300), '3.000E2');
      expect(printer(4321.768), '4.322E3');
      expect(printer(-53000), '-5.300E4');
      expect(printer(6720000000), '6.720E9');
      expect(printer(0.2), '2.000E-1');
      expect(printer(0.00000000751), '7.510E-9');
    });
    test('precision', () {
      final printer = ScientificNumberPrinter(precision: 6);
      expect(printer(0), '0.000000e0');
      expect(printer(2), '2.000000e0');
      expect(printer(300), '3.000000e2');
      expect(printer(4321.768), '4.321768e3');
      expect(printer(-53000), '-5.300000e4');
      expect(printer(6720000000), '6.720000e9');
      expect(printer(0.2), '2.000000e-1');
      expect(printer(0.00000000751), '7.510000e-9');
    });
    test('separator', () {
      final printer =
          ScientificNumberPrinter(precision: 4, separator: ',', significant: 4);
      expect(printer(0), '0.000,0e0');
      expect(printer(2), '2,000.000,0e-3');
      expect(printer(300), '3,000.000,0e-1');
      expect(printer(4321.768), '4,321.768,0e0');
      expect(printer(-53000), '-5,300.000,0e1');
      expect(printer(6720000000), '6,720.000,0e6');
      expect(printer(0.2), '2,000.000,0e-4');
      expect(printer(0.00000000751), '7,510.000,0e-12');
    });
    test('significant', () {
      final printer = ScientificNumberPrinter(significant: 3);
      expect(printer(0), '0.000e0');
      expect(printer(2), '200.000e-2');
      expect(printer(300), '300.000e0');
      expect(printer(4321.768), '432.177e1');
      expect(printer(-53000), '-530.000e2');
      expect(printer(6720000000), '672.000e7');
      expect(printer(0.2), '200.000e-3');
      expect(printer(0.00000000751), '751.000e-11');
    });
    test('toString', () {
      final printer = ScientificNumberPrinter();
      expect(printer.toString(), startsWith('ScientificNumberPrinter<num>'));
    });
  });
  group('ordinal', () {
    test('default', () {
      final printer = OrdinalNumberPrinter();
      expect(printer(0), '0th');
      expect(printer(1), '1st');
      expect(printer(2), '2nd');
      expect(printer(3), '3rd');
      expect(printer(4), '4th');
      expect(printer(10), '10th');
      expect(printer(11), '11th');
      expect(printer(12), '12th');
      expect(printer(13), '13th');
      expect(printer(14), '14th');
      expect(printer(20), '20th');
      expect(printer(21), '21st');
      expect(printer(22), '22nd');
      expect(printer(23), '23rd');
      expect(printer(24), '24th');
    });
    test('toString', () {
      final printer = OrdinalNumberPrinter();
      expect(printer.toString(), startsWith('OrdinalNumberPrinter'));
    });
  });
  group('human', () {
    group('decimal', () {
      test('default', () {
        final printer = HumanNumberPrinter.decimal();
        expect(printer(0), '0');
        expect(printer(10), '10');
        expect(printer(200), '200');
        expect(printer(3000), '3 k');
        expect(printer(4e4), '40 k');
        expect(printer(-5e5), '-500 k');
        expect(printer(-6e6), '-6 M');
        expect(printer(7e-7), '700 n');
        expect(printer(8e-8), '80 n');
        expect(printer(-9e-9), '-9 n');
        expect(printer(-1e-10), '-100 p');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.decimal(nan: 'n/a');
        expect(printer(double.nan), 'n/a');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.decimal(infinity: 'huge');
        expect(printer(double.infinity), 'huge');
        expect(printer(double.negativeInfinity), '-huge');
      });
      test('unitPrefix', () {
        final printer = HumanNumberPrinter.decimal(unitPrefix: true);
        expect(printer(4), '4');
        expect(printer(4e3), 'k 4');
        expect(printer(4e7), 'M 40');
        expect(printer(-4), '-4');
        expect(printer(-4e3), 'k -4');
        expect(printer(-4e7), 'M -40');
      });
      test('unitSeparator', () {
        final printer = HumanNumberPrinter.decimal(unitSeparator: '*');
        expect(printer(4), '4');
        expect(printer(4e3), '4*k');
        expect(printer(4e7), '40*M');
        expect(printer(-4), '-4');
        expect(printer(-4e3), '-4*k');
        expect(printer(-4e7), '-40*M');
      });
      test('long (double)', () {
        final base = 1000.toDouble();
        final printer = HumanNumberPrinter.decimal(long: true);
        final units = List.generate(19, (i) => printer(base.pow(i - 9)));
        expect(units, [
          '0 yocto',
          '1 yocto',
          '1 zepto',
          '1 atto',
          '1 femto',
          '1 pico',
          '1 nano',
          '1 micro',
          '1 milli',
          '1',
          '1 kilo',
          '1 mega',
          '1 giga',
          '1 tera',
          '1 peta',
          '1 exa',
          '1 zetta',
          '1 yotta',
          '1000 yotta',
        ]);
      });
    });
    group('binary', () {
      test('default', () {
        final printer = HumanNumberPrinter.binary();
        expect(printer(0), '0');
        expect(printer(10), '10');
        expect(printer(200), '200');
        expect(printer(3000), '3 Ki');
        expect(printer(4e4), '39 Ki');
        expect(printer(-5e5), '-488 Ki');
        expect(printer(-6e6), '-6 Mi');
        expect(printer(7e-7), '0');
        expect(printer(-8e-8), '-0');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.binary(nan: 'n/a');
        expect(printer(double.nan), 'n/a');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.binary(infinity: 'huge');
        expect(printer(double.infinity), 'huge');
        expect(printer(double.negativeInfinity), '-huge');
      });
      test('unitPrefix', () {
        final printer = HumanNumberPrinter.binary(unitPrefix: true);
        expect(printer(4), '4');
        expect(printer(4e3), 'Ki 4');
        expect(printer(4e7), 'Mi 38');
        expect(printer(-4), '-4');
        expect(printer(-4e3), 'Ki -4');
        expect(printer(-4e7), 'Mi -38');
      });
      test('unitSeparator', () {
        final printer = HumanNumberPrinter.binary(unitSeparator: '*');
        expect(printer(4), '4');
        expect(printer(4e3), '4*Ki');
        expect(printer(4e7), '38*Mi');
        expect(printer(-4), '-4');
        expect(printer(-4e3), '-4*Ki');
        expect(printer(-4e7), '-38*Mi');
      });
      test('long (double)', () {
        final base = 1024.toDouble();
        final printer = HumanNumberPrinter.binary(long: true);
        final units = List.generate(10, (i) => printer(base.pow(i)));
        expect(units, [
          '1',
          '1 kibi',
          '1 mebi',
          '1 gibi',
          '1 tebi',
          '1 pebi',
          '1 exbi',
          '1 zebi',
          '1 yobi',
          '1024 yobi',
        ]);
      });
    });
    test('toString', () {
      final printer = HumanNumberPrinter.decimal();
      expect(printer.toString(), startsWith('HumanNumberPrinter<num>'));
    });
  });
  group('date & time', () {
    final dateTimes = [
      DateTime.utc(0),
      DateTime.utc(1980, 11, 6, 8, 25),
      DateTime.utc(1969, 7, 20, 20, 18, 4, 12),
      DateTime.utc(2023, 10, 24, 18, 8, 32, 271, 828),
    ];
    test('iso8691', () {
      final printer = DateTimePrinter.iso8691();
      expect(dateTimes.map(printer.print), [
        '0000-01-01T00:00:00.000',
        '1980-11-06T08:25:00.000',
        '1969-07-20T20:18:04.012',
        isJavaScript ? '2023-10-24T18:08:32.272' : '2023-10-24T18:08:32.271828',
      ]);
    });
    group('era', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.era());
        expect(dateTimes.map(printer.print), ['BC', 'AD', 'AD', 'AD']);
      });
    });
    group('year', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.year());
        expect(dateTimes.map(printer.print), ['0', '1980', '1969', '2023']);
      });
      test('width: 6', () {
        final printer = DateTimePrinter((builder) => builder.year(width: 6));
        expect(dateTimes.map(printer.print),
            ['000000', '001980', '001969', '002023']);
      });
    });
    group('quarter', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.quarter());
        expect(dateTimes.map(printer.print), ['1', '4', '3', '4']);
      });
      test('names', () {
        final names = ['Q1', 'Q2', 'Q3', 'Q4'];
        final printer =
            DateTimePrinter((builder) => builder.quarter(names: names));
        expect(dateTimes.map(printer.print), ['Q1', 'Q4', 'Q3', 'Q4']);
      });
    });
    group('month', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.month());
        expect(dateTimes.map(printer.print), ['1', '11', '7', '10']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.month(width: 2));
        expect(dateTimes.map(printer.print), ['01', '11', '07', '10']);
      });
      test('names', () {
        final names = 'JFMAMJJASOND'.split('');
        final printer =
            DateTimePrinter((builder) => builder.month(names: names));
        expect(dateTimes.map(printer.print), ['J', 'N', 'J', 'O']);
      });
    });
    group('weekday', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.weekday());
        expect(dateTimes.map(printer.print), ['6', '4', '7', '2']);
      });
      test('names', () {
        final names = 'MTWTFSS'.split('');
        final printer =
            DateTimePrinter((builder) => builder.weekday(names: names));
        expect(dateTimes.map(printer.print), ['S', 'T', 'S', 'T']);
      });
    });
    group('weekNumber', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.weekNumber());
        expect(dateTimes.map(printer.print), ['52', '45', '29', '43']);
      });
      test('width: 2', () {
        final printer =
            DateTimePrinter((builder) => builder.weekNumber(width: 2));
        expect(dateTimes.map(printer.print), ['52', '45', '29', '43']);
      });
    });
    group('day', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.day());
        expect(dateTimes.map(printer.print), ['1', '6', '20', '24']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.day(width: 2));
        expect(dateTimes.map(printer.print), ['01', '06', '20', '24']);
      });
    });
    group('dayOfYear', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.dayOfYear());
        expect(dateTimes.map(printer.print), ['1', '311', '201', '297']);
      });
      test('width: 3', () {
        final printer =
            DateTimePrinter((builder) => builder.dayOfYear(width: 3));
        expect(dateTimes.map(printer.print), ['001', '311', '201', '297']);
      });
    });
    group('meridiem', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.meridiem());
        expect(dateTimes.map(printer.print), ['am', 'am', 'pm', 'pm']);
      });
    });
    group('hour', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.hour());
        expect(dateTimes.map(printer.print), ['0', '8', '20', '18']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.hour(width: 2));
        expect(dateTimes.map(printer.print), ['00', '08', '20', '18']);
      });
    });
    group('hour12', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.hour12());
        expect(dateTimes.map(printer.print), ['12', '8', '8', '6']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.hour12(width: 2));
        expect(dateTimes.map(printer.print), ['12', '08', '08', '06']);
      });
    });
    group('minute', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.minute());
        expect(dateTimes.map(printer.print), ['0', '25', '18', '8']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.minute(width: 2));
        expect(dateTimes.map(printer.print), ['00', '25', '18', '08']);
      });
    });
    group('second', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.second());
        expect(dateTimes.map(printer.print), ['0', '0', '4', '32']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.second(width: 2));
        expect(dateTimes.map(printer.print), ['00', '00', '04', '32']);
      });
    });
    group('millisecond', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.millisecond());
        expect(
            dateTimes.map(printer.print),
            isJavaScript
                ? ['000', '000', '012', '272']
                : ['000', '000', '012', '271']);
      });
      test('width: 2', () {
        final printer =
            DateTimePrinter((builder) => builder.millisecond(width: 2));
        expect(dateTimes.map(printer.print), ['00', '00', '01', '27']);
      });
    });
    group('microsecond', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.microsecond());
        expect(
            dateTimes.map(printer.print),
            isJavaScript
                ? ['000', '000', '000', '000']
                : ['000', '000', '000', '828']);
      });
      test('width: 2', () {
        final printer =
            DateTimePrinter((builder) => builder.microsecond(width: 2));
        expect(dateTimes.map(printer.print),
            isJavaScript ? ['00', '00', '00', '00'] : ['00', '00', '00', '82']);
      });
      test('skipIfZero', () {
        final printer =
            DateTimePrinter((builder) => builder.microsecond(skipIfZero: true));
        expect(dateTimes.map(printer.print),
            isJavaScript ? ['', '', '', ''] : ['', '', '', '828']);
      });
    });
    test('toString', () {
      final printer = DateTimePrinter.iso8691();
      expect(printer.toString(), startsWith('DateTimePrinter'));
    });
  });
  group('duration', () {
    const durations = [
      Duration.zero,
      Duration(days: 12345),
      Duration(seconds: 123456789),
      Duration(milliseconds: 123456789),
      Duration(hours: 1, minutes: 10, microseconds: 500),
      Duration(days: 1, hours: 1, minutes: 33, microseconds: 500),
      Duration(days: -2, hours: -3, minutes: -4),
    ];
    test('dart', () {
      final printer = DurationPrinter.dart();
      expect(durations.map(printer.print),
          durations.map((duration) => duration.toString()));
    });
    test('iso8691', () {
      final printer = DurationPrinter.iso8601();
      expect(durations.map(printer.print), [
        'P0DT0S',
        'P33Y10M0DT0S',
        'P3Y11M3DT21H33M9S',
        'P1DT10H17M36.789000S',
        'P0DT1H10M0.000500S',
        'P1DT1H33M0.000500S',
        'P-2DT3H4M0S',
      ]);
    });
    group('sign', () {
      test('default', () {
        final printer = DurationPrinter((builder) => builder.sign());
        expect(durations.map(printer.print), ['', '', '', '', '', '', '-']);
      });
      test('custom', () {
        final printer = DurationPrinter((builder) =>
            builder.sign(const SignNumberPrinter.negativeAndPositiveSign()));
        expect(
            durations.map(printer.print), ['+', '+', '+', '+', '+', '+', '-']);
      });
    });
    group('part', () {
      test('default', () {
        final printer = DurationPrinter((builder) => builder
          ..part(TimeUnit.day, FixedNumberPrinter())
          ..literal('*')
          ..part(TimeUnit.minute, FixedNumberPrinter()));
        expect(durations.map(printer.print), [
          '0*0',
          '12345*0',
          '1428*1293',
          '1*617',
          '0*70',
          '1*93',
          '2*184',
        ]);
      });
      test('skipIfZero', () {
        final printer = DurationPrinter((builder) => builder
          ..part(TimeUnit.day, FixedNumberPrinter(), skipIfZero: true)
          ..literal('*')
          ..part(TimeUnit.minute, FixedNumberPrinter(), skipIfZero: true));
        expect(durations.map(printer.print), [
          '*',
          '12345*',
          '1428*1293',
          '1*617',
          '*70',
          '1*93',
          '2*184',
        ]);
      });
      test('absoluteValue', () {
        final printer = DurationPrinter((builder) => builder
          ..part(TimeUnit.day, FixedNumberPrinter(), absoluteValue: false)
          ..literal('*')
          ..part(TimeUnit.minute, FixedNumberPrinter(), absoluteValue: false));
        expect(durations.map(printer.print), [
          '0*0',
          '12345*0',
          '1428*1293',
          '1*617',
          '0*70',
          '1*93',
          '-2*-184'
        ]);
      });
    });
    group('full', () {
      test('default', () {
        final printer = DurationPrinter((builder) =>
            builder.full(TimeUnit.day, FixedNumberPrinter(precision: 6)));
        expect(durations.map(printer.print), [
          '0.000000',
          '12345.000000',
          '1428.898021',
          '1.428898',
          '0.048611',
          '1.064583',
          '-2.127778',
        ]);
      });
      test('skipIfZero', () {
        final printer = DurationPrinter((builder) => builder.full(
            TimeUnit.day, FixedNumberPrinter(precision: 6),
            skipIfZero: true));
        expect(durations.map(printer.print), [
          '',
          '12345.000000',
          '1428.898021',
          '1.428898',
          '0.048611',
          '1.064583',
          '-2.127778',
        ]);
      });
      test('absoluteValue', () {
        final printer = DurationPrinter((builder) => builder.full(
            TimeUnit.day, FixedNumberPrinter(precision: 6),
            absoluteValue: true));
        expect(durations.map(printer.print), [
          '0.000000',
          '12345.000000',
          '1428.898021',
          '1.428898',
          '0.048611',
          '1.064583',
          '2.127778',
        ]);
      });
    });
  });
  group('take/skip', () {
    test('take', () {
      final printer = standardString.take(2);
      expect(printer(''), '');
      expect(printer('a'), 'a');
      expect(printer('ab'), 'ab');
      expect(printer('abc'), 'ab');
      expect(printer('abcd'), 'ab');
      expect(printer.toString(), startsWith('TakePrinter'));
    });
    test('takeLast', () {
      final printer = standardString.takeLast(2);
      expect(printer(''), '');
      expect(printer('a'), 'a');
      expect(printer('ab'), 'ab');
      expect(printer('abc'), 'bc');
      expect(printer('abcd'), 'cd');
      expect(printer.toString(), startsWith('TakeLastPrinter'));
    });
    test('skip', () {
      final printer = standardString.skip(2);
      expect(printer(''), '');
      expect(printer('a'), '');
      expect(printer('ab'), '');
      expect(printer('abc'), 'c');
      expect(printer('abcd'), 'cd');
      expect(printer.toString(), startsWith('SkipPrinter'));
    });
    test('skipLast', () {
      final printer = standardString.skipLast(2);
      expect(printer(''), '');
      expect(printer('a'), '');
      expect(printer('ab'), '');
      expect(printer('abc'), 'a');
      expect(printer('abcd'), 'ab');
      expect(printer.toString(), startsWith('SkipLastPrinter'));
    });
  });
  group('trim', () {
    test('both', () {
      final printer = standardString.trim();
      expect(printer(''), '');
      expect(printer(' * '), '*');
      expect(printer('  **  '), '**');
    });
    test('left', () {
      final printer = standardString.trimLeft();
      expect(printer(''), '');
      expect(printer(' * '), '* ');
      expect(printer('  **  '), '**  ');
    });
    test('right', () {
      final printer = standardString.trimRight();
      expect(printer(''), '');
      expect(printer(' * '), ' *');
      expect(printer('  **  '), '  **');
    });
    test('toString', () {
      final printer = standardString.trim();
      expect(printer.toString(), startsWith('TrimBothPrinter<String>'));
    });
  });
  group('pad', () {
    test('left', () {
      final printer = standardString.padLeft(5);
      expect(printer(''), '     ');
      expect(printer('1'), '    1');
      expect(printer('12'), '   12');
      expect(printer('123'), '  123');
      expect(printer('1234'), ' 1234');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '    👋');
    });
    test('left with custom pad', () {
      final printer = standardString.padLeft(5, '*');
      expect(printer(''), '*****');
      expect(printer('1'), '****1');
      expect(printer('12'), '***12');
      expect(printer('123'), '**123');
      expect(printer('1234'), '*1234');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '****👋');
    });
    test('right', () {
      final printer = standardString.padRight(5);
      expect(printer(''), '     ');
      expect(printer('1'), '1    ');
      expect(printer('12'), '12   ');
      expect(printer('123'), '123  ');
      expect(printer('1234'), '1234 ');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '👋    ');
    });
    test('right with custom pad', () {
      final printer = standardString.padRight(5, '*');
      expect(printer(''), '*****');
      expect(printer('1'), '1****');
      expect(printer('12'), '12***');
      expect(printer('123'), '123**');
      expect(printer('1234'), '1234*');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '👋****');
    });
    test('both', () {
      final printer = standardString.padBoth(5);
      expect(printer(''), '     ');
      expect(printer('1'), '  1  ');
      expect(printer('12'), ' 12  ');
      expect(printer('123'), ' 123 ');
      expect(printer('1234'), '1234 ');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '  👋  ');
    });
    test('both with custom pad', () {
      final printer = standardString.padBoth(5, '*');
      expect(printer(''), '*****');
      expect(printer('1'), '**1**');
      expect(printer('12'), '*12**');
      expect(printer('123'), '*123*');
      expect(printer('1234'), '1234*');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '**👋**');
    });
    test('toString', () {
      final printer = standardString.padBoth(5);
      expect(printer.toString(), startsWith('PadBothPrinter<String>'));
    });
  });
  group('truncate', () {
    group('left', () {
      test('default', () {
        final printer = standardString.truncateLeft(3);
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '…34');
        expect(printer('12345'), '…45');
        expect(printer('123456'), '…56');
        expect(printer('👨👩👧👦'), '…👧👦');
      });
      test('on characters', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer =
              standardString.truncateLeft(i, method: TruncateMethod.characters);
          final result = printer(lorem);
          expect(
              result, anyOf(isEmpty, startsWith('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('on words', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer =
              standardString.truncateLeft(i, method: TruncateMethod.words);
          final result = printer(lorem);
          expect(
              result, anyOf(isEmpty, startsWith('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('on sentences', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer =
              standardString.truncateLeft(i, method: TruncateMethod.sentences);
          final result = printer(lorem);
          expect(
              result, anyOf(isEmpty, startsWith('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('with ellipsis', () {
        final printer = standardString.truncateLeft(6, ellipsis: '...');
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '1234');
        expect(printer('12345'), '12345');
        expect(printer('123456'), '123456');
        expect(printer('1234567'), '...567');
        expect(printer('12345678'), '...678');
        expect(printer('👨👩👧👦😺💩'), '👨👩👧👦😺💩');
        expect(printer('👨👩👧👦😺💩🙉'), '...😺💩🙉');
      });
    });
    group('right', () {
      test('default', () {
        final printer = standardString.truncateRight(3);
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '12…');
        expect(printer('12345'), '12…');
        expect(printer('123456'), '12…');
        expect(printer('👨👩👧👦'), '👨👩…');
      });
      test('on characters', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateRight(i,
              method: TruncateMethod.characters);
          final result = printer(lorem);
          expect(lorem, startsWith(result.removeSuffix('…')));
          expect(result, anyOf(isEmpty, endsWith('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('on words', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer =
              standardString.truncateRight(i, method: TruncateMethod.words);
          final result = printer(lorem);
          expect(lorem, startsWith(result.removeSuffix('…')));
          expect(result, anyOf(isEmpty, endsWith('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('on sentences', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer =
              standardString.truncateRight(i, method: TruncateMethod.sentences);
          final result = printer(lorem);
          expect(lorem, startsWith(result.removeSuffix('…')));
          expect(result, anyOf(isEmpty, endsWith('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('with ellipsis', () {
        final printer = standardString.truncateRight(6, ellipsis: '...');
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '1234');
        expect(printer('12345'), '12345');
        expect(printer('123456'), '123456');
        expect(printer('1234567'), '123...');
        expect(printer('12345678'), '123...');
        expect(printer('👨👩👧👦😺💩'), '👨👩👧👦😺💩');
        expect(printer('👨👩👧👦😺💩🙉'), '👨👩👧...');
      });
    });
    group('center', () {
      test('default', () {
        final printer = standardString.truncateCenter(3);
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '1…4');
        expect(printer('12345'), '1…5');
        expect(printer('123456'), '1…6');
        expect(printer('👨👩👧👦'), '👨…👦');
      });
      test('on characters', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateCenter(i,
              method: TruncateMethod.characters);
          final result = printer(lorem);
          expect(lorem, startsWith(result.takeTo('…')));
          expect(lorem, endsWith(result.skipTo('…')));
          expect(result, anyOf(isEmpty, contains('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('on words', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer =
              standardString.truncateCenter(i, method: TruncateMethod.words);
          final result = printer(lorem);
          expect(lorem, startsWith(result.takeTo('…')));
          expect(lorem, endsWith(result.skipTo('…')));
          expect(result, anyOf(isEmpty, contains('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('on sentences', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateCenter(i,
              method: TruncateMethod.sentences);
          final result = printer(lorem);
          expect(lorem, startsWith(result.takeTo('…')));
          expect(lorem, endsWith(result.skipTo('…')));
          expect(result, anyOf(isEmpty, contains('…'), hasLength(lorem.length)),
              reason: result);
          expect(result.length, lessThanOrEqualTo(i), reason: result);
        }
      });
      test('with ellipsis', () {
        final printer = standardString.truncateCenter(6, ellipsis: '...');
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '1234');
        expect(printer('12345'), '12345');
        expect(printer('123456'), '123456');
        expect(printer('1234567'), '12...7');
        expect(printer('12345678'), '12...8');
        expect(printer('👨👩👧👦😺💩'), '👨👩👧👦😺💩');
        expect(printer('👨👩👧👦😺💩🙉'), '👨👩...🙉');
      });
    });
    test('toString', () {
      final printer = standardString.truncateLeft(3, ellipsis: '...');
      expect(printer.toString(), startsWith('TruncateLeftPrinter<String>'));
    });
  });
  group('separate', () {
    test('left', () {
      final printer = standardString.separateLeft(3, 0, '_');
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '123_4');
      expect(printer('12345'), '123_45');
      expect(printer('123456'), '123_456');
      expect(printer('1234567'), '123_456_7');
      expect(printer('12345678'), '123_456_78');
      expect(printer('123456789'), '123_456_789');
      expect(printer('1234567890'), '123_456_789_0');
      expect(printer('👨👩👧👦'), '👨👩👧_👦');
    });
    test('right', () {
      final printer = standardString.separateRight(3, 0, '_');
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '1_234');
      expect(printer('12345'), '12_345');
      expect(printer('123456'), '123_456');
      expect(printer('1234567'), '1_234_567');
      expect(printer('12345678'), '12_345_678');
      expect(printer('123456789'), '123_456_789');
      expect(printer('1234567890'), '1_234_567_890');
      expect(printer('👨👩👧👦'), '👨_👩👧👦');
    });
    test('offset left', () {
      final left0 = standardString.separateLeft(3, 0, '_');
      expect(left0('1234567890'), '123_456_789_0');
      final left1 = standardString.separateLeft(3, 1, '_');
      expect(left1('1234567890'), '1_234_567_890');
      final left2 = standardString.separateLeft(3, 2, '_');
      expect(left2('1234567890'), '12_345_678_90');
    });
    test('offset right', () {
      final right0 = standardString.separateRight(3, 0, '_');
      expect(right0('1234567890'), '1_234_567_890');
      final right1 = standardString.separateRight(3, 1, '_');
      expect(right1('1234567890'), '123_456_789_0');
      final right2 = standardString.separateRight(3, 2, '_');
      expect(right2('1234567890'), '12_345_678_90');
    });
    test('toString', () {
      final printer = standardString.separateLeft(3, 0, '_');
      expect(printer.toString(), startsWith('SeparateLeftPrinter<String>'));
    });
  });
  group('ifNull', () {
    test('default', () {
      final printer = standardString.ifNull();
      expect(printer(null), '␀');
      expect(printer('foo'), 'foo');
    });
    test('custom', () {
      final printer = standardString.ifNull('n/a');
      expect(printer(null), 'n/a');
      expect(printer('foo'), 'foo');
    });
    test('toString', () {
      final printer = standardString.ifNull();
      expect(printer.toString(), startsWith('NullPrinter<String>'));
    });
  });
  group('switcher', () {
    test('default', () {
      final printer = Printer<int>.switcher({
        (value) => value < 1: const Printer.literal('<1'),
        (value) => value < 10: const Printer.literal('<10'),
        (value) => value < 100: const Printer.literal('<100'),
      }, otherwise: const Printer.literal('larger'));
      expect(printer(0), '<1');
      expect(printer(5), '<10');
      expect(printer(50), '<100');
      expect(printer(500), 'larger');
    });
    test('missing otherwise', () {
      final printer = Printer<int>.switcher({
        (value) => value < 1: const Printer.literal('<1'),
        (value) => value < 10: const Printer.literal('<10'),
        (value) => value < 100: const Printer.literal('<100'),
      });
      expect(printer(0), '<1');
      expect(printer(5), '<10');
      expect(printer(50), '<100');
      expect(printer(500), '');
    });
    test('toString', () {
      const printer = Printer<int>.switcher({});
      expect(printer.toString(), startsWith('SwitcherPrinter'));
    });
  });
  group('sequence', () {
    test('default', () {
      const printer = SequencePrinter<String>(
          [standardString, Printer.literal('-'), standardString]);
      expect(printer('1'), '1-1');
      expect(printer('12'), '12-12');
    });
    test('iterable', () {
      final printer = <Printer<int>>[
        const Printer.standard(),
        const Printer.literal(' <-> '),
        Printer.pluggable(
            (value) => value.toString().split('').reversed.join('')),
      ].toPrinter();
      expect(printer(1), '1 <-> 1');
      expect(printer(12), '12 <-> 21');
      expect(printer(123), '123 <-> 321');
      expect(printer(1234), '1234 <-> 4321');
    });
    test('before', () {
      final printer = standardString.before('*');
      expect(printer('1'), '*1');
    });
    test('after', () {
      final printer = standardString.after('*');
      expect(printer('1'), '1*');
    });
    test('around (same)', () {
      final printer = standardString.around('*');
      expect(printer('1'), '*1*');
    });
    test('around (different)', () {
      final printer = standardString.around('<', '>');
      expect(printer('1'), '<1>');
    });
    test('toString', () {
      final printer = standardString.around('<', '>');
      expect(printer.toString(), startsWith('SequencePrinter<String>'));
    });
  });
  group('iterable', () {
    test('default', () {
      final printer = standardInt.iterable();
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, 5');
    });
    test('emptyPrinter', () {
      final printer =
          standardInt.iterable(emptyPrinter: const Printer.literal('n/a'));
      expect(printer([]), 'n/a');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, 5');
    });
    test('beforePrinter', () {
      final printer =
          standardInt.iterable(beforePrinter: const Printer.literal('['));
      expect(printer([]), '');
      expect(printer([1]), '[1');
      expect(printer([1, 2]), '[1, 2');
      expect(printer([1, 2, 3]), '[1, 2, 3');
      expect(printer([1, 2, 3, 4]), '[1, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '[1, 2, 3, 4, 5');
    });
    test('afterPrinter', () {
      final printer =
          standardInt.iterable(afterPrinter: const Printer.literal(']'));
      expect(printer([]), '');
      expect(printer([1]), '1]');
      expect(printer([1, 2]), '1, 2]');
      expect(printer([1, 2, 3]), '1, 2, 3]');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, 4]');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, 5]');
    });
    test('afterPrinter', () {
      final printer = standardInt.iterable(
          emptyPrinter: const Printer.literal('∅'),
          beforePrinter: const Printer.literal('['),
          afterPrinter: const Printer.literal(']'));
      expect(printer([]), '∅');
      expect(printer([1]), '[1]');
      expect(printer([1, 2]), '[1, 2]');
      expect(printer([1, 2, 3]), '[1, 2, 3]');
      expect(printer([1, 2, 3, 4]), '[1, 2, 3, 4]');
      expect(printer([1, 2, 3, 4, 5]), '[1, 2, 3, 4, 5]');
    });
    test('separator', () {
      final printer = standardInt.iterable(separator: ';');
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1;2');
      expect(printer([1, 2, 3]), '1;2;3');
      expect(printer([1, 2, 3, 4]), '1;2;3;4');
      expect(printer([1, 2, 3, 4, 5]), '1;2;3;4;5');
    });
    test('lastSeparator', () {
      final printer = standardInt.iterable(lastSeparator: ', and ');
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, and 2');
      expect(printer([1, 2, 3]), '1, 2, and 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, and 4');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, and 5');
    });
    test('leadingItems', () {
      final printer = standardInt.iterable(leadingItems: 3);
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5, 6]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5, 6, 7]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5, 6, 7, 8]), '1, 2, 3, …');
    });
    test('trailingItems', () {
      final printer = standardInt.iterable(trailingItems: 3);
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '…, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '…, 3, 4, 5');
      expect(printer([1, 2, 3, 4, 5, 6]), '…, 4, 5, 6');
      expect(printer([1, 2, 3, 4, 5, 6, 7]), '…, 5, 6, 7');
      expect(printer([1, 2, 3, 4, 5, 6, 7, 8]), '…, 6, 7, 8');
    });
    test('leadingItems and trailingItems', () {
      final printer = standardInt.iterable(leadingItems: 3, trailingItems: 3);
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, 5');
      expect(printer([1, 2, 3, 4, 5, 6]), '1, 2, 3, 4, 5, 6');
      expect(printer([1, 2, 3, 4, 5, 6, 7]), '1, 2, 3, …, 5, 6, 7');
      expect(printer([1, 2, 3, 4, 5, 6, 7, 8]), '1, 2, 3, …, 6, 7, 8');
    });
    test('toString', () {
      final printer = standardInt.iterable();
      expect(printer.toString(), startsWith('IterablePrinter<int>'));
    });
  });
  group('ifEmpty', () {
    test('default', () {
      final printer = standardInt.iterable().ifEmpty();
      expect(printer([]), '∅');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
    });
    test('custom', () {
      final printer = standardInt.iterable().ifEmpty('n/a');
      expect(printer([]), 'n/a');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
    });
    test('toString', () {
      final printer = standardInt.iterable().ifEmpty();
      expect(printer.toString(), startsWith('EmptyPrinter<int>'));
    });
  });
  group('onResultOf', () {
    test('printer', () {
      final printer = standardInt.onResultOf(int.parse);
      expect(() => printer(''), throwsFormatException);
      expect(printer('1'), '1');
      expect(printer('12'), '12');
    });
    test('cast', () {
      final printer = standardString.cast<Object>();
      expect(() => printer(0), throwsA(isA<TypeError>()));
      expect(printer('1'), '1');
      expect(printer('12'), '12');
    });
    test('toString', () {
      final printer = standardInt.onResultOf(int.parse);
      expect(printer.toString(), startsWith('ResultOfPrinter<String, int>'));
    });
  });
  group('where', () {
    test('printer', () {
      final printer = standardInt.where((value) => value > 0);
      expect(printer(1), '1');
      expect(printer(-1), '');
    });
    test('toString', () {
      final printer = standardInt.where((value) => value > 0);
      expect(printer.toString(), startsWith('WherePrinter<int>'));
    });
  });
  group('wrap', () {
    test('printer', () {
      final printer = Printer<String>.wrap(standardString);
      expect(printer, standardString);
      expect(printer('1'), '1');
    });
    test('callback', () {
      final printer = Printer<int>.wrap((int value) => (2 * value).toString());
      expect(printer(1), '2');
      expect(printer(12), '24');
    });
    test('literal', () {
      final printer = Printer<int>.wrap('*');
      expect(printer(1), '*');
      expect(printer(12), '*');
    });
    test('string', () {
      final printer = Printer<int>.wrap(const [standardInt, standardInt]);
      expect(printer(1), '11');
      expect(printer(12), '1212');
    });
    test('invalid', () {
      expect(() => Printer<String>.wrap(standardInt), throwsArgumentError);
      expect(() => Printer<String>.wrap(num.parse), throwsArgumentError);
      expect(() => Printer<String>.wrap(12), throwsArgumentError);
    });
  });
  group('pluggable', () {
    test('default', () {
      final printer = Printer<String>.pluggable((value) => '<$value>');
      expect(printer('a'), '<a>');
      expect(printer('bc'), '<bc>');
      expect(printer('def'), '<def>');
    });
    test('toString', () {
      final printer = Printer<int>.pluggable((value) => '$value');
      expect(printer.toString(), startsWith('PluggablePrinter'));
    });
  });
  group('object', () {
    test('default', () {
      final printer = ObjectPrinter<int>(const Printer.literal('*'));
      expect(printer(42), '*');
    });
    test('static', () {
      final printer = ObjectPrinter<Object>.static();
      expect(printer('hello'), 'Object');
    });
    test('dynamic', () {
      final printer = ObjectPrinter<Object>.dynamic();
      expect(printer('hello'), 'String');
    });
    group('addValue', () {
      test('default', () {
        final printer = ObjectPrinter<String>.static()..addValue(42);
        expect(printer('hello'), 'String{42}');
      });
      test('name', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue(42, name: 'size');
        expect(printer('hello'), 'String{size=42}');
      });
      test('printer', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue(42, printer: const Printer<int>.standard().around('"'));
        expect(printer('hello'), 'String{"42"}');
      });
      test('omitNull', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue<int?>(null, omitNull: true)
          ..addValue<int?>(42, omitNull: true);
        expect(printer('hello'), 'String{42}');
      });
      test('omitPredicate', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue<int>(42, omitPredicate: (value) => value.isEven)
          ..addValue<int>(43, omitPredicate: (value) => value.isEven);
        expect(printer('hello'), 'String{43}');
      });
      test('omitNull and omitPredicate', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue<int?>(null,
              omitNull: true, omitPredicate: (value) => value!.isEven)
          ..addValue<int?>(42,
              omitNull: true, omitPredicate: (value) => value!.isEven)
          ..addValue<int?>(43,
              omitNull: true, omitPredicate: (value) => value!.isEven);
        expect(printer('hello'), 'String{43}');
      });
    });
    group('addCallback', () {
      test('default', () {
        final printer = ObjectPrinter<String>.static()
          ..addCallback((object) => object.length);
        expect(printer('hello'), 'String{5}');
      });
      test('name', () {
        final printer = ObjectPrinter<String>.static()
          ..addCallback((object) => object.length, name: 'size');
        expect(printer('hello'), 'String{size=5}');
      });
      test('printer', () {
        final printer = ObjectPrinter<String>.static()
          ..addCallback((object) => object.length,
              printer: const Printer<int>.standard().around('"'));
        expect(printer('hello'), 'String{"5"}');
      });
      test('omitNull', () {
        final printer = ObjectPrinter<(String?, String?)>.static()
          ..addCallback((object) => object.first, omitNull: true, name: 'first')
          ..addCallback((object) => object.second,
              omitNull: false, name: 'second');
        expect(printer(('hello', 'world')),
            '(String?, String?){first=hello, second=world}');
        expect(printer((null, 'world')), '(String?, String?){second=world}');
        expect(printer(('hello', null)),
            '(String?, String?){first=hello, second=null}');
        expect(printer((null, null)), '(String?, String?){second=null}');
      });
      test('omitPredicate', () {
        final printer = ObjectPrinter<(int, int)>.static()
          ..addCallback<int>((object) => object.first, name: 'first')
          ..addCallback<int>(
            (object) => object.second,
            omitPredicate: (object, value) => value.isEven,
            name: 'second',
          );
        expect(printer((42, 43)), '(int, int){first=42, second=43}');
        expect(printer((42, 44)), '(int, int){first=42}');
      });
      test('omitNull and omitPredicate', () {
        final printer = ObjectPrinter<(int?,)>.static()
          ..addCallback<int?>((object) => object.first,
              omitNull: true, omitPredicate: (object, value) => value!.isEven);
        expect(printer((1,)), '(int?){1}');
        expect(printer((2,)), '(int?)');
        expect(printer((null,)), '(int?)');
      });
    });
    test('before and afterFields', () {
      final printer =
          ObjectPrinter<String>.static(beforeFields: '[', afterFields: ']')
            ..addCallback<int>((object) => object.length);
      expect(printer('hello'), 'String[5]');
    });
    test('fieldName', () {
      final printer = ObjectPrinter<String>.static(
          fieldName: const Printer<String>.standard().around('"'))
        ..addCallback<String>((object) => object[0], name: 'first');
      expect(printer('hello'), 'String{"first"=h}');
    });
    test('fieldNameSeparator', () {
      final printer = ObjectPrinter<String>.static(fieldNameSeparator: ': ')
        ..addCallback<String>((object) => object[0], name: 'first');
      expect(printer('hello'), 'String{first: h}');
    });
    test('fieldValue', () {
      final printer = ObjectPrinter<String>.static(
          fieldValue: const Printer<String>.standard().around('"'))
        ..addCallback<String>((object) => object[0]);
      expect(printer('hello'), 'String{"h"}');
    });
    test('fieldSeparator', () {
      final printer = ObjectPrinter<(int, int)>.static(fieldSeparator: ' ')
        ..addCallback<int>((object) => object.first, name: 'first')
        ..addCallback<int>((object) => object.second, name: 'second');
      expect(printer((1, 2)), '(int, int){first=1 second=2}');
    });
    test('toString', () {
      final printer = ObjectPrinter<(int, int)>.dynamic()
        ..addValue(true)
        ..addCallback((value) => value);
      expect(printer.toString(), startsWith('ObjectPrinter<(int, int)>'));
    });
  });
}
