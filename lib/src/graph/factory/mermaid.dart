import '../factory.dart';
import '../graph.dart';

/// Extension on [GraphFactory] to parse graphs from Mermaid flowchart syntax.
extension MermaidGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates a [Graph] parsed from a [Mermaid](https://mermaid.js.org/syntax/flowchart.html)
  /// flowchart definition.
  ///
  /// The [source] can be raw Mermaid text or enclosed within markdown code fences.
  ///
  /// Optionally, a [vertexParser] can be provided to map the node ID and optional
  /// label to a vertex instance of type [V].
  ///
  /// Optionally, an [edgeParser] can be provided to map the optional edge label
  /// to an edge value of type [E].
  Graph<V, E> fromMermaid(
    String source, {
    V Function(String id, String? label)? vertexParser,
    E Function(String? label)? edgeParser,
  }) {
    final builder = newBuilder();
    final parser = _MermaidParser<V, E>(
      builder: builder,
      vertexParser: vertexParser,
      edgeParser: edgeParser,
    );
    parser.parse(source);
    return builder.build();
  }
}

final class _MermaidParser<V, E> {
  new({required this.builder, this.vertexParser, this.edgeParser});

  final GraphBuilder<V, E> builder;
  final V Function(String id, String? label)? vertexParser;
  final E Function(String? label)? edgeParser;

  final Map<String, V> _vertexMap = {};

  void parse(String source) {
    var text = source.trim();

    // Strip markdown code fences if present.
    if (text.startsWith('```')) {
      final firstNewline = text.indexOf('\n');
      if (firstNewline != -1) {
        text = text.substring(firstNewline + 1);
      }
      if (text.endsWith('```')) {
        text = text.substring(0, text.length - 3);
      }
      text = text.trim();
    }

    final statements = _splitStatements(text);
    for (final rawStatement in statements) {
      final stmt = _stripComments(rawStatement).trim();
      if (stmt.isEmpty) continue;

      // Ignore diagram headers.
      if (_headerRegex.hasMatch(stmt)) continue;

      // Handle subgraphs.
      if (stmt.startsWith('subgraph') || stmt == 'end') {
        // If a subgraph statement declares an id/label e.g. "subgraph id [label]"
        continue;
      }

      // Ignore Mermaid directives or styling instructions.
      if (_isIgnoredDirective(stmt)) continue;

      _parseStatement(stmt);
    }
  }

  void _parseStatement(String statement) {
    // Find all edge connectors in the statement.
    final matches = _edgePattern.allMatches(statement).toList();
    if (matches.isEmpty) {
      // Single node declaration without edges.
      final node = _parseNodeToken(statement);
      if (node != null && node.$1.isNotEmpty) {
        _getOrCreateVertex(node.$1, node.$2);
      }
      return;
    }

    // Split chained edge expressions (e.g. A --> B --> C).
    var lastEnd = 0;
    final nodeTokens = <String>[];
    final edgeInfos = <_EdgeInfo>[];

    for (final match in matches) {
      final nodeToken = statement.substring(lastEnd, match.start).trim();
      nodeTokens.add(nodeToken);

      final arrowPart = match.group(1)!;
      final pipeLabel = match.group(2);
      final inlineLabel = _extractInlineLabel(arrowPart);
      final label = pipeLabel ?? inlineLabel;
      final isDirected = arrowPart.trimRight().endsWith('>');

      edgeInfos.add(_EdgeInfo(label: label, isDirected: isDirected));
      lastEnd = match.end;
    }

    final lastNodeToken = statement.substring(lastEnd).trim();
    nodeTokens.add(lastNodeToken);

    for (var i = 0; i < edgeInfos.length; i++) {
      final sourceToken = nodeTokens[i];
      final targetToken = nodeTokens[i + 1];

      final sourceParsed = _parseNodeToken(sourceToken);
      final targetParsed = _parseNodeToken(targetToken);
      if (sourceParsed == null || targetParsed == null) continue;

      final sourceVertex = _getOrCreateVertex(sourceParsed.$1, sourceParsed.$2);
      final targetVertex = _getOrCreateVertex(targetParsed.$1, targetParsed.$2);
      final edgeInfo = edgeInfos[i];
      var edgeVal = _parseEdgeValue(edgeInfo.label);

      if (edgeVal == null &&
          null is! E &&
          builder.factory.edgeProvider == null) {
        if ((0 as num) is E) {
          edgeVal = 1 as E;
        } else if (0 is E) {
          edgeVal = 1 as E;
        } else if (0.0 is E) {
          edgeVal = 1.0 as E;
        } else if ('' is E) {
          edgeVal = '' as E;
        }
      }

      if (builder.factory.isDirected) {
        if (edgeInfo.isDirected) {
          builder.addEdge(sourceVertex, targetVertex, value: edgeVal);
        } else {
          // Undirected edge in a directed graph represents bidirectional connection.
          builder.addEdge(sourceVertex, targetVertex, value: edgeVal);
          builder.addEdge(targetVertex, sourceVertex, value: edgeVal);
        }
      } else {
        builder.addEdge(sourceVertex, targetVertex, value: edgeVal);
      }
    }
  }

