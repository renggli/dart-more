import 'package:meta/meta.dart';

import '../functional/types/mapping.dart';
import 'literal.dart';
import 'pluggable.dart';
import 'standard.dart';

/// An abstract function that prints objects of type [T].
@immutable
abstract class Printer<T> {
  /// Generic const constructor.
  const Printer();

  /// Constructs a printer that simply calls `toString()`.
  const factory Printer.standard() = StandardPrinter<T>;

  /// Constructs a printer that emits a literal value.
  const factory Printer.literal([String value]) = LiteralPrinter<T>;

  /// Constructs a printer by wrapping `object`.
  factory Printer.wrap(Object object) {
    if (object is Printer<T>) {
      return object;
    } else if (object is Map1<T, String>) {
      return PluggablePrinter<T>(object);
    } else if (object is String) {
      return LiteralPrinter<T>(object);
    } else {
      throw ArgumentError.value(object, 'object', 'Invalid object type');
    }
  }

  /// Prints the [object].
  @nonVirtual
  String call(T object) => print(object);

  /// Returns the printed `object`.
  @nonVirtual
  String print(T object) {
    final buffer = StringBuffer();
    printOn(object, buffer);
    return buffer.toString();
  }

  /// Prints the `object` into `buffer`.
  void printOn(T object, StringBuffer buffer);
}
