import '../../../more.dart';

/// Encapsulates a matching block when comparing two inputs.
class Match with ToStringPrinter implements Comparable<Match> {
  /// Constructs a new match.
  const Match({
    required this.sourceStart,
    required this.targetStart,
    required this.length,
  });

  /// The start of the match in the source.
  final int sourceStart;

  /// The start of the match in the target.
  final int targetStart;

  /// The length of the match.
  final int length;

  @override
  bool operator ==(Object other) =>
      other is Match &&
      sourceStart == other.sourceStart &&
      targetStart == other.targetStart &&
      length == other.length;

  @override
  int get hashCode => Object.hash(sourceStart, targetStart, length);

  @override
  int compareTo(Match other) {
    final s = sourceStart.compareTo(other.sourceStart);
    if (s != 0) return s;
    final t = targetStart.compareTo(other.targetStart);
    if (t != 0) return t;
    return length.compareTo(other.length);
  }

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter
        ..addValue(sourceStart, name: 'sourceStart')
        ..addValue(targetStart, name: 'targetStart')
        ..addValue(length, name: 'length');
}
