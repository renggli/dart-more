import 'dart:math' show Random;

extension RandomIterableExtension<E> on Iterable<E> {
  /// Returns a random element from this [Iterable].
  ///
  /// For example
  ///
  ///    [1, 2, 3, 4, 5, 6].atRandom()
  ///
  /// returns a random dice roll each time you call it.
  ///
  E atRandom({Random? random, E Function()? orElse}) {
    if (isNotEmpty) {
      final index = (random ?? _defaultRandom).nextInt(length);
      return elementAt(index);
    }
    if (orElse == null) {
      throw StateError('Unable to get random element from empty collection.');
    }
    return orElse();
  }
}

final _defaultRandom = Random();
