import 'dart:collection' show ListBase;

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
