import 'dart:convert';

import 'package:more/graph.dart';

import 'node.dart';

/// Pure Dart graph codecs without browser DOM or JavaScript dependencies.
abstract final class GraphCodec {
  /// Serializes graph structure and node coordinates to JSON.
  static String exportToJson({
    required Graph<String, num> graph,
    required bool isWeighted,
    required Map<String, GraphNode> nodes,
  }) {
    final map = <String, dynamic>{
      'isDirected': graph.isDirected,
      'isWeighted': isWeighted,
      'nodes': [for (final node in nodes.values) node.toJson()],
      'edges': [
        for (final edge in graph.edges)
          {'source': edge.source, 'target': edge.target, 'value': edge.value},
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Parses graph structure, weight flag, and node coordinate map from JSON.
  static (Graph<String, num>, bool isWeighted, Map<String, GraphNode> nodes)
  importFromJson(String jsonStr) {
    final decoded = jsonDecode(jsonStr);
    if (decoded is! Map) {
      throw const FormatException('Expected JSON object at root');
    }
    final map = decoded.cast<String, dynamic>();

    final isDirected = switch (map['isDirected']) {
      final bool val => val,
      null => true,
      _ => throw const FormatException(
        'Invalid "isDirected" field, expected boolean',
      ),
    };
    final isWeighted = switch (map['isWeighted']) {
      final bool val => val,
      null => true,
      _ => throw const FormatException(
        'Invalid "isWeighted" field, expected boolean',
      ),
    };
    final graph = Graph<String, num>(isDirected: isDirected);
    final nodes = <String, GraphNode>{};

    if (map['nodes'] case final List<dynamic> rawNodes) {
      for (final item in rawNodes) {
        if (item is Map) {
          final node = GraphNode.fromJson(item.cast<String, dynamic>());
          if (node.id.isNotEmpty) {
            nodes[node.id] = node;
            graph.addVertex(node.id);
          }
        } else {
          throw const FormatException(
            'Expected node entry to be a JSON object',
          );
        }
      }
    } else if (map.containsKey('nodes')) {
      throw const FormatException('Invalid "nodes" field, expected array');
    }

    // Backwards compatibility for older exported files containing 'vertices'
    if (map['vertices'] case final List<dynamic> rawVertices) {
      for (final v in rawVertices) {
        final id = v.toString();
        graph.addVertex(id);
        nodes.putIfAbsent(id, () => GraphNode(id: id, label: id));
      }
    }

    if (map['edges'] case final List<dynamic> rawEdges) {
      for (final e in rawEdges) {
        if (e is Map) {
          final source = e['source']?.toString();
          final target = e['target']?.toString();
          final value = switch (e['value']) {
            final num val => val,
            null => 1,
            final String str => num.tryParse(str) ?? 1,
            _ => throw const FormatException(
              'Invalid edge "value", expected number',
            ),
          };
          if (source != null && target != null) {
            graph.addEdge(source, target, value: value);
            nodes.putIfAbsent(
              source,
              () => GraphNode(id: source, label: source),
            );
            nodes.putIfAbsent(
              target,
              () => GraphNode(id: target, label: target),
            );
          } else {
            throw const FormatException('Edge missing "source" or "target"');
          }
        } else {
          throw const FormatException(
            'Expected edge entry to be a JSON object',
          );
        }
      }
    } else if (map.containsKey('edges')) {
      throw const FormatException('Invalid "edges" field, expected array');
    }

    return (graph, isWeighted, nodes);
  }

  /// Exports the graph to Mermaid flowchart syntax.
  static String exportToMermaid(Graph<String, num> graph) => graph.toMermaid();

  /// Exports the graph to Graphviz DOT syntax.
  static String exportToDot(Graph<String, num> graph) => graph.toDot();

  /// Parses a graph from Mermaid diagram text.
  static (Graph<String, num>, bool isWeighted, Map<String, GraphNode> nodes)
  importFromMermaid(String text, {required bool isDirected}) {
    final factory = GraphFactory<String, num>(isDirected: isDirected);
    final nodes = <String, GraphNode>{};
    var hasExplicitWeight = false;
    final graph = factory.fromMermaid(
      text,
      vertexParser: (id, label) {
        nodes[id] = GraphNode(id: id, label: label);
        return id;
      },
      edgeParser: (label) {
        if (label != null && label.isNotEmpty) {
          hasExplicitWeight = true;
          return num.tryParse(label) ?? 1;
        }
        return 1;
      },
    );
    for (final v in graph.vertices) {
      nodes.putIfAbsent(v, () => GraphNode(id: v, label: v));
    }
    return (graph, hasExplicitWeight, nodes);
  }

  /// Encodes graph state into a compact URL hash string (#g=...).
  static String exportToUrlHash({
    required Graph<String, num> graph,
    required bool isWeighted,
    required Map<String, GraphNode> nodes,
  }) {
    final jsonStr = exportToJson(
      graph: graph,
      isWeighted: isWeighted,
      nodes: nodes,
    );
    final bytes = utf8.encode(jsonStr);
    final base64 = base64Url.encode(bytes).replaceAll('=', '');
    return 'g=$base64';
  }

  /// Decodes URL hash string to restore graph state.
  static (Graph<String, num>, bool isWeighted, Map<String, GraphNode> nodes)?
  importFromUrlHash(String hash) {
    var raw = hash;
    if (raw.startsWith('#')) raw = raw.substring(1);
    if (!raw.startsWith('g=')) return null;
    try {
      final base64Str = raw.substring(2);
      final normalized = base64.normalize(base64Str);
      final bytes = base64Url.decode(normalized);
      final jsonStr = utf8.decode(bytes);
      return importFromJson(jsonStr);
    } on FormatException {
      rethrow;
    } catch (_) {
      return null;
    }
  }

  /// Serializes tabular data (headers and rows) into RFC-4180 compliant CSV.
  static String exportToCsv(List<String> headers, List<List<String>> rows) {
    String escapeCell(String value) {
      if (value.contains(',') ||
          value.contains('"') ||
          value.contains('\n') ||
          value.contains('\r')) {
        return '"${value.replaceAll('"', '""')}"';
      }
      return value;
    }

    final buffer = StringBuffer();
    if (headers.isNotEmpty) {
      buffer.writeln(headers.map(escapeCell).join(','));
    }
    for (final row in rows) {
      buffer.writeln(row.map(escapeCell).join(','));
    }
    return buffer.toString();
  }
}
