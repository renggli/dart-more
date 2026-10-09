import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('take/skip', () {
    test('take', () {
      check('abc'.take(0)).equals('');
      check('abc'.take(1)).equals('a');
      check('abc'.take(2)).equals('ab');
      check('abc'.take(3)).equals('abc');
      check('abc'.take(4)).equals('abc');
    });
    test('takeTo', () {
      check('abc'.takeTo('a')).equals('');
      check('abc'.takeTo('b')).equals('a');
      check('abc'.takeTo('c')).equals('ab');
      check('abc'.takeTo('d')).equals('abc');
    });
    test('takeLast', () {
      check('abc'.takeLast(0)).equals('');
      check('abc'.takeLast(1)).equals('c');
      check('abc'.takeLast(2)).equals('bc');
      check('abc'.takeLast(3)).equals('abc');
      check('abc'.takeLast(4)).equals('abc');
    });
    test('takeLastTo', () {
      check('abc'.takeLastTo('a')).equals('bc');
      check('abc'.takeLastTo('b')).equals('c');
      check('abc'.takeLastTo('c')).equals('');
      check('abc'.takeLastTo('d')).equals('abc');
    });
    test('skip', () {
      check('abc'.skip(0)).equals('abc');
      check('abc'.skip(1)).equals('bc');
      check('abc'.skip(2)).equals('c');
      check('abc'.skip(3)).equals('');
      check('abc'.skip(4)).equals('');
    });
    test('skipTo', () {
      check('abc'.skipTo('a')).equals('bc');
      check('abc'.skipTo('b')).equals('c');
      check('abc'.skipTo('c')).equals('');
      check('abc'.skipTo('d')).equals('');
    });
    test('skipLast', () {
      check('abc'.skipLast(0)).equals('abc');
      check('abc'.skipLast(1)).equals('ab');
      check('abc'.skipLast(2)).equals('a');
      check('abc'.skipLast(3)).equals('');
      check('abc'.skipLast(4)).equals('');
    });
    test('skipLastTo', () {
      check('abc'.skipLastTo('a')).equals('');
      check('abc'.skipLastTo('b')).equals('a');
      check('abc'.skipLastTo('c')).equals('ab');
      check('abc'.skipLastTo('d')).equals('');
    });
  });
}
