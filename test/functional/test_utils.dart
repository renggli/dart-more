import 'package:checks/checks.dart';
import 'package:more/functional.dart';

/// Extension on [Subject] of [Optional] providing domain-specific checks.
extension OptionalChecks<T> on Subject<Optional<T>> {
  /// Asserts that the optional has a value.
  void isPresent() => has((o) => o.isPresent, 'isPresent').isTrue();

  /// Asserts that the optional does not have a value.
  void isAbsent() => has((o) => o.isAbsent, 'isAbsent').isTrue();

  /// Extracts the value of the optional for further assertions.
  Subject<T> get value => has((o) => o.value, 'value');
}

/// Extension on [Subject] of [Either] providing domain-specific checks.
extension EitherChecks<L, R> on Subject<Either<L, R>> {
  /// Asserts that the either is a left instance.
  void isLeft() => has((e) => e.isLeft, 'isLeft').isTrue();

  /// Asserts that the either is a right instance.
  void isRight() => has((e) => e.isRight, 'isRight').isTrue();

  /// Extracts the left value of the either for further assertions.
  Subject<L> get leftValue => has((e) => e.leftValue, 'leftValue');

  /// Extracts the right value of the either for further assertions.
  Subject<R> get rightValue => has((e) => e.rightValue, 'rightValue');
}
