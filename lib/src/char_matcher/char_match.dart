import 'package:meta/meta.dart';

import 'char_matcher.dart';

@immutable
class CharMatch extends Match {
  CharMatch(this.start, this.input, this.pattern);

  @override
  final int start;

  @override
  int get end => start + 1;

  @override
  final String input;

  @override
  final CharMatcher pattern;

  @override
  String? group(int group) => this[group];

  @override
  String? operator [](int group) => group == 0 ? input[start] : null;

  @override
  List<String?> groups(List<int> groupIndices) =>
      groupIndices.map(group).toList(growable: false);

  @override
  int get groupCount => 0;
}
