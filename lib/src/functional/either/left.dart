import 'package:meta/meta.dart';

import '../either.dart';
import '../optional.dart';
import '../types/mapping.dart';

@sealed
class LeftEither<L, R> extends Either<L, R> {
  const LeftEither(this.leftValue);

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
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  T fold<T>(Map1<L, T> leftFunction, Map1<R, T> rightFunction) =>
      leftFunction(leftValue);

  @override
  Either<L2, R2> map<L2, R2>(
          Map1<L, L2> leftFunction, Map1<R, R2> rightFunction) =>
      Either<L2, R2>.left(leftFunction(leftValue));

  @override
  Either<L2, R> mapLeft<L2>(Map1<L, L2> leftFunction) =>
      Either<L2, R>.left(leftFunction(leftValue));

  @override
  Either<L, R2> mapRight<R2>(Map1<R, R2> rightFunction) =>
      Either<L, R2>.left(leftValue);

  @override
  Either<L2, R2> flatMap<L2, R2>(Map1<L, Either<L2, R2>> leftFunction,
          Map1<R, Either<L2, R2>> rightFunction) =>
      leftFunction(leftValue);

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
