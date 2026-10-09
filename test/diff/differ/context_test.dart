import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

import '../test_data.dart';

void main() {
  group('context differ', () {
    const differ = ContextDiffer();

    test('constructor', () {
      check(differ.context).equals(3);
      check(const ContextDiffer(context: 5).context).equals(5);
    });

    test('empty', () {
      check(
        differ.compareStrings(
          '',
          '',
          sourceLabel: 'original',
          targetLabel: 'current',
        ),
      ).deepEquals(['*** original', '--- current']);
    });

    test('python', () {
      check(
        differ.compareLines(
          pythonSource,
          pythonTarget,
          sourceLabel: 'original',
          targetLabel: 'current',
        ),
      ).deepEquals([
        '*** original',
        '--- current',
        '***************',
        '*** 1,4 ****',
        '  1. Beautiful is better than ugly.',
        '! 2. Explicit is better than implicit.',
        '! 3. Simple is better than complex.',
        '! 4. Complex is better than complicated.',
        '--- 1,4 ----',
        '  1. Beautiful is better than ugly.',
        '! 3.   Simple is better than complex.',
        '! 4. Complicated is better than complex.',
        '! 5. Flat is better than nested.',
      ]);
    });

    test('wikipedia', () {
      check(
        differ.compareLines(
          wikipediaSource,
          wikipediaTarget,
          sourceLabel: 'original',
          targetLabel: 'current',
        ),
      ).deepEquals([
        '*** original',
        '--- current',
        '***************',
        '*** 1,3 ****',
        '--- 1,9 ----',
        '+ This is an important',
        '+ notice! It should',
        '+ therefore be located at',
        '+ the beginning of this',
        '+ document!',
        '+ ',
        '  This part of the',
        '  document has stayed the',
        '  same from version to',
        '***************',
        '*** 8,20 ****',
        '  compress the size of the',
        '  changes.',
        '  ',
        '- This paragraph contains',
        '- text that is outdated.',
        '- It will be deleted in the',
        '- near future.',
        '- ',
        '  It is important to spell',
        '! check this dokument. On',
        '  the other hand, a',
        '  misspelled word isn\'t',
        '  the end of the world.',
        '--- 14,21 ----',
        '  compress the size of the',
        '  changes.',
        '  ',
        '  It is important to spell',
        '! check this document. On',
        '  the other hand, a',
        '  misspelled word isn\'t',
        '  the end of the world.',
        '***************',
        '*** 22,24 ****',
        '--- 23,29 ----',
        '  this paragraph needs to',
        '  be changed. Things can',
        '  be added after it.',
        '+ ',
        '+ This paragraph contains',
        '+ important new additions',
        '+ to this document.',
      ]);
    });
  });
}
