import 'package:collection/collection.dart';

import '../../printer.dart';

/// A path that ends with the element [tail].
class Path<E> with ToStringPrinter implements Comparable<Path<E>> {
  /// Constructs a new path with a single element.
  const Path(this.tail, {this.parent, this.weight = 0});

  /// The last element of this path.
  final E tail;

  /// The path preceding the [tail] element, `null` if [tail] is the first
  /// element in this path.
  final Path<E>? parent;

  /// The cached cost of reaching the [tail] element from its parent, `0` if
  /// [tail] is the first element in this path.
  final num weight;

  /// The depth of this path.
  int get depth {
    var result = 0;
    for (var current = parent; current != null; current = current.parent) {
      result++;
    }
    return result;
  }

  /// The length of this path.
  int get length => depth + 1;

  /// The elements in this path.
  List<E> get elements {
    final result = <E>[tail];
    for (var current = parent; current != null; current = current.parent) {
      result.add(current.tail);
    }
    result.reverseRange(0, result.length);
    return result;
  }

  @override
  int compareTo(Path<E> other) => weight.compareTo(other.weight);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(tail, name: 'element')
    ..addValue(parent,
        name: 'parent', printer: Printer<Path<E>?>.literal('($length more)'))
    ..addValue(weight, name: 'cost');
}
