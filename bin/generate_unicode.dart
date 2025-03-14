import 'dart:io';

import 'package:more/collection.dart';
import 'package:more/more.dart';
import 'package:more/src/shared/rle.dart';

import 'utils/generating.dart';
import 'utils/unicode.dart';

void writeIntList(IOSink out, String name, List<int> values) {
  out.writeln('const $name = [');
  out.writeln(encodeRle(values).join(', ').wrap(78).indent('  '));
  out.writeln('];');
}

Future<void> generatePropertyData(String name, Uri url) async {
  final file = File('lib/src/char_matcher/unicode/$name.dart');
  final data = await getPropertyData(url);
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('// $url');
  out.writeln();

  var index = 1, listIndex = 1;
  final values = List.filled(unicodeMaxCodePoint + 1, 0);
  for (final MapEntry(:key, value: ranges) in data.asMap().entries) {
    if (index > 0xffffffff) {
      out.writeln();
      writeIntList(out, 'data${listIndex++}', values);
      out.writeln();
      values.fillRange(0, values.length, 0);
      index = 1;
    }
    out.writeln('const ${namify(key)} = 0x${index.toRadixString(16)};');
    for (final range in ranges) {
      for (var code = range.$1; code <= range.$2; code++) {
        values[code] |= index;
      }
    }
    index <<= 1;
  }

  out.writeln();
  writeIntList(out, listIndex > 1 ? 'data$listIndex' : 'data', values);

  await out.close();
  await format(file);
}

void writeList(IOSink out, String name, List<int> values) {
  out.writeln('const $name = [');
  out.writeln(encodeRle(values).join(', ').wrap(78).indent('  '));
  out.writeln('];');
}

Future<void> generateUnicodeBlocks() async {
  final file = File('lib/src/char_matcher/unicode/blocks.dart');
  final data = await getPropertyData(unicodeBlocksUrl);
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('// $unicodeBlocksUrl');
  out.writeln();

  out.writeln('import \'../basic/range.dart\';');
  out.writeln();

  for (final MapEntry(:key, value: ranges) in data.asMap().entries) {
    final range = ranges.single;
    out.writeln(
      'const ${namify(key)} = RangeCharMatcher('
      '0x${range.$1.toRadixString(16)}, '
      '0x${range.$2.toRadixString(16)});',
    );
  }

  await out.close();
  await format(file);
}

Future<void> generateDecimalData() async {
  final file = File('lib/src/printer/number/numeral.dart');
  final data = await unicodeData;
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('// $unicodeDataUrl');
  out.writeln();

  out.writeln(
    '/// A class defining different numeral systems for '
    'number printing.',
  );
  out.writeln('///');
  out.writeln(
    '/// To remain customizable the number systems are provided '
    'through immutable',
  );
  out.writeln(
    '/// `List<String>` instances. Each list starts with the string '
    'representations',
  );
  out.writeln('/// for 0, 1, 2, ... up to the maximally supported base.');
  out.writeln('///');
  out.writeln('/// The default number system is [latin].');
  out.writeln('abstract class NumeralSystem {');

  final iterator = data.iterator;
  while (iterator.moveNext()) {
    if (iterator.current.decimalDigit == 0) {
      final def = StringBuffer();
      final name = namify(iterator.current.characterName.takeTo(' DIGIT'));
      do {
        def.writeCharCode(iterator.current.codePoint);
      } while (iterator.current.decimalDigit! < 9 && iterator.moveNext());
      if (name == 'digitZero') {
        // Special casing of default latin characters, so that they also work
        // with arbitrary base printing (i.e. hexadecimal).
        for (var c = 'a'.codeUnitAt(0); c <= 'z'.codeUnitAt(0); c++) {
          def.writeCharCode(c);
        }
        out.writeln('static const latin = lowerCaseLatin;');
        out.writeln(
          'static const lowerCaseLatin = '
          '${characterList(def.toString().toLowerCase())};',
        );
        out.writeln(
          'static const upperCaseLatin = '
          '${characterList(def.toString().toUpperCase())};',
        );
        out.writeln();
      } else {
        out.writeln('static const $name = ${characterList(def.toString())};');
      }
    }
  }
  out.writeln('}');

  await out.close();
  await format(file);
}

String characterList(String input) =>
    '[${input.runes.map(String.fromCharCode).map((each) => "'$each'").join(', ')}]';

Future<void> main() => Future.wait([
  generatePropertyData('category', unicodeCategoryListUrl),
  generatePropertyData('property', unicodePropertyListUrl),
  generatePropertyData('bidi_class', unicodeBidiClassListUrl),
  generateUnicodeBlocks(),
  generateDecimalData(),
]);
