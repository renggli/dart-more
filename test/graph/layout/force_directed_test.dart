import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('forceDirectedLayout', () {
    test('empty vertices', () {
      final layout = LayoutGraph<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      final result = layout.forceDirected();
      check(result.positions).isEmpty();
    });

    test('single vertex centered', () {
      final layout = LayoutGraph<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      final result = layout.forceDirected(
        bounds: const LayoutRect(minX: 0, minY: 0, maxX: 400, maxY: 400),
      );
      check(result.positions.length).equals(1);
      check(result['A']?.x).equals(200.0);
      check(result['A']?.y).equals(200.0);
    });

    test('two connected nodes repel from collision and stay bounded', () {
      const bounds = LayoutRect(minX: 0, minY: 0, maxX: 600, maxY: 400);
      final adj = <String, List<String>>{
        'A': ['B'],
        'B': ['A'],
      };
      final layout = LayoutGraph<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => adj[v] ?? const [],
        vertexWidth: (_) => 50,
        vertexHeight: (_) => 50,
      );
      final result = layout.forceDirected(
        iterations: 60,
        bounds: bounds,
        seed: 42,
        spacing: 30,
      );

      check(result.positions.length).equals(2);
      final pA = result['A']!;
      final pB = result['B']!;
      final dist = pA.distanceTo(pB);
      // Nodes must be pushed apart beyond their collision distance
      check(dist).isGreaterThan(50.0);
    });

    test('graph extension on triangle graph', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addEdge('C', 'A');

      final result = graph.layout().forceDirected(
        iterations: 60,
        bounds: const LayoutRect(minX: 0, minY: 0, maxX: 500, maxY: 500),
        seed: 123,
      );

      check(result.positions.length).equals(3);
      final ab = result['A']!.distanceTo(result['B']!);
      final bc = result['B']!.distanceTo(result['C']!);
      final ca = result['C']!.distanceTo(result['A']!);

      check(ab).isGreaterThan(20.0);
      check(bc).isGreaterThan(20.0);
      check(ca).isGreaterThan(20.0);
    });
  });
}
