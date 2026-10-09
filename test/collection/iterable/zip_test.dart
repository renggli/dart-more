import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('zip', () {
    group('default', () {
      test('empty', () {
        check(<Iterable<int>>[].zip()).deepEquals(<int>[]);
      });
      test('single', () {
        check(
          [
            [1, 2, 3],
          ].zip(),
        ).deepEquals([
          [1],
          [2],
          [3],
        ]);
      });
      test('pair', () {
        check(
          [
            [1, 2, 3],
            ['a', 'b', 'c'],
          ].zip(),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
          [3, 'c'],
        ]);
        check(
          [
            [1, 2],
            ['a', 'b', 'c'],
          ].zip(),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
        ]);
        check(
          [
            [1, 2, 3],
            ['a', 'b'],
          ].zip(),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
        ]);
      });
      test('tuple', () {
        check(([1, 2, 3], ['a', 'b', 'c']).zip())
            .deepEquals([(1, 'a'), (2, 'b'), (3, 'c')]);
        check(([1, 2], ['a', 'b', 'c']).zip()).deepEquals([(1, 'a'), (2, 'b')]);
        check(([1, 2, 3], ['a', 'b']).zip()).deepEquals([(1, 'a'), (2, 'b')]);
      });
    });

    group('partial', () {
      test('empty', () {
        check(<Iterable<int>>[].zipPartial()).deepEquals(<int>[]);
      });
      test('single', () {
        check(
          [
            [1, 2, 3],
          ].zipPartial(),
        ).deepEquals([
          [1],
          [2],
          [3],
        ]);
      });
      test('pair', () {
        check(
          [
            [1, 2, 3],
            ['a', 'b', 'c'],
          ].zipPartial(),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
          [3, 'c'],
        ]);
        check(
          [
            [1, 2],
            ['a', 'b', 'c'],
          ].zipPartial(),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
          [null, 'c'],
        ]);
        check(
          [
            [1, 2, 3],
            ['a', 'b'],
          ].zipPartial(),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
          [3, null],
        ]);
      });
      test('tuple', () {
        check(([1, 2, 3], ['a', 'b', 'c']).zipPartial())
            .deepEquals([(1, 'a'), (2, 'b'), (3, 'c')]);
        check(([1, 2], ['a', 'b', 'c']).zipPartial())
            .deepEquals([(1, 'a'), (2, 'b'), (null, 'c')]);
        check(([1, 2, 3], ['a', 'b']).zipPartial())
            .deepEquals([(1, 'a'), (2, 'b'), (3, null)]);
      });
    });

    group('partial with', () {
      test('empty', () {
        check(<Iterable<int>>[].zipPartialWith(0)).deepEquals(<int>[]);
      });
      test('single', () {
        check(
          [
            [1, 2, 3],
          ].zipPartialWith(0),
        ).deepEquals([
          [1],
          [2],
          [3],
        ]);
      });
      test('pair', () {
        check(
          [
            [1, 2, 3],
            ['a', 'b', 'c'],
          ].zipPartialWith(0),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
          [3, 'c'],
        ]);
        check(
          [
            [1, 2],
            ['a', 'b', 'c'],
          ].zipPartialWith(0),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
          [0, 'c'],
        ]);
        check(
          [
            [1, 2, 3],
            ['a', 'b'],
          ].zipPartialWith(0),
        ).deepEquals([
          [1, 'a'],
          [2, 'b'],
          [3, 0],
        ]);
      });
      test('tuple', () {
        check(([1, 2, 3], ['a', 'b', 'c']).zipPartialWith((4, 'd')))
            .deepEquals([(1, 'a'), (2, 'b'), (3, 'c')]);
        check(([1, 2], ['a', 'b', 'c']).zipPartialWith((4, 'd')))
            .deepEquals([(1, 'a'), (2, 'b'), (4, 'c')]);
        check(([1, 2, 3], ['a', 'b']).zipPartialWith((4, 'd')))
            .deepEquals([(1, 'a'), (2, 'b'), (3, 'd')]);
      });
    });
  });
}
