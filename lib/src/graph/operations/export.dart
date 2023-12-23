import '../../collection/iterable/unique.dart';
import '../edge.dart';
import '../graph.dart';

extension ExportGraphExtension<V, E> on Graph<V, E> {
  /// Export this graph to [DOT Language](https://graphviz.org/doc/info/lang.html)
  /// typically used to describe [Graphviz](https://graphviz.org/) graphs.
  ///
  /// Nodes and edges are labelled with their standard print-string, unless a
  /// custom [vertexLabel] or [edgeLabel] callback is provided.
  ///
  /// The display of vertices can be customized by providing [vertexAttributes]
  /// as described in [Node Attributes](https://graphviz.org/docs/nodes/).
  /// Similarly edges can be customized by providing [edgeAttributes] as
  /// described in [Edge Attributes](https://graphviz.org/docs/edges/).
  String toDot({
    Map<String, String>? graphAttributes,
    String Function(V vertex)? vertexLabel,
    Map<String, String> Function(V vertex)? vertexAttributes,
    String Function(Edge<V, E> edge)? edgeLabel,
    Map<String, String> Function(Edge<V, E> edge)? edgeAttributes,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('${isDirected ? 'digraph' : 'graph'} {');
    for (final attribute in _encodeAttributes(graphAttributes ?? {})) {
      buffer.writeln('  $attribute;');
    }
    final ids = vertexStrategy.createMap<int>();
    for (final vertex in vertices) {
      buffer.write('  ${ids[vertex] = ids.length}');
      buffer.write(_encodeNodeEdgeAttributes({
        'label': vertexLabel?.call(vertex) ?? vertex.toString(),
        if (vertexAttributes != null) ...vertexAttributes(vertex),
      }));
      buffer.writeln(';');
    }
    final arrow = isDirected ? '->' : '--';
    for (final edge in edges.unique()) {
      buffer.write('  ${ids[edge.source]} $arrow ${ids[edge.target]}');
      buffer.write(_encodeNodeEdgeAttributes({
        'label': edgeLabel?.call(edge) ?? edge.value?.toString() ?? "",
        if (edgeAttributes != null) ...edgeAttributes(edge),
      }));
      buffer.writeln(';');
    }
    buffer.write('}');
    return buffer.toString();
  }

  String _encodeId(String input) => _validId.matchAsPrefix(input) == null
      ? '"${input.replaceAll('"', '\\"')}"'
      : input;

  Iterable<String> _encodeAttributes(Map<String, String> attributes) =>
      attributes.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => '${entry.key}=${_encodeId(entry.value)}');

  String _encodeNodeEdgeAttributes(Map<String, String> attributes) {
    final encoded = _encodeAttributes(attributes).join(', ');
    return encoded.isEmpty ? encoded : ' [$encoded]';
  }
}

final _validId = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
