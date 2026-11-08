import 'dart:convert';
import 'dart:js_interop';

import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'node.dart';
import 'state.dart';

/// Utilities for importing and exporting graphs across JSON, DSL, DOT, SVG, and Dart code.
final class GraphIO {
  /// Serializes graph state to a JSON string.
  static String exportToJson(AppState state) {
    state.syncNodes();
    final graph = state.primaryGraph;
    final map = <String, dynamic>{
      'isDirected': graph.isDirected,
      'isWeighted': state.isWeighted,
      'vertices': graph.vertices.toList(),
      'nodes': [for (final node in state.nodes.values) node.toJson()],
      'edges': [
        for (final edge in graph.edges)
          {'source': edge.source, 'target': edge.target, 'value': edge.value},
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Parses a graph from JSON.
  static (Graph<String, num>, bool isWeighted, Map<String, GraphNode> nodes)
  importFromJson(String jsonStr) {
    final dynamic decoded = jsonDecode(jsonStr);
    if (decoded is! Map) {
      throw const FormatException('Expected JSON object at root');
    }
    final isDirected = decoded['isDirected'] as bool? ?? true;
    final isWeighted = decoded['isWeighted'] as bool? ?? true;
    final graph = Graph<String, num>(isDirected: isDirected);
    final nodes = <String, GraphNode>{};

    final rawNodes = decoded['nodes'] as List?;
    if (rawNodes != null) {
      for (final item in rawNodes) {
        if (item is Map) {
          final node = GraphNode.fromJson(item.cast<String, dynamic>());
          if (node.id.isNotEmpty) {
            nodes[node.id] = node;
            graph.addVertex(node.id);
          }
        }
      }
    }

    final vertices = decoded['vertices'] as List?;
    if (vertices != null) {
      for (final v in vertices) {
        final id = v.toString();
        graph.addVertex(id);
        nodes.putIfAbsent(id, () => GraphNode(id: id, label: id));
      }
    }

    final edges = decoded['edges'] as List?;
    if (edges != null) {
      for (final e in edges) {
        if (e is Map) {
          final source = e['source']?.toString();
          final target = e['target']?.toString();
          final value = (e['value'] as num?) ?? 1;
          if (source != null && target != null) {
            graph.addEdge(source, target, value: value);
          }
        }
      }
    }

    return (graph, isWeighted, nodes);
  }

  /// Parses graph from flexible textual DSL (edge list, path chains, or adjacency).
  static Graph<String, num> importFromDsl(
    String text, {
    required bool isDirected,
  }) {
    final graph = Graph<String, num>(isDirected: isDirected);
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where(
          (l) => l.isNotEmpty && !l.startsWith('#') && !l.startsWith('//'),
        );

    for (final line in lines) {
      // 1. Adjacency format: "A: B, C:2, D"
      if (line.contains(':') && !line.contains('->') && !line.contains('--')) {
        final colonIdx = line.indexOf(':');
        final source = line.substring(0, colonIdx).trim();
        graph.addVertex(source);
        final targetsStr = line.substring(colonIdx + 1).trim();
        if (targetsStr.isNotEmpty) {
          final targetTokens = targetsStr.split(RegExp(r'[,;]'));
          for (final token in targetTokens) {
            final trimmed = token.trim();
            if (trimmed.isEmpty) continue;
            if (trimmed.contains(':')) {
              final subparts = trimmed.split(':');
              final target = subparts[0].trim();
              final weight = num.tryParse(subparts[1].trim()) ?? 1;
              graph.addEdge(source, target, value: weight);
            } else {
              graph.addEdge(source, trimmed, value: 1);
            }
          }
        }
        continue;
      }

      // 2. Path chain format: "A -> B -> C : 5" or "A -- B"
      var cleanLine = line;
      num weight = 1;
      if (cleanLine.contains(':')) {
        final lastColon = cleanLine.lastIndexOf(':');
        final weightStr = cleanLine.substring(lastColon + 1).trim();
        final parsedWeight = num.tryParse(weightStr);
        if (parsedWeight != null) {
          weight = parsedWeight;
          cleanLine = cleanLine.substring(0, lastColon).trim();
        }
      }

      final arrowRegex = RegExp(r'\s*(?:->|--|,)\s*');
      final parts = cleanLine.split(arrowRegex).map((p) => p.trim()).toList();

      if (parts.length == 1) {
        graph.addVertex(parts[0]);
      } else {
        for (var i = 0; i < parts.length - 1; i++) {
          graph.addEdge(parts[i], parts[i + 1], value: weight);
        }
      }
    }

    return graph;
  }

  /// Encodes graph state into a compact URL hash string (#g=...).
  static String exportToUrlHash(AppState state) {
    final jsonStr = exportToJson(state);
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
    } catch (_) {
      return null;
    }
  }

  /// Generates self-contained, runnable Dart code reproducing the graph.
  static String exportToDartCode(AppState state) {
    final graph = state.primaryGraph;
    final buffer = StringBuffer();
    buffer.writeln("import 'package:more/graph.dart';");
    buffer.writeln();
    buffer.writeln('void main() {');
    buffer.writeln(
      '  final graph = Graph<String, num>(isDirected: ${graph.isDirected});',
    );
    buffer.writeln();

    // Isolated vertices
    final connectedVertices = <String>{};
    for (final edge in graph.edges) {
      connectedVertices.add(edge.source);
      connectedVertices.add(edge.target);
    }
    for (final v in graph.vertices) {
      if (!connectedVertices.contains(v)) {
        buffer.writeln("  graph.addVertex('$v');");
      }
    }

    // Edges
    for (final edge in graph.edges) {
      if (state.isWeighted) {
        buffer.writeln(
          "  graph.addEdge('${edge.source}', '${edge.target}', value: ${edge.value});",
        );
      } else {
        buffer.writeln("  graph.addEdge('${edge.source}', '${edge.target}');");
      }
    }

    buffer.writeln();
    buffer.writeln("  print('Vertices: \${graph.vertices.length}');");
    buffer.writeln("  print('Edges: \${graph.edges.length}');");
    buffer.writeln('}');
    return buffer.toString();
  }

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

  /// Triggers a browser download of an SVG element.
  static void downloadSvgFile(String filename, web.SVGSVGElement svg) {
    final serializer = web.XMLSerializer();
    final svgString = serializer.serializeToString(svg);
    downloadTextFile(filename, svgString, 'image/svg+xml');
  }

  /// Triggers a browser download of the SVG converted to a PNG image.
  static void downloadPngFile(String filename, web.SVGSVGElement svg) {
    final serializer = web.XMLSerializer();
    final svgString = serializer.serializeToString(svg);
    final svgBlob = web.Blob(
      [svgString.toJS].toJS,
      web.BlobPropertyBag(type: 'image/svg+xml;charset=utf-8'),
    );
    final url = web.URL.createObjectURL(svgBlob);

    final image = web.document.createElement('img') as web.HTMLImageElement;
    image.onload = ((web.Event _) {
      final rect = svg.getBoundingClientRect();
      final width = (rect.width > 0 ? rect.width : 800) * 2;
      final height = (rect.height > 0 ? rect.height : 600) * 2;

      final canvas =
          web.document.createElement('canvas') as web.HTMLCanvasElement;
      canvas.width = width.round();
      canvas.height = height.round();

      final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
      ctx.fillStyle = '#ffffff'.toJS;
      ctx.fillRect(0, 0, width, height);
      ctx.drawImage(image, 0, 0, width, height);

      final pngUrl = canvas.toDataURL('image/png');
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = pngUrl;
      anchor.download = filename;
      anchor.click();

      web.URL.revokeObjectURL(url);
    }).toJS;

    image.src = url;
  }
}
