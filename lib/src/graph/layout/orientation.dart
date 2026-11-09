import 'geometry.dart';

/// Layout flow direction for hierarchical or tree layouts.
enum LayoutOrientation {
  /// Flow top to bottom (vertical descending).
  topToBottom,

  /// Flow bottom to top (vertical ascending).
  bottomToTop,

  /// Flow left to right (horizontal ascending).
  leftToRight,

  /// Flow right to left (horizontal descending).
  rightToLeft;

  /// Whether this orientation flows horizontally.
  bool get isHorizontal =>
      this == LayoutOrientation.leftToRight ||
      this == LayoutOrientation.rightToLeft;

  /// Whether this orientation flows vertically.
  bool get isVertical => !isHorizontal;

  /// Transforms a `(crossAxis, depthAxis)` coordinate into a 2D [LayoutPoint].
  LayoutPoint apply({required double crossAxis, required double depthAxis}) =>
      switch (this) {
        LayoutOrientation.topToBottom => LayoutPoint(crossAxis, depthAxis),
        LayoutOrientation.bottomToTop => LayoutPoint(crossAxis, -depthAxis),
        LayoutOrientation.leftToRight => LayoutPoint(depthAxis, crossAxis),
        LayoutOrientation.rightToLeft => LayoutPoint(-depthAxis, crossAxis),
      };

  /// Returns the dimension of [size] along the cross axis (sibling direction).
  double crossAxisExtent(LayoutSize size) =>
      isHorizontal ? size.height : size.width;

  /// Returns the dimension of [size] along the depth axis (layer/level direction).
  double depthAxisExtent(LayoutSize size) =>
      isHorizontal ? size.width : size.height;
}
