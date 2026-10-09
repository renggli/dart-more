import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('toList', () {
    const emptyString = '';
    const plentyString = 'Banana🍌';

    group('immutable standard', () {
      final empty = emptyString.toList();
      final plenty = plentyString.toList();

      test('isEmpty', () {
        check(empty.isEmpty).isTrue();
        check(plenty.isEmpty).isFalse();
      });
      test('length', () {
        check(empty.length).equals(0);
        check(plenty.length).equals(8);
      });
      test('reading', () {
        check(plenty[0]).equals('B');
        check(plenty[1]).equals('a');
        check(plenty[2]).equals('n');
        check(plenty[3]).equals('a');
        check(plenty[4]).equals('n');
        check(plenty[5]).equals('a');
        check(plenty[6]).equals('\ud83c');
        check(plenty[7]).equals('\udf4c');
      });
      test('reading (range error)', () {
        check(() => empty[0]).throws<RangeError>();
        check(() => plenty[-1]).throws<RangeError>();
        check(() => plenty[8]).throws<RangeError>();
      });
      test('converting', () {
        check(empty.toList()).isEmpty();
        check(plenty.toList())
            .deepEquals(['B', 'a', 'n', 'a', 'n', 'a', '\ud83c', '\udf4c']);
        check(empty.toSet()).isEmpty();
        check(plenty.toSet()).deepEquals({'B', 'a', 'n', '\ud83c', '\udf4c'});
        check(empty.toString()).equals(emptyString);
        check(plenty.toString()).equals(plentyString);
      });
      test('read-only', () {
        check(() => plenty[0] = 'a').throws<UnsupportedError>();
        check(() => plenty.length = 10).throws<UnsupportedError>();
        check(() => plenty.add('a')).throws<UnsupportedError>();
        check(() => plenty.remove('a')).throws<UnsupportedError>();
      });
      test('sublist', () {
        check(plenty.sublist(5).toString()).equals(plentyString.substring(5));
        check(plenty.sublist(5, 7).toString())
            .equals(plentyString.substring(5, 7));
      });
    });

    group('mutable standard', () {
      final empty = emptyString.toList(mutable: true);
      final plenty = plentyString.toList(mutable: true);

      test('isEmpty', () {
        check(empty.isEmpty).isTrue();
        check(plenty.isEmpty).isFalse();
      });
      test('length', () {
        check(empty.length).equals(0);
        check(plenty.length).equals(8);
      });
      test('reading', () {
        check(plenty[0]).equals('B');
        check(plenty[1]).equals('a');
        check(plenty[2]).equals('n');
        check(plenty[3]).equals('a');
        check(plenty[4]).equals('n');
        check(plenty[5]).equals('a');
        check(plenty[6]).equals('\ud83c');
        check(plenty[7]).equals('\udf4c');
      });
      test('reading (range error)', () {
        check(() => empty[0]).throws<RangeError>();
        check(() => plenty[-1]).throws<RangeError>();
        check(() => plenty[8]).throws<RangeError>();
      });
      test('writing', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable[1] = 'd';
        check(mutable.toString()).equals('adc');
      });
      test('writing (range error)', () {
        check(() => empty[0] = 'a').throws<RangeError>();
        check(() => plenty[-1] = 'a').throws<RangeError>();
        check(() => plenty[9] = 'a').throws<RangeError>();
      });
      test('writing (argument error)', () {
        check(() => plenty[0] = '🍌').throws<ArgumentError>();
      });
      test('adding', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.add('d');
        check(mutable.toString()).equals('abcd');
      });
      test('removing', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.remove('a');
        check(mutable.toString()).equals('bc');
      });
      test('converting', () {
        check(empty.toList()).isEmpty();
        check(plenty.toList())
            .deepEquals(['B', 'a', 'n', 'a', 'n', 'a', '\ud83c', '\udf4c']);
        check(empty.toSet()).isEmpty();
        check(plenty.toSet()).deepEquals({'B', 'a', 'n', '\ud83c', '\udf4c'});
        check(empty.toString()).equals(emptyString);
        check(plenty.toString()).equals(plentyString);
      });
      test('sublist', () {
        check(plenty.sublist(5).toString()).equals(plentyString.substring(5));
        check(plenty.sublist(5, 7).toString())
            .equals(plentyString.substring(5, 7));
      });
    });

    group('immutable unicode', () {
      final empty = emptyString.toList(unicode: true);
      final plenty = plentyString.toList(unicode: true);

      test('isEmpty', () {
        check(empty.isEmpty).isTrue();
        check(plenty.isEmpty).isFalse();
      });
      test('length', () {
        check(empty.length).equals(0);
        check(plenty.length).equals(7);
      });
      test('reading', () {
        check(plenty[0]).equals('B');
        check(plenty[1]).equals('a');
        check(plenty[2]).equals('n');
        check(plenty[3]).equals('a');
        check(plenty[4]).equals('n');
        check(plenty[5]).equals('a');
        check(plenty[6]).equals('🍌');
      });
      test('reading (range error)', () {
        check(() => empty[0]).throws<RangeError>();
        check(() => plenty[-1]).throws<RangeError>();
        check(() => plenty[9]).throws<RangeError>();
      });
      test('converting', () {
        check(empty.toList()).isEmpty();
        check(plenty.toList()).deepEquals(['B', 'a', 'n', 'a', 'n', 'a', '🍌']);
        check(empty.toSet()).isEmpty();
        check(plenty.toSet()).deepEquals({'B', 'a', 'n', '🍌'});
        check(empty.toString()).equals(emptyString);
        check(plenty.toString()).equals(plentyString);
      });
      test('read-only', () {
        check(() => plenty[0] = 'a').throws<UnsupportedError>();
        check(() => plenty.length = 10).throws<UnsupportedError>();
        check(() => plenty.add('a')).throws<UnsupportedError>();
        check(() => plenty.remove('a')).throws<UnsupportedError>();
      });
      test('sublist', () {
        check(plenty.sublist(5).toString()).equals(plentyString.substring(5));
        check(plenty.sublist(5, 7).toString())
            .equals(plentyString.substring(5, 8));
      });
    });

    group('mutable unicode', () {
      final empty = emptyString.toList(mutable: true, unicode: true);
      final plenty = plentyString.toList(mutable: true, unicode: true);

      test('creating', () {
        final coerced = '123'.toList(mutable: true, unicode: true);
        check(coerced.length).equals(3);
        check(coerced.toString()).equals('123');
      });
      test('isEmpty', () {
        check(empty.isEmpty).isTrue();
        check(plenty.isEmpty).isFalse();
      });
      test('length', () {
        check(empty.length).equals(0);
        check(plenty.length).equals(7);
      });
      test('reading', () {
        check(plenty[0]).equals('B');
        check(plenty[1]).equals('a');
        check(plenty[2]).equals('n');
        check(plenty[3]).equals('a');
        check(plenty[4]).equals('n');
        check(plenty[5]).equals('a');
        check(plenty[6]).equals('🍌');
      });
      test('reading (range error)', () {
        check(() => empty[0]).throws<RangeError>();
        check(() => plenty[-1]).throws<RangeError>();
        check(() => plenty[9]).throws<RangeError>();
      });
      test('writing', () {
        final mutable = 'abc'.toList(mutable: true, unicode: true);
        mutable[1] = '🍌';
        check(mutable.toString()).equals('a🍌c');
      });
      test('writing (range error)', () {
        check(() => empty[0] = 'a').throws<RangeError>();
        check(() => plenty[-1] = 'a').throws<RangeError>();
        check(() => plenty[9] = 'a').throws<RangeError>();
      });
      test('writing (argument error)', () {
        check(() => plenty[0] = 'ab').throws<ArgumentError>();
      });
      test('adding', () {
        final mutable = 'abc'.toList(mutable: true, unicode: true);
        mutable.add('🍌');
        check(mutable.toString()).equals('abc🍌');
      });
      test('removing', () {
        final mutable = '🍇🍌🍓'.toList(mutable: true, unicode: true);
        mutable.remove('🍌');
        check(mutable.toString()).equals('🍇🍓');
      });
      test('converting', () {
        check(empty.toList()).isEmpty();
        check(plenty.toList()).deepEquals(['B', 'a', 'n', 'a', 'n', 'a', '🍌']);
        check(empty.toSet()).isEmpty();
        check(plenty.toSet()).deepEquals({'B', 'a', 'n', '🍌'});
        check(empty.toString()).equals(emptyString);
        check(plenty.toString()).equals(plentyString);
      });
      test('sublist', () {
        check(plenty.sublist(5).toString()).equals(plentyString.substring(5));
        check(plenty.sublist(5, 7).toString())
            .equals(plentyString.substring(5, 8));
      });
    });
  });
}
