import 'package:meta/meta.dart';

import 'char_matcher.dart';

/// Represents a match of a [CharMatcher] on a character sequence.
@immutable
class CharMatch implements Match {
  const new(this.start, this.end, this.input, this.pattern);

  @override
  final int start;

  @override
  final int end;

  @override
  final String input;

  @override
  final CharMatcher pattern;

  @override
  String? group(int group) {
    RangeError.checkValueInInterval(group, 0, 0, 'group');
    return input.substring(start, end);
  }

  @override
  String? operator [](int group) => this.group(group);

  @override
  List<String?> groups(List<int> groupIndices) =>
      groupIndices.map(group).toList(growable: false);

  @override
  int get groupCount => 0;
}
