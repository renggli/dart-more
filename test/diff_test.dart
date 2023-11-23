import 'package:more/collection.dart';
import 'package:more/diff.dart';
import 'package:test/test.dart';

// Used to compare equality ratios.
const epsilon = 0.001;

// https://github.com/python/cpython/blob/main/Lib/test/test_difflib.py
const pythonSource = [
  '1. Beautiful is better than ugly.',
  '2. Explicit is better than implicit.',
  '3. Simple is better than complex.',
  '4. Complex is better than complicated.',
];
const pythonTarget = [
  '1. Beautiful is better than ugly.',
  '3.   Simple is better than complex.',
  '4. Complicated is better than complex.',
  '5. Flat is better than nested.',
];

// https://en.wikipedia.org/wiki/Diff#Usage
const wikipediaSource = [
  'This part of the',
  'document has stayed the',
  'same from version to',
  'version.  It shouldn\'t',
  'be shown if it doesn\'t',
  'change.  Otherwise, that',
  'would not be helping to',
  'compress the size of the',
  'changes.',
  '',
  'This paragraph contains',
  'text that is outdated.',
  'It will be deleted in the',
  'near future.',
  '',
  'It is important to spell',
  'check this dokument. On',
  'the other hand, a',
  'misspelled word isn\'t',
  'the end of the world.',
  'Nothing in the rest of',
  'this paragraph needs to',
  'be changed. Things can',
  'be added after it.',
];
const wikipediaTarget = [
  'This is an important',
  'notice! It should',
  'therefore be located at',
  'the beginning of this',
  'document!',
  '',
  'This part of the',
  'document has stayed the',
  'same from version to',
  'version.  It shouldn\'t',
  'be shown if it doesn\'t',
  'change.  Otherwise, that',
  'would not be helping to',
  'compress the size of the',
  'changes.',
  '',
  'It is important to spell',
  'check this document. On',
  'the other hand, a',
  'misspelled word isn\'t',
  'the end of the world.',
  'Nothing in the rest of',
  'this paragraph needs to',
  'be changed. Things can',
  'be added after it.',
  '',
  'This paragraph contains',
  'important new additions',
  'to this document.',
];

Matcher isMatch({
  dynamic sourceStart = anything,
  dynamic targetStart = anything,
  dynamic length = anything,
}) =>
    isA<Match>()
        .having((m) => m.sourceStart, 'sourceStart', sourceStart)
        .having((m) => m.targetStart, 'targetStart', targetStart)
        .having((m) => m.length, 'length', length);

Matcher isOperation(
  dynamic type, {
  dynamic sourceStart = anything,
  dynamic sourceEnd = anything,
  dynamic targetStart = anything,
  dynamic targetEnd = anything,
}) =>
    isA<Operation>()
        .having((m) => m.type, 'type', type)
        .having((m) => m.sourceStart, 'sourceStart', sourceStart)
        .having((m) => m.sourceEnd, 'sourceEnd', sourceEnd)
        .having((m) => m.targetStart, 'targetStart', targetStart)
        .having((m) => m.targetEnd, 'targetEnd', targetEnd);

