import 'dart:js_interop';

import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'io_codec.dart';
import 'node.dart';
import 'state.dart';

/// Utilities for importing and exporting graphs across JSON, Mermaid, DOT, and URL hash.
final class GraphIO {
  /// Serializes graph state to a JSON string.
  static String exportToJson(AppState state) {
    state.syncNodes();
    return GraphCodec.exportToJson(
      graph: state.primaryGraph,
      isWeighted: state.isWeighted,
      nodes: state.nodes,
      modifiers: [for (final m in state.modifiers) m.toJson()],
    );
  }

  /// Parses a graph from JSON.
  static (
    Graph<String, num>,
    bool isWeighted,
    Map<String, GraphNode> nodes,
    List<Map<String, dynamic>> modifiers,
  )
  importFromJson(String jsonStr) => GraphCodec.importFromJson(jsonStr);

  /// Exports the graph to Mermaid syntax.
  static String exportToMermaid(AppState state) =>
      GraphCodec.exportToMermaid(state.primaryGraph);

  /// Exports the graph to Graphviz DOT syntax.
  static String exportToDot(AppState state) =>
      GraphCodec.exportToDot(state.primaryGraph);

  /// Parses a graph from Mermaid diagram text.
  static (Graph<String, num>, bool isWeighted, Map<String, GraphNode> nodes)
  importFromMermaid(String text, {required bool isDirected}) =>
      GraphCodec.importFromMermaid(text, isDirected: isDirected);

  /// Encodes graph state into a compact URL hash string (#g=...).
  static String exportToUrlHash(AppState state) => GraphCodec.exportToUrlHash(
    graph: state.primaryGraph,
    isWeighted: state.isWeighted,
    nodes: state.nodes,
    modifiers: [for (final m in state.modifiers) m.toJson()],
  );

  /// Decodes URL hash string to restore graph state.
  static (
    Graph<String, num>,
    bool isWeighted,
    Map<String, GraphNode> nodes,
    List<Map<String, dynamic>> modifiers,
  )?
  importFromUrlHash(String hash) => GraphCodec.importFromUrlHash(hash);

  /// Triggers a browser file download of text content.
  static void downloadTextFile(
    String filename,
    String content,
    String mimeType,
  ) {
    final blob = web.Blob(
      [content.toJS].toJS,
      web.BlobPropertyBag(type: mimeType),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = filename;
    anchor.click();
    web.URL.revokeObjectURL(url);
  }
}
