import 'package:more/graph.dart';

/// Default visual constants for vertex sizing in layout algorithms.
const double defaultNodeRadius = 20.0;
const double defaultNodeHeight = 48.0;
const double minNodeWidth = 48.0;
const double charWidthEstimate = 8.5;
const double nodeHorizontalPadding = 24.0;

/// Available layout engine algorithms.
enum LayoutEngine {
  stress('stress', 'Stress Majorization'),
  force('force', 'Force-Directed'),
  layered('layered', 'Layered'),
  tree('tree', 'Tree'),
  radial('radial', 'Radial'),
  shell('shell', 'Shell'),
  spectral('spectral', 'Spectral'),
  circular('circular', 'Circular'),
  grid('grid', 'Grid'),
  random('random', 'Random');

  new(this.id, this.label);

  /// Engine identifier matching serialized modifier configuration.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [LayoutEngine] by [id], defaulting to [LayoutEngine.stress].
  static LayoutEngine fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => LayoutEngine.stress);
}

/// Flow direction for hierarchical and layered graph layouts.
enum RankDir {
  tb('TB', 'Top → Bottom'),
  lr('LR', 'Left → Right'),
  bt('BT', 'Bottom → Top'),
  rl('RL', 'Right → Left');

  new(this.id, this.label);

  /// Direction identifier matching serialized modifier configuration.
  final String id;

  /// User-visible display label.
  final String label;

  /// Looks up [RankDir] by [id], defaulting to [RankDir.tb].
  static RankDir fromId(String id) =>
      values.firstWhere((e) => e.id == id, orElse: () => RankDir.tb);

  /// Converts this direction to MoreDart [LayoutOrientation].
  LayoutOrientation toOrientation() => switch (this) {
    RankDir.lr => LayoutOrientation.leftToRight,
    RankDir.rl => LayoutOrientation.rightToLeft,
    RankDir.bt => LayoutOrientation.bottomToTop,
    RankDir.tb => LayoutOrientation.topToBottom,
  };
}
