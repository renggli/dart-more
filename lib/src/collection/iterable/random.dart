import 'dart:math' show Random;

/// Extension on [Iterable] to select a random element.
extension RandomIterableExtension<E> on Iterable<E> {
  /// Returns a random element from this [Iterable].
  ///
  /// For example, the following expression returns a random dice roll each
  /// time you call it:
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5, 6].atRandom()
  /// ```
  E atRandom({Random? random, E Function()? orElse}) {
    final rng = random ?? _defaultRandom;
    if (this is List<E>) {
      final list = this as List<E>;
      if (list.isNotEmpty) {
        return list[rng.nextInt(list.length)];
      }
    } else {
      final iterator = this.iterator;
      if (iterator.moveNext()) {
        var result = iterator.current;
        var count = 1;
        while (iterator.moveNext()) {
          count++;
          if (rng.nextInt(count) == 0) {
            result = iterator.current;
          }
        }
        return result;
      }
    }
    if (orElse == null) {
      throw StateError('Unable to get random element from empty collection.');
    }
    return orElse();
  }
}

final _defaultRandom = Random();
