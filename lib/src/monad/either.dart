/// A container that may contain one or the other value.
import 'package:meta/meta.dart';

import 'either/left.dart';
import 'either/right.dart';
import 'optional.dart';

/// A disjoint union with a value of either type [L] or type [R].
///
/// Also see https://en.wikipedia.org/wiki/Either_type.
@immutable
@sealed
abstract class Either<L, R> {
  /// Internal const constructor.
  @internal
  const Either();

  /// Creates an [Either] with the left value populated.
  const factory Either.left(L value) = LeftEither<L, R>;

  /// Creates an [Either] with the right value populated.
  const factory Either.right(R value) = RightEither<L, R>;

  /// Creates an left-sided [Either] from the [leftProvider], if [condition] is
  /// `true`. Otherwise, create a right-sided [Either] from the [rightProvider].
  factory Either.iff(
    bool condition,
    L Function() leftProvider,
    R Function() rightProvider,
  ) =>
      condition
          ? Either<L, R>.left(leftProvider())
          : Either<L, R>.right(rightProvider());

  /// Creates a left-biased [Either]. This means, if the [leftProvider] returns
  /// a non-null value create a left-sided [Either]. Alternatively, if the
  /// [rightProvider] returns a non-null value, create a right-sided [Either].
  /// Otherwise, if both providers return a null-value, throw a [StateError].
  factory Either.either(
    L? Function() leftProvider,
    R? Function() rightProvider,
  ) {
    final leftValue = leftProvider();
    if (leftValue != null) {
      return Either<L, R>.left(leftValue);
    }
    final rightValue = rightProvider();
    if (rightValue != null) {
      return Either<L, R>.right(rightValue);
    }
    throw noValueError;
  }

  /// Returns a dynamically typed value of this object, either the [leftValue]
  /// or the [rightValue].
  dynamic get value;

  /// Returns the left value, if absent throws a [StateError].
  L get leftValue;

  /// Returns the left value as an [Optional].
  Optional<L> get leftOptional;

  /// Returns the right value, if absent throws a [StateError].
  R get rightValue;

  /// Returns the right value as an [Optional].
  Optional<R> get rightOptional;

  /// Returns `true`, if this is a left value.
  bool get isLeft;

  /// Returns `true`, if this has a right value.
  bool get isRight;

  /// Returns the appropriate transformation to type [T].
  T fold<T>(
    T Function(L left) leftFunction,
    T Function(R right) rightFunction,
  );

  /// Transforms the left value with [leftFunction] or the right value with
  /// [rightFunction]. The resulting [Either] contains the transformed value
  /// of the corresponding function.
  Either<L2, R2> map<L2, R2>(
    L2 Function(L left) leftFunction,
    R2 Function(R left) rightFunction,
  );

  /// Transforms the left value with [leftFunction]. If applicable, the
  /// resulting [Either] contains the transformed left value.
  Either<L2, R> mapLeft<L2>(L2 Function(L left) leftFunction);

  /// Transforms the right value with [rightFunction]. If applicable, the
  /// resulting [Either] contains the transformed right value.
  Either<L, R2> mapRight<R2>(R2 Function(R right) rightFunction);

  /// Returns a new [Either] created by the either-returning transformation
  /// [leftFunction] or [rightFunction].
  Either<L2, R2> flatMap<L2, R2>(
    Either<L2, R2> Function(L left) leftFunction,
    Either<L2, R2> Function(R left) rightFunction,
  );

  /// Returns a new [Either] from the either-returning transformation
  /// [leftFunction], otherwise returns the wrapped right value.
  Either<L2, R> flatMapLeft<L2>(Either<L2, R> Function(L left) leftFunction);

  /// Returns a new [Either] from the either-returning transformation
  /// [rightFunction], otherwise returns the wrapped left value.
  Either<L, R2> flatMapRight<R2>(Either<L, R2> Function(R left) rightFunction);

  /// Returns a new [Either] with the left and right value switched.
  Either<R, L> swap();
}

final noValueError = StateError('No value');
final noLeftValueError = StateError('No left value');
final noRightValueError = StateError('No right value');
