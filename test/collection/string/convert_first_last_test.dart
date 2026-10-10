import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('converters', () {
    test('convert first character', () {
      check(
        ''.convertFirstCharacters((value) {
          throw StateError('Not supposed to be called');
        }),
      ).equals('');
      check(
        'a'.convertFirstCharacters((value) {
          check(value).equals('a');
          return 'A';
        }),
      ).equals('A');
      check(
        'ab'.convertFirstCharacters((value) {
          check(value).equals('a');
          return 'A';
        }),
      ).equals('Ab');
      check(
        'abc'.convertFirstCharacters((value) {
          check(value).equals('a');
          return 'A';
        }),
      ).equals('Abc');
    });
    test('convert first two characters', () {
      check(
        ''.convertFirstCharacters((value) {
          throw StateError('Not supposed to be called');
        }, count: 2),
      ).equals('');
      check(
        'a'.convertFirstCharacters((value) {
          throw StateError('Not supposed to be called');
        }, count: 2),
      ).equals('a');
      check(
        'ab'.convertFirstCharacters((value) {
          check(value).equals('ab');
          return '*';
        }, count: 2),
      ).equals('*');
      check(
        'abc'.convertFirstCharacters((value) {
          check(value).equals('ab');
          return '*';
        }, count: 2),
      ).equals('*c');
    });
    test('convert last character', () {
      check(
        ''.convertLastCharacters((value) {
          throw StateError('Not supposed to be called');
        }),
      ).equals('');
      check(
        'a'.convertLastCharacters((value) {
          check(value).equals('a');
          return 'A';
        }),
      ).equals('A');
      check(
        'ab'.convertLastCharacters((value) {
          check(value).equals('b');
          return 'B';
        }),
      ).equals('aB');
      check(
        'abc'.convertLastCharacters((value) {
          check(value).equals('c');
          return 'C';
        }),
      ).equals('abC');
    });
    test('convert last two characters', () {
      check(
        ''.convertLastCharacters((value) {
          throw StateError('Not supposed to be called');
        }, count: 2),
      ).equals('');
      check(
        'a'.convertLastCharacters((value) {
          throw StateError('Not supposed to be called');
        }, count: 2),
      ).equals('a');
      check(
        'ab'.convertLastCharacters((value) {
          check(value).equals('ab');
          return '*';
        }, count: 2),
      ).equals('*');
      check(
        'abc'.convertLastCharacters((value) {
          check(value).equals('bc');
          return '*';
        }, count: 2),
      ).equals('a*');
    });
    test('convert first character to upper-case', () {
      check(''.toUpperCaseFirstCharacter()).equals('');
      check('a'.toUpperCaseFirstCharacter()).equals('A');
      check('ab'.toUpperCaseFirstCharacter()).equals('Ab');
      check('abc'.toUpperCaseFirstCharacter()).equals('Abc');
    });
    test('convert first character to lower-case', () {
      check(''.toLowerCaseFirstCharacter()).equals('');
      check('A'.toLowerCaseFirstCharacter()).equals('a');
      check('AB'.toLowerCaseFirstCharacter()).equals('aB');
      check('ABC'.toLowerCaseFirstCharacter()).equals('aBC');
    });
  });
}
