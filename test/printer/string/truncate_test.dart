import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('truncate', () {
    group('left', () {
      test('default', () {
        final printer = standardString.truncateLeft(3);
        check(printer('')).equals('');
        check(printer('1')).equals('1');
        check(printer('12')).equals('12');
        check(printer('123')).equals('123');
        check(printer('1234')).equals('…34');
        check(printer('12345')).equals('…45');
        check(printer('123456')).equals('…56');
        check(printer('👨👩👧👦')).equals('…👧👦');
      });
      test('on characters', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateLeft(
            i,
            method: TruncateMethod.characters,
          );
          final result = printer(lorem);
          check(
            because: result,
            result.isEmpty ||
                result.startsWith('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('on words', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateLeft(
            i,
            method: TruncateMethod.words,
          );
          final result = printer(lorem);
          check(
            because: result,
            result.isEmpty ||
                result.startsWith('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('on sentences', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateLeft(
            i,
            method: TruncateMethod.sentences,
          );
          final result = printer(lorem);
          check(
            because: result,
            result.isEmpty ||
                result.startsWith('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('with ellipsis', () {
        final printer = standardString.truncateLeft(6, ellipsis: '...');
        check(printer('')).equals('');
        check(printer('1')).equals('1');
        check(printer('12')).equals('12');
        check(printer('123')).equals('123');
        check(printer('1234')).equals('1234');
        check(printer('12345')).equals('12345');
        check(printer('123456')).equals('123456');
        check(printer('1234567')).equals('...567');
        check(printer('12345678')).equals('...678');
        check(printer('👨👩👧👦😺💩')).equals('👨👩👧👦😺💩');
        check(printer('👨👩👧👦😺💩🙉')).equals('...😺💩🙉');
      });
    });
    group('right', () {
      test('default', () {
        final printer = standardString.truncateRight(3);
        check(printer('')).equals('');
        check(printer('1')).equals('1');
        check(printer('12')).equals('12');
        check(printer('123')).equals('123');
        check(printer('1234')).equals('12…');
        check(printer('12345')).equals('12…');
        check(printer('123456')).equals('12…');
        check(printer('👨👩👧👦')).equals('👨👩…');
      });
      test('on characters', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateRight(
            i,
            method: TruncateMethod.characters,
          );
          final result = printer(lorem);
          check(lorem).startsWith(result.removeSuffix('…'));
          check(
            because: result,
            result.isEmpty ||
                result.endsWith('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('on words', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateRight(
            i,
            method: TruncateMethod.words,
          );
          final result = printer(lorem);
          check(lorem).startsWith(result.removeSuffix('…'));
          check(
            because: result,
            result.isEmpty ||
                result.endsWith('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('on sentences', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateRight(
            i,
            method: TruncateMethod.sentences,
          );
          final result = printer(lorem);
          check(lorem).startsWith(result.removeSuffix('…'));
          check(
            because: result,
            result.isEmpty ||
                result.endsWith('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('with ellipsis', () {
        final printer = standardString.truncateRight(6, ellipsis: '...');
        check(printer('')).equals('');
        check(printer('1')).equals('1');
        check(printer('12')).equals('12');
        check(printer('123')).equals('123');
        check(printer('1234')).equals('1234');
        check(printer('12345')).equals('12345');
        check(printer('123456')).equals('123456');
        check(printer('1234567')).equals('123...');
        check(printer('12345678')).equals('123...');
        check(printer('👨👩👧👦😺💩')).equals('👨👩👧👦😺💩');
        check(printer('👨👩👧👦😺💩🙉')).equals('👨👩👧...');
      });
    });
    group('center', () {
      test('default', () {
        final printer = standardString.truncateCenter(3);
        check(printer('')).equals('');
        check(printer('1')).equals('1');
        check(printer('12')).equals('12');
        check(printer('123')).equals('123');
        check(printer('1234')).equals('1…4');
        check(printer('12345')).equals('1…5');
        check(printer('123456')).equals('1…6');
        check(printer('👨👩👧👦')).equals('👨…👦');
      });
      test('on characters', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateCenter(
            i,
            method: TruncateMethod.characters,
          );
          final result = printer(lorem);
          check(lorem).startsWith(result.takeTo('…'));
          check(lorem).endsWith(result.skipTo('…'));
          check(
            because: result,
            result.isEmpty ||
                result.contains('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('on words', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateCenter(
            i,
            method: TruncateMethod.words,
          );
          final result = printer(lorem);
          check(lorem).startsWith(result.takeTo('…'));
          check(lorem).endsWith(result.skipTo('…'));
          check(
            because: result,
            result.isEmpty ||
                result.contains('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('on sentences', () {
        for (var i = 0; i <= lorem.length; i++) {
          final printer = standardString.truncateCenter(
            i,
            method: TruncateMethod.sentences,
          );
          final result = printer(lorem);
          check(lorem).startsWith(result.takeTo('…'));
          check(lorem).endsWith(result.skipTo('…'));
          check(
            because: result,
            result.isEmpty ||
                result.contains('…') ||
                result.length == lorem.length,
          ).isTrue();
          check(because: result, result.length).isLessOrEqual(i);
        }
      });
      test('with ellipsis', () {
        final printer = standardString.truncateCenter(6, ellipsis: '...');
        check(printer('')).equals('');
        check(printer('1')).equals('1');
        check(printer('12')).equals('12');
        check(printer('123')).equals('123');
        check(printer('1234')).equals('1234');
        check(printer('12345')).equals('12345');
        check(printer('123456')).equals('123456');
        check(printer('1234567')).equals('12...7');
        check(printer('12345678')).equals('12...8');
        check(printer('👨👩👧👦😺💩')).equals('👨👩👧👦😺💩');
        check(printer('👨👩👧👦😺💩🙉')).equals('👨👩...🙉');
      });
    });
    test('toString', () {
      final printer = standardString.truncateLeft(3, ellipsis: '...');
      check(printer.toString()).startsWith('TruncateLeftPrinter<String>');
    });
  });
}
