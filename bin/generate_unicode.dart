import 'dart:io';

import 'package:more/collection.dart';
import 'package:more/more.dart';

import 'utils/generating.dart';
import 'utils/unicode.dart';

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
      writeList(out, 'data${listIndex++}', values);
      values.fillRange(0, values.length, 0);
      index = 1;
    }
    final label = key
        .split('_')
        .map((each) => each.toLowerCase().toUpperCaseFirstCharacter())
        .join()
        .toLowerCaseFirstCharacter();
    out.writeln('const $label = 0x${index.toRadixString(16)};');
    for (final range in ranges) {
      for (var code = range.$1; code <= range.$2; code++) {
        values[code] |= index;
      }
    }
    index <<= 1;
  }

  out.writeln();
  writeList(out, listIndex > 1 ? 'data$listIndex' : 'data', values);

  await out.close();
  await format(file);
}

void writeList(IOSink out, String name, List<int> values) {
  out.writeln();
  out.writeln('const $name = [');
  out.writeln('${rle(values).join(', ')} //'.wrap(78).indent('  '));
  out.writeln('];');
  out.writeln();
}

Future<void> main() => Future.wait([
      generatePropertyData('category', unicodeCategoryListUrl),
      generatePropertyData('property', unicodePropertyListUrl),
    ]);
