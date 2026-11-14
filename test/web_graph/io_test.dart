import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/io_codec.dart';
import '../../web/graph/node.dart';

void main() {
  group('GraphCodec', () {
    test('JSON round-trip preserves nodes, styles, and topology', () {
      final graph = Graph<String, num>(isDirected: false);
      graph.addEdge('A', 'B', value: 42);
      final nodes = <String, GraphNode>{
        'A': GraphNode(
          id: 'A',
          label: 'Vertex Alpha',
          x: 120.0,
          y: 240.0,
          userFillColor: '#3b82f6',
        ),
        'B': GraphNode(id: 'B', label: 'B', x: 200.0, y: 300.0),
      };

      final jsonStr = GraphCodec.exportToJson(
        graph: graph,
        isWeighted: true,
        nodes: nodes,
      );
      final (restoredGraph, isWeighted, restoredNodes) =
          GraphCodec.importFromJson(jsonStr);

      check(restoredGraph.isDirected).isFalse();
      check(isWeighted).isTrue();
      check(restoredGraph.vertices).contains('A');
      check(restoredGraph.vertices).contains('B');
      check(restoredGraph.getEdge('A', 'B')?.value).equals(42);

      final restoredA = restoredNodes['A']!;
      check(restoredA.label).equals('Vertex Alpha');
      check(restoredA.x).equals(120.0);
      check(restoredA.y).equals(240.0);
      check(restoredA.userFillColor).equals('#3b82f6');
    });

    test('Mermaid import preserves labels and detects weights', () {
      const mermaid = '''
graph TD
  A["Node Alpha"] -->|10| B["Node Beta"]
  B --> C
''';
      final (graph, isWeighted, nodes) = GraphCodec.importFromMermaid(
        mermaid,
        isDirected: true,
      );

      check(graph.isDirected).isTrue();
      check(isWeighted).isTrue();
      check(nodes['A']?.label).equals('Node Alpha');
      check(nodes['B']?.label).equals('Node Beta');
      check(nodes['C']?.label).equals('C');
      check(graph.getEdge('A', 'B')?.value).equals(10);
    });

    test('URL hash export and import', () {
      final graph = Graph<String, num>(isDirected: true);
      graph.addEdge('X', 'Y', value: 7);
      final nodes = <String, GraphNode>{
        'X': GraphNode(id: 'X', x: 50.0, y: 75.0),
        'Y': GraphNode(id: 'Y', x: 150.0, y: 175.0),
      };

      final hash = GraphCodec.exportToUrlHash(
        graph: graph,
        isWeighted: true,
        nodes: nodes,
      );
      final restored = GraphCodec.importFromUrlHash(hash);
      check(restored).isNotNull();
      check(restored!.$1.containsEdge('X', 'Y')).isTrue();
      check(restored.$3['X']?.x).equals(50.0);
    });

    test('importFromJson throws FormatException on invalid inputs', () {
      check(() => GraphCodec.importFromJson('not json'))
          .throws<FormatException>();
      check(() => GraphCodec.importFromJson('[]')).throws<FormatException>();
      check(() => GraphCodec.importFromJson('{"isDirected": "invalid"}'))
          .throws<FormatException>();
    });

    test('exportToCsv escapes quotes, commas, and newlines', () {
      final headers = ['Header 1', 'Header, "Two"'];
      final rows = [
        ['Simple', 'Value with, comma'],
        ['Quotes "here"', 'Multi\nline'],
      ];
      final csv = GraphCodec.exportToCsv(headers, rows);
      check(csv).equals(
        'Header 1,"Header, ""Two"""\n'
        'Simple,"Value with, comma"\n'
        '"Quotes ""here""","Multi\nline"\n',
      );
    });
  });
}
