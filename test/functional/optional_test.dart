import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

Never fail(String message) => throw StateError(message);

void main() {
  group('optional', () {
    const intPresent = Optional.of(42);
    const intAbsent = Optional<int>.absent();
    const stringPresent = Optional.of('foo');
    const stringAbsent = Optional<String>.absent();
    group('present', () {
      const optional = stringPresent;
      test('value', () {
        check(optional.value).equals('foo');
      });
      test('iterable', () {
        check(optional.iterable).isA<Iterable<String>>();
        check(optional.iterable).deepEquals(['foo']);
      });
      test('isPresent', () {
        check(optional.isPresent).isTrue();
      });
      test('ifPresent', () {
        var called = 0;
        optional.ifPresent((value) {
          called++;
          check(value).equals('foo');
        });
        check(called).equals(1);
      });
      test('isAbsent', () {
        check(optional.isAbsent).isFalse();
      });
      test('ifAbsent', () {
        optional.ifAbsent(() => fail('Not expected to be called'));
      });
      test('where (positive)', () {
        final other = optional.where((value) => value.isNotEmpty);
        check(other.value).equals('foo');
      });
      test('where (negative)', () {
        final other = optional.where((value) => value.isEmpty);
        check(other.isPresent).isFalse();
      });
      test('whereType (positive)', () {
        final other = optional.whereType<Object?>();
        check(other).isA<Optional<Object?>>();
        check(other.value).equals('foo');
      });
      test('whereType (negative)', () {
        final filtered = optional.whereType<int>();
        check(filtered).isA<Optional<int>>();
        check(filtered.isPresent).isFalse();
      });
      test('map (same type)', () {
        final other = optional.map((value) => value.toUpperCase());
        check(other).isA<Optional<String>>();
        check(other.value).equals('FOO');
      });
      test('map (other type)', () {
        final other = optional.map((value) => value.length);
        check(other).isA<Optional<int>>();
        check(other.value).equals(3);
      });
      test('flatMap (present)', () {
        final other = optional.flatMap((value) => intPresent);
        check(other).isA<Optional<int>>();
        check(other.value).equals(42);
      });
      test('flatMap (absent)', () {
        final other = optional.flatMap((value) => intAbsent);
        check(other).isA<Optional<int>>();
        check(other.isPresent).isFalse();
      });
      test('or', () {
        final other = optional.or(() => stringAbsent);
        check(other).identicalTo(optional);
      });
      test('orElse', () {
        check(optional.orElse('bar')).equals('foo');
      });
      test('orElseGet', () {
        check(optional.orElseGet(() => fail('Not expected to be called')))
            .equals('foo');
      });
      test('orElseThrow', () {
        check(optional.orElseThrow()).equals('foo');
      });
      test('==', () {
        // ignore: unrelated_type_equality_checks
        check(optional == intPresent).isFalse();
        // ignore: unrelated_type_equality_checks
        check(optional == intAbsent).isFalse();
        check(optional == stringPresent).isTrue();
        check(optional == stringAbsent).isFalse();
      });
      test('hashCode', () {
        check(optional.hashCode == intPresent.hashCode).isFalse();
        check(optional.hashCode == intAbsent.hashCode).isFalse();
        check(optional.hashCode == stringPresent.hashCode).isTrue();
        check(optional.hashCode == stringAbsent.hashCode).isFalse();
      });
      test('toString', () {
        check(optional.toString())
            .equals("Instance of 'PresentOptional<String>'[foo]");
      });
    });
    group('absent', () {
      const optional = stringAbsent;
      test('value', () {
        check(() => optional.value).throws<StateError>();
      });
      test('iterable', () {
        check(optional.iterable).isA<Iterable<String>>();
        check(optional.iterable).isEmpty();
      });
      test('isPresent', () {
        check(optional.isPresent).isFalse();
      });
      test('ifPresent', () {
        optional.ifPresent((value) => fail('Not expected to be called'));
      });
      test('isAbsent', () {
        check(optional.isAbsent).isTrue();
      });
      test('ifAbsent', () {
        var called = 0;
        optional.ifAbsent(() => called++);
        check(called).equals(1);
      });
      test('where (positive)', () {
        final other = optional.where(
          (value) => fail('Not expected to be called'),
        );
        check(other).identicalTo(optional);
      });
      test('where (negative)', () {
        final other = optional.where(
          (value) => fail('Not expected to be called'),
        );
        check(other).identicalTo(optional);
      });
      test('whereType (positive)', () {
        final other = optional.whereType<Object?>();
        check(other).isA<Optional<Object?>>();
        check(other.isAbsent).isTrue();
      });
      test('whereType (negative)', () {
        final other = optional.whereType<int>();
        check(other).isA<Optional<int>>();
        check(other.isAbsent).isTrue();
      });
      test('map', () {
        final other = optional.map<int>(
          (value) => fail('Not expected to be called'),
        );
        check(other).isA<Optional<int>>();
        check(other.isAbsent).isTrue();
      });
      test('flatMap', () {
        final other = optional.flatMap<int>(
          (value) => fail('Not expected to be called'),
        );
        check(other).isA<Optional<int>>();
        check(other.isAbsent).isTrue();
      });
      test('or', () {
        final other = optional.or(() => stringPresent);
        check(other).identicalTo(stringPresent);
      });
      test('orElse', () {
        check(optional.orElse('bar')).equals('bar');
      });
      test('orElseGet', () {
        check(optional.orElseGet(() => 'zork')).equals('zork');
      });
      test('orElseThrow', () {
        check(() => optional.orElseThrow()).throws<StateError>();
      });
      test('orElseThrow (custom)', () {
        check(() => optional.orElseThrow(UnimplementedError()))
            .throws<UnimplementedError>();
      });
      test('==', () {
        // ignore: unrelated_type_equality_checks
        check(optional == intPresent).isFalse();
        // ignore: unrelated_type_equality_checks
        check(optional == intAbsent).isFalse();
        check(optional == stringPresent).isFalse();
        check(optional == stringAbsent).isTrue();
      });
      test('hashCode', () {
        check(optional.hashCode == intPresent.hashCode).isFalse();
        check(optional.hashCode == intAbsent.hashCode).isFalse();
        check(optional.hashCode == stringPresent.hashCode).isFalse();
        check(optional.hashCode == stringAbsent.hashCode).isTrue();
      });
      test('toString', () {
        check(optional.toString())
            .equals("Instance of 'AbsentOptional<String>'");
      });
    });
    group('ofNullable', () {
      test('isAbsent', () {
        String? value;
        final optional = Optional.ofNullable(value);
        check(optional).isA<Optional<String>>();
        check(optional.isAbsent).isTrue();
      });
      test('isPresent', () {
        String? value;
        value = 'foo';
        final optional = Optional.ofNullable(value);
        check(optional).isA<Optional<String>>();
        check(optional.isPresent).isTrue();
      });
    });
  });
}
