import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:more/src/graph/layout/support/arc_placement.dart';
import 'package:more/src/graph/layout/support/bfs_levels.dart';
import 'package:more/src/graph/layout/support/components.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('support', () {
    test('bfsLevels assigns correct depths', () {
      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C', 'D'],
        successorsOf: (v) => switch (v) {
          'A' => ['B', 'C'],
          'B' => ['D'],
          _ => const [],
        },
      );
      final levels = bfsLevels(input, ['A']);
      check(levels.length).equals(3);
      check(levels[0]).unorderedEquals(['A']);
      check(levels[1]).unorderedEquals(['B', 'C']);
      check(levels[2]).unorderedEquals(['D']);
    });

    test(
      'components identifies disconnected components in undirected sense',
      () {
        final input = LayoutInput<String>(
          vertices: ['A1', 'A2', 'B1', 'B2', 'Isolated'],
          successorsOf: (v) => switch (v) {
            'A1' => ['A2'],
            'B1' => ['B2'],
            _ => const [],
          },
        );
        final comps = components(input);
        check(comps.length).equals(3);
        final compStrings = comps
            .map((c) => (c.toList()..sort()).join(','))
            .toList();
        check(compStrings).unorderedEquals(['A1,A2', 'B1,B2', 'Isolated']);
      },
    );

    test('arcPlacement places vertices evenly on circle', () {
      final (positions, radius) = arcPlacement<String>(
        vertices: ['A', 'B', 'C', 'D'],
        sizeOf: (_) => const (width: 20.0, height: 20.0),
        radius: 100,
        center: const LayoutPoint(0, 0),
        startAngle: 0,
        sweepAngle: 2 * math.pi,
        vertexDistance: 10,
      );
      check(positions.length).equals(4);
      for (final p in positions.values) {
        check(p.distanceTo(const LayoutPoint(0, 0))).isCloseTo(radius, 1e-4);
      }
    });
  });
}
