import 'package:meta/meta.dart';

import '../../functional.dart';
import 'literal.dart';
import 'pluggable.dart';
import 'sequence.dart';
import 'standard.dart';
import 'switcher.dart';
import 'to_string.dart';

/// An abstract function that prints objects of type [T].
@immutable
abstract class Printer<T> with ToStringPrinter {
  /// Generic const constructor.
  const Printer();

  /// Constructs a printer that simply calls `toString()`.
  const factory Printer.standard() = StandardPrinter<T>;

  /// Constructs a printer that emits a literal value.
  const factory Printer.literal([String value]) = LiteralPrinter<T>;

  /// Constructs a printer that evaluates the callback.
  const factory Printer.pluggable(Map1<T, String> callback) =
      PluggablePrinter<T>;

  /// Constructs a printer that emits a list of printers.
  const factory Printer.sequence(Iterable<Printer<T>> printers) =
      SequencePrinter<T>;

  /// Constructs a printer that switches between other printers.
  const factory Printer.switcher(Map<Predicate1<T>, Printer<T>> cases,
      {Printer<T> otherwise}) = SwitcherPrinter<T>;

  /// Constructs a printer by wrapping [object].
  factory Printer.wrap(Object? object) {
    if (object is Printer<T>) {
      return object;
    } else if (object is Map1<T, String>) {
      return Printer<T>.pluggable(object);
    } else if (object is String) {
      return Printer<T>.literal(object);
    } else if (object is Iterable) {
      return Printer<T>.sequence(
          object.map(Printer<T>.wrap).toList(growable: false));
    } else {
      throw ArgumentError.value(object, 'object', 'Invalid type');
    }
  }

  /// Prints the [object].
  @nonVirtual
  String call(T object) => print(object);

  /// Returns the printed [object].
  @nonVirtual
  String print(T object) {
    final buffer = StringBuffer();
    printOn(object, buffer);
    return buffer.toString();
  }

  /// Prints the [object] into [buffer].
  void printOn(T object, StringBuffer buffer);
}
