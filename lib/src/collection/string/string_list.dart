import 'dart:collection' show ListBase;

import '../../iterable/mixins/unmodifiable.dart' show UnmodifiableListMixin;

extension StringListExtension on String {
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
}

/// A string as a mutable list.
class MutableStringList extends ListBase<String> {
  final List<int> codeUnits;

  MutableStringList(this.codeUnits);

  @override
  int get length => codeUnits.length;

  @override
  set length(int newLength) => codeUnits.length = newLength;

  @override
  String operator [](int index) => String.fromCharCode(codeUnits[index]);

  @override
  void operator []=(int index, String character) {
    if (character.length == 1) {
      codeUnits[index] = character.codeUnitAt(0);
    } else {
      throw ArgumentError('Invalid character: $character');
    }
  }

  @override
  void add(String element) => codeUnits.addAll(element.codeUnits);

  @override
  List<String> sublist(int start, [int? end]) =>
      MutableStringList(codeUnits.sublist(start, end));

  @override
  String toString() => String.fromCharCodes(codeUnits);
}

/// A string as an immutable list.
class ImmutableStringList extends ListBase<String>
    with UnmodifiableListMixin<String> {
  final String contents;

  ImmutableStringList(this.contents);

  @override
  int get length => contents.length;

  @override
  String operator [](int index) =>
      String.fromCharCode(contents.codeUnitAt(index));

  @override
  List<String> sublist(int start, [int? end]) =>
      ImmutableStringList(contents.substring(start, end));

  @override
  String toString() => contents;
}
