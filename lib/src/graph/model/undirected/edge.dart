import '../../../../printer.dart' show ObjectPrinter;
import '../../edge.dart';

/// Undirected edge implementation.
class UndirectedEdge<V, E> extends Edge<V, E> {
  const UndirectedEdge(super.source, super.target, {super.value});

  @override
  bool get isDirected => false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UndirectedEdge &&
          ((source == other.source && target == other.target) ||
              (source == other.target && target == other.source)));

  @override
  int get hashCode => source.hashCode ^ target.hashCode;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue('$source — $target')
    ..addValue(value, name: 'value', omitNull: true);
}
