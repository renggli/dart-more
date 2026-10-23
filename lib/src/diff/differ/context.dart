import '../differ.dart';
import '../model/operation_type.dart';
import '../sequence_matcher.dart';

/// Generates the [context format](https://en.wikipedia.org/wiki/Diff#Context_format)
/// of `diff -c`.
///
/// The context format introduced at Berkeley helped with distributing patches
/// for source code that have been changed minimally.
///
/// In the context format, any changed lines are shown alongside unchanged
/// lines before and after. The context format introduces greater readability
/// for humans and reliability when applying the patch, and an output which is
/// accepted as input to the patch program.
class ContextDiffer extends Differ {
  /// Creates a context differ with [context] lines of unchanged text.
  const new({this.context = 3});

  /// The number of unchanged lines shown above and below a change.
  final int context;

  @override
  Iterable<String> compareLines(
    Iterable<String> source,
    Iterable<String> target, {
    String? sourceLabel,
    String? targetLabel,
  }) sync* {
    if (sourceLabel != null) yield '*** $sourceLabel';
    if (targetLabel != null) yield '--- $targetLabel';
    final sourceList = source is List<String>
        ? source
        : source.toList(growable: false);
    final targetList = target is List<String>
        ? target
        : target.toList(growable: false);
    final matcher = SequenceMatcher(source: sourceList, target: targetList);
    for (final group in matcher.groupedOperations(context: context)) {
      yield '***************';
      final sourceRange = _range(group.first.sourceStart, group.last.sourceEnd);
      yield '*** $sourceRange ****';
      if (group.any(
        (operation) =>
            operation.type == OperationType.replace ||
            operation.type == OperationType.delete,
      )) {
        for (final operation in group) {
          for (var s = operation.sourceStart; s < operation.sourceEnd; s++) {
            switch (operation.type) {
              case OperationType.replace:
                yield '! ${sourceList[s]}';
              case OperationType.delete:
                yield '- ${sourceList[s]}';
              case OperationType.insert:
                break;
              case OperationType.equal:
                yield '  ${sourceList[s]}';
            }
          }
        }
      }
      final targetRange = _range(group.first.targetStart, group.last.targetEnd);
      yield '--- $targetRange ----';
      if (group.any(
        (operation) =>
            operation.type == OperationType.replace ||
            operation.type == OperationType.insert,
      )) {
        for (final operation in group) {
          for (var t = operation.targetStart; t < operation.targetEnd; t++) {
            switch (operation.type) {
              case OperationType.replace:
                yield '! ${targetList[t]}';
              case OperationType.delete:
                break;
              case OperationType.insert:
                yield '+ ${targetList[t]}';
              case OperationType.equal:
                yield '  ${targetList[t]}';
            }
          }
        }
      }
    }
  }

  String _range(int start, int stop) {
    var beginning = start + 1;
    final length = stop - start;
    if (length == 0) beginning--;
    if (length <= 1) return '$beginning';
    return '$beginning,${beginning + length - 1}';
  }
}
