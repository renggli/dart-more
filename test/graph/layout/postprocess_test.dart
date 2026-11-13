import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('normalized', () {
    test('translates bounds to origin', () {
      final initial = LayoutResult<String>(
        positions: const {
          'A': LayoutPoint(100, 200),
          'B': LayoutPoint(300, 400),
        },
      );
      final normalized = initial.normalized();
      check(normalized.bounds.minX).equals(0.0);
      check(normalized.bounds.minY).equals(0.0);
      check(normalized['A']).equals(const LayoutPoint(0, 0));
      check(normalized['B']).equals(const LayoutPoint(200, 200));

      // Idempotence
      final doubleNormalized = normalized.normalized();
      check(doubleNormalized['A']).equals(const LayoutPoint(0, 0));
      check(doubleNormalized['B']).equals(const LayoutPoint(200, 200));
    });

    test('custom origin', () {
      final initial = LayoutResult<String>(
        positions: const {'A': LayoutPoint(10, 20)},
      );
      final normalized = initial.normalized(origin: const LayoutPoint(5, 5));
      check(normalized['A']).equals(const LayoutPoint(5, 5));
    });
  });

  group('fit', () {
    final initial = LayoutResult<String>(
      positions: const {
        'A': LayoutPoint(0, 0),
        'B': LayoutPoint(100, 0),
        'C': LayoutPoint(100, 100),
        'D': LayoutPoint(0, 100),
      },
      bounds: const LayoutRectangle(0, 0, 100, 100),
    );

    test('contain mode', () {
      final fitted = initial.fit(
        const LayoutRectangle(0, 0, 500, 500),
        margin: 50,
        mode: FitMode.contain,
      );
      check(fitted.bounds.minX).isGreaterThan(49.99);
      check(fitted.bounds.maxX).isLessThan(450.01);
      check(fitted.bounds.minY).isGreaterThan(49.99);
      check(fitted.bounds.maxY).isLessThan(450.01);
    });

    test('stretch mode scales axes independently', () {
      final fitted = initial.fit(
        const LayoutRectangle(0, 0, 1000, 200),
        margin: 0,
        mode: FitMode.stretch,
      );
      check(fitted.bounds.width).isGreaterThan(990.0);
      check(fitted.bounds.height).isLessThan(210.0);
    });

    test('shrinkOnly does not enlarge smaller layout', () {
      final fitted = initial.fit(
        const LayoutRectangle(0, 0, 1000, 1000),
        margin: 0,
        mode: FitMode.shrinkOnly,
      );
      check(fitted.bounds.width).equals(100.0);
      check(fitted.bounds.height).equals(100.0);
    });

    test('growOnly does not shrink larger layout', () {
      final fitted = initial.fit(
        const LayoutRectangle(0, 0, 50, 50),
        margin: 0,
        mode: FitMode.growOnly,
      );
      check(fitted.bounds.width).equals(100.0);
      check(fitted.bounds.height).equals(100.0);
    });

    test('fit transforms edge routes', () {
      final withRoutes = LayoutResult<String>(
        positions: const {'A': LayoutPoint(0, 0), 'B': LayoutPoint(100, 100)},
        edgeRoutes: const {
          ('A', 'B'): [
            LayoutPoint(0, 0),
            LayoutPoint(50, 50),
            LayoutPoint(100, 100),
          ],
        },
        bounds: const LayoutRectangle(0, 0, 100, 100),
      );
      final fitted = withRoutes.fit(
        const LayoutRectangle(0, 0, 200, 200),
        margin: 0,
        mode: FitMode.stretch,
      );
      final route = fitted.edgeRoutes[('A', 'B')]!;
      check(route.length).equals(3);
      check(route[1].x).equals(100.0);
      check(route[1].y).equals(100.0);
    });
  });

  group('packComponents', () {
    test('empty components return empty', () {
      final packed = packComponents<String>([]);
      check(packed.positions).isEmpty();
    });

    test('single component is returned as is', () {
      final single = LayoutResult<String>(
        positions: const {'A': LayoutPoint(10, 20)},
      );
      final packed = packComponents([single]);
      check(packed.positions.length).equals(1);
    });

    test('multiple components are packed without overlap', () {
      final c1 = LayoutResult<String>(
        positions: const {'A': LayoutPoint(0, 0), 'B': LayoutPoint(50, 50)},
        bounds: const LayoutRectangle(0, 0, 50, 50),
        edgeRoutes: const {
          ('A', 'B'): [LayoutPoint(0, 0), LayoutPoint(50, 50)],
        },
      );
      final c2 = LayoutResult<String>(
        positions: const {'C': LayoutPoint(0, 0), 'D': LayoutPoint(60, 60)},
        bounds: const LayoutRectangle(0, 0, 60, 60),
      );
      final packed = packComponents([c1, c2], vertexDistance: 20);
      check(packed.positions.keys).unorderedEquals(['A', 'B', 'C', 'D']);
      check(packed.edgeRoutes).isNotEmpty();

      // Check distance between vertices across components
      final posB = packed['B']!;
      final posC = packed['C']!;
      final dist = posB.distanceTo(posC);
      check(dist).isGreaterThan(10.0);
    });
  });

  group('removeOverlaps', () {
    test('pushes overlapping nodes apart', () {
      final input = LayoutInput<String>(
        vertices: const ['A', 'B'],
        successorsOf: (_) => const [],
        vertexSize: (_) => const (width: 40.0, height: 40.0),
      );
      final initial = LayoutResult<String>(
        positions: const {
          'A': LayoutPoint(10, 10),
          'B': LayoutPoint(12, 10), // Overlapping heavily horizontally
        },
      );
      final resolved = initial.removeOverlaps(input, padding: 5);
      final posA = resolved['A']!;
      final posB = resolved['B']!;
      final dist = posA.distanceTo(posB);
      check(dist).isGreaterThan(44.0);
    });

    test('pushes overlapping nodes apart vertically when dy is smaller', () {
      final input = LayoutInput<String>(
        vertices: const ['A', 'B'],
        successorsOf: (_) => const [],
        vertexSize: (_) => const (width: 40.0, height: 40.0),
      );
      final initial = LayoutResult<String>(
        positions: const {
          'A': LayoutPoint(10, 10),
          'B': LayoutPoint(10, 12), // Overlapping heavily vertically
        },
      );
      final resolved = initial.removeOverlaps(input, padding: 5);
      final posA = resolved['A']!;
      final posB = resolved['B']!;
      final dist = posA.distanceTo(posB);
      check(dist).isGreaterThan(44.0);
    });

    test('pushes collinear vertex off horizontal edge', () {
      final input = LayoutInput<String>(
        vertices: const ['A', 'B', 'C'],
        successorsOf: (v) => v == 'A' ? const ['B'] : const [],
        vertexSize: (_) => const (width: 30.0, height: 30.0),
      );
      final initial = LayoutResult<String>(
        positions: const {
          'A': LayoutPoint(0, 0),
          'B': LayoutPoint(100, 0),
          'C': LayoutPoint(50, 0), // Centered on edge A-B
        },
      );
      final resolved = initial.removeOverlaps(input, padding: 5);
      final posC = resolved['C']!;
      // C should be pushed vertically away from the A-B edge
      check(posC.y.abs()).isGreaterThan(18.0);
    });

    test('pushes collinear vertex off diagonal edge', () {
      final input = LayoutInput<String>(
        vertices: const ['A', 'B', 'C'],
        successorsOf: (v) => v == 'A' ? const ['B'] : const [],
        vertexSize: (_) => const (width: 30.0, height: 30.0),
      );
      final initial = LayoutResult<String>(
        positions: const {
          'A': LayoutPoint(0, 0),
          'B': LayoutPoint(100, 100),
          'C': LayoutPoint(50, 50), // Directly on diagonal edge A-B
        },
      );
      final resolved = initial.removeOverlaps(input, padding: 5);
      final posA = resolved['A']!;
      final posB = resolved['B']!;
      final posC = resolved['C']!;
      // Distance from C to line segment AB
      final dx = posB.x - posA.x;
      final dy = posB.y - posA.y;
      final t =
          ((posC.x - posA.x) * dx + (posC.y - posA.y) * dy) /
          (dx * dx + dy * dy);
      final projX = posA.x + t * dx;
      final projY = posA.y + t * dy;
      final dist = LayoutPoint(
        posC.x,
        posC.y,
      ).distanceTo(LayoutPoint(projX, projY));
      check(dist).isGreaterThan(18.0);
    });
  });
}
