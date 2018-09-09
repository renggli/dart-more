library more.iterable.product;

import 'dart:collection' show IterableBase;

/// Returns an iterable over the cross product of [iterables].
///
/// The resulting iterable is equivalent to nested for-loops. The rightmost
/// elements advance on every iteration. This pattern creates a lexicographic
/// ordering so that if the input’s iterables are sorted, the product is sorted
/// as well.
///
/// For example, the product of `['x', 'y']` and `[1, 2, 3]` is created with
///
///    product([['x', 'y'], [1, 2, 3]]);
///
/// and results in an iterable with the following elements:
///
///    ['x', 1]
///    ['x', 2]
///    ['x', 3]
///    ['y', 1]
///    ['y', 2]
///    ['y', 3]
///
Iterable<List<E>> product<E>(Iterable<Iterable<E>> iterables) {
  if (iterables.isEmpty || iterables.any((iterable) => iterable.isEmpty)) {
    return const Iterable.empty();
  } else {
    return ProductIterable<E>(iterables
        .map((iterable) => iterable.toList(growable: false))
        .toList(growable: false));
  }
}

class ProductIterable<E> extends IterableBase<List<E>> {
  final List<List<E>> sources;

  ProductIterable(this.sources);

  @override
  Iterator<List<E>> get iterator {
    final state = List<int>.filled(sources.length, 0);
    return ProductIterator<E>(sources, state);
  }
}

class ProductIterator<E> extends Iterator<List<E>> {
  final List<List<E>> sources;
  final List<int> state;

  bool completed = false;

  ProductIterator(this.sources, this.state);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      return false;
    }
    if (current == null) {
      current = List<E>.generate(sources.length, (i) => sources[i][0],
          growable: false);
      return true;
    }
    for (var i = state.length - 1; i >= 0; i--) {
      if (state[i] + 1 < sources[i].length) {
        state[i]++;
        current[i] = sources[i][state[i]];
        return true;
      } else {
        for (var j = state.length - 1; j >= i; j--) {
          state[j] = 0;
          current[j] = sources[j][0];
        }
      }
    }
    completed = true;
    current = null;
    return false;
  }
}
