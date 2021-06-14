import 'package:meta/meta.dart';

import '../../../hash.dart';
import '../either.dart';
import '../optional.dart';

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
  T fold<T>(
          T Function(L left) leftFunction, T Function(R right) rightFunction) =>
      leftFunction(leftValue);

  @override
  Either<L2, R2> map<L2, R2>(L2 Function(L left) leftFunction,
          R2 Function(R left) rightFunction) =>
      Either<L2, R2>.left(leftFunction(leftValue));

  @override
  Either<L2, R> mapLeft<L2>(L2 Function(L left) leftFunction) =>
      Either<L2, R>.left(leftFunction(leftValue));

  @override
  Either<L, R2> mapRight<R2>(R2 Function(R right) rightFunction) =>
      Either<L, R2>.left(leftValue);

  @override
  Either<L2, R2> flatMap<L2, R2>(Either<L2, R2> Function(L left) leftFunction,
          Either<L2, R2> Function(R left) rightFunction) =>
      leftFunction(leftValue);

  @override
  Either<L2, R> flatMapLeft<L2>(Either<L2, R> Function(L left) leftFunction) =>
      leftFunction(leftValue);

  @override
  Either<L, R2> flatMapRight<R2>(
          Either<L, R2> Function(R left) rightFunction) =>
      Either<L, R2>.left(leftValue);

  @override
  Either<R, L> swap() => Either<R, L>.right(leftValue);

  @override
  bool operator ==(Object other) =>
      other is LeftEither && leftValue == other.leftValue;

  @override
  int get hashCode => hash2(LeftEither, leftValue);

  @override
  String toString() => '${super.toString()}[$leftValue]';
}
