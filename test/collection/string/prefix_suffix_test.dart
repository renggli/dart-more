import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('remove prefix', () {
    test('string', () {
      check('abcd'.removePrefix('')).equals('abcd');
      check('abcd'.removePrefix('a')).equals('bcd');
      check('abcd'.removePrefix('ab')).equals('cd');
      check('abcd'.removePrefix('abc')).equals('d');
      check('abcd'.removePrefix('abcd')).equals('');
      check('abcd'.removePrefix('bcd')).equals('abcd');
      check('abcd'.removePrefix('xyz')).equals('abcd');
    });
    test('regexp', () {
      check('abcd'.removePrefix(RegExp(''))).equals('abcd');
      check('abcd'.removePrefix(RegExp('a'))).equals('bcd');
      check('abcd'.removePrefix(RegExp('ab'))).equals('cd');
      check('abcd'.removePrefix(RegExp('abc'))).equals('d');
      check('abcd'.removePrefix(RegExp('abcd'))).equals('');
      check('abcd'.removePrefix(RegExp('bcd'))).equals('abcd');
      check('abcd'.removePrefix(RegExp('xyz'))).equals('abcd');
    });
  });

  group('remove suffix', () {
    test('string', () {
      check('abcd'.removeSuffix('')).equals('abcd');
      check('abcd'.removeSuffix('d')).equals('abc');
      check('abcd'.removeSuffix('cd')).equals('ab');
      check('abcd'.removeSuffix('bcd')).equals('a');
      check('abcd'.removeSuffix('abcd')).equals('');
      check('abcd'.removeSuffix('abc')).equals('abcd');
      check('abcd'.removeSuffix('xyz')).equals('abcd');
    });
    test('regexp', () {
      check('abcd'.removeSuffix(RegExp(''))).equals('abcd');
      check('abcd'.removeSuffix(RegExp('d'))).equals('abc');
      check('abcd'.removeSuffix(RegExp('cd'))).equals('ab');
      check('abcd'.removeSuffix(RegExp('bcd'))).equals('a');
      check('abcd'.removeSuffix(RegExp('abcd'))).equals('');
      check('abcd'.removeSuffix(RegExp('abc'))).equals('abcd');
      check('abcd'.removeSuffix(RegExp('xyz'))).equals('abcd');
    });
  });
}
