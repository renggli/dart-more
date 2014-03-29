part of iterable;

/**
 * Returns a light-weight immutable iterable list around the characters of
 * a [string].
 *
 * To loop over the characters of a string simply write:
 *
 *     for (String char in string('Hello World')) {
 *       print(char);
 *     }
 *
 * Of course, also all other more functional operations from [List] work too:
 *
 *     string('Hello World')
 *       .where((char) => char != 'o')
 *       .forEach(print);
 *
 * For a mutable copy of the string see [mutableString(Object)].
 */
List<String> string(string) {
  return new _String(string.toString());
}

class _String extends ListBase<String> with UnmodifiableListMixin<String> {

  final String _string;

  _String(this._string);

  @override
  int get length => _string.length;

  @override
  String operator [](int index) => new String.fromCharCode(_string.codeUnitAt(index));

  @override
  String toString() => _string;

}

/**
 * Returns a mutable copy of the characters of a [string].
 *
 * For a light-weight immutable iterable list of the characters of the
 * string see [string(Object)].
 */
List<String> mutableString(string, {bool growable: true}) {
  return new _MutableString(new List.from(string.toString().codeUnits, growable: growable));
}

class _MutableString extends ListBase<String> {

  final List<int> _codeUnits;

  _MutableString(this._codeUnits);

  @override
  int get length => _codeUnits.length;

  @override
  void set length(int newLength) {
    _codeUnits.length = newLength;
  }

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
  String toString() => new String.fromCharCodes(_codeUnits);

}