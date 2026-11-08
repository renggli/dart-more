import 'package:meta/meta.dart' show optionalTypeArgs;

import '../../collection/iterable/unique.dart';
import '../../collection/multimap/list.dart';
import '../edge.dart';
import '../graph.dart';

/// Extension on [Graph] to export graphs to Mermaid format.
extension MermaidGraphExtension<V, E> on Graph<V, E> {
  /// Exports this graph to the [Mermaid](https://mermaid.js.org/syntax/flowchart.html)
  /// flowchart diagram format.
  ///
  /// The [direction] specifies the layout direction: `'TD'` or `'TB'` (top-down),
  /// `'LR'` (left-right), `'BT'` (bottom-up), or `'RL'` (right-left). Defaults
  /// to `'TD'`.
  ///
  /// The [type] specifies the Mermaid diagram keyword: `'flowchart'` (default)
  /// or `'graph'`.
  ///
  /// Vertices can be partitioned into subgraphs by providing a [subgraph]
  /// callback that maps each vertex to its subgraph identifier, or `null` if
  /// the vertex does not belong to any subgraph.
  ///
  /// Vertices, edges, and subgraphs are labelled with their standard print-string,
  /// unless a custom [vertexLabel], [edgeLabel], or [subgraphLabel] callback is
  /// provided.
  @optionalTypeArgs
  String toMermaid<S extends Object>({
    String direction = 'TD',
    String type = 'flowchart',
    String Function(V vertex)? vertexLabel,
    String Function(Edge<V, E> edge)? edgeLabel,
    S? Function(V vertex)? subgraph,
    String Function(S subgraph)? subgraphName,
    String Function(S subgraph)? subgraphLabel,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('$type $direction');

    // Assign sanitized unique IDs to all vertices.
    final ids = vertexStrategy.createMap<String>();
    final usedIds = <String>{};
    for (final vertex in vertices) {
      final str = vertex.toString();
      var id = str;
      if (!_validId.hasMatch(id) || _keywords.contains(id.toLowerCase())) {
        id = 'v${ids.length}';
      }
      var candidate = id;
      var counter = 1;
      while (!usedIds.add(candidate)) {
        candidate = '${id}_${counter++}';
      }
      ids[vertex] = candidate;
    }

    // Render vertices explicitly to ensure isolated vertices are captured.
    for (final vertex in vertices) {
      final id = ids[vertex]!;
      final label = vertexLabel?.call(vertex) ?? vertex.toString();
      buffer.write('  $id');
      buffer.write('["${_escapeLabel(label)}"]');
      buffer.writeln();
    }

    // Render edges.
    for (final edge in edges.unique()) {
      final sourceId = ids[edge.source]!;
      final targetId = ids[edge.target]!;
      final label = edgeLabel?.call(edge) ?? edge.value?.toString() ?? '';
      final arrow = isDirected ? '-->' : '---';
      buffer.write('  $sourceId ');
      if (label.isNotEmpty) {
        buffer.write('$arrow|${_escapeEdgeLabel(label)}|');
      } else {
        buffer.write(arrow);
      }
      buffer.writeln(' $targetId');
    }

    // Render subgraphs.
    if (subgraph != null) {
      final subgraphs = ListMultimap<S, V>();
      for (final vertex in vertices) {
        final group = subgraph(vertex);
        if (group != null) subgraphs.add(group, vertex);
      }
      for (final group in subgraphs.keys) {
        final name =
            subgraphName?.call(group) ??
            _sanitizeSubgraphName(group.toString());
        final label = subgraphLabel?.call(group) ?? group.toString();
        buffer.write('  subgraph $name');
        if (label.isNotEmpty) {
          buffer.write(' ["${_escapeLabel(label)}"]');
        }
        buffer.writeln();
        for (final vertex in subgraphs[group]) {
          buffer.writeln('    ${ids[vertex]}');
        }
        buffer.writeln('  end');
      }
    }

    return buffer.toString().trimRight();
  }

  static String _escapeLabel(String input) => input
      .replaceAll('"', '#quot;')
      .replaceAll('[', '#91;')
      .replaceAll(']', '#93;')
      .replaceAll('<', '#lt;')
      .replaceAll('>', '#gt;');

  static String _escapeEdgeLabel(String input) =>
      input.replaceAll('|', '#124;');

  static String _sanitizeSubgraphName(String input) {
    if (_validId.hasMatch(input) && !_keywords.contains(input.toLowerCase())) {
      return input;
    }
    final sanitized = input.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return sanitized.isEmpty ? 'subgraph_0' : sanitized;
  }
}

final _validId = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
const _keywords = {
  'subgraph',
  'end',
  'flowchart',
  'graph',
  'style',
  'class',
  'classdef',
  'linkstyle',
  'click',
  'direction',
  'tb',
  'td',
  'bt',
  'rl',
  'lr',
};
