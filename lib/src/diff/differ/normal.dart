import '../differ.dart';
import '../model/operation_type.dart';
import '../sequence_matcher.dart';

/// Generates the [normal output](https://en.wikipedia.org/wiki/Diff#Usage)
/// format of `diff`.
///
/// In this format, `a` stands for added, `d` for deleted and `c` for changed.
/// Line numbers of the original file appear before a/d/c and those of the new
/// file appear after. The less-than and greater-than signs (at the beginning
/// of lines that are added, deleted or changed) indicate which file the lines
/// appear in. Addition lines are added to the original file to appear in the
/// new file. Deletion lines are deleted from the original file to be missing
/// in the new file.
///
/// By default, lines common to both files are not shown. Lines that have moved
/// are shown as added at their new location and as deleted from their old
/// location.
class NormalDiffer extends Differ {
  NormalDiffer();

  @override
  Iterable<String> compareLines(
      Iterable<String> source, Iterable<String> target,
      {String? sourceLabel, String? targetLabel}) sync* {
    final matcher = SequenceMatcher(source: source, target: target);
    for (final operation in matcher.operations) {
      final sourceRange = _range(operation.sourceStart, operation.sourceEnd);
      final targetRange = _range(operation.targetStart, operation.targetEnd);
      switch (operation.type) {
        case OperationType.replace:
          yield '${sourceRange}c$targetRange';
          yield* _dump('<', source, operation.sourceStart, operation.sourceEnd);
          yield '---';
          yield* _dump('>', target, operation.targetStart, operation.targetEnd);
        case OperationType.delete:
          yield '${sourceRange}d$targetRange';
          yield* _dump('<', source, operation.sourceStart, operation.sourceEnd);
        case OperationType.insert:
          yield '${sourceRange}a$targetRange';
          yield* _dump('>', target, operation.targetStart, operation.targetEnd);
        case OperationType.equal:
          break;
      }
    }
  }
}

Iterable<String> _dump(
    String tag, Iterable<String> iterable, int start, int end) sync* {
  for (var i = start; i < end; i++) {
    yield '$tag ${iterable.elementAt(i)}';
  }
}

String _range(int start, int stop) {
  var beginning = start + 1;
  final length = stop - start;
  if (length == 0) beginning--;
  if (length <= 1) return '$beginning';
  return '$beginning,${beginning + length - 1}';
}
