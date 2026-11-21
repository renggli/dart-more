import 'package:checks/checks.dart';
import 'package:more/functional.dart';

/// Extension on [Subject] of [Optional] providing domain-specific checks.
extension OptionalChecks<T> on Subject<Optional<T>> {
  /// Asserts that the optional has a value.
  void isPresent() => has('isPresent', (o) => o.isPresent).isTrue;

  /// Asserts that the optional does not have a value.
  void isAbsent() => has('isAbsent', (o) => o.isAbsent).isTrue;

  /// Extracts the value of the optional for further assertions.
  Subject<T> get value => has('value', (o) => o.value);
}

/// Extension on [Subject] of [Either] providing domain-specific checks.
extension EitherChecks<L, R> on Subject<Either<L, R>> {
  /// Asserts that the either is a left instance.
  void isLeft() => has('isLeft', (e) => e.isLeft).isTrue;

  /// Asserts that the either is a right instance.
  void isRight() => has('isRight', (e) => e.isRight).isTrue;

  /// Extracts the left value of the either for further assertions.
  Subject<L> get leftValue => has('leftValue', (e) => e.leftValue);

  /// Extracts the right value of the either for further assertions.
  Subject<R> get rightValue => has('rightValue', (e) => e.rightValue);
}
