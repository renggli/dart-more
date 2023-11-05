import 'package:meta/meta.dart';

import 'char_matcher.dart';

@immutable
class CharMatch implements Match {
  const CharMatch(this.start, this.end, this.input, this.pattern);

  @override
  final int start;

  @override
  final int end;

  @override
  final String input;

  @override
  final CharMatcher pattern;

  @override
  String? group(int group) => group == 0 ? input.substring(start, end) : null;

  @override
  String? operator [](int group) => this.group(group);

  @override
  List<String?> groups(List<int> groupIndices) =>
      groupIndices.map(group).toList(growable: false);

  @override
  int get groupCount => 0;
}
