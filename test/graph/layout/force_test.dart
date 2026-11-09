import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('ForceLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = ForceLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('single vertex centered', () {
      final input = LayoutInput<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      const strategy = ForceLayout<String>(
        bounds: LayoutRectangle(0, 0, 400, 400),
      );
      final result = strategy.layout(input);
      check(result.positions.length).equals(1);
      check(result['A']?.x).equals(200.0);
      check(result['A']?.y).equals(200.0);
    });

    test('deterministic with seed', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => switch (v) {
          'A' => ['B'],
          'B' => ['C'],
          _ => const [],
        },
      );
      const strategy = ForceLayout<String>(seed: 123);
      final r1 = strategy.layout(input);
      final r2 = strategy.layout(input);
      check(r1['A']).equals(r2['A']);
      check(r1['B']).equals(r2['B']);
      check(r1['C']).equals(r2['C']);
    });

    test('pinned vertices unchanged', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => v == 'A' ? ['B'] : const [],
      );
      const pinnedPos = LayoutPoint(50, 50);
      const strategy = ForceLayout<String>(
        pinned: {'A'},
        initialPositions: {'A': pinnedPos},
        seed: 42,
      );
      final result = strategy.layout(input);
      check(result['A']).equals(pinnedPos);
    });

    test('connected vertices closer than unconnected on average', () {
      // 1-2-3-4-5 path
      final input = LayoutInput<int>(
        vertices: [1, 2, 3, 4, 5],
        successorsOf: (v) => [if (v > 1) v - 1, if (v < 5) v + 1],
      );
      const strategy = ForceLayout<int>(
        config: ForceConfig(iterations: 150),
        seed: 42,
      );
      final result = strategy.layout(input);

      // Distance 1-2 vs distance 1-5
      final d12 = result[1]!.distanceTo(result[2]!);
      final d15 = result[1]!.distanceTo(result[5]!);
      check(d12).isLessThan(d15);
    });

    test('Barnes-Hut mode runs and stays bounded', () {
      final input = LayoutInput<int>(
        vertices: List.generate(20, (i) => i),
        successorsOf: (v) => [(v + 1) % 20],
      );
      const strategy = ForceLayout<int>(
        config: ForceConfig(
          iterations: 50,
          repulsionMode: RepulsionMode.barnesHut,
        ),
        bounds: LayoutRectangle(0, 0, 500, 500),
        seed: 99,
      );
      final result = strategy.layout(input);
      check(result.positions.length).equals(20);
      for (final p in result.positions.values) {
        check(p.x).isGreaterThan(0.0);
        check(p.x).isLessThan(500.0);
        check(p.y).isGreaterThan(0.0);
        check(p.y).isLessThan(500.0);
      }
    });

    test('smoke test 2,000 vertices runs under time limit', () {
      final input = LayoutInput<int>(
        vertices: List.generate(2000, (i) => i),
        successorsOf: (v) => [(v + 1) % 2000],
      );
      const strategy = ForceLayout<int>(
        config: ForceConfig(
          iterations: 10,
          repulsionMode: RepulsionMode.barnesHut,
        ),
        seed: 1,
      );
      final stopwatch = Stopwatch()..start();
      final result = strategy.layout(input);
      stopwatch.stop();

      check(result.positions.length).equals(2000);
      check(stopwatch.elapsedMilliseconds).isLessThan(3000);
    });

    test('graph extension', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addEdge('C', 'A');

      final result = graph.layout(
        const ForceLayout(
          config: ForceConfig(iterations: 60),
          bounds: LayoutRectangle(0, 0, 500, 500),
          seed: 123,
        ),
        normalize: false,
      );

      check(result.positions.length).equals(3);
    });
  });
}
