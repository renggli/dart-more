import 'dart:collection' show ListBase;

import '../../iterable/mixins/unmodifiable.dart' show UnmodifiableListMixin;

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
