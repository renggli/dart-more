import 'dart:math' as math;

import 'geometry.dart';
import 'graph_layout.dart';
import 'orientation.dart';

/// Positions vertices in a hierarchical tree or forest using the Buchheim-Walker algorithm.
///
/// Builds a depth-first spanning forest and computes aesthetic node coordinates
/// without edge overlaps in $O(V)$ time.
///
/// ```dart
/// final graph = Graph<String, void>.directed()
///   ..addEdge('root', 'left')
///   ..addEdge('root', 'right');
/// final result = graph.layout(const TreeLayout());
/// print(result.positions['root']);
/// ```
final class TreeLayout<V> extends GraphLayout<V> {
  /// Constructs a tree layout strategy.
  const new({
    this.roots,
    this.layerDistance,
    this.vertexDistance = 20.0,
    this.orientation = LayoutOrientation.topToBottom,
  });

  /// Optional roots of the tree/forest.
  ///
  /// If not provided, roots are chosen based on in-degree 0 (for directed graphs)
  /// or maximum degree per component (for undirected graphs).
  final Iterable<V>? roots;

  /// Spacing between consecutive levels/depths of the tree.
  final double? layerDistance;

  /// Spacing between sibling nodes on the cross axis.
  final double vertexDistance;

  /// Flow direction of the tree.
  final LayoutOrientation orientation;

  @override
  bool get packDisconnectedComponents => false;

  @override
  LayoutResult<V> layoutComponent(LayoutInput<V> input) {
    final allVertices = input.vertices;

    final sizes = <V, LayoutSize>{
      for (final v in allVertices) v: input.sizeOf(v),
    };

    var maxDepthDim = 0.0;
    for (final v in allVertices) {
      final dim = orientation.depthAxisExtent(sizes[v]!);
      if (dim > maxDepthDim) maxDepthDim = dim;
    }
    final effectiveLayerDistance =
        layerDistance ?? (maxDepthDim + vertexDistance + 20.0);

    final List<V> effectiveRoots;
    if (roots != null && roots!.isNotEmpty) {
      final set = allVertices.toSet();
      effectiveRoots = roots!.where(set.contains).toList();
    } else {
      final inDegree = <V, int>{for (final v in allVertices) v: 0};
      for (final v in allVertices) {
        for (final child in input.successorsOf(v)) {
          if (inDegree.containsKey(child) && child != v) {
            inDegree[child] = (inDegree[child] ?? 0) + 1;
          }
        }
      }
      final zeroInDegree = allVertices.where((v) => inDegree[v] == 0).toList();
      if (zeroInDegree.isNotEmpty) {
        effectiveRoots = zeroInDegree;
      } else {
        effectiveRoots = [
          allVertices.reduce(
            (a, b) =>
                input.neighboursOf(a).length >= input.neighboursOf(b).length
                ? a
                : b,
          ),
        ];
      }
    }

    final visited = input.vertexStrategy?.createSet() ?? <V>{};
    final forest = <_TreeNode<V>>[];

    for (final root in effectiveRoots) {
      if (visited.add(root)) {
        final node = _TreeNode<V>(value: root);
        _buildTreeDfs(node, input, visited);
        forest.add(node);
      }
    }

    for (final v in allVertices) {
      if (visited.add(v)) {
        final node = _TreeNode<V>(value: v);
        _buildTreeDfs(node, input, visited);
        forest.add(node);
      }
    }

    var currentCrossOffset = 0.0;
    final rawPositions = <V, (double, double)>{};

    for (final rootNode in forest) {
      _initializeNodes(rootNode);
      _firstWalk(rootNode, input, vertexDistance, orientation);
      final minX = _getMinPrelim(rootNode);
      final shift = currentCrossOffset - minX;
      final maxX = _secondWalk(
        rootNode,
        shift,
        0.0,
        effectiveLayerDistance,
        rawPositions,
      );
      final rootDim = orientation.crossAxisExtent(input.sizeOf(rootNode.value));
      currentCrossOffset = maxX + rootDim + vertexDistance;
    }

    final positions = <V, LayoutPoint>{};
    for (final entry in rawPositions.entries) {
      positions[entry.key] = orientation.apply(
        crossAxis: entry.value.$1,
        depthAxis: entry.value.$2,
      );
    }

    return LayoutResult<V>(positions: positions, vertexSizes: sizes);
  }
}

void _buildTreeDfs<V>(
  _TreeNode<V> current,
  LayoutInput<V> input,
  Set<V> visited,
) {
  final nextVertices = input.isDirected
      ? input.successorsOf(current.value)
      : input.neighboursOf(current.value);

  for (final child in nextVertices) {
    if (visited.add(child)) {
      final childNode = _TreeNode<V>(
        value: child,
        parent: current,
        depth: current.depth + 1,
        number: current.children.length,
      );
      current.children.add(childNode);
      _buildTreeDfs(childNode, input, visited);
    }
  }
}

void _initializeNodes<V>(_TreeNode<V> node) {
  node.ancestor = node;
  for (var i = 0; i < node.children.length; i++) {
    node.children[i].number = i;
    _initializeNodes(node.children[i]);
  }
}

