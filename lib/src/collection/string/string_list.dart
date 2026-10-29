import 'dart:collection' show ListBase;

import '../iterable/mixins/unmodifiable.dart';

/// Extension on [String] providing list view over characters.
extension StringListExtension on String {
  /// Returns an iterable list of UTF-16 characters of this [String].
  ///
  /// The immutable version is very light-weight and a simple iterable wrapper
  /// around [String.codeUnits]. To loop over the characters of a string simply
  /// write:
  ///
  /// ```dart
  /// for (String char in 'Hello World'.toList()) {
  ///   print(char);
  /// }
  /// ```
  ///
  /// Of course, also all other more functional operations from [List] work too:
  ///
  /// ```dart
  /// 'Hello World'.toList()
  ///   .where((char) => char != 'o')
  ///   .forEach(print);
  /// ```
  ///
  /// For a mutable copy of the string set the parameter [mutable] to `true`.
  /// This is more expensive, as the string needs to be copied to a [List].
  ///
  /// For a list of UTF-16 code units set the parameter [unicode] to `true`.
  /// This is equivalent of using [String.runes] and requires to decode and
  /// copy the string to a list, no matter if immutable or mutable.
  ///
  /// For example:
  ///
  /// ```dart
  /// final result = 'Hello World'.toList(mutable: true);
  /// result.insertAll(6, 'brave '.toList());
  /// result[6] = 'B';
  /// result.add('!');
  /// print(result);  // Hello Brave World!
  /// ```
  List<String> toList({bool mutable = false, bool unicode = false}) {
    if (mutable) {
      return unicode
          ? MutableUnicodeStringList.fromString(this)
          : MutableStringList.fromString(this);
    } else {
      return unicode
          ? ImmutableUnicodeStringList.fromString(this)
          : ImmutableStringList.fromString(this);
    }
  }
}

/// A string as a mutable list of UTF-16 code units.
class MutableStringList extends ListBase<String> {
  new fromString(String string) : this.fromCodeUnits(string.codeUnits);

  new fromCodeUnits(List<int> codeUnits) : codeUnits = codeUnits.toList();

  final List<int> codeUnits;

  @override
  int get length => codeUnits.length;

  @override
  set length(int newLength) {
    if (newLength > codeUnits.length) {
      codeUnits.addAll(List.filled(newLength - codeUnits.length, 0));
    } else {
      codeUnits.length = newLength;
    }
  }

  @override
  String operator [](int index) => String.fromCharCode(codeUnits[index]);

  @override
  void operator []=(int index, String character) {
    if (character.length == 1) {
      codeUnits[index] = character.codeUnitAt(0);
    } else {
      throw ArgumentError.value(character, 'character', 'Invalid character');
    }
  }

  @override
  void add(String element) {
    if (element.length == 1) {
      codeUnits.add(element.codeUnitAt(0));
    } else {
      throw ArgumentError.value(element, 'element', 'Invalid character');
    }
  }

  @override
  void addAll(Iterable<String> iterable) {
    for (final element in iterable) {
      add(element);
    }
  }

  @override
  void insert(int index, String element) {
    if (element.length == 1) {
      codeUnits.insert(index, element.codeUnitAt(0));
    } else {
      throw ArgumentError.value(element, 'element', 'Invalid character');
    }
  }

  @override
  void insertAll(int index, Iterable<String> iterable) {
    final units = <int>[];
    for (final element in iterable) {
      if (element.length == 1) {
        units.add(element.codeUnitAt(0));
      } else {
        throw ArgumentError.value(element, 'element', 'Invalid character');
      }
    }
    codeUnits.insertAll(index, units);
  }

  @override
  String removeAt(int index) => String.fromCharCode(codeUnits.removeAt(index));

  @override
  void removeRange(int start, int end) => codeUnits.removeRange(start, end);

  @override
  void clear() => codeUnits.clear();

  @override
  List<String> sublist(int start, [int? end]) =>
      MutableStringList.fromCodeUnits(codeUnits.sublist(start, end));

  @override
  String toString() => String.fromCharCodes(codeUnits);
}

/// A string as a mutable list of Unicode code-points.
class MutableUnicodeStringList extends ListBase<String> {
  new fromString(String string) : this.fromRunes(string.runes);

  new fromRunes(Iterable<int> runes) : runes = runes.toList();

  final List<int> runes;

  @override
  int get length => runes.length;

  @override
  set length(int newLength) {
    if (newLength > runes.length) {
      runes.addAll(List.filled(newLength - runes.length, 0));
    } else {
      runes.length = newLength;
    }
  }

  @override
  String operator [](int index) => String.fromCharCode(runes[index]);

  @override
  void operator []=(int index, String character) {
    if (character.runes.length == 1) {
      runes[index] = character.runes.first;
    } else {
      throw ArgumentError.value(character, 'character', 'Invalid character');
    }
  }

  @override
  void add(String element) {
    if (element.runes.length == 1) {
      runes.add(element.runes.first);
    } else {
      throw ArgumentError.value(element, 'element', 'Invalid character');
    }
  }

  @override
  void addAll(Iterable<String> iterable) {
    for (final element in iterable) {
      add(element);
    }
  }

  @override
  void insert(int index, String element) {
    if (element.runes.length == 1) {
      runes.insert(index, element.runes.first);
    } else {
      throw ArgumentError.value(element, 'element', 'Invalid character');
    }
  }

  @override
  void insertAll(int index, Iterable<String> iterable) {
    final list = <int>[];
    for (final element in iterable) {
      if (element.runes.length == 1) {
        list.add(element.runes.first);
      } else {
        throw ArgumentError.value(element, 'element', 'Invalid character');
      }
    }
    runes.insertAll(index, list);
  }

  @override
  String removeAt(int index) => String.fromCharCode(runes.removeAt(index));

  @override
  void removeRange(int start, int end) => runes.removeRange(start, end);

  @override
  void clear() => runes.clear();

  @override
  List<String> sublist(int start, [int? end]) =>
      MutableUnicodeStringList.fromRunes(runes.sublist(start, end));

  @override
  String toString() => String.fromCharCodes(runes);
}

/// A string as an immutable list of UTF-16 code units.
class ImmutableStringList extends ListBase<String>
    with UnmodifiableListMixin<String> {
  new fromString(this.string);

  final String string;

  @override
  int get length => string.length;

  @override
  String operator [](int index) =>
      String.fromCharCode(string.codeUnitAt(index));

  @override
  List<String> sublist(int start, [int? end]) =>
      ImmutableStringList.fromString(string.substring(start, end));

  @override
  String toString() => string;
}

/// A string as an immutable list of Unicode code-points.
class ImmutableUnicodeStringList extends ListBase<String>
    with UnmodifiableListMixin<String> {
  new fromString(String string) : this.fromRunes(string.runes);

  new fromRunes(Iterable<int> runes) : runes = runes.toList(growable: false);

  final List<int> runes;

  @override
  int get length => runes.length;

  @override
  String operator [](int index) => String.fromCharCode(runes[index]);

  @override
  List<String> sublist(int start, [int? end]) =>
      ImmutableUnicodeStringList.fromRunes(runes.sublist(start, end));

  @override
  String toString() => String.fromCharCodes(runes);
}
