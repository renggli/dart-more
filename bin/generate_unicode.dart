import 'dart:io';

import 'package:more/collection.dart';

import 'utils/generating.dart';
import 'utils/unicode.dart';

Future<void> generatePropertyData(String name, Uri url) async {
  final file = File('lib/src/char_matcher/generated/$name.dart');
  final data = await getPropertyData(url);
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('// $url');
  out.writeln();

  var index = 1;
  final list = List.filled(unicodeMaxCodePoint + 1, 0);
  for (final MapEntry(:key, value: ranges) in data.asMap().entries) {
    final name = key
        .split('_')
        .map((each) => each.toLowerCase().toUpperCaseFirstCharacter())
        .join()
        .toLowerCaseFirstCharacter();
    out.writeln('const $name = 0x${index.toRadixString(16)};');
    for (final range in ranges) {
      for (var code = range.$1; code <= range.$2; code++) {
        list[code] |= index;
      }
    }
    index <<= 1;
  }
  out.writeln();

  out.writeln('const data = [');
  out.writeln('${rle(list).join(', ')} //'.wrap(78).indent('  '));
  out.writeln('];');

  await out.close();
  await format(file);
}

Future<void> main() => Future.wait([
      generatePropertyData('category', unicodeCategoryListUrl),
      generatePropertyData('property', unicodePropertyListUrl),
    ]);
