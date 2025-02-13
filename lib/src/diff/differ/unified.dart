import '../differ.dart';
import '../model/operation_type.dart';
import '../sequence_matcher.dart';

/// Generates the [unified format](https://en.wikipedia.org/wiki/Diff#Unified_format)
/// of `diff -u`.
///
/// The unified format inherits the technical improvements made by the context
/// format, but produces a smaller diff with old and new text presented
/// immediately adjacent.
class UnifiedDiffer extends Differ {
  UnifiedDiffer({this.context = 3});

  /// The number of unchanged lines shown above and blow a change.
  final int context;

  @override
  Iterable<String> compareLines(
    Iterable<String> source,
    Iterable<String> target, {
    String? sourceLabel,
    String? targetLabel,
  }) sync* {
    if (sourceLabel != null) yield '--- $sourceLabel';
    if (targetLabel != null) yield '+++ $targetLabel';
    final matcher = SequenceMatcher(source: source, target: target);
    for (final group in matcher.groupedOperations(context: context)) {
      final sourceRange = _range(group.first.sourceStart, group.last.sourceEnd);
      final targetRange = _range(group.first.targetStart, group.last.targetEnd);
      yield '@@ -$sourceRange +$targetRange @@';
      for (final operation in group) {
        if (operation.type == OperationType.equal) {
          yield* _dump(' ', source, operation.sourceStart, operation.sourceEnd);
        }
        if (operation.type == OperationType.replace ||
            operation.type == OperationType.delete) {
          yield* _dump('-', source, operation.sourceStart, operation.sourceEnd);
        }
        if (operation.type == OperationType.replace ||
            operation.type == OperationType.insert) {
          yield* _dump('+', target, operation.targetStart, operation.targetEnd);
        }
      }
    }
  }
}

Iterable<String> _dump(
  String tag,
  Iterable<String> iterable,
  int start,
  int end,
) sync* {
  for (var i = start; i < end; i++) {
    yield '$tag${iterable.elementAt(i)}';
  }
}

String _range(int start, int stop) {
  var beginning = start + 1;
  final length = stop - start;
  if (length == 1) return '$beginning';
  if (length == 0) beginning--;
  return '$beginning,$length';
}
