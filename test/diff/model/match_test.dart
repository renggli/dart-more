import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('match', () {
    const match = Match(sourceStart: 1, targetStart: 2, length: 3);
    const other = Match(sourceStart: 4, targetStart: 5, length: 6);

    test('properties', () {
      check(match)
        ..sourceStart.equals(1)
        ..targetStart.equals(2)
        ..length.equals(3);
    });

    test('toString', () {
      check(match.toString())
          .endsWith('(sourceStart: 1, targetStart: 2, length: 3)');
    });

    test('equality and hashCode', () {
      check(match == other).isFalse();
      check(match == match).isTrue();
      check(match == const Match(sourceStart: 1, targetStart: 2, length: 3))
          .isTrue();
      check(match == const Match(sourceStart: 9, targetStart: 2, length: 3))
          .isFalse();
      check(match == const Match(sourceStart: 1, targetStart: 9, length: 3))
          .isFalse();
      check(match == const Match(sourceStart: 1, targetStart: 2, length: 9))
          .isFalse();
      check(match.hashCode).not((it) => it.equals(other.hashCode));
      check(
        match.hashCode,
      ).equals(const Match(sourceStart: 1, targetStart: 2, length: 3).hashCode);
    });

    test('compareTo', () {
      check(match.compareTo(other)).equals(-1);
      check(other.compareTo(match)).equals(1);
      check(match.compareTo(match)).equals(0);

      const sameSource = Match(sourceStart: 1, targetStart: 5, length: 3);
      check(match.compareTo(sameSource)).equals(-1);
      check(sameSource.compareTo(match)).equals(1);

      const sameSourceAndTarget = Match(
        sourceStart: 1,
        targetStart: 2,
        length: 5,
      );
      check(match.compareTo(sameSourceAndTarget)).equals(-1);
      check(sameSourceAndTarget.compareTo(match)).equals(1);
    });
  });
}
