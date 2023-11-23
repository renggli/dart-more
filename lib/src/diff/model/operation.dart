import 'package:meta/meta.dart';

import '../../../printer.dart';
import 'operation_type.dart';

/// Encapsulates an operation when comparing two inputs.
@immutable
class Operation with ToStringPrinter {
  /// Constructs a new operation.
  const Operation(
    this.type, {
    required this.sourceStart,
    required this.sourceEnd,
    required this.targetStart,
    required this.targetEnd,
  });

  /// Constructs an empty operation.
  static const empty = Operation(
    OperationType.equal,
    sourceStart: 0,
    sourceEnd: 1,
    targetStart: 0,
    targetEnd: 1,
  );

  /// The type of the operation.
  final OperationType type;

  /// The start of the operation in the source.
  final int sourceStart;

  /// The end of the operation in the source (exclusive).
  final int sourceEnd;

  /// The start of the operation in the target.
  final int targetStart;

  /// The end of the operation in the target (exclusive).
  final int targetEnd;

  @override
  bool operator ==(Object other) =>
      other is Operation &&
      type == other.type &&
      sourceStart == other.sourceStart &&
      sourceEnd == other.sourceEnd &&
      targetStart == other.targetStart &&
      targetEnd == other.targetEnd;

  @override
  int get hashCode =>
      Object.hash(type, sourceStart, sourceEnd, targetStart, targetEnd);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(type)
    ..addValue(sourceStart, name: 'sourceStart')
    ..addValue(sourceEnd, name: 'sourceEnd')
    ..addValue(targetStart, name: 'targetStart')
    ..addValue(targetEnd, name: 'targetEnd');
}
