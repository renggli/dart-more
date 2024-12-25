import 'package:characters/characters.dart';

extension ConvertFirstLastStringExtension on String {
  /// Converts the first [count] characters of this string with [callback]. If
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

  /// Converts the last [count] characters of this string with [callback]. If
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
