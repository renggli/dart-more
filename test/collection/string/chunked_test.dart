import 'package:characters/characters.dart';
import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('chunked', () {
    test('string', () {
      check(''.chunked(2)).isEmpty();
      check('a'.chunked(2)).deepEquals(['a']);
      check('ab'.chunked(2)).deepEquals(['ab']);
      check('abc'.chunked(2)).deepEquals(['ab', 'c']);
      check('abcd'.chunked(2)).deepEquals(['ab', 'cd']);
      check('abcde'.chunked(2)).deepEquals(['ab', 'cd', 'e']);
      check(() => 'abc'.chunked(0)).throws<RangeError>();
    });
    test('characters', () {
      check(''.characters.chunked(2)).isEmpty();
      check('a'.characters.chunked(2)).deepEquals(['a'.characters]);
      check('ab'.characters.chunked(2)).deepEquals(['ab'.characters]);
      check('abc'.characters.chunked(2))
          .deepEquals(['ab'.characters, 'c'.characters]);
      check('abcd'.characters.chunked(2))
          .deepEquals(['ab'.characters, 'cd'.characters]);
      check('abcde'.characters.chunked(2))
          .deepEquals(['ab'.characters, 'cd'.characters, 'e'.characters]);
      check(() => 'abc'.characters.chunked(0)).throws<RangeError>();
    });
  });
}
