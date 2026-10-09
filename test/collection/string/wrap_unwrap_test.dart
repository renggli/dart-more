import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('wrap', () {
    test('default', () {
      check('a'.wrap(4)).equals('a');
      check('a b'.wrap(4)).equals('a b');
      check('a b c'.wrap(4)).equals('a b\nc');
      check('aa bb cc'.wrap(4)).equals('aa\nbb\ncc');
      check('a\nb'.wrap(4)).equals('a\nb');
      check('a\n\nb'.wrap(4)).equals('a\n\nb');
      check('1234'.wrap(4)).equals('1234');
      check('12345'.wrap(4)).equals('1234\n5');
      check('12345678'.wrap(4)).equals('1234\n5678');
      check('123456789'.wrap(4)).equals('1234\n5678\n9');
    });
    test('whitespace', () {
      const whitespace = ' ';
      check('a'.wrap(4, whitespace: whitespace)).equals('a');
      check('a b'.wrap(4, whitespace: whitespace)).equals('a b');
      check('a  b'.wrap(4, whitespace: whitespace)).equals('a b');
      check('a b c'.wrap(4, whitespace: whitespace)).equals('a b\nc');

      check('aa bb cc'.wrap(4, whitespace: whitespace)).equals('aa\nbb\ncc');
      check('a\nb'.wrap(4, whitespace: whitespace)).equals('a\nb');
      check('1234'.wrap(4, whitespace: whitespace)).equals('1234');
      check('12345'.wrap(4, whitespace: whitespace)).equals('1234\n5');
      check('12345678'.wrap(4, whitespace: whitespace)).equals('1234\n5678');
      check('123456789'.wrap(4, whitespace: whitespace))
          .equals('1234\n5678\n9');
    });
    test('breakLongWords', () {
      check('a'.wrap(4, breakLongWords: false)).equals('a');
      check('a b'.wrap(4, breakLongWords: false)).equals('a b');
      check('a b c'.wrap(4, breakLongWords: false)).equals('a b\nc');
      check('aa bb cc'.wrap(4, breakLongWords: false)).equals('aa\nbb\ncc');
      check('a\nb'.wrap(4, breakLongWords: false)).equals('a\nb');
      check('1234'.wrap(4, breakLongWords: false)).equals('1234');
      check('12345'.wrap(4, breakLongWords: false)).equals('12345');
      check('12345678'.wrap(4, breakLongWords: false)).equals('12345678');
      check('123456789'.wrap(4, breakLongWords: false)).equals('123456789');
    });
    test('invalid', () {
      check(() => 'a'.wrap(-1)).throws<RangeError>();
      check(() => 'a'.wrap(0)).throws<RangeError>();
    });
  });

  group('unwrap', () {
    test('single', () {
      check('1'.unwrap()).equals('1');
      check('1\n2'.unwrap()).equals('1 2');
      check('1\n2\n3'.unwrap()).equals('1 2 3');
    });
    test('multiple', () {
      check('1\n\na'.unwrap()).equals('1\n\na');
      check('1\n2\n\na\nb'.unwrap()).equals('1 2\n\na b');
      check('1\n2\n3\n\na\nb\nc'.unwrap()).equals('1 2 3\n\na b c');
    });
  });
}
