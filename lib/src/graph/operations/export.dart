import 'package:meta/meta.dart' show optionalTypeArgs;

import '../../collection/iterable/unique.dart';
import '../../collection/multimap/list.dart';
import '../edge.dart';
import '../graph.dart';

/// Extension on [Graph] to export graphs in different formats.
extension ExportGraphExtension<V, E> on Graph<V, E> {
  /// Exports this graph to the [DOT Language](https://graphviz.org/doc/info/lang.html)
  /// typically used to describe [Graphviz](https://graphviz.org/) graphs.
  ///
  /// Vertices can be partitioned into subgraphs by providing a [subgraph]
  /// callback that maps each vertex to its subgraph identifier, or `null` if
  /// the vertex does not belong to any subgraph.
  ///
  /// Nodes, edges, and subgraphs are labelled with their standard print-string,
  /// unless a custom [vertexLabel], [edgeLabel], or [subgraphLabel] callback is
  /// provided.
  ///
  /// The display of vertices can be customized by providing [vertexAttributes]
  /// as described in [Node Attributes](https://graphviz.org/docs/nodes/).
  /// Similarly edges can be customized by providing [edgeAttributes] as
  /// described in [Edge Attributes](https://graphviz.org/docs/edges/).
  ///
  /// Subgraphs can be named using [subgraphName]. In Graphviz, naming a subgraph
  /// with a `cluster` prefix (e.g. `cluster_0`) renders it as a visual cluster
  /// with a bounding box. Subgraph labels and styling can be customized with
  /// [subgraphLabel] and [subgraphAttributes].
  @optionalTypeArgs
  String toDot<S extends Object>({
    Map<String, String>? graphAttributes,
    String Function(V vertex)? vertexLabel,
    Map<String, String> Function(V vertex)? vertexAttributes,
    String Function(Edge<V, E> edge)? edgeLabel,
    Map<String, String> Function(Edge<V, E> edge)? edgeAttributes,
    S? Function(V vertex)? subgraph,
    String Function(S subgraph)? subgraphName,
    String Function(S subgraph)? subgraphLabel,
    Map<String, String> Function(S subgraph)? subgraphAttributes,
  }) {
    final buffer = StringBuffer();
    // Create graph.
    buffer.writeln('${isDirected ? 'digraph' : 'graph'} {');
    for (final attribute in _encodeAttributes(graphAttributes ?? {})) {
      buffer.writeln('  $attribute;');
    }
    // Create vertices.
    final ids = vertexStrategy.createMap<int>();
    for (final vertex in vertices) {
      buffer.write('  ${ids[vertex] = ids.length}');
      buffer.write(
        _encodeNodeEdgeAttributes({
          'label': vertexLabel?.call(vertex) ?? vertex.toString(),
          if (vertexAttributes != null) ...vertexAttributes(vertex),
        }),
      );
      buffer.writeln(';');
    }
    // Create edges.
    final arrow = isDirected ? '->' : '--';
    for (final edge in edges.unique()) {
      buffer.write('  ${ids[edge.source]} $arrow ${ids[edge.target]}');
      buffer.write(
        _encodeNodeEdgeAttributes({
          'label': edgeLabel?.call(edge) ?? edge.value?.toString() ?? '',
          if (edgeAttributes != null) ...edgeAttributes(edge),
        }),
      );
      buffer.writeln(';');
    }
    // Create subgraphs.
    if (subgraph != null) {
      final subgraphs = ListMultimap<S, int>();
      for (final MapEntry(key: vertex, value: id) in ids.entries) {
        final group = subgraph(vertex);
        if (group != null) subgraphs.add(group, id);
      }
      for (final group in subgraphs.keys) {
        buffer.write('  subgraph');
        final name = subgraphName?.call(group);
        if (name != null) buffer.write(' ${_encodeId(name)}');
        buffer.write(' {');
        final attributes = _encodeAttributes({
          'label': subgraphLabel?.call(group) ?? group.toString(),
          if (subgraphAttributes != null) ...subgraphAttributes(group),
        });
        for (final attribute in attributes) {
          buffer.write(' $attribute;');
        }
        for (final vertex in subgraphs[group]) {
          buffer.write(' $vertex;');
        }
        buffer.writeln(' }');
      }
    }
    buffer.write('}');
    return buffer.toString();
  }

  String _encodeId(String input) =>
      _validId.matchAsPrefix(input) == null ||
          _keywords.contains(input.toLowerCase())
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
const _keywords = {'node', 'edge', 'graph', 'digraph', 'subgraph', 'strict'};
