import 'dart:math';

import 'package:characters/characters.dart';

import '../../shared/exceptions.dart';

/// Extension on [String] to divide strings into chunks.
extension ChunkedStringExtension on String {
  /// Divides this [String] into an iterable of strings each not exceeding the
  /// given [size]. The last string might have fewer characters.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = 'abcde';
  /// print(input.chunked(2));  // ('ab', 'cd', 'e')
  /// ```
  Iterable<String> chunked(int size) sync* {
    checkNonZeroPositive(size);
    for (var i = 0; i < length; i += size) {
      yield substring(i, min(i + size, length));
    }
  }
}

/// Extension on [Characters] to divide characters into chunks.
extension ChunkedCharactersExtension on Characters {
  /// Divides these [Characters] into an iterable of characters each not
  /// exceeding the given [size]. The last string might have fewer characters.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = 'abcde';
  /// print(input.chunked(2));  // ('ab', 'cd', 'e')
  /// ```
  Iterable<Characters> chunked(int size) sync* {
    checkNonZeroPositive(size);
    final range = iterator;
    while (range.moveNext(size)) {
      yield range.currentCharacters;
    }
    if (range.isNotEmpty) {
      yield range.currentCharacters;
    }
  }
}
