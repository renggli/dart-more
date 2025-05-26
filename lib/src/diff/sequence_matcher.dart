// Port of Python's difflib library to Dart providing all necessary tools for
// comparing word sequences.

import 'dart:math';

import 'package:collection/collection.dart';

import '../../collection.dart';
import '../functional/types.dart';
import 'model/match.dart';
import 'model/operation.dart';
import 'model/operation_type.dart';

/// Low-level algorithm to compute match blocks, transformation operations,
/// and similarities between a [source] and a [target] collection.
class SequenceMatcher<T> {
  SequenceMatcher({
    Iterable<T>? source,
    Iterable<T>? target,
    Predicate1<T>? isJunk,
    bool autoJunk = true,
  }) : _isJunk = isJunk,
       _autoJunk = autoJunk {
    this.source = source ?? <T>[];
    this.target = target ?? <T>[];
  }

  // Internal configuration of the sequence matching.
  final Predicate1<T>? _isJunk;
  final bool _autoJunk;

  // Internal cached source and target data.
  final List<T> _source = <T>[];
  final List<T> _target = <T>[];

  // Internal cached data for matching blocks and operations.
  final List<Match> _matches = [];
  final List<Operation> _operations = [];

  // Internal cached data for `_target` input.
  final ListMultimap<T, int> _targetIndices = ListMultimap();
  final Set<T> _targetJunk = {};
  final Set<T> _targetPopular = {};

  /// Returns the [source] iterable.
  Iterable<T> get source => _source;

  /// Sets the [source] iterable to be compared.
  set source(Iterable<T> iterable) {
    _matches.clear();
    _operations.clear();
    _source.clear();
    _source.addAll(iterable);
  }

  /// Returns the [target] iterable.
  Iterable<T> get target => _target;

  /// Sets the [target] iterable to be compared.
  set target(Iterable<T> iterable) {
    _matches.clear();
    _operations.clear();
    _target.clear();
    _target.addAll(iterable);
    // Compute the target indices.
    _targetIndices.clear();
    for (var i = 0; i < _target.length; i++) {
      _targetIndices[_target[i]].add(i);
    }
    // Compute junk elements.
    _targetJunk.clear();
    if (_isJunk != null) {
      for (final element in _targetIndices.keys) {
        if (_isJunk(element)) {
          _targetJunk.add(element);
        }
      }
      for (final element in _targetJunk) {
        _targetIndices.removeAll(element);
      }
    }
    // Compute popular elements, that are not junk.
    _targetPopular.clear();
    if (_autoJunk && _target.length >= 200) {
      final cutoff = _target.length ~/ 100 + 1;
      for (final entry in _targetIndices.asMap().entries) {
        if (entry.values.length > cutoff) {
          _targetPopular.add(entry.key);
        }
      }
      for (final element in _targetPopular) {
        _targetIndices.removeAll(element);
      }
    }
  }

  /// Returns an iterable over the junk entries in [target].
  Iterable<T> get targetJunk => _targetJunk;

  /// Returns an iterable over the popular entries in [target].
  Iterable<T> get targetPopular => _targetPopular;

  /// Finds the longest matching block in the provided ranges.
  Match findLongestMatch({
    int sourceStart = 0,
    int? sourceEnd,
    int targetStart = 0,
    int? targetEnd,
  }) {
    sourceEnd ??= _source.length;
    targetEnd ??= _target.length;
    // Find longest junk-free match.
    var bestSource = sourceStart, bestTarget = targetStart, bestLength = 0;
    var targetLengths = <int, int>{};
    for (var s = sourceStart; s < sourceEnd; s++) {
      final newTargetLengths = <int, int>{};
      for (final t in _targetIndices[_source[s]]) {
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
      targetLengths = newTargetLengths;
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

  /// Return list of blocks describing matching subsequences.
  Iterable<Match> get matches {
    if (_matches.isNotEmpty) return _matches;
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
    var sourceStart = 0, targetStart = 0, length = 0;
    for (final block in blocks) {
      if (sourceStart + length == block.sourceStart &&
          targetStart + length == block.targetStart) {
        length += block.length;
      } else {
        if (length > 0) {
          _matches.add(
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
      _matches.add(
        Match(
          sourceStart: sourceStart,
          targetStart: targetStart,
          length: length,
        ),
      );
    }
    _matches.add(
      Match(
        sourceStart: _source.length,
        targetStart: _target.length,
        length: 0,
      ),
    );
    return _matches;
  }

  /// Returns a sequence of operations describing how to turn [source] into
  /// [target].
  Iterable<Operation> get operations {
    if (_operations.isNotEmpty) return _operations;
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
        _operations.add(
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
        _operations.add(
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
    return _operations;
  }

  /// Returns a sequence of operations describing how to turn [source] into
  /// [target] keeping a [context] of lines before and after each change.
  Iterable<List<Operation>> groupedOperations({int context = 3}) sync* {
    if (context < 0) throw ArgumentError.value(context, 'context');
    final codes = [...operations];
    if (codes.isEmpty) codes.add(Operation.empty);
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
    final group = <Operation>[];
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
        group.clear();
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

  /// Return a measure of the sequences' similarity, that is _1.0_ if the
  /// sequences are identical, and _0.0_ if the sequences have nothing in
  /// common.
  double get ratio => _calculateRatio(
    matches.map((each) => each.length).sum,
    _source.length + _target.length,
  );

  /// Return an upper bound on [ratio] relatively quickly.
  double get quickRatio => _calculateRatio(
    Multiset.from(_source).intersection(_target).length,
    _source.length + _target.length,
  );

  /// Return an upper bound on [ratio] really quickly.
  double get realQuickRatio => _calculateRatio(
    min(_source.length, _target.length),
    _source.length + _target.length,
  );
}

double _calculateRatio(int count, int total) =>
    total > 0 ? 2.0 * count / total : 1.0;
