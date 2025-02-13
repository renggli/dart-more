import 'dart:math';

import 'package:meta/meta.dart';

import 'factory/builder.dart';
import 'strategy.dart';

/// Factory methods to create common graphs types efficiently.
class GraphFactory<V, E> {
  GraphFactory({
    this.isDirected = true,
    this.isUnmodifiable = false,
    this.vertexProvider,
    this.edgeProvider,
    Random? random,
    StorageStrategy<V>? vertexStrategy,
  }) : random = random ?? Random(),
       vertexStrategy = vertexStrategy ?? StorageStrategy<V>.defaultStrategy();

  /// Flag indicating if the graph is directed.
  final bool isDirected;

  /// Flag indicating if the resulting graph can be further modified.
  final bool isUnmodifiable;

  /// Optional provider of vertex data.
  final V Function(int index)? vertexProvider;

  /// Optional provider of edge data.
  final E Function(V source, V target)? edgeProvider;

  /// Random generator used when creating random graphs.
  final Random random;

  /// The strategy describing how vertices are stored.
  final StorageStrategy<V> vertexStrategy;

  /// Internal graph builder based on this configuration.
  @internal
  GraphBuilder<V, E> newBuilder() => GraphBuilder<V, E>(this);
}
