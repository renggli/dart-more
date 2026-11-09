import 'dart:math' as math;
import 'dart:typed_data';

/// 2D Quadtree for Barnes-Hut $O(n \log n)$ repulsive force approximation.
final class Quadtree {
  new({
    required this.minX,
    required this.minY,
    required this.size,
    this.depth = 0,
  });

  final double minX;
  final double minY;
  final double size;
  final int depth;

  int mass = 0;
  double cx = 0.0;
  double cy = 0.0;

  int? vertexIndex;
  double? pointX;
  double? pointY;

  Quadtree? nw;
  Quadtree? ne;
  Quadtree? sw;
  Quadtree? se;

  bool get isLeaf => nw == null && ne == null && sw == null && se == null;

  /// Builds a quadtree containing all vertices.
  static Quadtree build(
    Float64List posX,
    Float64List posY,
    int n, {
    double? minX,
    double? minY,
    double? size,
  }) {
    if (minX == null || minY == null || size == null) {
      var x1 = double.infinity;
      var y1 = double.infinity;
      var x2 = -double.infinity;
      var y2 = -double.infinity;
      for (var i = 0; i < n; i++) {
        final x = posX[i];
        final y = posY[i];
        if (x < x1) x1 = x;
        if (x > x2) x2 = x;
        if (y < y1) y1 = y;
        if (y > y2) y2 = y;
      }
      minX = x1;
      minY = y1;
      size = math.max(10.0, math.max(x2 - x1, y2 - y1) + 1.0);
    }

    final tree = Quadtree(minX: minX, minY: minY, size: size);
    for (var i = 0; i < n; i++) {
      tree.insert(i, posX[i], posY[i]);
    }
    return tree;
  }

  /// Inserts vertex [index] at coordinate `(x, y)`.
  void insert(int index, double x, double y) {
    if (mass == 0) {
      vertexIndex = index;
      pointX = x;
      pointY = y;
      cx = x;
      cy = y;
      mass = 1;
      return;
    }

    if (depth >= 30 || size < 1e-6) {
      cx = (cx * mass + x) / (mass + 1);
      cy = (cy * mass + y) / (mass + 1);
      mass++;
      return;
    }

    if (isLeaf) {
      final oldIndex = vertexIndex!;
      final oldX = pointX!;
      final oldY = pointY!;
      vertexIndex = null;
      pointX = null;
      pointY = null;

      _subdivide();
      _insertIntoChild(oldIndex, oldX, oldY);
      _insertIntoChild(index, x, y);
    } else {
      _insertIntoChild(index, x, y);
    }

    cx = (cx * mass + x) / (mass + 1);
    cy = (cy * mass + y) / (mass + 1);
    mass++;
  }

  void _subdivide() {
    final half = size / 2.0;
    final d = depth + 1;
    nw = Quadtree(minX: minX, minY: minY, size: half, depth: d);
    ne = Quadtree(minX: minX + half, minY: minY, size: half, depth: d);
    sw = Quadtree(minX: minX, minY: minY + half, size: half, depth: d);
    se = Quadtree(minX: minX + half, minY: minY + half, size: half, depth: d);
  }

  void _insertIntoChild(int index, double x, double y) {
    final half = size / 2.0;
    final midX = minX + half;
    final midY = minY + half;

    if (x < midX) {
      if (y < midY) {
        nw!.insert(index, x, y);
      } else {
        sw!.insert(index, x, y);
      }
    } else {
      if (y < midY) {
        ne!.insert(index, x, y);
      } else {
        se!.insert(index, x, y);
      }
    }
  }

  /// Computes the repulsive force exerted by the tree on vertex [targetIndex].
  void accumulateRepulsion(
    int targetIndex,
    double targetX,
    double targetY,
    double k2,
    double theta,
    Float64List dispX,
    Float64List dispY,
    math.Random rng,
  ) {
    if (mass == 0) return;

    if (isLeaf) {
      if (vertexIndex != null && vertexIndex != targetIndex) {
        var dx = targetX - pointX!;
        var dy = targetY - pointY!;
        var dist = math.sqrt(dx * dx + dy * dy);
        if (dist < 0.01) {
          dx = (rng.nextDouble() - 0.5) * 2.0;
          dy = (rng.nextDouble() - 0.5) * 2.0;
          dist = 0.01;
        }
        final force = k2 / dist;
        dispX[targetIndex] += (dx / dist) * force;
        dispY[targetIndex] += (dy / dist) * force;
      }
      return;
    }

    var dx = targetX - cx;
    var dy = targetY - cy;
    var dist = math.sqrt(dx * dx + dy * dy);
    if (dist < 0.01) {
      dx = (rng.nextDouble() - 0.5) * 2.0;
      dy = (rng.nextDouble() - 0.5) * 2.0;
      dist = 0.01;
    }

    if (size / dist < theta) {
      final force = (k2 / dist) * mass;
      dispX[targetIndex] += (dx / dist) * force;
      dispY[targetIndex] += (dy / dist) * force;
    } else {
      nw?.accumulateRepulsion(
        targetIndex,
        targetX,
        targetY,
        k2,
        theta,
        dispX,
        dispY,
        rng,
      );
      ne?.accumulateRepulsion(
        targetIndex,
        targetX,
        targetY,
        k2,
        theta,
        dispX,
        dispY,
        rng,
      );
      sw?.accumulateRepulsion(
        targetIndex,
        targetX,
        targetY,
        k2,
        theta,
        dispX,
        dispY,
        rng,
      );
      se?.accumulateRepulsion(
        targetIndex,
        targetX,
        targetY,
        k2,
        theta,
        dispX,
        dispY,
        rng,
      );
    }
  }
}
