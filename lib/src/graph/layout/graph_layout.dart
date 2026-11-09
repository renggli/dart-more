import 'dart:math' as math;

import '../strategy.dart';
import 'geometry.dart';

/// Immutable graph topology and sizing input provided to layout algorithms.
final class LayoutInput<V> {
  /// Constructs a layout input.
  new({
    required Iterable<V> vertices,
    required this.successorsOf,
    this.predecessorsOf,
    this.vertexSize,
    this.edgeWeight,
    this.vertexStrategy,
  }) : vertices = List<V>.unmodifiable(vertices);

  /// Materialized list of vertices to lay out.
  final List<V> vertices;

  /// Function returning the outgoing successors of a vertex.
  final Iterable<V> Function(V vertex) successorsOf;

  /// Function returning the incoming predecessors of a vertex (null if undirected).
  final Iterable<V> Function(V vertex)? predecessorsOf;

  /// Optional function returning the `(width, height)` size of a vertex.
  final LayoutSize Function(V vertex)? vertexSize;

  /// Optional function returning the weight of an edge between two vertices.
  final num Function(V source, V target)? edgeWeight;

  /// Optional storage strategy for vertex collections.
  final StorageStrategy<V>? vertexStrategy;

  /// Default vertex size `(40, 40)`.
  static const LayoutSize defaultSize = (width: 40.0, height: 40.0);

  /// Whether the input topology is directed.
  bool get isDirected => predecessorsOf != null;

  /// Returns the `(width, height)` size for [vertex].
  LayoutSize sizeOf(V vertex) => vertexSize?.call(vertex) ?? defaultSize;

  /// Returns the width of [vertex].
  double widthOf(V vertex) => sizeOf(vertex).width;

  /// Returns the height of [vertex].
  double heightOf(V vertex) => sizeOf(vertex).height;

  /// Returns the bounding diagonal diameter of [vertex].
  double diameterOf(V vertex) {
    final size = sizeOf(vertex);
    final (w, h) = (size.width, size.height);
    return math.sqrt(w * w + h * h);
  }

  /// Returns the weight of the edge between [source] and [target].
  num weightOf(V source, V target) => edgeWeight?.call(source, target) ?? 1.0;

  Map<V, Set<V>>? _cachedNeighbours;

  /// Returns the undirected neighbours (adjacent vertices) of [vertex].
  Iterable<V> neighboursOf(V vertex) {
    var cached = _cachedNeighbours;
    if (cached == null) {
      final map = vertexStrategy?.createMap<Set<V>>() ?? <V, Set<V>>{};
      for (final v in vertices) {
        map[v] = vertexStrategy?.createSet() ?? <V>{};
      }
      for (final v in vertices) {
        for (final next in successorsOf(v)) {
          map[v]?.add(next);
          if (predecessorsOf == null) {
            map[next]?.add(v);
          }
        }
        if (predecessorsOf != null) {
          for (final prev in predecessorsOf!(v)) {
            map[v]?.add(prev);
          }
        }
      }
      _cachedNeighbours = cached = map;
    }
    return cached[vertex] ?? const [];
  }
}

/// Abstract strategy interface for graph layout algorithms.
abstract interface class GraphLayout<V> {
  /// Computes vertex positions and optional edge routes for [input].
  LayoutResult<V> layout(LayoutInput<V> input);
}

/// The result of calculating a 2D graph layout.
final class LayoutResult<V> {
  /// Constructs a layout result.
  new({
    required Map<V, LayoutPoint> positions,
    Map<(V, V), List<LayoutPoint>> edgeRoutes = const {},
    this.vertexSizes,
    this._bounds,
  }) : positions = Map<V, LayoutPoint>.unmodifiable(positions),
       edgeRoutes = Map<(V, V), List<LayoutPoint>>.unmodifiable(edgeRoutes);

  /// Empty layout result.
  static LayoutResult<V> empty<V>() => LayoutResult<V>(
    positions: const {},
    bounds: const LayoutRectangle(0, 0, 0, 0),
  );

  /// Map associating each vertex with its computed center [LayoutPoint].
  final Map<V, LayoutPoint> positions;

  /// Optional control/routing points for edges.
  final Map<(V, V), List<LayoutPoint>> edgeRoutes;

  /// Optional map of vertex sizes used for bounds and collision calculation.
  final Map<V, LayoutSize>? vertexSizes;

  LayoutRectangle? _bounds;

  /// Bounding rectangle enclosing all vertex extents and edge routes.
  LayoutRectangle get bounds {
    var cached = _bounds;
    if (cached == null) {
      if (positions.isEmpty) {
        return _bounds = const LayoutRectangle(0, 0, 0, 0);
      }
      var minX = double.infinity;
      var minY = double.infinity;
      var maxX = -double.infinity;
      var maxY = -double.infinity;
      for (final entry in positions.entries) {
        final p = entry.value;
        final size = vertexSizes?[entry.key];
        final halfW = (size?.width ?? 0.0) / 2.0;
        final halfH = (size?.height ?? 0.0) / 2.0;
        final left = p.x - halfW;
        final top = p.y - halfH;
        final right = p.x + halfW;
        final bottom = p.y + halfH;
        if (left < minX) minX = left;
        if (top < minY) minY = top;
        if (right > maxX) maxX = right;
        if (bottom > maxY) maxY = bottom;
      }
      for (final route in edgeRoutes.values) {
        for (final p in route) {
          if (p.x < minX) minX = p.x;
          if (p.y < minY) minY = p.y;
          if (p.x > maxX) maxX = p.x;
          if (p.y > maxY) maxY = p.y;
        }
      }
      _bounds = cached = LayoutRectangle(minX, minY, maxX - minX, maxY - minY);
    }
    return cached;
  }

  /// Accesses the position for [vertex].
  LayoutPoint? operator [](V vertex) => positions[vertex];

  /// Transforms all positions and routes using [f].
  LayoutResult<V> transform(
    LayoutPoint Function(V vertex, LayoutPoint point) f,
  ) {
    final newPositions = <V, LayoutPoint>{};
    for (final entry in positions.entries) {
      newPositions[entry.key] = f(entry.key, entry.value);
    }
    final newRoutes = <(V, V), List<LayoutPoint>>{};
    for (final entry in edgeRoutes.entries) {
      final edge = entry.key;
      newRoutes[edge] = [for (final pt in entry.value) f(edge.$1, pt)];
    }
    return LayoutResult<V>(
      positions: newPositions,
      edgeRoutes: newRoutes,
      vertexSizes: vertexSizes,
    );
  }
}
