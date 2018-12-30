library more.iterable.permutations;

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
    return _permutations(elements.toList(growable: false));
  }
}

Iterable<List<E>> _permutations<E>(List<E> elements) sync* {
  final indexes = List.generate(elements.length, (i) => i);
  final current = List.generate(elements.length, (i) => elements[i]);
  for (;;) {
    yield current;
    var k = indexes.length - 2;
    while (k >= 0 && indexes[k] > indexes[k + 1]) {
      k--;
    }
    if (k == -1) {
      break;
    }
    var l = indexes.length - 1;
    while (indexes[k] > indexes[l]) {
      l--;
    }
    _swap(elements, indexes, current, k, l);
    for (var i = k + 1, j = indexes.length - 1; i < j; i++, j--) {
      _swap(elements, indexes, current, i, j);
    }
  }
}

void _swap<E>(
    List<E> elements, List<int> indexes, List<E> current, int i, int j) {
  final temp = indexes[i];
  indexes[i] = indexes[j];
  indexes[j] = temp;
  current[i] = elements[indexes[i]];
  current[j] = elements[indexes[j]];
}
