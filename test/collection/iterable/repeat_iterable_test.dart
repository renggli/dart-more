import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('repeat iterable', () {
    test('empty', () {
      check(<int>[].repeat()).isEmpty();
      check(<int>[].repeat(count: 0)).isEmpty();
      check(<int>[].repeat(count: 1)).isEmpty();
      check(<int>[].repeat(count: 2)).isEmpty();
      check(<int>[].repeat(count: 3)).isEmpty();
    });
    test('single', () {
      check([1].repeat().take(3)).deepEquals([1, 1, 1]);
      check([1].repeat(count: 0)).isEmpty();
      check([1].repeat(count: 1)).deepEquals([1]);
      check([1].repeat(count: 2)).deepEquals([1, 1]);
      check([1].repeat(count: 3)).deepEquals([1, 1, 1]);
    });
    test('double', () {
      check([1, 2].repeat().take(5)).deepEquals([1, 2, 1, 2, 1]);
      check([1, 2].repeat(count: 0)).isEmpty();
      check([1, 2].repeat(count: 1)).deepEquals([1, 2]);
      check([1, 2].repeat(count: 2)).deepEquals([1, 2, 1, 2]);
      check([1, 2].repeat(count: 3)).deepEquals([1, 2, 1, 2, 1, 2]);
    });
    test('triple', () {
      check([1, 2, 3].repeat().take(7)).deepEquals([1, 2, 3, 1, 2, 3, 1]);
      check([1, 2, 3].repeat(count: 0)).isEmpty();
      check([1, 2, 3].repeat(count: 1)).deepEquals([1, 2, 3]);
      check([1, 2, 3].repeat(count: 2)).deepEquals([1, 2, 3, 1, 2, 3]);
      check([1, 2, 3].repeat(count: 3)).deepEquals([1, 2, 3, 1, 2, 3, 1, 2, 3]);
    });
    test('infinite', () {
      final iterable = [1, 2, 3].repeat();
      check(iterable.isEmpty).isFalse();
      check(iterable.isNotEmpty).isTrue();
      check(() => iterable.length).throws<UnsupportedError>();
      check(() => iterable.last).throws<UnsupportedError>();
      check(() => iterable.lastWhere((e) => true)).throws<UnsupportedError>();
      check(() => iterable.single).throws<UnsupportedError>();
      check(() => iterable.singleWhere((e) => true)).throws<UnsupportedError>();
      check(iterable.toList).throws<UnsupportedError>();
      check(iterable.toSet).throws<UnsupportedError>();
    });
    test('error', () {
      check(() => [1, 2, 3].repeat(count: -1)).throws<RangeError>();
    });
  });
}
