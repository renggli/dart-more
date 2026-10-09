import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('indent', () {
    test('default', () {
      check(''.indent('*')).equals('');
      check('foo'.indent('*')).equals('*foo');
      check('foo\nbar'.indent('*')).equals('*foo\n*bar');
      check('foo\n\nbar'.indent('*')).equals('*foo\n\n*bar');
      check(' zork '.indent('*')).equals('*zork');
    });
    test('firstPrefix', () {
      check(''.indent('*', firstPrefix: '!')).equals('');
      check('foo'.indent('*', firstPrefix: '!')).equals('!foo');
      check('foo\nbar'.indent('*', firstPrefix: '!')).equals('!foo\n*bar');
      check('foo\n\nbar'.indent('*', firstPrefix: '!')).equals('!foo\n\n*bar');
      check(' zork '.indent('*', firstPrefix: '!')).equals('!zork');
    });
    test('trimWhitespace', () {
      check(''.indent('*', trimWhitespace: false)).equals('');
      check('foo'.indent('*', trimWhitespace: false)).equals('*foo');
      check('foo\nbar'.indent('*', trimWhitespace: false)).equals('*foo\n*bar');
      check('foo\n\nbar'.indent('*', trimWhitespace: false))
          .equals('*foo\n\n*bar');
      check(' zork '.indent('*', trimWhitespace: false)).equals('* zork ');
    });
    test('indentEmpty', () {
      check(''.indent('*', indentEmpty: true)).equals('*');
      check('foo'.indent('*', indentEmpty: true)).equals('*foo');
      check('foo\nbar'.indent('*', indentEmpty: true)).equals('*foo\n*bar');
      check('foo\n\nbar'.indent('*', indentEmpty: true))
          .equals('*foo\n*\n*bar');
      check(' zork '.indent('*', indentEmpty: true)).equals('*zork');
    });
  });

  group('dedent', () {
    test('default', () {
      check(''.dedent()).equals('');
      check('1\n2'.dedent()).equals('1\n2');
      check('1\n\n2'.dedent()).equals('1\n\n2');
      check(' 1\n\n 2'.dedent()).equals('1\n\n2');
      check(' 1\n\n\t2'.dedent()).equals(' 1\n\n\t2');
      check(' 1'.dedent()).equals('1');
      check(' 1\n  2'.dedent()).equals('1\n 2');
      check('  2\n 1'.dedent()).equals(' 2\n1');
      check(' 1\n  2\n   3'.dedent()).equals('1\n 2\n  3');
      check('   3\n  2\n 1'.dedent()).equals('  3\n 2\n1');
    });
    test('whitespace', () {
      check(''.dedent(whitespace: '\t')).equals('');
      check('1\n2'.dedent(whitespace: '\t')).equals('1\n2');
      check('1\n\n2'.dedent(whitespace: '\t')).equals('1\n\n2');
      check('\t1\n\n\t2'.dedent(whitespace: '\t')).equals('1\n\n2');
      check('\t1'.dedent(whitespace: '\t')).equals('1');
      check('\t1\n\t\t2'.dedent(whitespace: '\t')).equals('1\n\t2');
      check('\t\t2\n\t1'.dedent(whitespace: '\t')).equals('\t2\n1');
      check('\t1\n\t\t2\n\t\t\t3'.dedent(whitespace: '\t'))
          .equals('1\n\t2\n\t\t3');
      check('\t\t\t3\n\t\t2\n\t1'.dedent(whitespace: '\t'))
          .equals('\t\t3\n\t2\n1');
    });
    test('ignoreEmpty', () {
      check(''.dedent(ignoreEmpty: false)).equals('');
      check('1\n2'.dedent(ignoreEmpty: false)).equals('1\n2');
      check('1\n\n2'.dedent(ignoreEmpty: false)).equals('1\n\n2');
      check(' 1\n\n 2'.dedent(ignoreEmpty: false)).equals(' 1\n\n 2');
      check(' 1'.dedent(ignoreEmpty: false)).equals('1');
      check(' 1\n  2'.dedent(ignoreEmpty: false)).equals('1\n 2');
      check('  2\n 1'.dedent(ignoreEmpty: false)).equals(' 2\n1');
      check(' 1\n  2\n   3'.dedent(ignoreEmpty: false)).equals('1\n 2\n  3');
      check('   3\n  2\n 1'.dedent(ignoreEmpty: false)).equals('  3\n 2\n1');
    });
  });
}
