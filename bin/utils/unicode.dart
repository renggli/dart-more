import 'dart:convert';
import 'dart:io';

import 'package:more/collection.dart';

/// Version of the data.
const unicodeVersion = '15.1.0';

/// Last unicode code-point.
const unicodeMaxCodePoint = 0x10ffff;

/// URLs of the unicode data.
final unicodePropertyListUrl = Uri.parse(
    'https://www.unicode.org/Public/$unicodeVersion/ucd/PropList.txt');
final unicodeCategoryListUrl = Uri.parse(
    'https://www.unicode.org/Public/$unicodeVersion/ucd/extracted/DerivedGeneralCategory.txt');

/// Reads a Unicode file of the form `START[..STOP] ; NAME` into a
/// [ListMultimap] with `NAME` as key to its values.
Future<ListMultimap<String, (int, int)>> getPropertyData(Uri uri) async {
  final request = await HttpClient().getUrl(uri);
  final response = await request.close();
  return response
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) => line.takeTo('#').trim())
      .where((line) => line.isNotEmpty)
      .fold<ListMultimap<String, (int, int)>>(
          ListMultimap<String, (int, int)>(), (result, line) {
    final [values, name] = line.split(';').map((each) => each.trim()).toList();
    final range =
        values.split('..').map((each) => int.parse(each, radix: 16)).toList();
    result.add(name, (range.first, range.last));
    return result;
  });
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
