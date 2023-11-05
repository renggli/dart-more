import 'dart:convert';
import 'dart:io';

import 'package:more/collection.dart';

import 'utils.dart';

// Unicode database: https://www.unicode.org/versions/latest
const unicodeVersion = '15.1.0';
final unicodeDataUrl = Uri.parse(
    'https://www.unicode.org/Public/$unicodeVersion/ucd/UnicodeData.txt');

typedef UnicodeChar = ({int code, String name, String generalCategory});

final unicodeData = (() async {
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
  return results;
})();

// General Categories:
// https://www.unicode.org/reports/tr44/#General_Category_Values
final generalCategories = {
  'Cc': (desc: 'Control', dart: 'control'),
  'Cf': (desc: 'Format', dart: 'format'),
  'Cn': (desc: 'Not Assigned', dart: 'notAssigned'),
  'Co': (desc: 'Private Use', dart: 'privateUse'),
  'Cs': (desc: 'Surrogate', dart: 'surrogate'),
  'Ll': (desc: 'Letter, Lowercase', dart: 'letterLowercase'),
  'Lm': (desc: 'Letter, Modifier', dart: 'letterModifier'),
  'Lo': (desc: 'Letter, Other', dart: 'letterOther'),
  'Lt': (desc: 'Letter, Titlecase', dart: 'letterTitlecase'),
  'Lu': (desc: 'Letter, Uppercase', dart: 'letterUppercase'),
  'Mc': (desc: 'Mark, Spacing Combining', dart: 'markSpacingCombining'),
  'Me': (desc: 'Mark, Enclosing', dart: 'markEnclosing'),
  'Mn': (desc: 'Mark, Non-Spacing', dart: 'markNonSpacing'),
  'Nd': (desc: 'Number, Decimal Digit', dart: 'numberDecimalDigit'),
  'Nl': (desc: 'Number, Letter', dart: 'numberLetter'),
  'No': (desc: 'Number, Other', dart: 'numberOther'),
  'Pc': (desc: 'Punctuation, Connector', dart: 'punctuationConnector'),
  'Pd': (desc: 'Punctuation, Dash', dart: 'punctuationDash'),
  'Pe': (desc: 'Punctuation, Close', dart: 'punctuationClose'),
  'Pf': (desc: 'Punctuation, Final quote', dart: 'punctuationFinalQuote'),
  'Pi': (desc: 'Punctuation, Initial quote', dart: 'punctuationInitialQuote'),
  'Po': (desc: 'Punctuation, Other', dart: 'punctuationOther'),
  'Ps': (desc: 'Punctuation, Open', dart: 'punctuationOpen'),
  'Sc': (desc: 'Symbol, Currency', dart: 'symbolCurrency'),
  'Sk': (desc: 'Symbol, Modifier', dart: 'symbolModifier'),
  'Sm': (desc: 'Symbol, Math', dart: 'symbolMath'),
  'So': (desc: 'Symbol, Other', dart: 'symbolOther'),
  'Zl': (desc: 'Separator, Line', dart: 'separatorLine'),
  'Zp': (desc: 'Separator, Paragraph', dart: 'separatorParagraph'),
  'Zs': (desc: 'Separator, Space', dart: 'separatorSpace'),
};
final generalCategoryGroups = {
  'C': (desc: 'Other', src: ['Cc', 'Cf', 'Cs', 'Co', 'Cn'], dart: 'other'),
  'L': (desc: 'Letter', src: ['Lu', 'Ll', 'Lt', 'Lm', 'Lo'], dart: 'letter'),
  'LC': (desc: 'Letter cased', src: ['Lu', 'Ll', 'Lt'], dart: 'letterCased'),
  'M': (desc: 'Mark', src: ['Mn', 'Mc', 'Me'], dart: 'mark'),
  'N': (desc: 'Number', src: ['Nd', 'Nl', 'No'], dart: 'number'),
  'P': (
    desc: 'Punctuation',
    src: ['Pc', 'Pd', 'Ps', 'Pe', 'Pi', 'Pf', 'Po'],
    dart: 'punctuation'
  ),
  'S': (desc: 'Symbol', src: ['Sm', 'Sc', 'Sk', 'So'], dart: 'symbol'),
  'Z': (desc: 'Separator', src: ['Zs', 'Zl', 'Zp'], dart: 'separator'),
};

Future<void> generateGeneralCategories() async {
  final file = File('lib/src/char_matcher/generated/general_categories.dart');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('import \'../../../char_matcher.dart\';');
  out.writeln('import \'../optimize.dart\';');
  out.writeln('import \'../range.dart\';');
  out.writeln();

  for (final MapEntry(key: abbr, value: category)
      in generalCategories.entries) {
    final characters = (await unicodeData)
        .where((char) => char.generalCategory == abbr)
        .toList();
    final values = <int>[];
    for (final character in characters) {
      if (values.isNotEmpty && values.last == character.code - 1) {
        values.last = character.code;
      } else {
        values.add(character.code);
        values.add(character.code);
      }
    }

    out.writeln('/// ${category.desc} ($abbr)');
    out.writeln('final ${category.dart} = _decode(_${category.dart});');
    out.writeln('const _${category.dart} = <int>[');
    out.writeln('${values.join(', ')} //'.wrap(78).indent('  '));
    out.writeln('];');
    out.writeln();
  }

  for (final MapEntry(key: abbr, value: category)
      in generalCategoryGroups.entries) {
    out.writeln('/// ${category.desc} ($abbr)');
    out.writeln('final ${category.dart} = _decode([');
    for (final abbr in category.src) {
      out.writeln('..._${generalCategories[abbr]!.dart},');
    }
    out.writeln(']);');
    out.writeln();
  }

  out.writeln('CharMatcher _decode(List<int> values) {');
  out.writeln('final result = <RangeCharMatcher>[];');
  out.writeln('for (var i = 0; i < values.length; i += 2) {');
  out.writeln('  result.add(RangeCharMatcher(values[i], values[i + 1]));');
  out.writeln('}');
  out.writeln('return optimize(result);');
  out.writeln('}');

  await out.close();
  await format(file);
}

Future<void> main() async {
  await Future.wait([
    generateGeneralCategories(),
  ]);
}
