library more.iterable.combinations;

import 'dart:collection';

/// Returns an iterable over the combinations of [elements] of length [count]. The
/// combinations are emitted in lexicographical order based on the input.
///
/// If [repetitions] is set to `true` the iterable allows individual elements to be
/// repeated more than once. The number of items returned is:
///
///     (elements.length + count - 1)! / count! / (elements.length - 1)!
///
/// The following expression iterates over xx, xy, xz, yy, yz, and zz:
///
///     combinations(string('xyz'), 2, repetitions: true);
///
/// If [repetitions] is set to `false` the iterable generates all the sub-sequences
/// of length [count]. The number of items returned is:
///
///     elements.length! / count! / (elements.length - count)!
///
/// The following expression iterates over xy, xz, yz:
///
///     combinations(string('xyz'), 2, repetitions: false);
///
Iterable<List<E>> combinations<E>(Iterable<E> elements, int count, {bool repetitions: false}) {
  elements = elements.toList(growable: false);
  if (count < 0) {
    throw new RangeError.value(count);
  } else if (!repetitions && elements.length < count) {
    throw new RangeError.range(count, 0, elements.length);
  } else if (count == 0 || elements.isEmpty) {
    return new Iterable<List<E>>.empty();
  } else if (repetitions) {
    return new CombinationsWithRepetitionsIterable<E>(elements.toList(growable: false), count);
  } else {
    return new CombinationsWithoutRepetitionsIterable<E>(elements.toList(growable: false), count);
  }
}

class CombinationsWithRepetitionsIterable<E> extends IterableBase<List<E>> {
  final List<E> elements;
  final int count;

  CombinationsWithRepetitionsIterable(this.elements, this.count);

  @override
  Iterator<List<E>> get iterator {
    return new CombinationsWithRepetitionsIterator<E>(elements, count);
  }
}

class CombinationsWithRepetitionsIterator<E> extends Iterator<List<E>> {
  final List<E> elements;
  final int count;

  List<int> state;
  bool completed = false;

  CombinationsWithRepetitionsIterator(this.elements, this.count);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      return false;
    } else if (current == null) {
      state = new List<int>.filled(count, 0);
      current = new List<E>.filled(count, elements[0]);
      return true;
    } else {
      for (var i = count - 1; i >= 0; i--) {
        var index = state[i] + 1;
        if (index < elements.length) {
          for (var j = i; j < count; j++) {
            state[j] = index;
            current[j] = elements[index];
          }
          return true;
        }
      }
      state = null;
      current = null;
      completed = true;
      return false;
    }
  }
}

class CombinationsWithoutRepetitionsIterable<E> extends IterableBase<List<E>> {
  final List<E> elements;
  final int count;

  CombinationsWithoutRepetitionsIterable(this.elements, this.count);

  @override
  Iterator<List<E>> get iterator {
    return new CombinationsWithoutRepetitionsIterator<E>(elements, count);
  }
}

class CombinationsWithoutRepetitionsIterator<E> extends Iterator<List<E>> {
  final List<E> elements;
  final int count;

  List<int> state;
  bool completed = false;

  CombinationsWithoutRepetitionsIterator(this.elements, this.count);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      return false;
    } else if (current == null) {
      state = new List<int>(count);
      current = new List<E>(count);
      for (var i = 0; i < count; i++) {
        state[i] = i;
        current[i] = elements[i];
      }
      return true;
    } else {
      for (var i = count - 1; i >= 0; i--) {
        var index = state[i];
        if (index + count - i < elements.length) {
          for (var j = i; j < count; j++) {
            state[j] = index + j - i + 1;
            current[j] = elements[state[j]];
          }
          return true;
        }
      }
      state = null;
      current = null;
      completed = true;
      return false;
    }
  }
}
