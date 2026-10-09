import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('either', () {
    group('left', () {
      const value = 42;
      const either = Either<int, bool>.left(value);
      const otherEither = Either<int, bool>.left(value + 1);
      test('iff', () {
        final created = Either<int, bool>.iff(true, () => value, () => false);
        check(created).equals(either);
      });
      test('either', () {
        final created = Either<int, bool>.either(() => value, () => false);
        check(created).equals(either);
      });
      test('value', () {
        check(either.value).equals(value);
      });
      test('leftValue', () {
        check(either.leftValue).equals(value);
      });
      test('leftOptional', () {
        check(either.leftOptional.orElseThrow()).equals(value);
      });
      test('rightValue', () {
        check(() => either.rightValue).throws<StateError>();
      });
      test('rightOptional', () {
        check(either.rightOptional.isAbsent).isTrue();
      });
      test('tuple', () {
        check(either.tuple).equals((value, null));
      });
      test('isLeft', () {
        check(either.isLeft).isTrue();
      });
      test('isRight', () {
        check(either.isRight).isFalse();
      });
      test('fold', () {
        check(either.fold((left) => 'l:$left', (right) => 'r:$right'))
            .equals('l:$value');
      });
      test('map', () {
        check(either.map((each) => 'l:$each', (each) => 'r:$each'))
            .equals(const Either<String, String>.left('l:$value'));
      });
      test('mapLeft', () {
        check(either.mapLeft((each) => 'l:$each'))
            .equals(const Either<String, bool>.left('l:$value'));
      });
      test('mapRight', () {
        check(either.mapRight((each) => 'r:$each'))
            .equals(const Either<int, String>.left(value));
      });
      test('flatMap', () {
        check(
          either.flatMap(
            (each) => Either<String, String>.right('l:$each'),
            (each) => Either<String, String>.left('r:$each'),
          ),
        ).equals(const Either<String, String>.right('l:$value'));
      });
      test('flatMapLeft', () {
        check(
          either.flatMapLeft((each) => Either<String, bool>.left('l:$each')),
        ).equals(const Either<String, bool>.left('l:$value'));
      });
      test('flatMapRight', () {
        check(
          either.flatMapRight((each) => Either<int, String>.right('r:$each')),
        ).equals(const Either<int, String>.left(value));
      });
      test('swap', () {
        check(either.swap()).equals(const Either<bool, int>.right(value));
      });
      test('==', () {
        check(either == either).isTrue();
        check(either == otherEither).isFalse();
        // ignore: unrelated_type_equality_checks
        check(either == either.swap()).isFalse();
      });
      test('hashCode', () {
        check(either.hashCode == either.hashCode).isTrue();
        check(either.hashCode == otherEither.hashCode).isFalse();
        check(either.hashCode == either.swap().hashCode).isFalse();
      });
      test('toString', () {
        check(either.toString())
            .equals("Instance of 'LeftEither<int, bool>'[$value]");
      });
    });
    group('right', () {
      const value = true;
      const either = Either<int, bool>.right(value);
      const otherEither = Either<int, bool>.right(!value);
      test('iff', () {
        final created = Either<int, bool>.iff(false, () => 0, () => value);
        check(created).equals(either);
      });
      test('either', () {
        final created = Either<int, bool>.either(() => null, () => value);
        check(created).equals(either);
      });
      test('either (error)', () {
        check(() => Either<int, bool>.either(() => null, () => null))
            .throws<StateError>();
      });
      test('value', () {
        check(either.value).equals(value);
      });
      test('leftValue', () {
        check(() => either.leftValue).throws<StateError>();
      });
      test('leftOptional', () {
        check(either.leftOptional.isAbsent).isTrue();
      });
      test('rightValue', () {
        check(either.rightValue).equals(value);
      });
      test('rightOptional', () {
        check(either.rightOptional.orElseThrow()).equals(value);
      });
      test('tuple', () {
        check(either.tuple).equals((null, value));
      });
      test('isLeft', () {
        check(either.isLeft).isFalse();
      });
      test('isRight', () {
        check(either.isRight).isTrue();
      });
      test('fold', () {
        check(either.fold((left) => 'l:$left', (right) => 'r:$right'))
            .equals('r:$value');
      });
      test('map', () {
        check(either.map((each) => 'l:$each', (each) => 'r:$each'))
            .equals(const Either<String, String>.right('r:$value'));
      });
      test('mapLeft', () {
        check(either.mapLeft((each) => '$each'))
            .equals(const Either<String, bool>.right(value));
      });
      test('mapRight', () {
        check(either.mapRight((each) => '$each'))
            .equals(const Either<int, String>.right('$value'));
      });
      test('flatMap', () {
        check(
          either.flatMap(
            (each) => Either<String, String>.right('l:$each'),
            (each) => Either<String, String>.left('r:$each'),
          ),
        ).equals(const Either<String, String>.left('r:$value'));
      });
      test('flatMapLeft', () {
        check(
          either.flatMapLeft((each) => Either<String, bool>.left('l:$each')),
        ).equals(const Either<String, bool>.right(value));
      });
      test('flatMapRight', () {
        check(
          either.flatMapRight((each) => Either<int, String>.right('r:$each')),
        ).equals(const Either<int, String>.right('r:$value'));
      });
      test('swap', () {
        check(either.swap()).equals(const Either<bool, int>.left(value));
      });
      test('==', () {
        check(either == either).isTrue();
        check(either == otherEither).isFalse();
        // ignore: unrelated_type_equality_checks
        check(either == either.swap()).isFalse();
      });
      test('hashCode', () {
        check(either.hashCode == either.hashCode).isTrue();
        check(either.hashCode == otherEither.hashCode).isFalse();
        check(either.hashCode == either.swap().hashCode).isFalse();
      });
      test('toString', () {
        check(either.toString())
            .equals("Instance of 'RightEither<int, bool>'[$value]");
      });
    });
  });
}
