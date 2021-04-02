import 'package:more/optional.dart';
import 'package:test/test.dart';

void main() {
  group('optional', () {
    final numberPresent = Optional<num>.of(42);
    final numberAbsent = Optional<num>.absent();
    final stringPresent = Optional<String>.of('foo');
    final stringAbsent = Optional<String>.absent();
    group('present', () {
      final optional = stringPresent;
      test('value', () {
        expect(optional.value, 'foo');
      });
      test('iterable', () {
        expect(optional.iterable, isA<Iterable<String>>());
        expect(optional.iterable, ['foo']);
      });
      test('isPresent', () {
        expect(optional.isPresent, isTrue);
      });
      test('ifPresent', () {
        var called = 0;
        optional.ifPresent((value) {
          called++;
          expect(value, 'foo');
        });
        expect(called, 1);
      });
      test('isAbsent', () {
        expect(optional.isAbsent, isFalse);
      });
      test('ifAbsent', () {
        optional.ifAbsent(() => fail('Not expected to be called'));
      });
      test('where (positive)', () {
        final other = optional.where((value) => value.isNotEmpty);
        expect(other.value, 'foo');
      });
      test('where (negative)', () {
        final other = optional.where((value) => value.isEmpty);
        expect(other.isPresent, isFalse);
      });
      test('whereType (positive)', () {
        final other = optional.whereType<Object?>();
        expect(other, isA<Optional<Object?>>());
        expect(other.value, 'foo');
      });
      test('whereType (negative)', () {
        final filtered = optional.whereType<int>();
        expect(filtered, isA<Optional<num>>());
        expect(filtered.isPresent, isFalse);
      });
      test('map (same type)', () {
        final other = optional.map((value) => value.toUpperCase());
        expect(other, isA<Optional<String>>());
        expect(other.value, 'FOO');
      });
      test('map (other type)', () {
        final other = optional.map((value) => value.length);
        expect(other, isA<Optional<int>>());
        expect(other.value, 3);
      });
      test('flatMap (present)', () {
        final other = optional.flatMap((value) => numberPresent);
        expect(other, isA<Optional<num>>());
        expect(other.value, 42);
      });
      test('flatMap (absent)', () {
        final other = optional.flatMap((value) => numberAbsent);
        expect(other, isA<Optional<num>>());
        expect(other.isPresent, isFalse);
      });
      test('or', () {
        final other = optional.or(() => stringAbsent);
        expect(other, same(optional));
      });
      test('orElse', () {
        expect(optional.orElse('bar'), 'foo');
      });
      test('orElseGet', () {
        expect(
            optional.orElseGet(() => fail('Not expected to be called')), 'foo');
      });
      test('orElseThrow', () {
        expect(optional.orElseThrow(), 'foo');
      });
    });
    group('absent', () {
      final optional = stringAbsent;
      test('value', () {
        expect(() => optional.value, throwsStateError);
      });
      test('iterable', () {
        expect(optional.iterable, isA<Iterable<String>>());
        expect(optional.iterable, []);
      });
      test('isPresent', () {
        expect(optional.isPresent, isFalse);
      });
      test('ifPresent', () {
        optional.ifPresent((value) => fail('Not expected to be called'));
      });
      test('isAbsent', () {
        expect(optional.isAbsent, isTrue);
      });
      test('ifAbsent', () {
        var called = 0;
        optional.ifAbsent(() => called++);
        expect(called, 1);
      });
      test('where (positive)', () {
        final other =
            optional.where((value) => fail('Not expected to be called'));
        expect(other, same(optional));
      });
      test('where (negative)', () {
        final other =
            optional.where((value) => fail('Not expected to be called'));
        expect(other, same(optional));
      });
      test('whereType (positive)', () {
        final other = optional.whereType<Object?>();
        expect(other, isA<Optional<Object?>>());
        expect(other.isAbsent, isTrue);
      });
      test('whereType (negative)', () {
        final other = optional.whereType<int>();
        expect(other, isA<Optional<num>>());
        expect(other.isAbsent, isTrue);
      });
      test('map', () {
        final other =
            optional.map<num>((value) => fail('Not expected to be called'));
        expect(other, isA<Optional<num>>());
        expect(other.isAbsent, isTrue);
      });
      test('flatMap', () {
        final other =
            optional.flatMap<num>((value) => fail('Not expected to be called'));
        expect(other, isA<Optional<num>>());
        expect(other.isAbsent, isTrue);
      });
      test('or', () {
        final other = optional.or(() => stringPresent);
        expect(other, same(stringPresent));
      });
      test('orElse', () {
        expect(optional.orElse('bar'), 'bar');
      });
      test('orElseGet', () {
        expect(optional.orElseGet(() => 'zork'), 'zork');
      });
      test('orElseThrow', () {
        expect(() => optional.orElseThrow(), throwsStateError);
      });
      test('orElseThrow (custom)', () {
        expect(() => optional.orElseThrow(UnimplementedError()),
            throwsUnimplementedError);
      });
    });
  });
}
