import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('graph extension', () {
    test('authority and hub scores on simple directed structure', () {
      final graph = Graph<String, void>(isDirected: true)
        ..addEdge('H1', 'A1')
        ..addEdge('H1', 'A2')
        ..addEdge('H2', 'A1')
        ..addEdge('H2', 'A2');
      final (auth, hubs) = graph.hits();
      check(auth['A1']! > 0).isTrue;
      check(auth['A2']! > 0).isTrue;
      check(hubs['H1']! > 0).isTrue;
      check(hubs['H2']! > 0).isTrue;
    });

    test('empty graph returns empty records', () {
      final empty = Graph<String, void>(isDirected: true);
      final (auth, hubs) = empty.hits();
      check(auth).isEmpty;
      check(hubs).isEmpty;
    });
  });

  group('standalone', () {
    test('standalone hits function', () {
      final (auth, hubs) = hits<String>(
        vertices: ['H', 'A'],
        successorsOf: (v) => v == 'H' ? ['A'] : const [],
        predecessorsOf: (v) => v == 'A' ? ['H'] : const [],
      );
      check(auth['A']!).isCloseTo(1.0, 1e-6);
      check(hubs['H']!).isCloseTo(1.0, 1e-6);
    });
  });
}
