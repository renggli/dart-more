library more.collection.string;

import 'dart:collection' show ListBase;

import 'package:more/src/iterable/mixins/unmodifiable.dart'
    show UnmodifiableListMixin;

/// Returns a light-weight immutable iterable list around the characters of a
/// [string].
///
/// To loop over the characters of a string simply write:
///
///     for (String char in string('Hello World')) {
///       print(char);
///     }
///
/// Of course, also all other more functional operations from [List] work too:
///
///     string('Hello World')
///       .where((char) => char != 'o')
///       .forEach(print);
///
/// For a mutable copy of the string see [mutableString(Object)].
List<String> string(Object string) => new StringList(string.toString());

/// A string as an immutable list.
class StringList extends ListBase<String> with UnmodifiableListMixin<String> {
  final String contents;

  StringList(this.contents);

  @override
  int get length => contents.length;

  @override
  String operator [](int index) =>
      new String.fromCharCode(contents.codeUnitAt(index));

  @override
  List<String> sublist(int start, [int end]) =>
      new StringList(contents.substring(start, end));

  @override
  String toString() => contents;
}

/// Returns a mutable copy of the characters of a [string].
///
/// For example the following code prints 'Hello Brave World!':
///
///       var result = mutableString('Hello World');
///       result.insertAll(6, string('brave '));
///       result[6] = 'B';
///       result.add('!');
///       print(result);
///
/// For a light-weight immutable list of characters see [string(Object)].
List<String> mutableString(Object string, {bool growable: true}) {
  return new MutableStringList(
      new List.from(string.toString().codeUnits, growable: growable));
}

/// A string as a mutable list.
class MutableStringList extends ListBase<String> {
  final List<int> _codeUnits;

  MutableStringList(this._codeUnits);

  @override
  int get length => _codeUnits.length;

  @override
  set length(int newLength) => _codeUnits.length = newLength;

  @override
  String operator [](int index) => new String.fromCharCode(_codeUnits[index]);

  @override
  void operator []=(int index, String character) {
    if (character.length == 1) {
      _codeUnits[index] = character.codeUnitAt(0);
    } else {
      throw new ArgumentError('Invalid character: $character');
    }
  }

  @override
  List<String> sublist(int start, [int end]) =>
      new MutableStringList(_codeUnits.sublist(start, end));

  @override
  String toString() => new String.fromCharCodes(_codeUnits);
}
