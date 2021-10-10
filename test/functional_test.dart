import 'package:more/functional.dart';
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
      test('==', () {
        // ignore: unrelated_type_equality_checks
        expect(optional == intPresent, isFalse);
        // ignore: unrelated_type_equality_checks
        expect(optional == intAbsent, isFalse);
        expect(optional == stringPresent, isTrue);
        expect(optional == stringAbsent, isFalse);
      });
      test('hashCode', () {
        expect(optional.hashCode == intPresent.hashCode, isFalse);
        expect(optional.hashCode == intAbsent.hashCode, isFalse);
        expect(optional.hashCode == stringPresent.hashCode, isTrue);
        expect(optional.hashCode == stringAbsent.hashCode, isFalse);
      });
      test('toString', () {
        expect(
            optional.toString(), "Instance of 'PresentOptional<String>'[foo]");
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
      test('==', () {
        // ignore: unrelated_type_equality_checks
        expect(optional == intPresent, isFalse);
        // ignore: unrelated_type_equality_checks
        expect(optional == intAbsent, isFalse);
        expect(optional == stringPresent, isFalse);
        expect(optional == stringAbsent, isTrue);
      });
      test('hashCode', () {
        expect(optional.hashCode == intPresent.hashCode, isFalse);
        expect(optional.hashCode == intAbsent.hashCode, isFalse);
        expect(optional.hashCode == stringPresent.hashCode, isFalse);
        expect(optional.hashCode == stringAbsent.hashCode, isTrue);
      });
      test('toString', () {
        expect(optional.toString(), "Instance of 'AbsentOptional<String>'");
      });
    });
    group('ofNullable', () {
      test('isAbsent', () {
        const String? value = null;
        final optional = Optional.ofNullable(value);
        expect(optional, isA<Optional<String>>());
        expect(optional.isAbsent, isTrue);
      });
      test('isPresent', () {
        // ignore: unnecessary_nullable_for_final_variable_declarations
        const String? value = 'foo';
        final optional = Optional.ofNullable(value);
        expect(optional, isA<Optional<String>>());
        expect(optional.isPresent, isTrue);
      });
    });
  });
  group('either', () {
    group('left', () {
      const value = 42;
      const either = Either<int, bool>.left(value);
      const otherEither = Either<int, bool>.left(value + 1);
      test('iff', () {
        final created = Either.iff(true, () => value, () => 'hello');
        expect(created, either);
      });
      test('either', () {
        final created = Either.either(() => value, () => 'hello');
        expect(created, either);
      });
      test('value', () {
        expect(either.value, value);
      });
      test('leftValue', () {
        expect(either.leftValue, value);
      });
      test('leftOptional', () {
        expect(either.leftOptional.orElseThrow(), value);
      });
      test('rightValue', () {
        expect(() => either.rightValue, throwsStateError);
      });
      test('rightOptional', () {
        expect(either.rightOptional.isAbsent, isTrue);
      });
      test('isLeft', () {
        expect(either.isLeft, isTrue);
      });
      test('isRight', () {
        expect(either.isRight, isFalse);
      });
      test('fold', () {
        expect(either.fold((left) => 'l:$left', (right) => 'r:$right'),
            'l:$value');
      });
      test('map', () {
        expect(
            either.map(
              (each) => 'l:$each',
              (each) => 'r:$each',
            ),
            const Either.left('l:$value'));
      });
      test('mapLeft', () {
        expect(
            either.mapLeft((each) => 'l:$each'), const Either.left('l:$value'));
      });
      test('mapRight', () {
        expect(either.mapRight((each) => 'r:$each'), const Either.left(value));
      });
      test('flatMap', () {
        expect(
            either.flatMap(
              (each) => Either.right('l:$each'),
              (each) => Either.left('r:$each'),
            ),
            const Either.right('l:$value'));
      });
      test('flatMapLeft', () {
        expect(either.flatMapLeft((each) => Either.left('l:$each')),
            const Either.left('l:$value'));
      });
      test('flatMapRight', () {
        expect(either.flatMapRight((each) => Either.right('r:$each')),
            const Either.left(value));
      });
      test('swap', () {
        expect(either.swap(), const Either.right(value));
      });
      test('==', () {
        expect(either == either, isTrue);
        expect(either == otherEither, isFalse);
        // ignore: unrelated_type_equality_checks
        expect(either == either.swap(), isFalse);
      });
      test('hashCode', () {
        expect(either.hashCode == either.hashCode, isTrue);
        expect(either.hashCode == otherEither.hashCode, isFalse);
        expect(either.hashCode == either.swap().hashCode, isFalse);
      });
      test('toString', () {
        expect(
            either.toString(), "Instance of 'LeftEither<int, bool>'[$value]");
      });
    });
    group('right', () {
      const value = true;
      const either = Either<int, bool>.right(value);
      const otherEither = Either<int, bool>.right(!value);
      test('iff', () {
        final created = Either.iff(false, () => 'hello', () => value);
        expect(created, either);
      });
      test('either', () {
        final created = Either.either(() => null, () => value);
        expect(created, either);
      });
      test('either (error)', () {
        expect(() => Either.either(() => null, () => null), throwsStateError);
      });
      test('value', () {
        expect(either.value, value);
      });
      test('leftValue', () {
        expect(() => either.leftValue, throwsStateError);
      });
      test('leftOptional', () {
        expect(either.leftOptional.isAbsent, isTrue);
      });
      test('rightValue', () {
        expect(either.rightValue, value);
      });
      test('rightOptional', () {
        expect(either.rightOptional.orElseThrow(), value);
      });
      test('isLeft', () {
        expect(either.isLeft, isFalse);
      });
      test('isRight', () {
        expect(either.isRight, isTrue);
      });
      test('fold', () {
        expect(either.fold((left) => 'l:$left', (right) => 'r:$right'),
            'r:$value');
      });
      test('map', () {
        expect(
            either.map(
              (each) => 'l:$each',
              (each) => 'r:$each',
            ),
            const Either.right('r:$value'));
      });
      test('mapLeft', () {
        expect(either.mapLeft((each) => '$each'), const Either.right(value));
      });
      test('mapRight', () {
        expect(
            either.mapRight((each) => '$each'), const Either.right('$value'));
      });
      test('flatMap', () {
        expect(
            either.flatMap(
              (each) => Either.right('l:$each'),
              (each) => Either.left('r:$each'),
            ),
            const Either.left('r:$value'));
      });
      test('flatMapLeft', () {
        expect(either.flatMapLeft((each) => Either.left('l:$each')),
            const Either.right(value));
      });
      test('flatMapRight', () {
        expect(either.flatMapRight((each) => Either.right('r:$each')),
            const Either.right('r:$value'));
      });
      test('swap', () {
        expect(either.swap(), const Either.left(value));
      });
      test('==', () {
        expect(either == either, isTrue);
        expect(either == otherEither, isFalse);
        // ignore: unrelated_type_equality_checks
        expect(either == either.swap(), isFalse);
      });
      test('hashCode', () {
        expect(either.hashCode == either.hashCode, isTrue);
        expect(either.hashCode == otherEither.hashCode, isFalse);
        expect(either.hashCode == either.swap().hashCode, isFalse);
      });
      test('toString', () {
        expect(
            either.toString(), "Instance of 'RightEither<int, bool>'[$value]");
      });
    });
  });
}
