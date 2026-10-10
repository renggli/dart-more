import 'package:checks/checks.dart';
import 'package:more/diff.dart';

/// Extension on [Subject] of [Match] providing domain-specific checks.
extension MatchChecks on Subject<Match> {
  /// Extracts the source start index.
  Subject<int> get sourceStart => has((m) => m.sourceStart, 'sourceStart');

  /// Extracts the target start index.
  Subject<int> get targetStart => has((m) => m.targetStart, 'targetStart');

  /// Extracts the match length.
  Subject<int> get length => has((m) => m.length, 'length');
}

/// Extension on [Subject] of [Operation] providing domain-specific checks.
extension OperationChecks on Subject<Operation> {
  /// Extracts the operation type.
  Subject<OperationType> get type => has((o) => o.type, 'type');

  /// Extracts the source start index.
  Subject<int> get sourceStart => has((o) => o.sourceStart, 'sourceStart');

  /// Extracts the source end index.
  Subject<int> get sourceEnd => has((o) => o.sourceEnd, 'sourceEnd');

  /// Extracts the target start index.
  Subject<int> get targetStart => has((o) => o.targetStart, 'targetStart');

  /// Extracts the target end index.
  Subject<int> get targetEnd => has((o) => o.targetEnd, 'targetEnd');
}
