import '../../functional.dart';
import 'object/object.dart';
import 'printer.dart';

/// Switches between different printers based on a predicate.
class SwitcherPrinter<T> extends Printer<T> {
  const SwitcherPrinter(this.cases, {this.otherwise});

  /// Ordered map with predicates and corresponding printers.
  final Map<Predicate1<T>, Printer<T>> cases;

  /// Printer to be used if none of the predicates are satisfied.
  final Printer<T>? otherwise;

  @override
  void printOn(T object, StringBuffer buffer) {
    for (final MapEntry(key: predicate, value: printer) in cases.entries) {
      if (predicate(object)) {
        printer.printOn(object, buffer);
        return;
      }
    }
    if (otherwise != null) {
      otherwise!.printOn(object, buffer);
    }
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(cases, name: 'cases')
    ..addValue(otherwise, name: 'otherwise');
}
