import '../../../../printer.dart' show ObjectPrinter;
import '../../edge.dart';

/// Directed edge implementation.
class DirectedEdge<V, E> extends Edge<V, E> {
  const DirectedEdge(super.source, super.target, {super.value});

  @override
  bool get isDirected => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Edge && source == other.source && target == other.target);

  @override
  int get hashCode => Object.hash(source, target);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue('$source → $target')
    ..addValue(value, name: 'value', omitNull: true);
}
