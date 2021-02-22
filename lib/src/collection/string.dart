import 'package:characters/characters.dart';

import 'string/immutable_list.dart';
import 'string/mutable_list.dart';

extension StringExtension on String {
  /// Returns a iterable list of the UTF-16 characters of this [String].
  ///
  /// The immutable version is very light-weight. To loop over the characters
  /// of a string simply write:
  ///
  ///     for (String char in 'Hello World'.toList()) {
  ///       print(char);
  ///     }
  ///
  /// Of course, also all other more functional operations from [List] work too:
  ///
  ///     'Hello World'.toList()
  ///       .where((char) => char != 'o')
  ///       .forEach(print);
  ///
  /// For a mutable copy of the string set the parameter [mutable] to `true`.
  ///
  /// For example the following code prints 'Hello Brave World!':
  ///
  ///       var result = 'Hello World'.toList(mutable: true);
  ///       result.insertAll(6, 'brave '.toList());
  ///       result[6] = 'B';
  ///       result.add('!');
  ///       print(result);
  ///
  List<String> toList({bool mutable = false}) => mutable
      ? MutableStringList(List.of(codeUnits))
      : ImmutableStringList(this);

  /// If the string starts with the prefix pattern returns this [String]
  /// with the prefix removed, otherwise return `this`.
  String removePrefix(Pattern pattern) {
    if (pattern is String && startsWith(pattern)) {
      return substring(pattern.length);
    }
    final match = pattern.matchAsPrefix(this);
    if (match != null && match.end > 0) {
      return substring(match.end);
    }
    return this;
  }

  /// If the string ends with the suffix, return this [String] with the suffix
  /// removed, otherwise return `this`.
  String removeSuffix(String other) {
    if (endsWith(other)) {
      return substring(0, length - other.length);
    }
    return this;
  }

  /// Converts the first [count] characters of this string with `callback`. If
  /// this is shorter than [count], this [String] is returned.
  String convertFirstCharacters(String Function(String) callback,
      {int count = 1}) {
    final iterator = characters.iterator;
    if (iterator.moveNext(count)) {
      return callback(iterator.stringBefore + iterator.current) +
          iterator.stringAfter;
    }
    return this;
  }

  /// Converts the last [count] characters of this string with `callback`. If
  /// this is shorter than [count], this [String] is returned.
  String convertLastCharacters(String Function(String value) callback,
      {int count = 1}) {
    final iterator = characters.iteratorAtEnd;
    if (iterator.moveBack(count)) {
      return iterator.stringBefore +
          callback(iterator.current + iterator.stringAfter);
    }
    return this;
  }

  /// Converts the first character of this string to upper-case.
  ///
  /// For example `'hello'.toUpperCaseFirstCharacter()` returns `'Hello'`.
  String toUpperCaseFirstCharacter() =>
      convertFirstCharacters((value) => value.toUpperCase());

  /// Converts the first character of the string to lower-case.
  ///
  /// For example `'Haha'.toLowerCaseFirstCharacter()` returns `'haha'`.
  String toLowerCaseFirstCharacter() =>
      convertFirstCharacters((value) => value.toLowerCase());
}
