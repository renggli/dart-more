import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

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
      check(fwd.movePrevious()).isFalse();
      check(fwd.moveNext()).isFalse();
      final bwd = range.iteratorAtEnd;
      check(bwd.movePrevious()).isFalse();
      check(bwd.moveNext()).isFalse();
      check(bwd.movePrevious()).isFalse();
    });
    test('RangeIterator change direction after exhaustion', () {
      final range = IntegerRange(3);
      final it = range.iterator;
      while (it.moveNext()) {}
      check(it.moveNext()).isFalse();
      check(it.movePrevious()).isTrue();
      check(it.current).equals(2);
      check(it.movePrevious()).isTrue();
      check(it.current).equals(1);
      check(it.movePrevious()).isTrue();
      check(it.current).equals(0);
      check(it.movePrevious()).isFalse();
      check(it.movePrevious()).isFalse();
      check(it.moveNext()).isTrue();
      check(it.current).equals(0);

      final itEnd = range.iteratorAtEnd;
      while (itEnd.movePrevious()) {}
      check(itEnd.movePrevious()).isFalse();
      check(itEnd.moveNext()).isTrue();
      check(itEnd.current).equals(0);
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
