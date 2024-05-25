import 'package:collection/collection.dart';

import '../../../comparator.dart';

extension PermutationIterableExtension<E> on Iterable<E> {
  /// Returns an iterable over the permutations of this [Iterable] of length
  /// [count]. If no [count] is specified all full-length permutations are
  /// generated. The permutations are emitted in lexicographical order based
  /// on the input.
  ///
  /// The following expression iterates over `xyz`, `xzy`, `yxz`, `yzx`, `zxy`,
  /// and `zyx:`
  ///
  /// ```dart
  /// ['x', 'y', 'z'].permutations();
  /// ```
  ///
  /// The following expression iterates over the permutations of length 2, these
  /// are: `xy`, `xz`, `yx`, `yz`, `zx`, and `zy`:
  ///
  /// ```dart
  /// ['x', 'y', 'z'].permutations(2);
  /// ```
  Iterable<List<E>> permutations([int? count]) {
    final elements = toList(growable: false);
    count ??= elements.length;
    if (count == 0 || elements.isEmpty) {
      return const [];
    } else if (count == elements.length) {
      return _fullPermutations(elements);
    } else if (0 < count && count < elements.length) {
      return _partialPermutations(elements, count);
    }
    throw RangeError.range(count, 0, elements.length, 'count');
  }
}

Iterable<List<E>> _fullPermutations<E>(List<E> elements) sync* {
  final indices = List.generate(elements.length, (i) => i, growable: false);
  final current =
      List.generate(elements.length, (i) => elements[i], growable: false);
  for (;;) {
    yield current.toList(growable: false);
    var k = indices.length - 2;
    while (k >= 0 && indices[k] > indices[k + 1]) {
      k--;
    }
    if (k == -1) {
      break;
    }
    var l = indices.length - 1;
    while (indices[k] > indices[l]) {
      l--;
    }
    _fullPermutationSwap(elements, indices, current, k, l);
    for (var i = k + 1, j = indices.length - 1; i < j; i++, j--) {
      _fullPermutationSwap(elements, indices, current, i, j);
    }
  }
}

void _fullPermutationSwap<E>(
    List<E> elements, List<int> indices, List<E> current, int i, int j) {
  final temp = indices[i];
  indices[i] = indices[j];
  indices[j] = temp;
  current[i] = elements[indices[i]];
  current[j] = elements[indices[j]];
}

Iterable<List<E>> _partialPermutations<E>(List<E> elements, int count) sync* {
  final indices = List.generate(elements.length, (i) => i, growable: false);
  final cycles =
      List.generate(count, (i) => elements.length - i, growable: false);
  yield indices
      .sublist(0, count)
      .map((i) => elements[i])
      .toList(growable: false);
  for (;;) {
    var generated = 0;
    for (var i = count - 1; i >= 0; i--) {
      cycles[i]--;
      if (cycles[i] == 0) {
        final temp = indices[i];
        indices.setRange(
            i, indices.length - 1, indices.getRange(i + 1, indices.length));
        indices[indices.length - 1] = temp;
        cycles[i] = elements.length - i;
      } else {
        final j = cycles[i];
        indices.swap(i, indices.length - j);
        yield indices
            .sublist(0, count)
            .map((i) => elements[i])
            .toList(growable: false);
        generated++;
        break;
      }
    }
    if (generated == 0) {
      break;
    }
  }
}

extension PermutationComparableListExtension<E> on List<E> {
  /// Permutes this [List] in-place into the next permutation with respect
  /// to the provided [comparator]. Returns `true` if such a permutation
  /// exists, otherwise leaves the list unmodified and returns `false`.
  bool nextPermutation({Comparator<E>? comparator}) {
    comparator ??= naturalCompare;
    var i = length - 2;
    while (i >= 0 && comparator(this[i], this[i + 1]) >= 0) {
      i--;
    }
    if (i < 0) {
      return false;
    }
    var j = length - 1;
    while (comparator(this[i], this[j]) >= 0) {
      j--;
    }
    swap(i, j);
    reverseRange(i + 1, length);
    return true;
  }

  /// Permutes this [List] in-place into the previous permutation with respect
  /// to the provided [comparator]. Returns `true` if such a permutation
  /// exists, otherwise leaves the list unmodified and returns `false`.
  bool previousPermutation({Comparator<E>? comparator}) =>
      nextPermutation(comparator: comparator?.reversed ?? reverseCompare);
}
