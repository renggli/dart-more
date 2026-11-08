import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('mermaid', () {
    group('fromMermaid', () {
      test('simple directed graph', () {
        const source = '''
flowchart TD
  A --> B
  B --> C
''';
        final graph = GraphFactory<String, void>(isDirected: true)
            .fromMermaid(source);
        check(graph.isDirected).isTrue();
        check(graph.vertices).unorderedEquals(['A', 'B', 'C']);
        check(graph.edges.map((e) => (e.source, e.target)))
            .unorderedEquals([('A', 'B'), ('B', 'C')]);
      });

      test('simple undirected graph', () {
        const source = '''
flowchart LR
  A --- B
  B --- C
''';
        final graph = GraphFactory<String, void>(isDirected: false)
            .fromMermaid(source);
        check(graph.isDirected).isFalse();
        check(graph.vertices).unorderedEquals(['A', 'B', 'C']);
        check(graph.neighboursOf('B')).unorderedEquals(['A', 'C']);
      });

      test('undirected edges in directed graph become bidirectional', () {
        const source = '''
flowchart TD
  A --- B
''';
        final graph = GraphFactory<String, void>(isDirected: true)
            .fromMermaid(source);
        check(graph.isDirected).isTrue();
        check(graph.edges.map((e) => (e.source, e.target)))
            .unorderedEquals([('A', 'B'), ('B', 'A')]);
      });

      test('numeric edge weights via pipe syntax', () {
        const source = '''
flowchart TD
  A -->|10| B
  B -->|25.5| C
''';
        final graph = GraphFactory<String, num>().fromMermaid(source);
        check(graph.getEdge('A', 'B')?.value).equals(10);
        check(graph.getEdge('B', 'C')?.value).equals(25.5);
      });

      test('inline edge labels', () {
        const source = '''
flowchart TD
  A -- 5 --> B
  B -- 12 --- C
''';
        final graph = GraphFactory<String, int>().fromMermaid(source);
        check(graph.getEdge('A', 'B')?.value).equals(5);
        check(graph.getEdge('B', 'C')?.value).equals(12);
      });

      test('chained edges', () {
        const source = '''
flowchart TD
  A --> B --> C --> D
''';
        final graph = GraphFactory<String, void>().fromMermaid(source);
        check(graph.vertices).unorderedEquals(['A', 'B', 'C', 'D']);
        check(graph.edges.map((e) => (e.source, e.target)))
            .unorderedEquals([('A', 'B'), ('B', 'C'), ('C', 'D')]);
      });

      test('various node shapes and labels', () {
        const source = '''
flowchart TD
  A["Rectangle with spaces"]
  B("Rounded")
  C(("Circle"))
  D(["Stadium"])
  E[["Subroutine"]]
  F[("Database")]
  G{"Rhombus"}
  H{{"Hexagon"}}
  I>Asymmetric]
  A --> B
''';
        final graph = GraphFactory<String, void>().fromMermaid(source);
        check(graph.vertices).unorderedEquals([
          'Rectangle with spaces',
          'Rounded',
          'Circle',
          'Stadium',
          'Subroutine',
          'Database',
          'Rhombus',
          'Hexagon',
          'Asymmetric',
        ]);
        check(graph.edges.length).equals(1);
        check(graph.edges.single.source).equals('Rectangle with spaces');
        check(graph.edges.single.target).equals('Rounded');
      });

      test('markdown code fences and comments', () {
        const source = '''
```mermaid
%% Initial architecture graph
flowchart TD
  A --> B %% Connect A to B
  %% Another comment
  B --> C
```
''';
        final graph = GraphFactory<String, void>().fromMermaid(source);
        check(graph.vertices).unorderedEquals(['A', 'B', 'C']);
        check(graph.edges.length).equals(2);
      });

      test('isolated vertices', () {
        const source = '''
flowchart TD
  A --> B
  Isolated
  AnotherAlone["Standalone"]
''';
        final graph = GraphFactory<String, void>().fromMermaid(source);
        check(graph.vertices)
            .unorderedEquals(['A', 'B', 'Isolated', 'Standalone']);
        check(graph.degreeOf('Isolated')).equals(0);
        check(graph.degreeOf('Standalone')).equals(0);
      });

      test('semicolon-delimited statements', () {
        const source = 'flowchart TD; A-->B; B-->C; D;';
        final graph = GraphFactory<String, void>().fromMermaid(source);
        check(graph.vertices).unorderedEquals(['A', 'B', 'C', 'D']);
        check(graph.edges.length).equals(2);
      });

      test('unescaping characters', () {
        const source = '''
flowchart TD
  A["Node with #quot;quotes#quot; and #91;brackets#93;"] -->|#124;pipe#124;| B
''';
        final graph = GraphFactory<String, String>().fromMermaid(source);
        check(graph.vertices)
            .unorderedEquals(['Node with "quotes" and [brackets]', 'B']);
        check(graph.getEdge('Node with "quotes" and [brackets]', 'B')?.value)
            .equals('|pipe|');
      });

      test('subgraphs ignored cleanly', () {
        const source = '''
flowchart TD
  subgraph Cluster A
    A1 --> A2
  end
  subgraph Cluster B
    B1 --> B2
  end
  A2 --> B1
''';
        final graph = GraphFactory<String, void>().fromMermaid(source);
        check(graph.vertices).unorderedEquals(['A1', 'A2', 'B1', 'B2']);
        check(graph.edges.length).equals(3);
      });

      test('directives and styles ignored cleanly', () {
        const source = '''
flowchart TD
  A --> B
  style A fill:#f9f,stroke:#333,stroke-width:4px
  classDef special fill:#bbf,stroke:#f66
  class B special
  click A "https://dart.dev" "Dart"
''';
        final graph = GraphFactory<String, void>().fromMermaid(source);
        check(graph.vertices).unorderedEquals(['A', 'B']);
        check(graph.edges.length).equals(1);
      });

      test('custom vertexParser and edgeParser', () {
        const source = '''
flowchart TD
  n1["First"] -->|weight: 100| n2["Second"]
''';
        final graph = GraphFactory<int, int>().fromMermaid(
          source,
          vertexParser: (id, label) => int.parse(id.replaceAll('n', '')),
          edgeParser: (label) => int.parse(label!.replaceAll('weight: ', '')),
        );
        check(graph.vertices).unorderedEquals([1, 2]);
        check(graph.getEdge(1, 2)?.value).equals(100);
      });

      test('round-trip serialization', () {
        final original = Graph<String, num>(isDirected: true)
          ..addEdge('Alpha', 'Beta', value: 15)
          ..addEdge('Beta', 'Gamma', value: 30)
          ..addEdge('Beta', 'Delta', value: 45)
          ..addVertex('Epsilon');

        final mermaidText = original.toMermaid();
        final reconstructed = GraphFactory<String, num>(isDirected: true)
            .fromMermaid(mermaidText);

        check(reconstructed.vertices).unorderedEquals(original.vertices);
        check(reconstructed.edges.length).equals(original.edges.length);
        for (final edge in original.edges) {
          final targetEdge = reconstructed.getEdge(edge.source, edge.target);
          check(targetEdge).isNotNull();
          check(targetEdge?.value).equals(edge.value);
        }
      });
    });
  });
}
