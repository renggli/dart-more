import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

import '../test_data.dart';

void main() {
  group('normal differ', () {
    const differ = NormalDiffer();

    test('empty', () {
      check(differ.compareStrings('', '')).isEmpty();
    });

    test('python', () {
      check(differ.compareLines(pythonSource, pythonTarget)).deepEquals([
        '2,4c2,4',
        '< 2. Explicit is better than implicit.',
        '< 3. Simple is better than complex.',
        '< 4. Complex is better than complicated.',
        '---',
        '> 3.   Simple is better than complex.',
        '> 4. Complicated is better than complex.',
        '> 5. Flat is better than nested.',
      ]);
    });

    test('wikipedia', () {
      check(differ.compareLines(wikipediaSource, wikipediaTarget)).deepEquals([
        '0a1,6',
        '> This is an important',
        '> notice! It should',
        '> therefore be located at',
        '> the beginning of this',
        '> document!',
        '> ',
        '11,15d16',
        '< This paragraph contains',
        '< text that is outdated.',
        '< It will be deleted in the',
        '< near future.',
        '< ',
        '17c18',
        '< check this dokument. On',
        '---',
        '> check this document. On',
        '24a26,29',
        '> ',
        '> This paragraph contains',
        '> important new additions',
        '> to this document.',
      ]);
    });
  });
}
