// Port of Python's difflib library to Dart providing all necessary tools for
// comparing word sequences.

import 'dart:math';

import 'package:collection/collection.dart';

import '../functional/types.dart';
import 'model/match.dart';
import 'model/operation.dart';
import 'model/operation_type.dart';

/// Low-level algorithm to compute match blocks, transformation operations,
/// and similarities between a [source] and a [target] collection.
class SequenceMatcher<T> {
  /// Creates a sequence matcher between [source] and [target].
  ///
  /// Optional [isJunk] identifies elements that should be ignored when finding
  /// matching blocks. When [autoJunk] is `true` (the default), popular elements
  /// in large sequences are automatically treated as junk.
  new({
    Iterable<T>? source,
    Iterable<T>? target,
    this.isJunk,
    this.autoJunk = true,
  }) {
    this.source = source ?? <T>[];
    this.target = target ?? <T>[];
  }

  /// Predicate identifying junk elements.
  final Predicate1<T>? isJunk;

  /// Whether to automatically treat popular elements as junk.
  final bool autoJunk;

  // Internal cached source and target data.
  List<T> _source = const [];
  List<T> _target = const [];

  // Internal cached data for matching blocks and operations.
  UnmodifiableListView<Match>? _matches;
  UnmodifiableListView<Operation>? _operations;

  // Internal cached data for `_target` input.
  final Map<T, List<int>> _targetIndices = {};
  Map<T, int>? _targetCounts;
  final Set<T> _targetJunk = {};
  final Set<T> _targetPopular = {};

  /// The [source] iterable.
  Iterable<T> get source => UnmodifiableListView(_source);

  set source(Iterable<T> iterable) {
    _matches = null;
    _operations = null;
    _source = List.of(iterable, growable: false);
  }

  /// The [target] iterable.
  Iterable<T> get target => UnmodifiableListView(_target);

  set target(Iterable<T> iterable) {
    _matches = null;
    _operations = null;
    _targetCounts = null;
    _target = List.of(iterable, growable: false);
    // Compute the target indices.
    _targetIndices.clear();
    for (var i = 0; i < _target.length; i++) {
      (_targetIndices[_target[i]] ??= []).add(i);
    }
    // Compute junk elements.
    _targetJunk.clear();
    if (isJunk case final isJunk?) {
      for (final element in _targetIndices.keys) {
        if (isJunk(element)) {
          _targetJunk.add(element);
        }
      }
      _targetJunk.forEach(_targetIndices.remove);
    }
    // Compute popular elements, that are not junk.
    _targetPopular.clear();
    if (autoJunk && _target.length >= 200) {
      final cutoff = _target.length ~/ 100 + 1;
      for (final entry in _targetIndices.entries) {
        if (entry.value.length > cutoff) {
          _targetPopular.add(entry.key);
        }
      }
      _targetPopular.forEach(_targetIndices.remove);
    }
  }

  /// Returns an iterable over the junk entries in [target].
  Iterable<T> get targetJunk => UnmodifiableSetView(_targetJunk);

  /// Returns an iterable over the popular entries in [target].
  Iterable<T> get targetPopular => UnmodifiableSetView(_targetPopular);

