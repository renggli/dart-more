import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/enums.dart';

void main() {
  group('Layout enums', () {
    test('LayoutEngine fromId', () {
      check(LayoutEngine.fromId('stress')).equals(LayoutEngine.stress);
      check(LayoutEngine.fromId('force')).equals(LayoutEngine.force);
      check(LayoutEngine.fromId('layered')).equals(LayoutEngine.layered);
      check(LayoutEngine.fromId('unknown')).equals(LayoutEngine.stress);
    });

    test('RankDir fromId and toOrientation', () {
      check(RankDir.fromId('TB')).equals(RankDir.tb);
      check(RankDir.fromId('LR')).equals(RankDir.lr);
      check(RankDir.fromId('BT')).equals(RankDir.bt);
      check(RankDir.fromId('RL')).equals(RankDir.rl);
      check(RankDir.fromId('unknown')).equals(RankDir.tb);
    });

    test('ForceLayout on Petersen graph', () {
      final g = Graph<String, num>.undirected();
      for (var i = 0; i < 5; i++) {
        g.addEdge('v$i', 'v${(i + 1) % 5}', value: 1);
        g.addEdge('v$i', 'v${i + 5}', value: 1);
        g.addEdge('v${i + 5}', 'v${(i + 2) % 5 + 5}', value: 1);
      }
      const strategy = ForceLayout<String>(
        config: ForceConfig(iterations: 120),
        bounds: LayoutRectangle(80, 80, 720, 520),
        vertexDistance: 40.0,
        seed: 42,
      );
      final result = g.layout(strategy, normalize: false);
      check(result.positions).length.equals(10);
      final fitted = result.fit(
        const LayoutRectangle(120, 100, 660, 460),
        margin: 40,
        mode: FitMode.shrinkOnly,
      );
      check(fitted.positions).length.equals(10);
    });
  });
}