  V _getOrCreateVertex(String id, String? label) {
    final existing = _vertexMap[id];
    if (existing != null) return existing;

    final V vertex;
    if (vertexParser != null) {
      vertex = vertexParser!(id, label);
    } else if (builder.factory.vertexProvider != null) {
      vertex = builder.factory.vertexProvider!(_vertexMap.length);
    } else if ('' is V) {
      vertex = (label ?? id) as V;
    } else if (0 is V) {
      final parsed = int.tryParse(label ?? '') ?? int.tryParse(id);
      vertex = (parsed ?? _vertexMap.length) as V;
    } else if ((0 as num) is V) {
      final parsed = num.tryParse(label ?? '') ?? num.tryParse(id);
      vertex = (parsed ?? _vertexMap.length) as V;
    } else {
      vertex = (label ?? id) as V;
    }

    _vertexMap[id] = vertex;
    builder.addVertex(vertex);
    return vertex;
  }

  E? _parseEdgeValue(String? label) {
    if (edgeParser != null) {
      return edgeParser!(label);
    }
    if (label == null || label.isEmpty) {
      return null;
    }
    final unescaped = _unescape(label).trim();
    if ((0 as num) is E) {
      final parsed = num.tryParse(unescaped);
      if (parsed != null) return parsed as E;
    } else if (0 is E) {
      final parsed = int.tryParse(unescaped);
      if (parsed != null) return parsed as E;
    } else if (0.0 is E) {
      final parsed = double.tryParse(unescaped);
      if (parsed != null) return parsed as E;
    } else if ('' is E) {
      return unescaped as E;
    }
    return null;
  }

  static (String, String?)? _parseNodeToken(String rawToken) {
    final token = rawToken.trim();
    if (token.isEmpty) return null;

    final bracketIdx = token.indexOf(RegExp(r'[\[\(\{\>]'));
    if (bracketIdx == -1) {
      final id = _stripQuotes(token);
      return (id, null);
    }

    final id = _stripQuotes(token.substring(0, bracketIdx).trim());
    final shapePart = token.substring(bracketIdx).trim();
    final rawLabel = _extractShapeContent(shapePart);
    final label = rawLabel != null ? _unescape(_stripQuotes(rawLabel)) : null;

    return (id, label);
  }

  static String? _extractShapeContent(String input) {
    if (input.length < 2) return null;

    // Remove opening brackets/symbols.
    var start = 0;
    while (start < input.length && _isOpenBracket(input[start])) {
      start++;
    }
    if (start < input.length && (input[start] == '/' || input[start] == '\\')) {
      start++;
    }

    // Remove closing brackets/symbols.
    var end = input.length - 1;
    while (end >= start && _isCloseBracket(input[end])) {
      end--;
    }
    if (end >= start && (input[end] == '/' || input[end] == '\\')) {
      end--;
    }

    if (start <= end) {
      return input.substring(start, end + 1).trim();
    }
    return '';
  }

  static bool _isOpenBracket(String c) =>
      c == '[' || c == '(' || c == '{' || c == '>';

  static bool _isCloseBracket(String c) => c == ']' || c == ')' || c == '}';

