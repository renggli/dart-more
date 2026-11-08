import 'dart:math' as math;

import 'graph.dart';

/// Extension on [Graph] providing access to graph layouts.
extension LayoutGraphExtension<V, E> on Graph<V, E> {
  /// Creates a [LayoutGraph] configured with this graph's vertices, topology,
  /// and optional vertex dimensions.
  LayoutGraph<V> layout({
    double Function(V vertex)? vertexWidth,
    double Function(V vertex)? vertexHeight,
    double defaultVertexWidth = 40.0,
    double defaultVertexHeight = 40.0,
  }) => LayoutGraph<V>(
    vertices: vertices,
    successorsOf: successorsOf,
    predecessorsOf: isDirected ? predecessorsOf : successorsOf,
    vertexWidth: vertexWidth,
    vertexHeight: vertexHeight,
    defaultVertexWidth: defaultVertexWidth,
    defaultVertexHeight: defaultVertexHeight,
  );
}

/// A graph layout orchestrator that holds vertices, topology closures, and
/// optional vertex dimension accessors for computing 2D coordinates.
final class LayoutGraph<V> {
  /// Constructs a [LayoutGraph] instance.
  const new({
    required this.vertices,
    required this.successorsOf,
    Iterable<V> Function(V vertex)? predecessorsOf,
    this.vertexWidth,
    this.vertexHeight,
    this.defaultVertexWidth = 40.0,
    this.defaultVertexHeight = 40.0,
  }) : predecessorsOf = predecessorsOf ?? successorsOf;

  /// The vertices to be laid out.
  final Iterable<V> vertices;

  /// Function returning the outgoing successors of a vertex.
  final Iterable<V> Function(V vertex) successorsOf;

  /// Function returning the incoming predecessors of a vertex.
  final Iterable<V> Function(V vertex) predecessorsOf;

  /// Optional function returning the width of a vertex.
  final double Function(V vertex)? vertexWidth;

  /// Optional function returning the height of a vertex.
  final double Function(V vertex)? vertexHeight;

  /// Default vertex width when [vertexWidth] is not provided or returns null.
  final double defaultVertexWidth;

  /// Default vertex height when [vertexHeight] is not provided or returns null.
  final double defaultVertexHeight;

  /// Computes the width of [vertex].
  double widthOf(V vertex) => vertexWidth?.call(vertex) ?? defaultVertexWidth;

  /// Computes the height of [vertex].
  double heightOf(V vertex) =>
      vertexHeight?.call(vertex) ?? defaultVertexHeight;

  /// Returns the bounding diagonal diameter of [vertex].
  double diameterOf(V vertex) {
    final w = widthOf(vertex);
    final h = heightOf(vertex);
    return math.sqrt(w * w + h * h);
  }

  /// Returns all adjacent neighbours (successors and predecessors) of [vertex].
  Iterable<V> neighboursOf(V vertex) => {
    ...successorsOf(vertex),
    ...predecessorsOf(vertex),
  };
}
