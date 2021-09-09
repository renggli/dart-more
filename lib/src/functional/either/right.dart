import 'package:meta/meta.dart';

import '../either.dart';
import '../optional.dart';
import '../types/mapping.dart';

@sealed
class RightEither<L, R> extends Either<L, R> {
  const RightEither(this.rightValue);

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
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  T fold<T>(Map1<L, T> leftFunction, Map1<R, T> rightFunction) =>
      rightFunction(rightValue);

  @override
  Either<L2, R2> map<L2, R2>(
          Map1<L, L2> leftFunction, Map1<R, R2> rightFunction) =>
      Either<L2, R2>.right(rightFunction(rightValue));

  @override
  Either<L2, R> mapLeft<L2>(Map1<L, L2> leftFunction) =>
      Either<L2, R>.right(rightValue);

  @override
  Either<L, R2> mapRight<R2>(Map1<R, R2> rightFunction) =>
      Either<L, R2>.right(rightFunction(rightValue));

  @override
  Either<L2, R2> flatMap<L2, R2>(Map1<L, Either<L2, R2>> leftFunction,
          Map1<R, Either<L2, R2>> rightFunction) =>
      rightFunction(rightValue);

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
