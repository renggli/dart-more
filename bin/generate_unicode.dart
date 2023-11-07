import 'dart:io';

import 'package:more/collection.dart';

import 'utils/generating.dart';
import 'utils/unicode.dart';

// General Categories:
// https://www.unicode.org/reports/tr44/#General_Category_Values
final generalCategories = {
  'Cc': 'Control',
  'Cf': 'Format',
  'Co': 'Private Use',
  'Cs': 'Surrogate',
  'Cn': 'Unassigned',
  'Ll': 'Letter, Lowercase',
  'Lm': 'Letter, Modifier',
  'Lo': 'Letter, Other',
  'Lt': 'Letter, Titlecase',
  'Lu': 'Letter, Uppercase',
  'Mc': 'Mark, Spacing Combining',
  'Me': 'Mark, Enclosing',
  'Mn': 'Mark, Non-Spacing',
  'Nd': 'Number, Decimal Digit',
  'Nl': 'Number, Letter',
  'No': 'Number, Other',
  'Pc': 'Punctuation, Connector',
  'Pd': 'Punctuation, Dash',
  'Pe': 'Punctuation, Close',
  'Pf': 'Punctuation, Final quote',
  'Pi': 'Punctuation, Initial quote',
  'Po': 'Punctuation, Other',
  'Ps': 'Punctuation, Open',
  'Sc': 'Symbol, Currency',
  'Sk': 'Symbol, Modifier',
  'Sm': 'Symbol, Math',
  'So': 'Symbol, Other',
  'Zl': 'Separator, Line',
  'Zp': 'Separator, Paragraph',
  'Zs': 'Separator, Space',
};

final generalCategoryGroups = {
  'C': (desc: 'Other', parts: ['Cc', 'Cf', 'Cs', 'Co', 'Cn']),
  'L': (desc: 'Letter', parts: ['Lu', 'Ll', 'Lt', 'Lm', 'Lo']),
  'LC': (desc: 'Letter cased', parts: ['Lu', 'Ll', 'Lt']),
  'M': (desc: 'Mark', parts: ['Mn', 'Mc', 'Me']),
  'N': (desc: 'Number', parts: ['Nd', 'Nl', 'No']),
  'P': (desc: 'Punctuation', parts: ['Pc', 'Pd', 'Ps', 'Pe', 'Pi', 'Pf', 'Po']),
  'S': (desc: 'Symbol', parts: ['Sm', 'Sc', 'Sk', 'So']),
  'Z': (desc: 'Separator', parts: ['Zs', 'Zl', 'Zp']),
};

String className(String input) => input
    .split(RegExp('[, -]+'))
    .map((word) => word.toUpperCaseFirstCharacter())
    .join();

String hex(int value) => '0x${value.toRadixString(16)}';

Future<void> generateGeneralCategory() async {
  final characterData = await unicodeData;
  final categoryMask = generalCategories.entries
      .indexed()
      .toMap(key: (entry) => entry.value.key, value: (entry) => 1 << entry.key);
  final groupMask = generalCategoryGroups.entries.toMap(
      key: (entry) => entry.key,
      value: (entry) => entry.value.parts
          .map((part) => categoryMask[part]!)
          .reduce((a, b) => a + b));
  final mask =
      characterData.map((char) => categoryMask[char.generalCategory]!).toList();

  final file = File('lib/src/char_matcher/generated/general_categories.dart');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('import \'../classifiers/unicode.dart\';');
  out.writeln();

  for (final MapEntry(key: abbr, value: desc) in generalCategories.entries) {
    out.writeln('// $abbr: $desc');
    out.writeln('class ${className(desc)}CharMatcher '
        'extends UnicodeCharMatcher {');
    out.writeln('  const ${className(desc)}CharMatcher()');
    out.writeln('    : super(${hex(categoryMask[abbr]!)});');
    out.writeln('}');
    out.writeln();
  }

  for (final MapEntry(key: abbr, value: data)
      in generalCategoryGroups.entries) {
    out.writeln('// $abbr: ${data.desc}');
    out.writeln('class ${className(data.desc)}CharMatcher '
        'extends UnicodeCharMatcher {');
    out.writeln('  const ${className(data.desc)}CharMatcher()');
    out.writeln('    : super(${hex(groupMask[abbr]!)});');
    out.writeln('}');
    out.writeln();
  }

  out.writeln('// RLE encoded general category mask from Unicode '
      '$unicodeVersion.');
  out.writeln('const generalCategoriesLength = ${hex(mask.length)};');
  out.writeln('const generalCategories = [');
  out.writeln('${rle(mask).join(', ')} //'.wrap(78).indent('  '));
  out.writeln('];');

  await out.close();
  await format(file);
}

Future<void> main() => generateGeneralCategory();
