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
  /// For a list of Unicode code points set the parameter [unicode] to `true`.
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

  new fromCodeUnits(List<int> codeUnits) : _codeUnits = codeUnits.toList();

  final List<int> _codeUnits;

  @override
  int get length => _codeUnits.length;

  @override
  set length(int newLength) {
    if (newLength > _codeUnits.length) {
      _codeUnits.addAll(List.filled(newLength - _codeUnits.length, 0));
    } else {
      _codeUnits.length = newLength;
    }
  }

  @override
  String operator [](int index) => String.fromCharCode(_codeUnits[index]);

  @override
  void operator []=(int index, String character) {
    if (character.length == 1) {
      _codeUnits[index] = character.codeUnitAt(0);
    } else {
      throw ArgumentError.value(character, 'character', 'Invalid character');
    }
  }

  @override
  void add(String element) {
    if (element.length == 1) {
      _codeUnits.add(element.codeUnitAt(0));
    } else {
      throw ArgumentError.value(element, 'element', 'Invalid character');
    }
  }

  @override
  void addAll(Iterable<String> iterable) {
    final units = <int>[];
    for (final element in iterable) {
      if (element.length == 1) {
        units.add(element.codeUnitAt(0));
      } else {
        throw ArgumentError.value(element, 'element', 'Invalid character');
      }
    }
    _codeUnits.addAll(units);
  }

  @override
  void insert(int index, String element) {
    if (element.length == 1) {
      _codeUnits.insert(index, element.codeUnitAt(0));
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
    _codeUnits.insertAll(index, units);
  }

  @override
  String removeAt(int index) => String.fromCharCode(_codeUnits.removeAt(index));

  @override
  void removeRange(int start, int end) => _codeUnits.removeRange(start, end);

  @override
  void clear() => _codeUnits.clear();

  @override
  List<String> sublist(int start, [int? end]) =>
      MutableStringList.fromCodeUnits(_codeUnits.sublist(start, end));

  @override
  String toString() => String.fromCharCodes(_codeUnits);
}

/// A string as a mutable list of Unicode code-points.
class MutableUnicodeStringList extends ListBase<String> {
  new fromString(String string) : this.fromRunes(string.runes);

  new fromRunes(Iterable<int> runes) : _runes = runes.toList();

  final List<int> _runes;

  @override
  int get length => _runes.length;

  @override
  set length(int newLength) {
    if (newLength > _runes.length) {
      _runes.addAll(List.filled(newLength - _runes.length, 0));
    } else {
      _runes.length = newLength;
    }
  }

  @override
  String operator [](int index) => String.fromCharCode(_runes[index]);

  @override
  void operator []=(int index, String character) =>
      _runes[index] = _singleRune(character, 'character');

  @override
  void add(String element) => _runes.add(_singleRune(element, 'element'));

  @override
  void addAll(Iterable<String> iterable) {
    final list = <int>[];
    for (final element in iterable) {
      list.add(_singleRune(element, 'element'));
    }
    _runes.addAll(list);
  }

  @override
  void insert(int index, String element) =>
      _runes.insert(index, _singleRune(element, 'element'));

  @override
  void insertAll(int index, Iterable<String> iterable) {
    final list = <int>[];
    for (final element in iterable) {
      list.add(_singleRune(element, 'element'));
    }
    _runes.insertAll(index, list);
  }

  @override
  String removeAt(int index) => String.fromCharCode(_runes.removeAt(index));

  @override
  void removeRange(int start, int end) => _runes.removeRange(start, end);

  @override
  void clear() => _runes.clear();

  @override
  List<String> sublist(int start, [int? end]) =>
      MutableUnicodeStringList.fromRunes(_runes.sublist(start, end));

  @override
  String toString() => String.fromCharCodes(_runes);
}

int _singleRune(String element, String name) {
  final iterator = element.runes.iterator;
  if (iterator.moveNext()) {
    final rune = iterator.current;
    if (!iterator.moveNext()) {
      return rune;
    }
  }
  throw ArgumentError.value(element, name, 'Invalid character');
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

  new fromRunes(Iterable<int> runes) : _runes = runes.toList(growable: false);

  final List<int> _runes;

  @override
  int get length => _runes.length;

  @override
  String operator [](int index) => String.fromCharCode(_runes[index]);

  @override
  List<String> sublist(int start, [int? end]) =>
      ImmutableUnicodeStringList.fromRunes(_runes.sublist(start, end));

  @override
  String toString() => String.fromCharCodes(_runes);
}