void _firstWalk<V>(
  _TreeNode<V> v,
  LayoutInput<V> input,
  double vertexDistance,
  LayoutOrientation orientation,
) {
  if (v.children.isEmpty) {
    if (v.leftSibling != null) {
      final gap = _nodeGap(
        v.leftSibling!.value,
        v.value,
        input,
        vertexDistance,
        orientation,
      );
      v.prelim = v.leftSibling!.prelim + gap;
    } else {
      v.prelim = 0.0;
    }
  } else {
    var defaultAncestor = v.children.first;
    for (final w in v.children) {
      _firstWalk(w, input, vertexDistance, orientation);
      defaultAncestor = _apportion(
        w,
        defaultAncestor,
        input,
        vertexDistance,
        orientation,
      );
    }
    _executeShifts(v);
    final midpoint = (v.children.first.prelim + v.children.last.prelim) / 2.0;
    if (v.leftSibling != null) {
      final gap = _nodeGap(
        v.leftSibling!.value,
        v.value,
        input,
        vertexDistance,
        orientation,
      );
      v.prelim = v.leftSibling!.prelim + gap;
      v.mod = v.prelim - midpoint;
    } else {
      v.prelim = midpoint;
    }
  }
}

_TreeNode<V> _apportion<V>(
  _TreeNode<V> v,
  _TreeNode<V> defaultAncestor,
  LayoutInput<V> input,
  double vertexDistance,
  LayoutOrientation orientation,
) {
  final w = v.leftSibling;
  if (w != null) {
    var vip = v;
    var vop = v;
    var vim = w;
    var vom = vip.leftMostSibling!;
    var sip = vip.mod;
    var sop = vop.mod;
    var sim = vim.mod;
    var som = vom.mod;

    while (vim.nextRight != null && vip.nextLeft != null) {
      vim = vim.nextRight!;
      vip = vip.nextLeft!;
      vom = vom.nextLeft!;
      vop = vop.nextRight!;
      vop.ancestor = v;
      final gap = _nodeGap(
        vim.value,
        vip.value,
        input,
        vertexDistance,
        orientation,
      );
      final shift = (vim.prelim + sim) - (vip.prelim + sip) + gap;
      if (shift > 0) {
        final a = _ancestor(vim, v, defaultAncestor);
        _moveSubtree(a, v, shift);
        sip += shift;
        sop += shift;
      }
      sim += vim.mod;
      sip += vip.mod;
      som += vom.mod;
      sop += vop.mod;
    }
    if (vim.nextRight != null && vop.nextRight == null) {
      vop.thread = vim.nextRight;
      vop.mod += sim - sop;
    }
    if (vip.nextLeft != null && vom.nextLeft == null) {
      vom.thread = vip.nextLeft;
      vom.mod += sip - som;
      defaultAncestor = v;
    }
  }
  return defaultAncestor;
}

double _nodeGap<V>(
  V left,
  V right,
  LayoutInput<V> input,
  double vertexDistance,
  LayoutOrientation orientation,
) {
  final leftExtent = orientation.crossAxisExtent(input.sizeOf(left));
  final rightExtent = orientation.crossAxisExtent(input.sizeOf(right));
  return (leftExtent + rightExtent) / 2.0 + vertexDistance;
}

void _moveSubtree<V>(_TreeNode<V> wl, _TreeNode<V> wr, double shift) {
  final subtrees = wr.number - wl.number;
  if (subtrees > 0) {
    wr.change -= shift / subtrees;
    wr.shift += shift;
    wl.change += shift / subtrees;
    wr.prelim += shift;
    wr.mod += shift;
  }
}

void _executeShifts<V>(_TreeNode<V> v) {
  var shift = 0.0;
  var change = 0.0;
  for (var i = v.children.length - 1; i >= 0; i--) {
    final w = v.children[i];
    w.prelim += shift;
    w.mod += shift;
    change += w.change;
    shift += w.shift + change;
  }
}

_TreeNode<V> _ancestor<V>(
  _TreeNode<V> vim,
  _TreeNode<V> v,
  _TreeNode<V> defaultAncestor,
) {
  if (v.parent != null && v.parent!.children.contains(vim.ancestor)) {
    return vim.ancestor;
  }
  return defaultAncestor;
}

double _getMinPrelim<V>(_TreeNode<V> node, [double currentMod = 0.0]) {
  var minX = node.prelim + currentMod;
  for (final child in node.children) {
    minX = math.min(minX, _getMinPrelim(child, currentMod + node.mod));
  }
  return minX;
}

double _secondWalk<V>(
  _TreeNode<V> v,
  double m,
  double depth,
  double layerDistance,
  Map<V, (double, double)> positions,
) {
  final x = v.prelim + m;
  final y = depth;
  positions[v.value] = (x, y);

  var maxX = x;
  for (final w in v.children) {
    final childMax = _secondWalk(
      w,
      m + v.mod,
      depth + layerDistance,
      layerDistance,
      positions,
    );
    if (childMax > maxX) maxX = childMax;
  }
  return maxX;
}

final class _TreeNode<V> {
  new({required this.value, this.parent, this.depth = 0, this.number = 0});

  final V value;
  final _TreeNode<V>? parent;
  final int depth;
  int number;
  final List<_TreeNode<V>> children = [];

  double prelim = 0.0;
  double mod = 0.0;
  double shift = 0.0;
  double change = 0.0;
  _TreeNode<V>? thread;
  late _TreeNode<V> ancestor;

  _TreeNode<V>? get leftSibling {
    if (parent == null || number == 0) return null;
    return parent!.children[number - 1];
  }

  _TreeNode<V>? get leftMostSibling {
    if (parent == null || parent!.children.isEmpty) return null;
    return parent!.children.first;
  }

  _TreeNode<V>? get nextLeft => children.isNotEmpty ? children.first : thread;

  _TreeNode<V>? get nextRight => children.isNotEmpty ? children.last : thread;
}
