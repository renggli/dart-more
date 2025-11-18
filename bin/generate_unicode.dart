import 'dart:io';

import 'package:more/collection.dart';
import 'package:more/more.dart';
import 'package:more/src/shared/rle.dart';

import 'utils/generating.dart';
import 'utils/unicode.dart';

final whitepsaceSplitter = RegExp(r'\s+');

void writeIntList(IOSink out, String name, List<int> values) {
  out.writeln('const $name = [');
  out.writeln(encodeRle(values).join(',\n'));
  out.writeln('];');
}

String formatUnicode(int codePoint) =>
    '0x${codePoint.toRadixString(16).padLeft(4, '0')}';

Future<void> generatePropertyData(
  String name,
  Uri url, {
  String? unlistedAs,
}) async {
  final file = File('lib/src/char_matcher/unicode/$name.dart');
  final data = await getPropertyData(url);
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('// $url');
  out.writeln();

  var entries = data.asMap().entries;
  if (unlistedAs != null) {
    final unlistedRanges = getUnlistedCodePoints(
      data,
    ).map((code) => (code, code)).toList(growable: false);
    entries = entries.followedBy([MapEntry(unlistedAs, unlistedRanges)]);
  }

  var index = 1, listIndex = 1;
  final values = List.filled(unicodeMaxCodePoint + 1, 0);
  for (final MapEntry(:key, value: ranges) in entries) {
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

Future<void> generateNormalizationData() async {
  final file = File('lib/src/collection/string/normalization_data.dart');
  final unicodeData = await unicodeDataFuture;
  final compositionExclusions = await getLineData(compositionExclusionsUrl);
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('// $unicodeDataUrl');
  out.writeln('// $compositionExclusionsUrl');
  out.writeln();

  out.writeln(
    '/// Dictionary mapping characters with non-zero canonical combining class values',
  );
  out.writeln('/// to their corresponding values.');
  out.writeln('const canonicalCombiningClasses = {');
  for (final unicode in unicodeData) {
    if (unicode.canonicalCombiningClasses != null &&
        unicode.canonicalCombiningClasses != 0) {
      out.write('${formatUnicode(unicode.codePoint)}: ');
      out.writeln('${unicode.canonicalCombiningClasses},');
    }
  }
  out.writeln('};');
  out.writeln();

  out.writeln(
    '/// Dictionary mapping characters to their canonical decompositions.',
  );
  out.writeln('const characterDecompositionMapping = {');
  for (final unicode in unicodeData) {
    if (unicode.characterDecompositionMapping != null &&
        unicode.characterDecompositionMapping!.isNotEmpty) {
      out.write('${formatUnicode(unicode.codePoint)}: (');
      var parts = unicode.characterDecompositionMapping!.split(
        whitepsaceSplitter,
      );
      if (parts[0].startsWith('<')) {
        out.write("type: '${parts[0]}', ");
        parts = parts.sublist(1);
      } else {
        out.write('type: null, ');
      }
      out.write(
        'values: [${parts.map((value) => formatUnicode(int.parse(value, radix: 16))).join(', ')}]),',
      );
    }
  }
  out.writeln('};');
  out.writeln();

  out.writeln('const compositionExclusion = {');
  for (final exclusion in compositionExclusions) {
    out.writeln('${formatUnicode(int.parse(exclusion[0], radix: 16))},');
  }
  out.writeln('};');
  out.writeln();

  await out.close();
  await format(file);
}

Future<void> generateNormalizationTestData() async {
  final file = File('test/data/normalization_data.dart');
  final normalizationTestData = await getLineData(normalizationTestUrl);
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('// $normalizationTestUrl');
  out.writeln();

  out.writeln('const normalizationTestData = {');
  for (final testData in normalizationTestData) {
    if (testData.length == 1) {
      if (testData != normalizationTestData.first) {
        out.writeln('],');
      }
      out.writeln("'${testData[0]}': [");
      continue;
    }
    final parts = testData
        .sublist(0, 5)
        .map(
          (part) => part
              .split(whitepsaceSplitter)
              .map((each) => formatUnicode(int.parse(each, radix: 16)))
              .join(', '),
        )
        .toList();
    out.writeln('(');
    out.writeln('source: [${parts[0]}],');
    out.writeln('nfc: [${parts[1]}],');
    out.writeln('nfd: [${parts[2]}],');
    out.writeln('nfkc: [${parts[3]}],');
    out.writeln('nfkd: [${parts[4]}],');
    out.writeln('),');
  }
  out.writeln(']};');
  out.writeln();

  await out.close();
  await format(file);
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
      '${formatUnicode(range.$1)}, ${formatUnicode(range.$2)});',
    );
  }

  await out.close();
  await format(file);
}

Future<void> generateDecimalData() async {
  final file = File('lib/src/printer/number/numeral.dart');
  final unicodeData = await unicodeDataFuture;
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

  final iterator = unicodeData.iterator;
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
  generatePropertyData('scripts', unicodeScriptsUrl, unlistedAs: 'Unknown'),
  generateNormalizationData(),
  generateNormalizationTestData(),
  generateUnicodeBlocks(),
  generateDecimalData(),
]);
