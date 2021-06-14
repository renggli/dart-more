import 'package:meta/meta.dart';

import '../../../hash.dart';
import '../either.dart';
import '../optional.dart';

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
  T fold<T>(
          T Function(L left) leftFunction, T Function(R right) rightFunction) =>
      rightFunction(rightValue);

  @override
  Either<L2, R2> map<L2, R2>(L2 Function(L left) leftFunction,
          R2 Function(R left) rightFunction) =>
      Either<L2, R2>.right(rightFunction(rightValue));

  @override
  Either<L2, R> mapLeft<L2>(L2 Function(L left) leftFunction) =>
      Either<L2, R>.right(rightValue);

  @override
  Either<L, R2> mapRight<R2>(R2 Function(R right) rightFunction) =>
      Either<L, R2>.right(rightFunction(rightValue));

  @override
  Either<L2, R2> flatMap<L2, R2>(Either<L2, R2> Function(L left) leftFunction,
          Either<L2, R2> Function(R left) rightFunction) =>
      rightFunction(rightValue);

  @override
  Either<L2, R> flatMapLeft<L2>(Either<L2, R> Function(L left) leftFunction) =>
      Either<L2, R>.right(rightValue);

  @override
  Either<L, R2> flatMapRight<R2>(
          Either<L, R2> Function(R left) rightFunction) =>
      rightFunction(rightValue);

  @override
  Either<R, L> swap() => Either<R, L>.left(rightValue);

  @override
  bool operator ==(Object other) =>
      other is RightEither && rightValue == other.rightValue;

  @override
  int get hashCode => hash2(RightEither, rightValue);

  @override
  String toString() => '${super.toString()}[$rightValue]';
}
