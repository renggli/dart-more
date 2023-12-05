import '../bound.dart';
import 'lower.dart';
import 'upper.dart';

class Empty<T> extends Bound<T> implements LowerBound<T>, UpperBound<T> {
  @override
  bool contains(Comparator<T> comparator, T value) => false;

  @override
  int get hashCode => 81966051;

  @override
  bool operator ==(Object other) => other is Empty<T>;

  @override
  String toString() => '∅';
}
