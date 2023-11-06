import 'dart:convert';
import 'dart:io';

import 'package:more/collection.dart';

/// Unicode database: https://www.unicode.org/versions/latest

/// Version of the data.
const unicodeVersion = '15.1.0';

/// Last unicode code-point.
const unicodeMaxCodePoint = 0x10ffff;

/// Url of the unicode data.
final unicodeDataUrl = Uri.parse(
    'https://www.unicode.org/Public/$unicodeVersion/ucd/UnicodeData.txt');

/// Datatype describing an unicode character.
typedef UnicodeChar = ({
  int code,
  String name,
  String generalCategory,
});

/// Future to the unicode database sorted by character code.
final unicodeData = _fetchUnicodeData(unicodeDataUrl);

/// Helper to fetch and parse the unicode database.
Future<List<UnicodeChar>> _fetchUnicodeData(Uri uri) async {
  final request = await HttpClient().getUrl(unicodeDataUrl);
  final response = await request.close();
  final lines = await response
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) => line.split(';'))
      .toList();
  final lineIterator = lines.iterator;
  final results = <UnicodeChar>[];
  while (lineIterator.moveNext()) {
    final codeStart = int.parse(lineIterator.current[0], radix: 16);
    if (results.isNotEmpty) {
      for (var code = results.last.code + 1; code < codeStart; code++) {
        results.add((code: code, name: '<unassigned>', generalCategory: 'Cn'));
      }
    }
    var codeEnd = codeStart;
    var name = lineIterator.current[1];
    final generalCategory = lineIterator.current[2];
    if (name.endsWith(', First>')) {
      lineIterator.moveNext();
      name = name.removePrefix('<').removeSuffix(', First>');
      codeEnd = int.parse(lineIterator.current[0], radix: 16);
    }
    for (var code = codeStart; code <= codeEnd; code++) {
      results.add((code: code, name: name, generalCategory: generalCategory));
    }
  }
  for (var code = results.last.code + 1; code < unicodeMaxCodePoint; code++) {
    results.add((code: code, name: '<unassigned>', generalCategory: 'Cn'));
  }
  return results;
}

/// Generates a list of unicode code-point ranges satisfying the filter.
Future<List<int>> filterUnicodeData(bool Function(UnicodeChar) filter) async {
  final result = <int>[];
  final data = await unicodeData;
  for (final character in data.where(filter).toList()) {
    if (result.isNotEmpty && result.last == character.code - 1) {
      result.last = character.code;
    } else {
      result.add(character.code);
      result.add(character.code);
    }
  }
  return result;
}

/// Encodes a list of integers using run-length encoding. A negative number
/// means the next number is repeated that amount of times.
List<int> rle(List<int> values) {
  final result = <int>[];
  for (var i = 0; i < values.length;) {
    var count = 1;
    while (i + count < values.length && values[i] == values[i + count]) {
      count++;
    }
    if (count > 1) result.add(-count);
    result.add(values[i]);
    i += count;
  }
  return result;
}
