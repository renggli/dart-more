import 'package:meta/meta.dart';

import 'object/object.dart';

/// A mixin to provide a consistent `toString()` implementation.
///
/// Add the mixin to the root of your object hierarchy and override the
/// `toStringPrinter` accessor:
///
///    @override
///    ObjectPrinter get toStringPrinter => super.toStringPrinter
///      ..addValue(someField, 'someField')
///      ..addValue(otherField, 'otherField');
///
/// Note: Due to the lack of a `Self` type in Dart, this is working with a
/// dynamically typed printer Object. To avoid loosing the type information
/// use `addValue` instead of `addCallback` to configure the field printers
/// (https://github.com/dart-lang/sdk/issues/28477).
mixin ToStringPrinter {
  /// Override to configure the empty [ObjectPrinter].
  @protected
  ObjectPrinter get defaultToStringPrinter => ObjectPrinter.dynamic();

  /// Override and call super to add values to the [ObjectPrinter].
  @protected
  @mustCallSuper
  ObjectPrinter get toStringPrinter => defaultToStringPrinter;

  /// Standard `toString` implementation. Do not override, instead implement
  /// [toStringPrinter] to customize.
  @override
  @nonVirtual
  String toString() => toStringPrinter.print(this);
}
