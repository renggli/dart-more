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
      final (restoredGraph, isWeighted, restoredNodes, restoredModifiers) =
          GraphCodec.importFromJson(jsonStr);

      check(restoredGraph.isDirected).isFalse();
      check(isWeighted).isTrue();
      check(restoredGraph.vertices).contains('A');
      check(restoredGraph.vertices).contains('B');
      check(restoredGraph.getEdge('A', 'B')?.value).equals(42);
      check(restoredModifiers).isEmpty();

      final restoredA = restoredNodes['A']!;
      check(restoredA.label).equals('Vertex Alpha');
      check(restoredA.x).equals(120.0);
      check(restoredA.y).equals(240.0);
      check(restoredA.userFillColor).equals('#3b82f6');
    });

    test('JSON round-trip preserves modifiers stack and configuration', () {
      final graph = Graph<String, num>(isDirected: true);
      graph.addEdge('U', 'V', value: 1);
      final nodes = <String, GraphNode>{
        'U': GraphNode(id: 'U', x: 10.0, y: 20.0),
        'V': GraphNode(id: 'V', x: 30.0, y: 40.0),
      };
      final modifiers = <Map<String, dynamic>>[
        {
          'id': 'shortest_path',
          'enabled': true,
          'collapsed': false,
          'config': {
            'algorithm': 'dijkstra',
            'sourceVertex': 'U',
            'targetVertex': 'V',
            'findAll': true,
            'outputStyle': {'color': '#ef4444', 'pattern': '6,4'},
          },
        },
        {
          'id': 'layout',
          'enabled': false,
          'collapsed': true,
          'config': {'algorithm': 'force', 'vertexDistance': 75.0},
        },
      ];

      final jsonStr = GraphCodec.exportToJson(
        graph: graph,
        isWeighted: true,
        nodes: nodes,
        modifiers: modifiers,
      );
      final (restoredGraph, _, _, restoredModifiers) =
          GraphCodec.importFromJson(jsonStr);

      check(restoredGraph.containsEdge('U', 'V')).isTrue();
      check(restoredModifiers.length).equals(2);

      check(restoredModifiers[0]['id']).equals('shortest_path');
      check(restoredModifiers[0]['enabled']).equals(true);
      check(restoredModifiers[0]['collapsed']).equals(false);
      final config0 = restoredModifiers[0]['config'] as Map;
      check(config0['algorithm']).equals('dijkstra');
      check(config0['sourceVertex']).equals('U');
      check(config0['findAll']).equals(true);

      check(restoredModifiers[1]['id']).equals('layout');
      check(restoredModifiers[1]['enabled']).equals(false);
      check(restoredModifiers[1]['collapsed']).equals(true);
      final config1 = restoredModifiers[1]['config'] as Map;
      check(config1['algorithm']).equals('force');
      check(config1['vertexDistance']).equals(75.0);
    });

    test('URL hash export and import preserves modifiers', () {
      final graph = Graph<String, num>(isDirected: false);
      graph.addVertex('Z');
      final nodes = {'Z': GraphNode(id: 'Z', x: 0, y: 0)};
      final modifiers = [
        {
          'id': 'components',
          'enabled': true,
          'collapsed': false,
          'config': {'mode': 'strongly'},
        },
      ];

      final hash = GraphCodec.exportToUrlHash(
        graph: graph,
        isWeighted: false,
        nodes: nodes,
        modifiers: modifiers,
      );
      final restored = GraphCodec.importFromUrlHash(hash);
      check(restored).isNotNull();
      check(restored!.$4.length).equals(1);
      check(restored.$4[0]['id']).equals('components');
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
      check(
        () => GraphCodec.importFromJson(
          '{"nodes": [], "edges": [], "modifiers": "invalid"}',
        ),
      ).throws<FormatException>();
      check(
        () => GraphCodec.importFromJson(
          '{"nodes": [], "edges": [], "modifiers": ["not an object"]}',
        ),
      ).throws<FormatException>();
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
