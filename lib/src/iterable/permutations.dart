library more.iterable.permutations;

import 'dart:collection' show IterableBase;

/// Returns an iterable over the permutations of [elements]. The permutations
/// are emitted in lexicographical order based on the input.
///
/// The following expression iterates over xyz, xzy, yxz, yzx, zxy, and zyx:
///
///     permutations(string('xyz'));
///
Iterable<List<E>> permutations<E>(Iterable<E> elements) {
  if (elements.isEmpty) {
    return const Iterable.empty();
  } else {
    return PermutationIterable<E>(elements.toList(growable: false));
  }
}

class PermutationIterable<E> extends IterableBase<List<E>> {
  final List<E> elements;

  PermutationIterable(this.elements);

  @override
  Iterator<List<E>> get iterator => PermutationIterator<E>(elements);
}

class PermutationIterator<E> extends Iterator<List<E>> {
  final List<E> elements;

  List<int> state;
  bool completed = false;

  PermutationIterator(this.elements);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      return false;
    } else if (current == null) {
      state = List<int>(elements.length);
      current = List<E>(elements.length);
      for (var i = 0; i < state.length; i++) {
        state[i] = i;
        current[i] = elements[i];
      }
      return true;
    } else {
      var k = state.length - 2;
      while (k >= 0 && state[k] > state[k + 1]) {
        k--;
      }
      if (k == -1) {
        state = null;
        current = null;
        completed = true;
        return false;
      }
      var l = state.length - 1;
      while (state[k] > state[l]) {
        l--;
      }
      swap(k, l);
      for (var i = k + 1, j = state.length - 1; i < j; i++, j--) {
        swap(i, j);
      }
      return true;
    }
  }

  void swap(int i, int j) {
    var temp = state[i];
    state[i] = state[j];
    state[j] = temp;
    current[i] = elements[state[i]];
    current[j] = elements[state[j]];
  }
}
