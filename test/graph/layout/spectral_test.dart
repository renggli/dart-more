import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('SpectralLayout', () {
    test('empty vertices', () {
      final input = LayoutInput<String>(
        vertices: const [],
        successorsOf: (_) => const [],
      );
      const strategy = SpectralLayout<String>();
      final result = strategy.layout(input);
      check(result.positions).isEmpty();
    });

    test('single vertex at center', () {
      final input = LayoutInput<String>(
        vertices: ['A'],
        successorsOf: (_) => const [],
      );
      const strategy = SpectralLayout<String>(center: LayoutPoint(50, 50));
      final result = strategy.layout(input);
      check(result['A']).equals(const LayoutPoint(50, 50));
    });

    test('two vertices placed symmetrically', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B'],
        successorsOf: (v) => v == 'A' ? ['B'] : const [],
      );
      const strategy = SpectralLayout<String>(
        scale: 100,
        center: LayoutPoint(0, 0),
      );
      final result = strategy.layout(input);
      check(result['A']).equals(const LayoutPoint(-50, 0));
      check(result['B']).equals(const LayoutPoint(50, 0));
    });

    test('deterministic with seed', () {
      final input = LayoutInput<int>(
        vertices: [1, 2, 3, 4],
        successorsOf: (v) => [(v % 4) + 1],
      );
      const strategy = SpectralLayout<int>(seed: 42);
      final r1 = strategy.layout(input);
      final r2 = strategy.layout(input);
      check(r1[1]).equals(r2[1]);
      check(r1[2]).equals(r2[2]);
      check(r1[3]).equals(r2[3]);
      check(r1[4]).equals(r2[4]);
    });

    test('disconnected components packed', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (v) => switch (v) {
          'A' => ['B'],
          'B' => ['A'],
          'C' => ['D'],
          'D' => ['C'],
          _ => const [],
        },
      );
      const strategy = SpectralLayout<String>();
      final result = strategy.layout(input);
      check(result.positions.keys).unorderedEquals(['A', 'B', 'C', 'D']);
    });
  });
}
