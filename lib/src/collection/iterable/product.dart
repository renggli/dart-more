import '../../shared/exceptions.dart';

extension ProductIterableExtension<E> on Iterable<Iterable<E>> {
  /// Returns an iterable over the cross product of this [Iterable].
  ///
  /// The resulting iterable is equivalent to nested for-loops. The rightmost
  /// elements advance on every iteration. This pattern creates a lexicographic
  /// ordering so that if the input’s iterables are sorted, the product is
  /// sorted as well.
  ///
  /// For example:
  ///
  /// ```dart
  /// final a = ['x', 'y'];
  /// final b = [1, 2, 3];
  /// print([a, b].product());  // [['x', 1], ['x', 2], ['x', 3],
  ///                           //  ['y', 1], ['y', 2], ['y', 3]]
  /// ```
  Iterable<List<E>> product({int repeat = 1}) {
    checkNonZeroPositive(repeat, 'repeat');
    if (isEmpty || any((iterable) => iterable.isEmpty)) {
      return const [];
    } else {
      return productNotEmpty(
          map((iterable) => iterable.toList(growable: false))
              .toList(growable: false),
          repeat);
    }
  }
}

extension Product2IterableExtension<T1, T2> on (Iterable<T1>, Iterable<T2>) {
  /// Combines a tuple of iterables with the cross product to an iterable of
  /// tuples.
  ///
  /// For example:
  ///
  /// ```dart
  /// final a = ['x', 'y'];
  /// final b = [1, 2, 3];
  /// print((a, b).product());  // [('x', 1), ('x', 2), ('x', 3),
  ///                           //  ('y', 1), ('y', 2), ('y', 3)]
  /// ```
  Iterable<(T1, T2)> product() sync* {
    for (final v1 in $1) {
      for (final v2 in $2) {
        yield (v1, v2);
      }
    }
  }
}

Iterable<List<E>> productNotEmpty<E>(List<List<E>> elements, int repeat) sync* {
  final indices = List<int>.filled(elements.length * repeat, 0);
  final current = List<E>.generate(
    elements.length * repeat,
    (i) => elements[i % elements.length][0],
  );
  var hasMore = false;
  do {
    yield current.toList(growable: false);
    hasMore = false;
    for (var i = indices.length - 1; i >= 0; i--) {
      final e = i % elements.length;
      if (indices[i] + 1 < elements[e].length) {
        indices[i]++;
        current[i] = elements[e][indices[i]];
        hasMore = true;
        break;
      } else {
        for (var j = indices.length - 1; j >= i; j--) {
          indices[j] = 0;
          current[j] = elements[j % elements.length][0];
        }
      }
    }
  } while (hasMore);
}
