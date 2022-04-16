import '../bound.dart';
import 'lower.dart';
import 'upper.dart';

class Empty<T extends Comparable<T>> extends Bound<T>
    implements LowerBound<T>, UpperBound<T> {
  @override
  bool contains(T value) => false;

  @override
  int get hashCode => 81966051;

  @override
  bool operator ==(Object other) => other is Empty<T>;

  @override
  String toString() => '∅';
}
