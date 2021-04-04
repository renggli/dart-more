import 'package:more/optional.dart';
import 'package:test/test.dart';

void main() {
  group('optional', () {
    const intPresent = Optional.of(42);
    const intAbsent = Optional<int>.absent();
    const stringPresent = Optional.of('foo');
    const stringAbsent = Optional<String>.absent();
    group('present', () {
      const optional = stringPresent;
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
        expect(filtered, isA<Optional<int>>());
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
        final other = optional.flatMap((value) => intPresent);
        expect(other, isA<Optional<int>>());
        expect(other.value, 42);
      });
      test('flatMap (absent)', () {
        final other = optional.flatMap((value) => intAbsent);
        expect(other, isA<Optional<int>>());
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
      const optional = stringAbsent;
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
        expect(other, isA<Optional<int>>());
        expect(other.isAbsent, isTrue);
      });
      test('map', () {
        final other =
            optional.map<int>((value) => fail('Not expected to be called'));
        expect(other, isA<Optional<int>>());
        expect(other.isAbsent, isTrue);
      });
      test('flatMap', () {
        final other =
            optional.flatMap<int>((value) => fail('Not expected to be called'));
        expect(other, isA<Optional<int>>());
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
