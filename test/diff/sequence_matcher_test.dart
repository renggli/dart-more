import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

import 'test_data.dart';

void main() {
  group('sequence matcher', () {
    final abcd = 'abcd'.split(''), bcde = 'bcde'.split('');

    test('source', () {
      final matcher = SequenceMatcher(source: abcd, target: bcde);
      check(matcher.source).deepEquals(abcd);
      check(matcher.ratio).equals(0.75);
      matcher.source = bcde;
      check(matcher.source).deepEquals(bcde);
      check(matcher.ratio).equals(1.00);
    });

    test('target', () {
      final matcher = SequenceMatcher(source: abcd, target: bcde);
      check(matcher.target).deepEquals(bcde);
      check(matcher.ratio).equals(0.75);
      matcher.target = abcd;
      check(matcher.target).deepEquals(abcd);
      check(matcher.ratio).equals(1.00);
    });

    test('findLongestMatch', () {
      final matcher = SequenceMatcher(
        source: ' abcd'.split(''),
        target: 'abcd abcd'.split(''),
      );
      check(matcher.findLongestMatch())
          .equals(const Match(sourceStart: 0, targetStart: 4, length: 5));
    });

    test('findLongestMatch (with junk)', () {
      final matcher = SequenceMatcher(
        source: '  abcd  '.split(''),
        target: ' abcd abcd '.split(''),
        isJunk: (char) => char == ' ',
      );
      check(matcher.findLongestMatch())
          .equals(const Match(sourceStart: 1, targetStart: 0, length: 6));
    });

    test('findLongestMatch (without match)', () {
      final matcher = SequenceMatcher(
        source: 'ab'.split(''),
        target: 'c'.split(''),
      );
      check(matcher.findLongestMatch())
          .equals(const Match(sourceStart: 0, targetStart: 0, length: 0));
    });

    test('matches', () {
      final matcher = SequenceMatcher(
        source: 'abxcd'.split(''),
        target: 'abcd'.split(''),
      );
      check(matcher.matches).deepEquals([
        const Match(sourceStart: 0, targetStart: 0, length: 2),
        const Match(sourceStart: 3, targetStart: 2, length: 2),
        const Match(sourceStart: 5, targetStart: 4, length: 0),
      ]);
    });

    test('operations', () {
      final matcher = SequenceMatcher(
        source: 'qabxcd'.split(''),
        target: 'abycdf'.split(''),
      );
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.delete,
          sourceStart: 0,
          sourceEnd: 1,
          targetStart: 0,
          targetEnd: 0,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 1,
          sourceEnd: 3,
          targetStart: 0,
          targetEnd: 2,
        ),
        const Operation(
          OperationType.replace,
          sourceStart: 3,
          sourceEnd: 4,
          targetStart: 2,
          targetEnd: 3,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 4,
          sourceEnd: 6,
          targetStart: 3,
          targetEnd: 5,
        ),
        const Operation(
          OperationType.insert,
          sourceStart: 6,
          sourceEnd: 6,
          targetStart: 5,
          targetEnd: 6,
        ),
      ]);
    });

    test('groupedOperations', () {
      final source = IntegerRange(
        1,
        40,
      ).map((each) => each.toString()).toList();
      final target = [...source];
      target.insert(8, 'i'); // make an insertion
      target[20] += 'x'; // make a replacement
      target.removeRange(23, 28); // make a deletion
      target[30] += 'y'; // make another replacement
      final matcher = SequenceMatcher(source: source, target: target);
      check(matcher.groupedOperations()).deepEquals([
        [
          const Operation(
            OperationType.equal,
            sourceStart: 5,
            sourceEnd: 8,
            targetStart: 5,
            targetEnd: 8,
          ),
          const Operation(
            OperationType.insert,
            sourceStart: 8,
            sourceEnd: 8,
            targetStart: 8,
            targetEnd: 9,
          ),
          const Operation(
            OperationType.equal,
            sourceStart: 8,
            sourceEnd: 11,
            targetStart: 9,
            targetEnd: 12,
          ),
        ],
        [
          const Operation(
            OperationType.equal,
            sourceStart: 16,
            sourceEnd: 19,
            targetStart: 17,
            targetEnd: 20,
          ),
          const Operation(
            OperationType.replace,
            sourceStart: 19,
            sourceEnd: 20,
            targetStart: 20,
            targetEnd: 21,
          ),
          const Operation(
            OperationType.equal,
            sourceStart: 20,
            sourceEnd: 22,
            targetStart: 21,
            targetEnd: 23,
          ),
          const Operation(
            OperationType.delete,
            sourceStart: 22,
            sourceEnd: 27,
            targetStart: 23,
            targetEnd: 23,
          ),
          const Operation(
            OperationType.equal,
            sourceStart: 27,
            sourceEnd: 30,
            targetStart: 23,
            targetEnd: 26,
          ),
        ],
        [
          const Operation(
            OperationType.equal,
            sourceStart: 31,
            sourceEnd: 34,
            targetStart: 27,
            targetEnd: 30,
          ),
          const Operation(
            OperationType.replace,
            sourceStart: 34,
            sourceEnd: 35,
            targetStart: 30,
            targetEnd: 31,
          ),
          const Operation(
            OperationType.equal,
            sourceStart: 35,
            sourceEnd: 38,
            targetStart: 31,
            targetEnd: 34,
          ),
        ],
      ]);
    });

    test('groupedOperations invalid context', () {
      final matcher = SequenceMatcher(source: ['a'], target: ['b']);
      check(() => matcher.groupedOperations(context: -1).toList())
          .throws<ArgumentError>();
    });

    test('empty', () {
      final matcher = SequenceMatcher(source: <String>[], target: <String>[]);
      check(matcher.ratio).isCloseTo(1, epsilon);
      check(matcher.quickRatio).isCloseTo(1, epsilon);
      check(matcher.realQuickRatio).isCloseTo(1, epsilon);
      check(matcher.matches)
          .deepEquals([const Match(sourceStart: 0, targetStart: 0, length: 0)]);
      check(matcher.operations).isEmpty();
      check(matcher.groupedOperations()).isEmpty();
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });
  });

  group('caching', () {
    final source = ['a', 'b', 'c'];
    final target = ['c', 'b', 'a'];

    test('blocks', () {
      final matcher = SequenceMatcher(source: source, target: target);
      final blocks = matcher.matches;
      check(matcher.matches).identicalTo(blocks);
    });

    test('operations', () {
      final matcher = SequenceMatcher(source: source, target: target);
      final operations = matcher.operations;
      check(matcher.operations).identicalTo(operations);
    });
  });

  group('insert', () {
    test('begin', () {
      final a = [...repeat('a', count: 100)];
      final b = ['x', ...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.995, epsilon);
      check(matcher.quickRatio).isCloseTo(0.995, epsilon);
      check(matcher.realQuickRatio).isCloseTo(0.995, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.insert,
          sourceStart: 0,
          sourceEnd: 0,
          targetStart: 0,
          targetEnd: 1,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 0,
          sourceEnd: 100,
          targetStart: 1,
          targetEnd: 101,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });

    test('middle', () {
      final a = [...repeat('a', count: 100)];
      final b = [...repeat('a', count: 50), 'x', ...repeat('a', count: 50)];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.995, epsilon);
      check(matcher.quickRatio).isCloseTo(0.995, epsilon);
      check(matcher.realQuickRatio).isCloseTo(0.995, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.equal,
          sourceStart: 0,
          sourceEnd: 50,
          targetStart: 0,
          targetEnd: 50,
        ),
        const Operation(
          OperationType.insert,
          sourceStart: 50,
          sourceEnd: 50,
          targetStart: 50,
          targetEnd: 51,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 50,
          sourceEnd: 100,
          targetStart: 51,
          targetEnd: 101,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });

    test('end', () {
      final a = [...repeat('a', count: 100)];
      final b = [...repeat('a', count: 100), 'x'];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.995, epsilon);
      check(matcher.quickRatio).isCloseTo(0.995, epsilon);
      check(matcher.realQuickRatio).isCloseTo(0.995, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.equal,
          sourceStart: 0,
          sourceEnd: 100,
          targetStart: 0,
          targetEnd: 100,
        ),
        const Operation(
          OperationType.insert,
          sourceStart: 100,
          sourceEnd: 100,
          targetStart: 100,
          targetEnd: 101,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });
  });

  group('replace', () {
    test('begin', () {
      final a = ['x', ...repeat('a', count: 100)];
      final b = ['y', ...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.990, epsilon);
      check(matcher.quickRatio).isCloseTo(0.990, epsilon);
      check(matcher.realQuickRatio).isCloseTo(1, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.replace,
          sourceStart: 0,
          sourceEnd: 1,
          targetStart: 0,
          targetEnd: 1,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 1,
          sourceEnd: 101,
          targetStart: 1,
          targetEnd: 101,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });

    test('middle', () {
      final a = [...repeat('a', count: 50), 'x', ...repeat('a', count: 50)];
      final b = [...repeat('a', count: 50), 'y', ...repeat('a', count: 50)];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.990, epsilon);
      check(matcher.quickRatio).isCloseTo(0.990, epsilon);
      check(matcher.realQuickRatio).isCloseTo(1, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.equal,
          sourceStart: 0,
          sourceEnd: 50,
          targetStart: 0,
          targetEnd: 50,
        ),
        const Operation(
          OperationType.replace,
          sourceStart: 50,
          sourceEnd: 51,
          targetStart: 50,
          targetEnd: 51,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 51,
          sourceEnd: 101,
          targetStart: 51,
          targetEnd: 101,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });

    test('end', () {
      final a = [...repeat('a', count: 100), 'x'];
      final b = [...repeat('a', count: 100), 'y'];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.990, epsilon);
      check(matcher.quickRatio).isCloseTo(0.990, epsilon);
      check(matcher.realQuickRatio).isCloseTo(1, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.equal,
          sourceStart: 0,
          sourceEnd: 100,
          targetStart: 0,
          targetEnd: 100,
        ),
        const Operation(
          OperationType.replace,
          sourceStart: 100,
          sourceEnd: 101,
          targetStart: 100,
          targetEnd: 101,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });
  });

  group('delete', () {
    test('begin', () {
      final a = ['x', ...repeat('a', count: 100)];
      final b = [...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.995, epsilon);
      check(matcher.quickRatio).isCloseTo(0.995, epsilon);
      check(matcher.realQuickRatio).isCloseTo(0.995, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.delete,
          sourceStart: 0,
          sourceEnd: 1,
          targetStart: 0,
          targetEnd: 0,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 1,
          sourceEnd: 101,
          targetStart: 0,
          targetEnd: 100,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });

    test('middle', () {
      final a = [...repeat('a', count: 50), 'x', ...repeat('a', count: 50)];
      final b = [...repeat('a', count: 100)];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.995, epsilon);
      check(matcher.quickRatio).isCloseTo(0.995, epsilon);
      check(matcher.realQuickRatio).isCloseTo(0.995, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.equal,
          sourceStart: 0,
          sourceEnd: 50,
          targetStart: 0,
          targetEnd: 50,
        ),
        const Operation(
          OperationType.delete,
          sourceStart: 50,
          sourceEnd: 51,
          targetStart: 50,
          targetEnd: 50,
        ),
        const Operation(
          OperationType.equal,
          sourceStart: 51,
          sourceEnd: 101,
          targetStart: 50,
          targetEnd: 100,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });

    test('end', () {
      final a = [...repeat('a', count: 100)];
      final b = [...repeat('a', count: 100), 'x'];
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.995, epsilon);
      check(matcher.quickRatio).isCloseTo(0.995, epsilon);
      check(matcher.realQuickRatio).isCloseTo(0.995, epsilon);
      check(matcher.operations).deepEquals([
        const Operation(
          OperationType.equal,
          sourceStart: 0,
          sourceEnd: 100,
          targetStart: 0,
          targetEnd: 100,
        ),
        const Operation(
          OperationType.insert,
          sourceStart: 100,
          sourceEnd: 100,
          targetStart: 100,
          targetEnd: 101,
        ),
      ]);
      check(matcher.targetJunk).isEmpty();
      check(matcher.targetPopular).isEmpty();
    });
  });

  group('isJunk', () {
    test('no junk', () {
      final a = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final b = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final matcher = SequenceMatcher(
        source: a,
        target: b,
        isJunk: (char) => false,
      );
      check(matcher.targetJunk).isEmpty();
    });

    test('some junk', () {
      final a = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final b = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final matcher = SequenceMatcher(
        source: a,
        target: b,
        isJunk: {'a'}.contains,
      );
      check(matcher.targetJunk).deepEquals({'a'});
    });

    test('all junk', () {
      final a = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final b = [...repeat('a', count: 5), ...repeat('b', count: 5)];
      final matcher = SequenceMatcher(
        source: a,
        target: b,
        isJunk: {'a', 'b'}.contains,
      );
      check(matcher.targetJunk).deepEquals({'a', 'b'});
    });
  });

  group('autoJunk', () {
    final a = [...repeat('b', count: 200)];
    final b = ['a', ...repeat('b', count: 200)];

    test('default', () {
      final matcher = SequenceMatcher(source: a, target: b);
      check(matcher.ratio).isCloseTo(0.0, epsilon);
      check(matcher.targetPopular).deepEquals({'b'});
    });

    test('suppressed', () {
      final matcher = SequenceMatcher(source: a, target: b, autoJunk: false);
      check(matcher.ratio).isCloseTo(0.9975, epsilon);
      check(matcher.targetPopular).isEmpty();
    });
  });
}
