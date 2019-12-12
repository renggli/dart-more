library more.iterable.combinations;

extension CombinationsExtension<E> on Iterable<E> {
  /// Returns an iterable over the combinations of this [Iterable] of length
  /// [count]. The combinations are emitted in lexicographical order based on
  /// the input.
  ///
  /// If [repetitions] is set to `true` the iterable allows individual elements
  /// to be repeated more than once. The number of items returned is:
  ///
  ///     (elements.length + count - 1)! / count! / (elements.length - 1)!
  ///
  /// The following expression iterates over xx, xy, xz, yy, yz, and zz:
  ///
  ///     ['x', 'y', 'z'].combinations(2, repetitions: true);
  ///
  /// If [repetitions] is set to `false` the iterable generates all the
  /// sub-sequences of length [count]. The number of items returned is:
  ///
  ///     elements.length! / count! / (elements.length - count)!
  ///
  /// The following expression iterates over xy, xz, yz:
  ///
  ///     ['x', 'y', 'z'].combinations(2, repetitions: false);
  ///
  Iterable<List<E>> combinations(int count, {bool repetitions = false}) {
    if (count < 0) {
      throw RangeError.value(count);
    } else if (!repetitions && length < count) {
      throw RangeError.range(count, 0, length);
    } else if (count == 0 || isEmpty) {
      return const Iterable.empty();
    }
    if (repetitions) {
      return combinationsWithRepetitions<E>(toList(growable: false), count);
    } else {
      return combinationsWithoutRepetitions<E>(toList(growable: false), count);
    }
  }
}

Iterable<List<E>> combinationsWithRepetitions<E>(
    List<E> elements, int count) sync* {
  final indices = List.filled(count, 0);
  final current = List.filled(count, elements[0]);
  var hasMore = false;
  do {
    yield current.toList(growable: false);
    hasMore = false;
    for (var i = count - 1; i >= 0; i--) {
      final index = indices[i] + 1;
      if (index < elements.length) {
        for (var j = i; j < count; j++) {
          indices[j] = index;
          current[j] = elements[index];
        }
        hasMore = true;
        break;
      }
    }
  } while (hasMore);
}

Iterable<List<E>> combinationsWithoutRepetitions<E>(
    List<E> elements, int count) sync* {
  final indices = List.generate(count, (i) => i);
  final current = List.generate(count, (i) => elements[i]);
  var hasMore = false;
  do {
    yield current.toList(growable: false);
    hasMore = false;
    for (var i = count - 1; i >= 0; i--) {
      final index = indices[i];
      if (index + count - i < elements.length) {
        for (var j = i; j < count; j++) {
          indices[j] = index + j - i + 1;
          current[j] = elements[indices[j]];
        }
        hasMore = true;
        break;
      }
    }
  } while (hasMore);
}
