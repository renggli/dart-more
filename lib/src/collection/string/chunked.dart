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
  Iterable<String> chunked(int size) {
    checkNonZeroPositive(size, 'size');
    return _chunkedString(this, size);
  }
}

Iterable<String> _chunkedString(String source, int size) sync* {
  for (var i = 0; i < source.length; i += size) {
    yield source.substring(i, min(i + size, source.length));
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
  /// final input = 'abcde'.characters;
  /// print(input.chunked(2));  // ('ab', 'cd', 'e')
  /// ```
  Iterable<Characters> chunked(int size) {
    checkNonZeroPositive(size, 'size');
    return _chunkedCharacters(this, size);
  }
}

Iterable<Characters> _chunkedCharacters(Characters source, int size) sync* {
  final range = source.iterator;
  while (range.moveNext(size)) {
    yield range.currentCharacters;
  }
  if (range.isNotEmpty) {
    yield range.currentCharacters;
  }
}
