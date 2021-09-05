import 'package:meta/meta.dart';

import '../functional/types/mapping.dart';
import 'literal.dart';
import 'pluggable.dart';

/// An abstract function that prints objects of type [T].
@immutable
abstract class Printer<T> {
  /// Generic const constructor.
  const Printer();

  /// Wraps an object into an appropriate printer.
  factory Printer.wrap(Object object) {
    if (object is Printer<T>) {
      return object;
    } else if (object is Map1<T, String>) {
      return PluggablePrinter<T>(object);
    } else if (object is String) {
      return LiteralPrinter<T>(object);
    } else {
      throw ArgumentError.value(object, 'object', 'Invalid type');
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
