library more.iterable.fold;

import 'dart:collection';

import 'package:more/src/iterable/mixins/infinite.dart';

/// Returns a lazy infinite list of repeated applications of the
/// n-ary [Function] to its previous n initial [elements].
///
/// For example, the expression
///
///     fold([0, 1], (a, b) => a + b);
///
/// results in the infinite iterable of all fibonacci numbers:
///
///     [0, 1, 1, 2, 3, 5, ...]
///
Iterable<E> fold<E>(Iterable<E> elements, E Function(List<E>) combine) {
  return new FoldIterable<E>(elements, combine);
}

class FoldIterable<E> extends IterableBase<E> with InfiniteIterable<E> {
  final Iterable<E> elements;
  final E Function(List<E>) combine;

  FoldIterable(this.elements, this.combine);

  @override
  Iterator<E> get iterator {
    return new FoldIterator<E>(new List.from(elements, growable: false), combine);
  }
}

class FoldIterator<E> extends Iterator<E> {
  final List<E> state;
  final Function combine;

  int index = 0;

  FoldIterator(this.state, this.combine);

  @override
  E current;

  @override
  bool moveNext() {
    if (index < state.length) {
      current = state[index];
      index++;
    } else {
      current = combine(state);
      for (var i = 0; i < state.length - 1; i++) {
        state[i] = state[i + 1];
      }
      state[state.length - 1] = current;
    }
    return true;
  }
}
