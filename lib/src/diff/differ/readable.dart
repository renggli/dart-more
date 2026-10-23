import '../../../collection.dart';
import '../../../functional.dart';
import '../../../printer.dart';
import '../differ.dart';
import '../model/operation_type.dart';
import '../sequence_matcher.dart';

/// Generates a highly configurable diff output.
class ReadableDiffer extends Differ {
  /// Creates a readable differ with optional custom line/character filters and
  /// printers.
  new({
    this.lineJunk,
    this.charJunk,
    Printer<String>? replaceLine,
    Printer<String>? deleteLine,
    Printer<String>? insertLine,
    Printer<String>? equalLine,
  }) : replaceLine = replaceLine ?? _stringPrinter.before('? '),
       deleteLine = deleteLine ?? _stringPrinter.before('- '),
       insertLine = insertLine ?? _stringPrinter.before('+ '),
       equalLine = equalLine ?? _stringPrinter.before('  ');

  /// Predicate identifying junk lines.
  final Predicate1<String>? lineJunk;

  /// Predicate identifying junk character codes.
  final Predicate1<int>? charJunk;

  /// Printer for replaced lines.
  final Printer<String> replaceLine;

  /// Printer for deleted lines.
  final Printer<String> deleteLine;

  /// Printer for inserted lines.
  final Printer<String> insertLine;

  /// Printer for equal lines.
  final Printer<String> equalLine;

  @override
  Iterable<String> compareLines(
    Iterable<String> source,
    Iterable<String> target, {
    String? sourceLabel,
    String? targetLabel,
  }) sync* {
    final sourceList = source is List<String>
        ? source
        : source.toList(growable: false);
    final targetList = target is List<String>
        ? target
        : target.toList(growable: false);
    final lineMatcher = SequenceMatcher(
      source: sourceList,
      target: targetList,
      isJunk: lineJunk,
    );
    for (final operation in lineMatcher.operations) {
      switch (operation.type) {
        case OperationType.replace:
          yield* _replace(
            sourceList,
            operation.sourceStart,
            operation.sourceEnd,
            targetList,
            operation.targetStart,
            operation.targetEnd,
          );
        case OperationType.delete:
          yield* _dump(
            deleteLine,
            sourceList,
            operation.sourceStart,
            operation.sourceEnd,
          );
        case OperationType.insert:
          yield* _dump(
            insertLine,
            targetList,
            operation.targetStart,
            operation.targetEnd,
          );
        case OperationType.equal:
          yield* _dump(
            equalLine,
            sourceList,
            operation.sourceStart,
            operation.sourceEnd,
          );
      }
    }
  }

  Iterable<String> _replace(
    List<String> source,
    int sourceStart,
    int sourceEnd,
    List<String> target,
    int targetStart,
    int targetEnd,
  ) sync* {
    const cutoff = 0.75;
    final matcher = SequenceMatcher<int>(isJunk: charJunk);
    var sourceBest = -1, targetBest = -1, ratioBest = 0.74;
    var sourceEqual = -1, targetEqual = -1;
    for (var t = targetStart; t < targetEnd; t++) {
      final targetStr = target[t];
      for (var s = sourceStart; s < sourceEnd; s++) {
        final sourceStr = source[s];
        if (sourceStr == targetStr) {
          if (sourceEqual == -1) {
            sourceEqual = s;
            targetEqual = t;
          }
          continue;
        }
        matcher.target = targetStr.runes;
        matcher.source = sourceStr.runes;
        if (matcher.realQuickRatio > ratioBest &&
            matcher.quickRatio > ratioBest) {
          final ratio = matcher.ratio;
          if (ratio > ratioBest) {
            ratioBest = ratio;
            sourceBest = s;
            targetBest = t;
          }
        }
      }
    }
    if (ratioBest < cutoff) {
      if (sourceEqual == -1) {
        yield* _replaceBasic(
          source,
          sourceStart,
          sourceEnd,
          target,
          targetStart,
          targetEnd,
        );
        return;
      }
      sourceBest = sourceEqual;
      targetBest = targetEqual;
      ratioBest = 1.0;
    } else {
      sourceEqual = targetEqual = -1;
    }
    yield* _replaceRest(
      source,
      sourceStart,
      sourceBest,
      target,
      targetStart,
      targetBest,
    );
    if (sourceEqual == -1) {
      final sourceLine = source[sourceBest].runes;
      final sourceTags = StringBuffer('');
      matcher.source = sourceLine;
      final targetLine = target[targetBest].runes;
      final targetTags = StringBuffer('');
      matcher.target = targetLine;
      for (final operation in matcher.operations) {
        final sourceLength = operation.sourceEnd - operation.sourceStart;
        final targetLength = operation.targetEnd - operation.targetStart;
        switch (operation.type) {
          case OperationType.replace:
            sourceTags.writeAll(repeat('^', count: sourceLength));
            targetTags.writeAll(repeat('^', count: targetLength));
          case OperationType.delete:
            sourceTags.writeAll(repeat('-', count: sourceLength));
          case OperationType.insert:
            targetTags.writeAll(repeat('+', count: targetLength));
          case OperationType.equal:
            sourceTags.writeAll(repeat(' ', count: sourceLength));
            targetTags.writeAll(repeat(' ', count: targetLength));
        }
      }
      yield* _dumpWithTags(
        deleteLine,
        source[sourceBest],
        sourceTags.toString(),
      );
      yield* _dumpWithTags(
        insertLine,
        target[targetBest],
        targetTags.toString(),
      );
    } else {
      yield equalLine(source[sourceBest]);
    }
    yield* _replaceRest(
      source,
      sourceBest + 1,
      sourceEnd,
      target,
      targetBest + 1,
      targetEnd,
    );
  }

  Iterable<String> _replaceBasic(
    List<String> source,
    int sourceStart,
    int sourceEnd,
    List<String> target,
    int targetStart,
    int targetEnd,
  ) sync* {
    if (targetEnd - targetStart < sourceEnd - sourceStart) {
      yield* _dump(insertLine, target, targetStart, targetEnd);
      yield* _dump(deleteLine, source, sourceStart, sourceEnd);
    } else {
      yield* _dump(deleteLine, source, sourceStart, sourceEnd);
      yield* _dump(insertLine, target, targetStart, targetEnd);
    }
  }

  Iterable<String> _replaceRest(
    List<String> source,
    int sourceStart,
    int sourceEnd,
    List<String> target,
    int targetStart,
    int targetEnd,
  ) sync* {
    if (sourceStart < sourceEnd) {
      if (targetStart < targetEnd) {
        yield* _replace(
          source,
          sourceStart,
          sourceEnd,
          target,
          targetStart,
          targetEnd,
        );
      } else {
        yield* _dump(deleteLine, source, sourceStart, sourceEnd);
      }
    } else if (targetStart < targetEnd) {
      yield* _dump(insertLine, target, targetStart, targetEnd);
    }
  }

  Iterable<String> _dump(
    Printer<String> printer,
    List<String> list,
    int start,
    int end,
  ) sync* {
    for (var i = start; i < end; i++) {
      yield printer(list[i]);
    }
  }

  Iterable<String> _dumpWithTags(
    Printer<String> printer,
    String line,
    String tags,
  ) sync* {
    yield printer(line);
    tags = tags.trimRight();
    if (tags.isNotEmpty) yield replaceLine(tags);
  }
}

const _stringPrinter = Printer<String>.standard();