  /// Finds the longest matching block in the provided ranges.
  Match findLongestMatch({
    int sourceStart = 0,
    int? sourceEnd,
    int targetStart = 0,
    int? targetEnd,
  }) {
    sourceEnd = RangeError.checkValidRange(
      sourceStart,
      sourceEnd,
      _source.length,
      'sourceStart',
      'sourceEnd',
    );
    targetEnd = RangeError.checkValidRange(
      targetStart,
      targetEnd,
      _target.length,
      'targetStart',
      'targetEnd',
    );
    // Find longest junk-free match.
    var bestSource = sourceStart, bestTarget = targetStart, bestLength = 0;
    var targetLengths = <int, int>{};
    var newTargetLengths = <int, int>{};
    for (var s = sourceStart; s < sourceEnd; s++) {
      newTargetLengths.clear();
      for (final t in _targetIndices[_source[s]] ?? const <int>[]) {
        if (t < targetStart) continue;
        if (t >= targetEnd) break;
        final targetLength = (targetLengths[t - 1] ?? 0) + 1;
        if (targetLength > bestLength) {
          bestSource = s - targetLength + 1;
          bestTarget = t - targetLength + 1;
          bestLength = targetLength;
        }
        newTargetLengths[t] = targetLength;
      }
      final temp = targetLengths;
      targetLengths = newTargetLengths;
      newTargetLengths = temp;
    }
    // Extend the best by non-junk elements on each end.
    while (bestSource > sourceStart &&
        bestTarget > targetStart &&
        !_targetJunk.contains(_target[bestTarget - 1]) &&
        _source[bestSource - 1] == _target[bestTarget - 1]) {
      bestSource--;
      bestTarget--;
      bestLength++;
    }
    while (bestSource + bestLength < sourceEnd &&
        bestTarget + bestLength < targetEnd &&
        !_targetJunk.contains(_target[bestTarget + bestLength]) &&
        _source[bestSource + bestLength] == _target[bestTarget + bestLength]) {
      bestLength++;
    }
    // Extend matching junk on each side.
    while (bestSource > sourceStart &&
        bestTarget > targetStart &&
        _targetJunk.contains(_target[bestTarget - 1]) &&
        _source[bestSource - 1] == _target[bestTarget - 1]) {
      bestSource--;
      bestTarget--;
      bestLength++;
    }
    while (bestSource + bestLength < sourceEnd &&
        bestTarget + bestLength < targetEnd &&
        _targetJunk.contains(_target[bestTarget + bestLength]) &&
        _source[bestSource + bestLength] == _target[bestTarget + bestLength]) {
      bestLength++;
    }
    return Match(
      sourceStart: bestSource,
      targetStart: bestTarget,
      length: bestLength,
    );
  }

