import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('product', () {
    test('2', () {
      final iterable = [
        [1, 2],
      ].product();
      check(iterable).deepEquals([
        [1],
        [2],
      ]);
    });
    test('2 x 2', () {
      final iterable = [
        [1, 2],
        [3, 4],
      ].product();
      check(iterable).deepEquals([
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4],
      ]);
    });
    test('1 x 2 x 3', () {
      final iterable = [
        [1],
        [2, 3],
        [4, 5, 6],
      ].product();
      check(iterable).deepEquals([
        [1, 2, 4],
        [1, 2, 5],
        [1, 2, 6],
        [1, 3, 4],
        [1, 3, 5],
        [1, 3, 6],
      ]);
    });
    test('3 x 2 x 1', () {
      final iterable = [
        [1, 2, 3],
        [4, 5],
        [6],
      ].product();
      check(iterable).deepEquals([
        [1, 4, 6],
        [1, 5, 6],
        [2, 4, 6],
        [2, 5, 6],
        [3, 4, 6],
        [3, 5, 6],
      ]);
    });
    test('repeat 0', () {
      check(() => <Iterable<int>>[].product(repeat: 0)).throws<RangeError>();
    });
    test('2 x repeat 2', () {
      final iterable = [
        [0, 1],
      ].product(repeat: 2);
      check(iterable).deepEquals([
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ]);
    });
    test('2 x 1 x repeat 2', () {
      final iterable = [
        [0, 1],
        [3],
      ].product(repeat: 2);
      check(iterable).deepEquals([
        [0, 3, 0, 3],
        [0, 3, 1, 3],
        [1, 3, 0, 3],
        [1, 3, 1, 3],
      ]);
    });
    test('2 x repeat 3', () {
      final iterable = [
        [0, 1],
      ].product(repeat: 3);
      check(iterable).deepEquals([
        [0, 0, 0],
        [0, 0, 1],
        [0, 1, 0],
        [0, 1, 1],
        [1, 0, 0],
        [1, 0, 1],
        [1, 1, 0],
        [1, 1, 1],
      ]);
    });
    test('1 x 2, repeat 3', () {
      final iterable = [
        [0, 1],
      ].product(repeat: 3);
      check(iterable).deepEquals([
        [0, 0, 0],
        [0, 0, 1],
        [0, 1, 0],
        [0, 1, 1],
        [1, 0, 0],
        [1, 0, 1],
        [1, 1, 0],
        [1, 1, 1],
      ]);
    });
    test('empty', () {
      check(<Iterable<int>>[].product()).isEmpty();
      check(<Iterable<int>>[[]].product()).isEmpty();
      check(
        <Iterable<int>>[
          [1],
          [],
        ].product(),
      ).isEmpty();
      check(
        <Iterable<int>>[
          [],
          [1],
        ].product(),
      ).isEmpty();
      check(
        <Iterable<int>>[
          [1],
          [],
          [1],
        ].product(),
      ).isEmpty();
    });
    group('tuple', () {
      test('basic', () {
        check((['x', 'y'], [1, 2, 3]).product()).deepEquals([
          ('x', 1),
          ('x', 2),
          ('x', 3),
          ('y', 1),
          ('y', 2),
          ('y', 3),
        ]);
      });
      test('empty', () {
        check((<String>[], <int>[]).product()).isEmpty();
        check((['x'], <int>[]).product()).isEmpty();
        check((<String>[], [42]).product()).isEmpty();
      });
    });
  });
}
