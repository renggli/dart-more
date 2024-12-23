import '../../collection.dart';
import '../../comparator.dart';
import 'sequence_matcher.dart';

extension CloseMatchesOnIterable<T> on Iterable<Iterable<T>> {
  /// Returns a list of the best "good enough" matches.
  ///
  /// [count] specifies the number of matches to return. [cutoff] specifies the
  /// required similarity of candidates.
  Iterable<Iterable<T>> closeMatches(Iterable<T> target,
      {int count = 3, double cutoff = 0.6}) {
    if (count <= 0) throw ArgumentError.value(count, 'count');
    if (cutoff < 0 || cutoff > 1) throw ArgumentError.value(cutoff, 'cutoff');
    final matcher = SequenceMatcher<T>(target: target);
    final candidates = <({Iterable<T> candidate, double ratio})>[];
    for (final candidate in this) {
      matcher.source = candidate;
      if (matcher.realQuickRatio >= cutoff && matcher.quickRatio >= cutoff) {
        final ratio = matcher.ratio;
        if (ratio >= cutoff) {
          candidates.add((candidate: candidate, ratio: ratio));
        }
      }
    }
    return candidates
        .largest(count,
            comparator: delegateComparator<
                ({Iterable<T> candidate, double ratio}),
                num>((each) => each.ratio))
        .map((each) => each.candidate);
  }
}

extension CloseMatchesOnStringIterable on Iterable<String> {
  /// Returns a list of the best "good enough" matches of a list of strings.
  ///
  /// [count] specifies the number of matches to return. [cutoff] specifies the
  /// required similarity of candidates.
  Iterable<String> closeMatches(String target,
          {int count = 3, double cutoff = 0.6}) =>
      map((each) => each.runes)
          .closeMatches(target.runes, count: count, cutoff: cutoff)
          .map(String.fromCharCodes);
}
