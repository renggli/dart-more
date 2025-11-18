import 'dart:convert';
import 'dart:io';

import 'package:more/collection.dart';
import 'package:more/number.dart';

/// Version of the data.
const unicodeVersion = '17.0.0';

/// Last unicode code-point.
const unicodeMaxCodePoint = 0x10ffff;

/// Unicode data.
typedef UnicodeData = ({
  int codePoint,
  String characterName,
  String generalCategory,
  int? canonicalCombiningClasses,
  String? bidirectionCategory,
  String? characterDecompositionMapping,
  int? decimalDigit,
  int? digitValue,
  Fraction? numericValue,
  bool? mirrored,
  int? upperCaseMapping,
  int? lowerCaseMapping,
  int? titleCaseMapping,
});

/// URLs of the unicode data.
final unicodeDataUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/UnicodeData.txt',
);
final unicodePropertyListUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/PropList.txt',
);
final unicodeBlocksUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/Blocks.txt',
);
final compositionExclusionsUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/CompositionExclusions.txt',
);
final normalizationTestUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/NormalizationTest.txt',
);
final unicodeCategoryListUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/extracted/DerivedGeneralCategory.txt',
);
final unicodeBidiClassListUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/extracted/DerivedBidiClass.txt',
);

final unicodeScriptsUrl = Uri.parse(
  'https://www.unicode.org/Public/$unicodeVersion/ucd/Scripts.txt',
);

/// Reads the unicode database.
final Future<List<UnicodeData>> unicodeDataFuture = _getUnicodeData();

Future<List<UnicodeData>> _getUnicodeData() async {
  final lines = await getLineData(unicodeDataUrl);
  final result = <UnicodeData>[];
  for (var i = 0; i < lines.length;) {
    final start = int.parse(lines[i][0], radix: 16);
    final end = lines[i][1].endsWith(', First>')
        ? int.parse(lines[i + 1][0], radix: 16)
        : start;
    if (result.isNotEmpty) {
      for (var j = result.last.codePoint + 1; j < start; j++) {
        result.add(_createEmpty(j));
      }
    }
    for (var j = start; j <= end; j++) {
      result.add(_createParts(j, lines[i]));
    }
    i += start == end ? 1 : 2;
  }
  for (var j = result.last.codePoint + 1; j < unicodeMaxCodePoint; j++) {
    result.add(_createEmpty(j));
  }
  return result;
}

UnicodeData _createParts(int codePoint, List<String> parts) => (
  codePoint: codePoint,
  characterName: parts[1]
      .removePrefix('<')
      .removeSuffix(', First>')
      .removeSuffix(', Last>'),
  generalCategory: parts[2],
  canonicalCombiningClasses: int.tryParse(parts[3]),
  bidirectionCategory: parts[4],
  characterDecompositionMapping: parts[5],
  decimalDigit: int.tryParse(parts[6]),
  digitValue: int.tryParse(parts[7]),
  numericValue: Fraction.tryParse(parts[8]),
  mirrored: parts[9] == 'Y',
  upperCaseMapping: int.tryParse(parts[12], radix: 16),
  lowerCaseMapping: int.tryParse(parts[13], radix: 16),
  titleCaseMapping: int.tryParse(parts[14], radix: 16),
);

UnicodeData _createEmpty(int codePoint) => (
  codePoint: codePoint,
  characterName: '<unassigned>',
  generalCategory: 'Cn',
  canonicalCombiningClasses: null,
  bidirectionCategory: null,
  characterDecompositionMapping: null,
  decimalDigit: null,
  digitValue: null,
  numericValue: null,
  mirrored: null,
  upperCaseMapping: null,
  lowerCaseMapping: null,
  titleCaseMapping: null,
);

/// Reads a Unicode file of the form `START[..STOP] ; NAME` into a
/// [ListMultimap] with `NAME` as key to its values.
Future<ListMultimap<String, (int, int)>> getPropertyData(Uri uri) async {
  final lines = await getLineData(uri);
  return lines.fold<ListMultimap<String, (int, int)>>(
    ListMultimap<String, (int, int)>(),
    (result, line) {
      final range = line[0]
          .split('..')
          .map((each) => int.parse(each, radix: 16))
          .toList();
      result.add(line[1], (range.first, range.last));
      return result;
    },
  );
}

/// From property data created by [getPropertyData], returns all code points
/// that are *not* included in the data.
Iterable<int> getUnlistedCodePoints(
  ListMultimap<String, (int, int)> propertyData,
) {
  final allCodePoints = List.generate(unicodeMaxCodePoint + 1, (code) => code);
  for (final (start, end) in propertyData.values) {
    allCodePoints.replaceRange(
      start,
      end + 1,
      List.filled(end - start + 1, -1),
    );
  }
  return allCodePoints.where((code) => code != -1);
}

/// Reads a unicode file into a list of lines with its values. Removes comments
/// and empty lines.
Future<List<List<String>>> getLineData(Uri uri) async {
  final request = await HttpClient().getUrl(uri);
  final response = await request.close();
  return response
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) => line.takeTo('#').trim())
      .where((line) => line.isNotEmpty)
      .map((line) => line.split(';').map((value) => value.trim()).toList())
      .toList();
}
