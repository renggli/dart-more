import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('take/skip', () {
    const list = ['a', 'b', 'c'];
    test('take', () {
      check(list.take(0)).isEmpty();
      check(list.take(1)).deepEquals(['a']);
      check(list.take(2)).deepEquals(['a', 'b']);
      check(list.take(3)).deepEquals(['a', 'b', 'c']);
      check(list.take(4)).deepEquals(['a', 'b', 'c']);
    });
    test('takeTo', () {
      check(list.takeTo('a')).isEmpty();
      check(list.takeTo('b')).deepEquals(['a']);
      check(list.takeTo('c')).deepEquals(['a', 'b']);
      check(list.takeTo('d')).deepEquals(['a', 'b', 'c']);
    });
    test('takeLast', () {
      check(list.takeLast(0)).isEmpty();
      check(list.takeLast(1)).deepEquals(['c']);
      check(list.takeLast(2)).deepEquals(['b', 'c']);
      check(list.takeLast(3)).deepEquals(['a', 'b', 'c']);
      check(list.takeLast(4)).deepEquals(['a', 'b', 'c']);
    });
    test('takeLastTo', () {
      check(list.takeLastTo('a')).deepEquals(['b', 'c']);
      check(list.takeLastTo('b')).deepEquals(['c']);
      check(list.takeLastTo('c')).isEmpty();
      check(list.takeLastTo('d')).deepEquals(['a', 'b', 'c']);
    });
    test('skip', () {
      check(list.skip(0)).deepEquals(['a', 'b', 'c']);
      check(list.skip(1)).deepEquals(['b', 'c']);
      check(list.skip(2)).deepEquals(['c']);
      check(list.skip(3)).isEmpty();
      check(list.skip(4)).isEmpty();
    });
    test('skipTo', () {
      check(list.skipTo('a')).deepEquals(['b', 'c']);
      check(list.skipTo('b')).deepEquals(['c']);
      check(list.skipTo('c')).isEmpty();
      check(list.skipTo('d')).isEmpty();
    });
    test('skipLast', () {
      check(list.skipLast(0)).deepEquals(['a', 'b', 'c']);
      check(list.skipLast(1)).deepEquals(['a', 'b']);
      check(list.skipLast(2)).deepEquals(['a']);
      check(list.skipLast(3)).isEmpty();
      check(list.skipLast(4)).isEmpty();
    });
    test('skipLastTo', () {
      check(list.skipLastTo('a')).isEmpty();
      check(list.skipLastTo('b')).deepEquals(['a']);
      check(list.skipLastTo('c')).deepEquals(['a', 'b']);
      check(list.skipLastTo('d')).isEmpty();
    });
  });
}
