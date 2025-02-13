/// A container that may contain one or the other value.
library;

import 'package:meta/meta.dart';

import 'optional.dart';
import 'types/mapping.dart';

/// A disjoint union with a value of either type [L] or type [R].
///
/// Also see https://en.wikipedia.org/wiki/Either_type.
@immutable
sealed class Either<L, R> {
  /// Internal const constructor.
  const Either._();

  /// Creates an [Either] with the left value populated.
  const factory Either.left(L value) = LeftEither<L, R>._;

  /// Creates an [Either] with the right value populated.
  const factory Either.right(R value) = RightEither<L, R>._;

  /// Creates an left-sided [Either] from the [leftProvider], if [condition] is
  /// `true`. Otherwise, create a right-sided [Either] from the [rightProvider].
  factory Either.iff(
    bool condition,
    Map0<L> leftProvider,
    Map0<R> rightProvider,
  ) =>
      condition
          ? Either<L, R>.left(leftProvider())
          : Either<L, R>.right(rightProvider());

  /// Creates a left-biased [Either]. This means, if the [leftProvider] returns
  /// a non-null value create a left-sided [Either]. Alternatively, if the
  /// [rightProvider] returns a non-null value, create a right-sided [Either].
  /// Otherwise, if both providers return a null-value, throw a [StateError].
  factory Either.either(Map0<L?> leftProvider, Map0<R?> rightProvider) {
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

  /// Returns a tuple with either the left or right value defined.
  (L?, R?) get tuple;

  /// Returns `true`, if this is a left value.
  bool get isLeft;

  /// Returns `true`, if this has a right value.
  bool get isRight;

  /// Returns the appropriate transformation to type [T].
  T fold<T>(Map1<L, T> leftFunction, Map1<R, T> rightFunction);

  /// Transforms the left value with [leftFunction] or the right value with
  /// [rightFunction]. The resulting [Either] contains the transformed value
  /// of the corresponding function.
  Either<L2, R2> map<L2, R2>(
    Map1<L, L2> leftFunction,
    Map1<R, R2> rightFunction,
  );

  /// Transforms the left value with [leftFunction]. If applicable, the
  /// resulting [Either] contains the transformed left value.
  Either<L2, R> mapLeft<L2>(Map1<L, L2> leftFunction);

  /// Transforms the right value with [rightFunction]. If applicable, the
  /// resulting [Either] contains the transformed right value.
  Either<L, R2> mapRight<R2>(Map1<R, R2> rightFunction);

  /// Returns a new [Either] created by the either-returning transformation
  /// [leftFunction] or [rightFunction].
  Either<L2, R2> flatMap<L2, R2>(
    Map1<L, Either<L2, R2>> leftFunction,
    Map1<R, Either<L2, R2>> rightFunction,
  );

  /// Returns a new [Either] from the either-returning transformation
  /// [leftFunction], otherwise returns the wrapped right value.
  Either<L2, R> flatMapLeft<L2>(Map1<L, Either<L2, R>> leftFunction);

  /// Returns a new [Either] from the either-returning transformation
  /// [rightFunction], otherwise returns the wrapped left value.
  Either<L, R2> flatMapRight<R2>(Map1<R, Either<L, R2>> rightFunction);

  /// Returns a new [Either] with the left and right value switched.
  Either<R, L> swap();
}

/// Implementation of an [Either] with [leftValue] populated.
class LeftEither<L, R> extends Either<L, R> {
  const LeftEither._(this.leftValue) : super._();

  @override
  L get value => leftValue;

  @override
  final L leftValue;

  @override
  Optional<L> get leftOptional => Optional<L>.of(leftValue);

  @override
  R get rightValue => throw noRightValueError;

  @override
  Optional<R> get rightOptional => Optional<R>.absent();

  @override
  (L, R?) get tuple => (leftValue, null);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  T fold<T>(Map1<L, T> leftFunction, Map1<R, T> rightFunction) =>
      leftFunction(leftValue);

  @override
  Either<L2, R2> map<L2, R2>(
    Map1<L, L2> leftFunction,
    Map1<R, R2> rightFunction,
  ) => Either<L2, R2>.left(leftFunction(leftValue));

  @override
  Either<L2, R> mapLeft<L2>(Map1<L, L2> leftFunction) =>
      Either<L2, R>.left(leftFunction(leftValue));

  @override
  Either<L, R2> mapRight<R2>(Map1<R, R2> rightFunction) =>
      Either<L, R2>.left(leftValue);

  @override
  Either<L2, R2> flatMap<L2, R2>(
    Map1<L, Either<L2, R2>> leftFunction,
    Map1<R, Either<L2, R2>> rightFunction,
  ) => leftFunction(leftValue);

  @override
  Either<L2, R> flatMapLeft<L2>(Map1<L, Either<L2, R>> leftFunction) =>
      leftFunction(leftValue);

  @override
  Either<L, R2> flatMapRight<R2>(Map1<R, Either<L, R2>> rightFunction) =>
      Either<L, R2>.left(leftValue);

  @override
  Either<R, L> swap() => Either<R, L>.right(leftValue);

  @override
  bool operator ==(Object other) =>
      other is LeftEither && leftValue == other.leftValue;

  @override
  int get hashCode => Object.hash(LeftEither, leftValue);

  @override
  String toString() => '${super.toString()}[$leftValue]';
}

/// Implementation of an [Either] with [rightValue] populated.
class RightEither<L, R> extends Either<L, R> {
  const RightEither._(this.rightValue) : super._();

  @override
  R get value => rightValue;

  @override
  L get leftValue => throw noLeftValueError;

  @override
  Optional<L> get leftOptional => Optional<L>.absent();

  @override
  final R rightValue;

  @override
  Optional<R> get rightOptional => Optional<R>.of(rightValue);

  @override
  (L?, R) get tuple => (null, rightValue);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  T fold<T>(Map1<L, T> leftFunction, Map1<R, T> rightFunction) =>
      rightFunction(rightValue);

  @override
  Either<L2, R2> map<L2, R2>(
    Map1<L, L2> leftFunction,
    Map1<R, R2> rightFunction,
  ) => Either<L2, R2>.right(rightFunction(rightValue));

  @override
  Either<L2, R> mapLeft<L2>(Map1<L, L2> leftFunction) =>
      Either<L2, R>.right(rightValue);

  @override
  Either<L, R2> mapRight<R2>(Map1<R, R2> rightFunction) =>
      Either<L, R2>.right(rightFunction(rightValue));

  @override
  Either<L2, R2> flatMap<L2, R2>(
    Map1<L, Either<L2, R2>> leftFunction,
    Map1<R, Either<L2, R2>> rightFunction,
  ) => rightFunction(rightValue);

  @override
  Either<L2, R> flatMapLeft<L2>(Map1<L, Either<L2, R>> leftFunction) =>
      Either<L2, R>.right(rightValue);

  @override
  Either<L, R2> flatMapRight<R2>(Map1<R, Either<L, R2>> rightFunction) =>
      rightFunction(rightValue);

  @override
  Either<R, L> swap() => Either<R, L>.left(rightValue);

  @override
  bool operator ==(Object other) =>
      other is RightEither && rightValue == other.rightValue;

  @override
  int get hashCode => Object.hash(RightEither, rightValue);

  @override
  String toString() => '${super.toString()}[$rightValue]';
}

final noValueError = StateError('No value');
final noLeftValueError = StateError('No left value');
final noRightValueError = StateError('No right value');
