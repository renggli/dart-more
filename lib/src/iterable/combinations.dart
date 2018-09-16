library more.iterable.combinations;

/// Returns an iterable over the combinations of [elements] of length [count].
/// The combinations are emitted in lexicographical order based on the input.
///
/// If [repetitions] is set to `true` the iterable allows individual elements to
/// be repeated more than once. The number of items returned is:
///
///     (elements.length + count - 1)! / count! / (elements.length - 1)!
///
/// The following expression iterates over xx, xy, xz, yy, yz, and zz:
///
///     combinations(string('xyz'), 2, repetitions: true);
///
/// If [repetitions] is set to `false` the iterable generates all the
/// sub-sequences of length [count]. The number of items returned is:
///
///     elements.length! / count! / (elements.length - count)!
///
/// The following expression iterates over xy, xz, yz:
///
///     combinations(string('xyz'), 2, repetitions: false);
///
Iterable<List<E>> combinations<E>(Iterable<E> elements, int count,
    {bool repetitions = false}) {
  if (count < 0) {
    throw RangeError.value(count);
  } else if (!repetitions && elements.length < count) {
    throw RangeError.range(count, 0, elements.length);
  } else if (count == 0 || elements.isEmpty) {
    return Iterable.empty();
  }
  if (repetitions) {
    return _combinationsWithRepetitions<E>(
        elements.toList(growable: false), count);
  } else {
    return _combinationsWithoutRepetitions<E>(
        elements.toList(growable: false), count);
  }
}

Iterable<List<E>> _combinationsWithRepetitions<E>(
    List<E> elements, int count) sync* {
  final indices = List.filled(count, 0);
  final current = List.filled(count, elements[0]);
  var hasMore = false;
  do {
    yield current;
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

Iterable<List<E>> _combinationsWithoutRepetitions<E>(
    List<E> elements, int count) sync* {
  final indices = List.generate(count, (i) => i);
  final current = List.generate(count, (i) => elements[i]);
  var hasMore = false;
  do {
    yield current;
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
