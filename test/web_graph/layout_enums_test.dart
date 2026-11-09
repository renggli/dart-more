import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/layout_options.dart';

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
  });
}
