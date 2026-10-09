import 'package:checks/context.dart';

// Used to compare equality ratios.
const epsilon = 0.001;

extension CloseToChecks<T extends num> on Subject<T> {
  void isCloseTo(num expected, num delta) {
    context.expect(() => ['is within $delta of $expected'], (actual) {
      final diff = (actual - expected).abs();
      if (diff <= delta) return null;
      return Rejection(which: ['differs by $diff']);
    });
  }
}

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
