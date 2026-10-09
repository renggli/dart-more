import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import '../test_data.dart';

void main() {
  group('readable differ', () {
    final differ = ReadableDiffer();

    test('empty', () {
      check(differ.compareStrings('', '')).isEmpty();
    });

    test('python', () {
      check(differ.compareLines(pythonSource, pythonTarget)).deepEquals([
        '  1. Beautiful is better than ugly.',
        '- 2. Explicit is better than implicit.',
        '- 3. Simple is better than complex.',
        '+ 3.   Simple is better than complex.',
        '?   ++',
        '- 4. Complex is better than complicated.',
        '?          ^                     ---- ^',
        '+ 4. Complicated is better than complex.',
        '?         ++++ ^                      ^',
        '+ 5. Flat is better than nested.',
      ]);
    });

    test('wikipedia', () {
      check(differ.compareLines(wikipediaSource, wikipediaTarget)).deepEquals([
        '+ This is an important',
        '+ notice! It should',
        '+ therefore be located at',
        '+ the beginning of this',
        '+ document!',
        '+ ',
        '  This part of the',
        '  document has stayed the',
        '  same from version to',
        '  version.  It shouldn\'t',
        '  be shown if it doesn\'t',
        '  change.  Otherwise, that',
        '  would not be helping to',
        '  compress the size of the',
        '  changes.',
        '  ',
        '- This paragraph contains',
        '- text that is outdated.',
        '- It will be deleted in the',
        '- near future.',
        '- ',
        '  It is important to spell',
        '- check this dokument. On',
        '?              ^',
        '+ check this document. On',
        '?              ^',
        '  the other hand, a',
        '  misspelled word isn\'t',
        '  the end of the world.',
        '  Nothing in the rest of',
        '  this paragraph needs to',
        '  be changed. Things can',
        '  be added after it.',
        '+ ',
        '+ This paragraph contains',
        '+ important new additions',
        '+ to this document.',
      ]);
    });

    test('custom lineJunk and charJunk', () {
      final custom = ReadableDiffer(
        lineJunk: (line) => line.isEmpty,
        charJunk: (char) => char == 32, // space
      );
      check(custom.compareLines(['hello world'], ['hello  world']))
          .deepEquals(['- hello world', '+ hello  world', '?       +']);
    });

    test('custom printers', () {
      final custom = ReadableDiffer(
        replaceLine: const Printer<String>.standard().before('MOD: '),
        deleteLine: const Printer<String>.standard().before('DEL: '),
        insertLine: const Printer<String>.standard().before('INS: '),
        equalLine: const Printer<String>.standard().before('EQ: '),
      );
      check(custom.compareLines(['a', 'b', 'c'], ['a', 'x', 'c']))
          .deepEquals(['EQ: a', 'DEL: b', 'INS: x', 'EQ: c']);
    });
  });
}