  /// Returns a list of blocks describing matching subsequences.
  Iterable<Match> get matches {
    if (_matches case final matches?) return matches;
    // Find the longest matching blocks iteratively.
    final blocks = <Match>[];
    final queue = QueueList.from([
      (
        sourceStart: 0,
        sourceEnd: _source.length,
        targetStart: 0,
        targetEnd: _target.length,
      ),
    ]);
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final match = findLongestMatch(
        sourceStart: current.sourceStart,
        sourceEnd: current.sourceEnd,
        targetStart: current.targetStart,
        targetEnd: current.targetEnd,
      );
      if (match.length > 0) {
        if (current.sourceStart < match.sourceStart &&
            current.targetStart < match.targetStart) {
          queue.add((
            sourceStart: current.sourceStart,
            sourceEnd: match.sourceStart,
            targetStart: current.targetStart,
            targetEnd: match.targetStart,
          ));
        }
        if (match.sourceStart + match.length < current.sourceEnd &&
            match.targetStart + match.length < current.targetEnd) {
          queue.add((
            sourceStart: match.sourceStart + match.length,
            sourceEnd: current.sourceEnd,
            targetStart: match.targetStart + match.length,
            targetEnd: current.targetEnd,
          ));
        }
        blocks.add(match);
      }
    }
    blocks.sort();
    // Collapse adjacent blocks.
    final result = <Match>[];
    var sourceStart = 0, targetStart = 0, length = 0;
    for (final block in blocks) {
      if (sourceStart + length == block.sourceStart &&
          targetStart + length == block.targetStart) {
        length += block.length;
      } else {
        if (length > 0) {
          result.add(
            Match(
              sourceStart: sourceStart,
              targetStart: targetStart,
              length: length,
            ),
          );
        }
        sourceStart = block.sourceStart;
        targetStart = block.targetStart;
        length = block.length;
      }
    }
    if (length > 0) {
      result.add(
        Match(
          sourceStart: sourceStart,
          targetStart: targetStart,
          length: length,
        ),
      );
    }
    result.add(
      Match(
        sourceStart: _source.length,
        targetStart: _target.length,
        length: 0,
      ),
    );
    return _matches = UnmodifiableListView(result);
  }

  /// Returns a sequence of operations describing how to turn [source] into
  /// [target].
  Iterable<Operation> get operations {
    if (_operations case final operations?) return operations;
    final result = <Operation>[];
    var sourceStart = 0, targetStart = 0;
    for (final block in matches) {
      final type =
          sourceStart < block.sourceStart && targetStart < block.targetStart
          ? OperationType.replace
          : sourceStart < block.sourceStart
          ? OperationType.delete
          : targetStart < block.targetStart
          ? OperationType.insert
          : null;

      if (type != null) {
        result.add(
          Operation(
            type,
            sourceStart: sourceStart,
            sourceEnd: block.sourceStart,
            targetStart: targetStart,
            targetEnd: block.targetStart,
          ),
        );
      }
      sourceStart = block.sourceStart + block.length;
      targetStart = block.targetStart + block.length;
      if (block.length > 0) {
        result.add(
          Operation(
            OperationType.equal,
            sourceStart: block.sourceStart,
            sourceEnd: sourceStart,
            targetStart: block.targetStart,
            targetEnd: targetStart,
          ),
        );
      }
    }
    return _operations = UnmodifiableListView(result);
  }

  /// Returns a sequence of operations describing how to turn [source] into
  /// [target] keeping a [context] of lines before and after each change.
  Iterable<List<Operation>> groupedOperations({int context = 3}) {
    if (context < 0) throw ArgumentError.value(context, 'context');
    return _groupedOperations(context);
  }

  Iterable<List<Operation>> _groupedOperations(int context) sync* {
    final codes = [...operations];
    if (codes.isEmpty) return;
    if (codes.first.type == OperationType.equal) {
      final Operation(
        :type,
        :sourceStart,
        :sourceEnd,
        :targetStart,
        :targetEnd,
      ) = codes.first;
      codes.first = Operation(
        type,
        sourceStart: max(sourceStart, sourceEnd - context),
        sourceEnd: sourceEnd,
        targetStart: max(targetStart, targetEnd - context),
        targetEnd: targetEnd,
      );
    }
    if (codes.last.type == OperationType.equal) {
      final Operation(
        :type,
        :sourceStart,
        :sourceEnd,
        :targetStart,
        :targetEnd,
      ) = codes.last;
      codes.last = Operation(
        type,
        sourceStart: sourceStart,
        sourceEnd: min(sourceEnd, sourceStart + context),
        targetStart: targetStart,
        targetEnd: min(targetEnd, targetStart + context),
      );
    }
    var group = <Operation>[];
    for (final code in codes) {
      var Operation(:type, :sourceStart, :sourceEnd, :targetStart, :targetEnd) =
          code;
      if (type == OperationType.equal &&
          sourceEnd - sourceStart > 2 * context) {
        group.add(
          Operation(
            type,
            sourceStart: sourceStart,
            sourceEnd: min(sourceEnd, sourceStart + context),
            targetStart: targetStart,
            targetEnd: min(targetEnd, targetStart + context),
          ),
        );
        yield group;
        group = [];
        sourceStart = max(sourceStart, sourceEnd - context);
        targetStart = max(targetStart, targetEnd - context);
      }
      group.add(
        Operation(
          type,
          sourceStart: sourceStart,
          sourceEnd: sourceEnd,
          targetStart: targetStart,
          targetEnd: targetEnd,
        ),
      );
    }
    if (group.isNotEmpty &&
        !(group.length == 1 && group.first.type == OperationType.equal)) {
      yield group;
    }
  }

  /// Returns a measure of the sequences' similarity, that is _1.0_ if the
  /// sequences are identical, and _0.0_ if the sequences have nothing in
  /// common.
  double get ratio => _calculateRatio(
    matches.map((each) => each.length).sum,
    _source.length + _target.length,
  );

  /// Returns an upper bound on [ratio] relatively quickly.
  double get quickRatio {
    var counts = _targetCounts;
    if (counts == null) {
      counts = _targetCounts = <T, int>{};
      for (final element in _target) {
        counts[element] = (counts[element] ?? 0) + 1;
      }
    }
    final available = <T, int>{};
    var matches = 0;
    for (final element in _source) {
      final remaining = available[element] ?? counts[element] ?? 0;
      if (remaining > 0) {
        available[element] = remaining - 1;
        matches++;
      }
    }
    return _calculateRatio(matches, _source.length + _target.length);
  }

  /// Returns an upper bound on [ratio] really quickly.
  double get realQuickRatio => _calculateRatio(
    min(_source.length, _target.length),
    _source.length + _target.length,
  );
}

double _calculateRatio(int count, int total) =>
    total > 0 ? 2.0 * count / total : 1.0;