void main() {
  group('sequence matcher', () {
    final abcd = 'abcd'.split(''), bcde = 'bcde'.split('');
    test('source', () {
      final matcher = SequenceMatcher(source: abcd, target: bcde);
      expect(matcher.source, abcd);
      expect(matcher.ratio, 0.75);
      matcher.source = bcde;
      expect(matcher.source, bcde);
      expect(matcher.ratio, 1.00);
    });
    test('target', () {
      final matcher = SequenceMatcher(source: abcd, target: bcde);
      expect(matcher.target, bcde);
      expect(matcher.ratio, 0.75);
      matcher.target = abcd;
      expect(matcher.target, abcd);
      expect(matcher.ratio, 1.00);
    });
    test('findLongestMatch', () {
      final matcher = SequenceMatcher(
          source: ' abcd'.split(''), target: 'abcd abcd'.split(''));
      expect(matcher.findLongestMatch(),
          isMatch(sourceStart: 0, targetStart: 4, length: 5));
    });
    test('findLongestMatch (with junk)', () {
      final matcher = SequenceMatcher(
          source: '  abcd  '.split(''),
          target: ' abcd abcd '.split(''),
          isJunk: (char) => char == ' ');
      expect(matcher.findLongestMatch(),
          isMatch(sourceStart: 1, targetStart: 0, length: 6));
    });
    test('findLongestMatch (without match)', () {
      final matcher =
          SequenceMatcher(source: 'ab'.split(''), target: 'c'.split(''));
      expect(matcher.findLongestMatch(),
          isMatch(sourceStart: 0, targetStart: 0, length: 0));
    });
    test('match', () {
      const match = Match(sourceStart: 1, targetStart: 2, length: 3);
      const other = Match(sourceStart: 4, targetStart: 5, length: 6);
      expect(
          match.toString(),
          endsWith('(sourceStart: 1, targetStart: 2, '
              'length: 3)'));
      expect(match == other, isFalse);
      expect(match == match, isTrue);
      expect(match.hashCode, isNot(other.hashCode));
      expect(match.compareTo(other), -1);
      expect(other.compareTo(match), 1);
      expect(match.compareTo(match), 0);
    });
    test('matches', () {
      final matcher =
          SequenceMatcher(source: 'abxcd'.split(''), target: 'abcd'.split(''));
      expect(matcher.matches, [
        isMatch(sourceStart: 0, targetStart: 0, length: 2),
        isMatch(sourceStart: 3, targetStart: 2, length: 2),
        isMatch(sourceStart: 5, targetStart: 4, length: 0),
      ]);
    });
    test('operation', () {
      const operation = Operation(OperationType.equal,
          sourceStart: 1, sourceEnd: 2, targetStart: 2, targetEnd: 3);
      const other = Operation(OperationType.replace,
          sourceStart: 4, sourceEnd: 5, targetStart: 6, targetEnd: 7);
      expect(
          operation.toString(),
          endsWith('sourceStart: 1, sourceEnd: 2, '
              'targetStart: 2, targetEnd: 3)'));
      expect(operation == other, isFalse);
      expect(operation == operation, isTrue);
      expect(operation.hashCode, isNot(other.hashCode));
    });
    test('operations', () {
      final matcher = SequenceMatcher(
          source: 'qabxcd'.split(''), target: 'abycdf'.split(''));
      expect(matcher.operations, [
        isOperation(OperationType.delete,
            sourceStart: 0, sourceEnd: 1, targetStart: 0, targetEnd: 0),
        isOperation(OperationType.equal,
            sourceStart: 1, sourceEnd: 3, targetStart: 0, targetEnd: 2),
        isOperation(OperationType.replace,
            sourceStart: 3, sourceEnd: 4, targetStart: 2, targetEnd: 3),
        isOperation(OperationType.equal,
            sourceStart: 4, sourceEnd: 6, targetStart: 3, targetEnd: 5),
        isOperation(OperationType.insert,
            sourceStart: 6, sourceEnd: 6, targetStart: 5, targetEnd: 6),
      ]);
    });
    test('groupedOperations', () {
      final source =
          IntegerRange(1, 40).map((each) => each.toString()).toList();
      final target = [...source];
      target.insert(8, 'i'); // make an insertion
      target[20] += 'x'; // make a replacement
      target.removeRange(23, 28); // make a deletion
      target[30] += 'y'; // make another replacement
      final matcher = SequenceMatcher(source: source, target: target);
      expect(matcher.groupedOperations(), [
        [
          isOperation(OperationType.equal,
              sourceStart: 5, sourceEnd: 8, targetStart: 5, targetEnd: 8),
          isOperation(OperationType.insert,
              sourceStart: 8, sourceEnd: 8, targetStart: 8, targetEnd: 9),
          isOperation(OperationType.equal,
              sourceStart: 8, sourceEnd: 11, targetStart: 9, targetEnd: 12)
        ],
        [
          isOperation(OperationType.equal,
              sourceStart: 16, sourceEnd: 19, targetStart: 17, targetEnd: 20),
          isOperation(OperationType.replace,
              sourceStart: 19, sourceEnd: 20, targetStart: 20, targetEnd: 21),
          isOperation(OperationType.equal,
              sourceStart: 20, sourceEnd: 22, targetStart: 21, targetEnd: 23),
          isOperation(OperationType.delete,
              sourceStart: 22, sourceEnd: 27, targetStart: 23, targetEnd: 23),
          isOperation(OperationType.equal,
              sourceStart: 27, sourceEnd: 30, targetStart: 23, targetEnd: 26)
        ],
        [
          isOperation(OperationType.equal,
              sourceStart: 31, sourceEnd: 34, targetStart: 27, targetEnd: 30),
          isOperation(OperationType.replace,
              sourceStart: 34, sourceEnd: 35, targetStart: 30, targetEnd: 31),
          isOperation(OperationType.equal,
              sourceStart: 35, sourceEnd: 38, targetStart: 31, targetEnd: 34)
        ]
      ]);
    });
    test('empty', () {
      final matcher = SequenceMatcher(source: <String>[], target: <String>[]);
      expect(matcher.ratio, closeTo(1, epsilon));
      expect(matcher.quickRatio, closeTo(1, epsilon));
      expect(matcher.realQuickRatio, closeTo(1, epsilon));
      expect(matcher.matches,
          [isMatch(sourceStart: 0, targetStart: 0, length: 0)]);
      expect(matcher.operations, isEmpty);
      expect(matcher.groupedOperations(), isEmpty);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
  });
  group('caching', () {
    final source = ['a', 'b', 'c'];
    final target = ['c', 'b', 'a'];
    test('blocks', () {
      final matcher = SequenceMatcher(source: source, target: target);
      final blocks = matcher.matches;
      expect(matcher.matches, same(blocks));
    });
    test('operations', () {
      final matcher = SequenceMatcher(source: source, target: target);
      final operations = matcher.operations;
      expect(matcher.operations, same(operations));
    });
  });
  group('insert', () {
    test('begin', () {
      final a = [...repeat('a', count: 100)];
      final b = ['x', ...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.995, epsilon));
      expect(matcher.quickRatio, closeTo(0.995, epsilon));
      expect(matcher.realQuickRatio, closeTo(0.995, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.insert,
            sourceStart: 0, sourceEnd: 0, targetStart: 0, targetEnd: 1),
        isOperation(OperationType.equal,
            sourceStart: 0, sourceEnd: 100, targetStart: 1, targetEnd: 101)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
    test('middle', () {
      final a = [...repeat('a', count: 100)];
      final b = [...repeat('a', count: 50), 'x', ...repeat('a', count: 50)];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.995, epsilon));
      expect(matcher.quickRatio, closeTo(0.995, epsilon));
      expect(matcher.realQuickRatio, closeTo(0.995, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.equal,
            sourceStart: 0, sourceEnd: 50, targetStart: 0, targetEnd: 50),
        isOperation(OperationType.insert,
            sourceStart: 50, sourceEnd: 50, targetStart: 50, targetEnd: 51),
        isOperation(OperationType.equal,
            sourceStart: 50, sourceEnd: 100, targetStart: 51, targetEnd: 101)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
    test('end', () {
      final a = [...repeat('a', count: 100)];
      final b = [...repeat('a', count: 100), 'x'];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.995, epsilon));
      expect(matcher.quickRatio, closeTo(0.995, epsilon));
      expect(matcher.realQuickRatio, closeTo(0.995, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.equal,
            sourceStart: 0, sourceEnd: 100, targetStart: 0, targetEnd: 100),
        isOperation(OperationType.insert,
            sourceStart: 100, sourceEnd: 100, targetStart: 100, targetEnd: 101)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
  });
  group('replace', () {
    test('begin', () {
      final a = ['x', ...repeat('a', count: 100)];
      final b = ['y', ...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.990, epsilon));
      expect(matcher.quickRatio, closeTo(0.990, epsilon));
      expect(matcher.realQuickRatio, closeTo(1, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.replace,
            sourceStart: 0, sourceEnd: 1, targetStart: 0, targetEnd: 1),
        isOperation(OperationType.equal,
            sourceStart: 1, sourceEnd: 101, targetStart: 1, targetEnd: 101)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
    test('middle', () {
      final a = [...repeat('a', count: 50), 'x', ...repeat('a', count: 50)];
      final b = [...repeat('a', count: 50), 'y', ...repeat('a', count: 50)];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.990, epsilon));
      expect(matcher.quickRatio, closeTo(0.990, epsilon));
      expect(matcher.realQuickRatio, closeTo(1, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.equal,
            sourceStart: 0, sourceEnd: 50, targetStart: 0, targetEnd: 50),
        isOperation(OperationType.replace,
            sourceStart: 50, sourceEnd: 51, targetStart: 50, targetEnd: 51),
        isOperation(OperationType.equal,
            sourceStart: 51, sourceEnd: 101, targetStart: 51, targetEnd: 101)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
    test('end', () {
      final a = [...repeat('a', count: 100), 'x'];
      final b = [...repeat('a', count: 100), 'y'];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.990, epsilon));
      expect(matcher.quickRatio, closeTo(0.990, epsilon));
      expect(matcher.realQuickRatio, closeTo(1, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.equal,
            sourceStart: 0, sourceEnd: 100, targetStart: 0, targetEnd: 100),
        isOperation(OperationType.replace,
            sourceStart: 100, sourceEnd: 101, targetStart: 100, targetEnd: 101)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
  });
  group('delete', () {
    test('begin', () {
      final a = ['x', ...repeat('a', count: 100)];
      final b = [...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.995, epsilon));
      expect(matcher.quickRatio, closeTo(0.995, epsilon));
      expect(matcher.realQuickRatio, closeTo(0.995, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.delete,
            sourceStart: 0, sourceEnd: 1, targetStart: 0, targetEnd: 0),
        isOperation(OperationType.equal,
            sourceStart: 1, sourceEnd: 101, targetStart: 0, targetEnd: 100)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
    test('middle', () {
      final a = [...repeat('a', count: 50), 'x', ...repeat('a', count: 50)];
      final b = [...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.995, epsilon));
      expect(matcher.quickRatio, closeTo(0.995, epsilon));
      expect(matcher.realQuickRatio, closeTo(0.995, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.equal,
            sourceStart: 0, sourceEnd: 50, targetStart: 0, targetEnd: 50),
        isOperation(OperationType.delete,
            sourceStart: 50, sourceEnd: 51, targetStart: 50, targetEnd: 50),
        isOperation(OperationType.equal,
            sourceStart: 51, sourceEnd: 101, targetStart: 50, targetEnd: 100)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
    test('end', () {
      final a = [...repeat('a', count: 100)];
      final b = [...repeat('a', count: 100), 'x'];
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.995, epsilon));
      expect(matcher.quickRatio, closeTo(0.995, epsilon));
      expect(matcher.realQuickRatio, closeTo(0.995, epsilon));
      expect(matcher.operations, [
        isOperation(OperationType.equal,
            sourceStart: 0, sourceEnd: 100, targetStart: 0, targetEnd: 100),
        isOperation(OperationType.insert,
            sourceStart: 100, sourceEnd: 100, targetStart: 100, targetEnd: 101)
      ]);
      expect(matcher.targetJunk, isEmpty);
      expect(matcher.targetPopular, isEmpty);
    });
  });
  group('isJunk', () {
    test('no junk', () {
      final a = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final b = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final matcher =
          SequenceMatcher(source: a, target: b, isJunk: (char) => false);
      expect(matcher.targetJunk, isEmpty);
    });
    test('some junk', () {
      final a = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final b = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final matcher =
          SequenceMatcher(source: a, target: b, isJunk: {'a'}.contains);
      expect(matcher.targetJunk, {'a'});
    });
    test('all junk', () {
      final a = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final b = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final matcher =
          SequenceMatcher(source: a, target: b, isJunk: {'a', 'b'}.contains);
      expect(matcher.targetJunk, {'a', 'b'});
    });
  });
  group('autoJunk', () {
    final a = [...repeat('b', count: 200)];
    final b = ['a', ...repeat('b', count: 200)];
    test('default', () {
      final matcher = SequenceMatcher(source: a, target: b);
      expect(matcher.ratio, closeTo(0.0, epsilon));
      expect(matcher.targetPopular, {'b'});
    });
    test('suppressed', () {
      final matcher = SequenceMatcher(source: a, target: b, autoJunk: false);
      expect(matcher.ratio, closeTo(0.9975, epsilon));
      expect(matcher.targetPopular, isEmpty);
    });
  });
  group('closeMatches', () {
    test('basic', () {
      expect(['ape', 'apple', 'peach', 'puppy'].closeMatches('appel'),
          ['apple', 'ape']);
    });
    test('keywords', () {
      final keywords = 'abstract as assert async await base break case catch '
              'class const continue covariant default deferred do dynamic else '
              'enum export extends extension external factory false final '
              'finally for function get hide if implements import in interface '
              'is late library mixin new null on operator part required '
              'rethrow return sealed set show static super switch sync this '
              'throw true try typedef var void when while with yield'
          .split(' ');
      expect(keywords.closeMatches('is'), ['is', 'this']);
      expect(keywords.closeMatches('wheel'), ['when', 'while']);
      expect(keywords.closeMatches('valiant'), ['covariant']);
    });
  });
  group('context differ', () {
    final differ = ContextDiffer();
    test('empty', () {
      expect(
          differ.compareStrings('', '',
              sourceLabel: 'original', targetLabel: 'current'),
          ['*** original', '--- current']);
    });
    test('python', () {
      expect(
          differ.compareLines(pythonSource, pythonTarget,
              sourceLabel: 'original', targetLabel: 'current'),
          [
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
      expect(
          differ.compareLines(wikipediaSource, wikipediaTarget,
              sourceLabel: 'original', targetLabel: 'current'),
          [
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
  group('default differ', () {
    final differ = NormalDiffer();
    test('empty', () {
      expect(differ.compareStrings('', ''), isEmpty);
    });
    test('python', () {
      expect(differ.compareLines(pythonSource, pythonTarget), [
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
      expect(differ.compareLines(wikipediaSource, wikipediaTarget), [
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
  group('readable differ', () {
    final differ = ReadableDiffer();
    test('empty', () {
      expect(differ.compareStrings('', ''), isEmpty);
    });
    test('python', () {
      expect(differ.compareLines(pythonSource, pythonTarget), [
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
      expect(differ.compareLines(wikipediaSource, wikipediaTarget), [
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
  });
  group('unified differ', () {
    final differ = UnifiedDiffer();
    test('empty', () {
      expect(
          differ.compareLines([], [],
              sourceLabel: 'original', targetLabel: 'current'),
          ['--- original', '+++ current']);
    });
    test('python', () {
      expect(
          differ.compareLines(pythonSource, pythonTarget,
              sourceLabel: 'original', targetLabel: 'current'),
          [
            '--- original',
            '+++ current',
            '@@ -1,4 +1,4 @@',
            ' 1. Beautiful is better than ugly.',
            '-2. Explicit is better than implicit.',
            '-3. Simple is better than complex.',
            '-4. Complex is better than complicated.',
            '+3.   Simple is better than complex.',
            '+4. Complicated is better than complex.',
            '+5. Flat is better than nested.',
          ]);
    });
    test('wikipedia', () {
      expect(
          differ.compareLines(wikipediaSource, wikipediaTarget,
              sourceLabel: 'original', targetLabel: 'current'),
          [
            '--- original',
            '+++ current',
            '@@ -1,3 +1,9 @@',
            '+This is an important',
            '+notice! It should',
            '+therefore be located at',
            '+the beginning of this',
            '+document!',
            '+',
            ' This part of the',
            ' document has stayed the',
            ' same from version to',
            '@@ -8,13 +14,8 @@',
            ' compress the size of the',
            ' changes.',
            ' ',
            '-This paragraph contains',
            '-text that is outdated.',
            '-It will be deleted in the',
            '-near future.',
            '-',
            ' It is important to spell',
            '-check this dokument. On',
            '+check this document. On',
            ' the other hand, a',
            ' misspelled word isn\'t',
            ' the end of the world.',
            '@@ -22,3 +23,7 @@',
            ' this paragraph needs to',
            ' be changed. Things can',
            ' be added after it.',
            '+',
            '+This paragraph contains',
            '+important new additions',
            '+to this document.',
          ]);
    });
  });
}
