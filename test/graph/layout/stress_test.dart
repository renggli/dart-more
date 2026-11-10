import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('StressLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = StressLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('single vertex at center', () {
      final input = LayoutInput<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      const strategy = StressLayout<String>(center: LayoutPoint(100, 100));
      final result = strategy.layout(input);
      check(result.positions.length).equals(1);
      check(result['A']).equals(const LayoutPoint(100, 100));
    });

    test('path graph has near-uniform spacing', () {
      final input = LayoutInput<int>(
        vertices: [1, 2, 3, 4],
        successorsOf: (v) => [if (v > 1) v - 1, if (v < 4) v + 1],
      );
      const strategy = StressLayout<int>(vertexDistance: 50);
      final result = strategy.layout(input);

      final d12 = result[1]!.distanceTo(result[2]!);
      final d23 = result[2]!.distanceTo(result[3]!);
      final d34 = result[3]!.distanceTo(result[4]!);

      check((d12 - d23).abs()).isLessThan(15.0);
      check((d23 - d34).abs()).isLessThan(15.0);
    });

    test('cycle becomes near-circular', () {
      final input = LayoutInput<int>(
        vertices: List.generate(6, (i) => i),
        successorsOf: (v) => [(v + 1) % 6, (v + 5) % 6],
      );
      const strategy = StressLayout<int>(
        vertexDistance: 50,
        center: LayoutPoint(0, 0),
      );
      final result = strategy.layout(input);

      final r0 = result[0]!.distanceTo(const LayoutPoint(0, 0));
      for (var i = 1; i < 6; i++) {
        final ri = result[i]!.distanceTo(const LayoutPoint(0, 0));
        check((ri - r0).abs()).isLessThan(10.0);
      }
    });

    test('complete graph symmetric', () {
      final input = LayoutInput<int>(
        vertices: [0, 1, 2, 3],
        successorsOf: (v) => [
          for (var i = 0; i < 4; i++)
            if (i != v) i,
        ],
      );
      const strategy = StressLayout<int>(
        vertexDistance: 60,
        center: LayoutPoint(0, 0),
      );
      final result = strategy.layout(input);

      // In K4, all nodes should be roughly equidistant from the center
      final r0 = result[0]!.distanceTo(const LayoutPoint(0, 0));
      for (var i = 1; i < 4; i++) {
        final ri = result[i]!.distanceTo(const LayoutPoint(0, 0));
        check((ri - r0).abs()).isLessThan(10.0);
      }
    });

    test('disconnected input handled via component packing', () {
      final input = LayoutInput<String>(
        vertices: ['A1', 'A2', 'B1', 'B2'],
        successorsOf: (v) => switch (v) {
          'A1' => ['A2'],
          'A2' => ['A1'],
          'B1' => ['B2'],
          'B2' => ['B1'],
          _ => const [],
        },
      );
      const strategy = StressLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.keys).unorderedEquals(['A1', 'A2', 'B1', 'B2']);
    });

    test('respects vertexSize and prevents overlap on Petersen graph', () {
      final g = Graph<String, num>.undirected();
      for (var i = 0; i < 5; i++) {
        g.addEdge('v$i', 'v${(i + 1) % 5}', value: 1);
        g.addEdge('v$i', 'v${i + 5}', value: 1);
        g.addEdge('v${i + 5}', 'v${(i + 2) % 5 + 5}', value: 1);
      }
      final result = g.layout(
        const StressLayout<String>(vertexDistance: 50.0),
        vertexSize: (_) => (width: 48.0, height: 48.0),
      );
      final pts = result.positions.values.toList();
      for (var i = 0; i < pts.length; i++) {
        for (var j = i + 1; j < pts.length; j++) {
          check(pts[i].distanceTo(pts[j])).isGreaterThan(48.0);
        }
      }
    });
  });
}
