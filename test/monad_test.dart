library monad_test;

import 'package:unittest/unittest.dart';
import 'package:more/monad.dart';

void main() {
  group('monad', () {
    group('eventually', () {
      var eventually = new Eventually.fromFunction((success) => success('string'));
      var result = eventually.then((string) => string.asUpperCase());
      result.run((string) => print(string));
    });
    group('many', () {

    });
    group('maybe', () {
      var present = new Optional.present('test');
      var absent = new Optional.absent();
      test('present', () {
        expect(() => new Optional.present(null), throwsArgumentError);
      });
      test('constructor', () {
        expect(new Optional(null).isAbsent, isTrue);
        expect(new Optional('hello').isPresent, isTrue);
      });
      test('value', () {
        expect(present.value, 'test');
        expect(() => absent.value, throwsArgumentError);
      });
      test('or', () {
        expect(present.or('world'), 'test');
        expect(absent.or('world'), 'world');
      });
      test('orNull', () {
        expect(present.orNull, 'test');
        expect(absent.orNull, null);
      });
      test('then', () {
        var presentResult = present.then((value) => value.toUpperCase());
        expect(presentResult.value, 'TEST');
        var absentResult = absent.then((value) => fail('Not expected to be called.'));
        expect(absentResult.isAbsent, isTrue);
      });
      test('isPresent', () {
        expect(present.isPresent, isTrue);
        expect(absent.isPresent, isFalse);
      });
      test('isAbsent', () {
        expect(present.isAbsent, isFalse);
        expect(absent.isAbsent, isTrue);
      });
    });
  });
}
