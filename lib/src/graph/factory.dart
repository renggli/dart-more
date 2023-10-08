import 'dart:math';

import 'package:meta/meta.dart';

import 'factory/builder.dart';
import 'strategy.dart';

typedef VertexProvider<V> = V Function(int index);
typedef EdgeProvider<V, E> = E Function(V source, V target);

/// Factory methods to create commmon graphs types efficiently.
class GraphFactory<V, E> {
  GraphFactory({
    this.isDirected = true,
    this.isUnmodifiable = false,
    this.vertexProvider,
    this.edgeProvider,
    Random? random,
    StorageStrategy<V>? vertexStrategy,
  })  : random = random ?? Random(),
        vertexStrategy = vertexStrategy ?? StorageStrategy<V>.defaultStrategy();

  /// Flag indicating if the graph is directed.
  final bool isDirected;

  /// Flag indicating if the resulting graph can be further modified.
  final bool isUnmodifiable;

  /// Optional provider of vertex data.
  final VertexProvider<V>? vertexProvider;

  /// Optional provider of edge data.
  final EdgeProvider<V, E>? edgeProvider;

  /// Random generator used when creating random graphs.
  final Random random;

  /// The strategy describing how vertices are stored.
  final StorageStrategy<V> vertexStrategy;

  /// Internal factory to create a graph without depending on the underlying
  /// implementation.
  @internal
  GraphBuilder<V, E> newBuilder() => GraphBuilder<V, E>(this);
}
