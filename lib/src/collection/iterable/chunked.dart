import '../../shared/exceptions.dart';

/// Extension on [Iterable] to chunk elements into fixed-size lists.
extension ChunkedIterableExtension<E> on Iterable<E> {
  /// Divides this [Iterable] into sub-lists of a given [size]. The final list
  /// might be smaller or equal to the desired size.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = [1, 2, 3, 4, 5];
  /// print(input.chunked(2));  // [[1, 2], [3, 4], [5]]
  /// ```
  Iterable<List<E>> chunked(int size) {
    checkNonZeroPositive(size, 'size');
    return _chunked(this, size);
  }

  /// Divides this [Iterable] into sub-lists of a given [size]. The final list
  /// is expanded with the provided [padding].
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = [1, 2, 3, 4, 5];
  /// print(input.chunkedWithPadding(2, -1));  // [[1, 2], [3, 4], [5, -1]]
  /// ```
  Iterable<List<E>> chunkedWithPadding(int size, E padding) {
    checkNonZeroPositive(size, 'size');
    return _chunkedWithPadding(this, size, padding);
  }
}

Iterable<List<E>> _chunked<E>(Iterable<E> iterable, int size) sync* {
  final iterator = iterable.iterator;
  while (iterator.moveNext()) {
    final current = <E>[];
    do {
      current.add(iterator.current);
    } while (current.length < size && iterator.moveNext());
    yield current.toList(growable: false);
  }
}

Iterable<List<E>> _chunkedWithPadding<E>(
  Iterable<E> iterable,
  int size,
  E padding,
) sync* {
  final iterator = iterable.iterator;
  while (iterator.moveNext()) {
    final current = List<E>.filled(size, padding);
    var count = 0;
    do {
      current[count++] = iterator.current;
    } while (count < size && iterator.moveNext());
    yield current;
  }
}