  static String? _extractInlineLabel(String connector) {
    final match = _inlineLabelRegex.firstMatch(connector);
    return match?.group(1)?.trim();
  }

  static String _stripComments(String line) {
    final commentIdx = line.indexOf('%%');
    if (commentIdx == -1) return line;
    return line.substring(0, commentIdx);
  }

  static bool _isIgnoredDirective(String stmt) {
    final lower = stmt.toLowerCase();
    return lower.startsWith('classdef ') ||
        lower.startsWith('class ') ||
        lower.startsWith('style ') ||
        lower.startsWith('linkstyle ') ||
        lower.startsWith('click ') ||
        lower.startsWith('acctitle:') ||
        lower.startsWith('accdescr:') ||
        lower.startsWith('direction ');
  }

  static List<String> _splitStatements(String text) {
    final statements = <String>[];
    final current = StringBuffer();
    var inQuotes = false;
    var quoteChar = '';
    var inPipes = false;
    var bracketDepth = 0;

    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (inQuotes) {
        current.write(char);
        if (char == quoteChar && (i == 0 || text[i - 1] != '\\')) {
          inQuotes = false;
        }
      } else {
        if (char == '"' || char == "'") {
          inQuotes = true;
          quoteChar = char;
          current.write(char);
        } else if (char == '|') {
          inPipes = !inPipes;
          current.write(char);
        } else if (char == '[' || char == '(' || char == '{') {
          bracketDepth++;
          current.write(char);
        } else if (char == ']' || char == ')' || char == '}') {
          if (bracketDepth > 0) bracketDepth--;
          current.write(char);
        } else if (char == '\n' ||
            (!inPipes &&
                bracketDepth == 0 &&
                char == ';' &&
                !_isEntitySemicolon(text, i))) {
          final s = current.toString().trim();
          if (s.isNotEmpty) statements.add(s);
          current.clear();
        } else {
          current.write(char);
        }
      }
    }
    final s = current.toString().trim();
    if (s.isNotEmpty) statements.add(s);
    return statements;
  }

  static bool _isEntitySemicolon(String text, int index) {
    var j = index - 1;
    while (j >= 0 && j >= index - 10) {
      final cu = text.codeUnitAt(j);
      if (cu == 0x23 /* # */ || cu == 0x26 /* & */ ) return true;
      if (!((cu >= 0x61 && cu <= 0x7a) ||
          (cu >= 0x41 && cu <= 0x5a) ||
          (cu >= 0x30 && cu <= 0x39))) {
        break;
      }
      j--;
    }
    return false;
  }

  static String _stripQuotes(String s) {
    final trimmed = s.trim();
    if (trimmed.length >= 2 &&
        ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
            (trimmed.startsWith("'") && trimmed.endsWith("'")))) {
      return trimmed.substring(1, trimmed.length - 1);
    }
    return trimmed;
  }

  static String _unescape(String input) => input
      .replaceAll('#quot;', '"')
      .replaceAll(r'\"', '"')
      .replaceAll(r"\'", "'")
      .replaceAll('#91;', '[')
      .replaceAll('#93;', ']')
      .replaceAll('#lt;', '<')
      .replaceAll('#gt;', '>')
      .replaceAll('#124;', '|');
}

final class _EdgeInfo {
  const new({this.label, required this.isDirected});

  final String? label;
  final bool isDirected;
}

final _headerRegex = RegExp(
  r'^(flowchart|graph)(\s+[A-Za-z]+)?$',
  caseSensitive: false,
);

final _inlineLabelRegex = RegExp(
  r'(?:--|\-\.|\=\=)\s*([^-.\=]+?)\s*(?:-->|---|-.->|-.-|==>|===)',
);

final _edgePattern = RegExp(
  r'(--\s*[^>\s-][^>\n]*?-->|--\s*[^>\s-][^>\n]*?---|-->|---|'
  r'-\.\s*[^.\s-][^.\n]*?\.->|-\.\s*[^.\s-][^.\n]*?\.-|-\.->|-.-|'
  r'==\s*[^=\s-][^=\n]*?==>|==\s*[^=\s-][^=\n]*?===|==>|===)'
  r'(?:\s*\|([^|]*)\|)?',
);
