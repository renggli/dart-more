import 'package:meta/meta.dart';

/// An abstract function that prints objects of type [T].
@immutable
abstract class Printer<T> {
  /// Generic const constructor.
  const Printer();

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
