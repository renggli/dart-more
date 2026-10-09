import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('range', () {
    test('RangeIterator forward', () {
      final range = IntegerRange(3);
      final iterator = range.iterator;
      check(iterator.range).identicalTo(range);
      check(iterator.moveNext()).isTrue();
      check(iterator.current).equals(0);
      check(iterator.moveNext()).isTrue();
      check(iterator.current).equals(1);
      check(iterator.moveNext()).isTrue();
      check(iterator.current).equals(2);
      check(iterator.moveNext()).isFalse();
    });
    test('RangeIterator backward', () {
      final range = IntegerRange(3);
      final iterator = range.iteratorAtEnd;
      check(iterator.range).identicalTo(range);
      check(iterator.movePrevious()).isTrue();
      check(iterator.current).equals(2);
      check(iterator.movePrevious()).isTrue();
      check(iterator.current).equals(1);
      check(iterator.movePrevious()).isTrue();
      check(iterator.current).equals(0);
      check(iterator.movePrevious()).isFalse();
    });
    test('RangeIterator empty', () {
      const range = IntegerRange.empty;
      final fwd = range.iterator;
      check(fwd.moveNext()).isFalse();
      final bwd = range.iteratorAtEnd;
      check(bwd.movePrevious()).isFalse();
    });
    test('Range lastIndexOf', () {
      final range = IntegerRange(5);
      check(range.lastIndexOf(2)).equals(2);
      check(range.lastIndexOf(2, 3)).equals(2);
      check(range.lastIndexOf(2, 1)).equals(-1);
      check(range.lastIndexOf(10)).equals(-1);
    });
  });
}
