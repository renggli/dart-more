import '../collection/iterable/operators.dart';
import '../comparator/constructors/key_of.dart';
import 'sequence_matcher.dart';

/// Extension on nested iterables to find close matches.
extension CloseMatchesOnIterable<T> on Iterable<Iterable<T>> {
  /// Returns a list of the best "good enough" matches.
  ///
  /// [count] specifies the number of matches to return. [cutoff] specifies the
  /// required similarity of candidates.
  Iterable<Iterable<T>> closeMatches(
    Iterable<T> target, {
    int count = 3,
    double cutoff = 0.6,
  }) => _closeMatches(
    this,
    target,
    (candidate) => candidate,
    count: count,
    cutoff: cutoff,
  );
}

/// Extension on string iterables to find close matches.
extension CloseMatchesOnStringIterable on Iterable<String> {
  /// Returns a list of the best "good enough" matches of a list of strings.
  ///
  /// [count] specifies the number of matches to return. [cutoff] specifies the
  /// required similarity of candidates.
  Iterable<String> closeMatches(
    String target, {
    int count = 3,
    double cutoff = 0.6,
  }) => _closeMatches(
    this,
    target.runes,
    (candidate) => candidate.runes,
    count: count,
    cutoff: cutoff,
  );
}

Iterable<E> _closeMatches<E, T>(
  Iterable<E> items,
  Iterable<T> target,
  Iterable<T> Function(E item) toSequence, {
  required int count,
  required double cutoff,
}) {
  if (count <= 0) throw ArgumentError.value(count, 'count');
  if (!(cutoff >= 0 && cutoff <= 1)) {
    throw ArgumentError.value(cutoff, 'cutoff');
  }
  final matcher = SequenceMatcher<T>(target: target);
  final candidates = <({E candidate, double ratio})>[];
  for (final candidate in items) {
    matcher.source = toSequence(candidate);
    if (matcher.realQuickRatio >= cutoff && matcher.quickRatio >= cutoff) {
      final ratio = matcher.ratio;
      if (ratio >= cutoff) {
        candidates.add((candidate: candidate, ratio: ratio));
      }
    }
  }
  return candidates
      .largest(
        count,
        comparator: keyOf<({E candidate, double ratio}), num>(
          (each) => each.ratio,
        ),
      )
      .map((each) => each.candidate);
}
