import 'package:checks/checks.dart';
import 'package:more/diff.dart';

/// Extension on [Subject] of [Match] providing domain-specific checks.
extension MatchChecks on Subject<Match> {
  /// Extracts the source start index.
  Subject<int> get sourceStart => has('sourceStart', (m) => m.sourceStart);

  /// Extracts the target start index.
  Subject<int> get targetStart => has('targetStart', (m) => m.targetStart);

  /// Extracts the match length.
  Subject<int> get length => has('length', (m) => m.length);
}

/// Extension on [Subject] of [Operation] providing domain-specific checks.
extension OperationChecks on Subject<Operation> {
  /// Extracts the operation type.
  Subject<OperationType> get type => has('type', (o) => o.type);

  /// Extracts the source start index.
  Subject<int> get sourceStart => has('sourceStart', (o) => o.sourceStart);

  /// Extracts the source end index.
  Subject<int> get sourceEnd => has('sourceEnd', (o) => o.sourceEnd);

  /// Extracts the target start index.
  Subject<int> get targetStart => has('targetStart', (o) => o.targetStart);

  /// Extracts the target end index.
  Subject<int> get targetEnd => has('targetEnd', (o) => o.targetEnd);
}
