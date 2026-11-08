import 'dart:math' as math;

import '../layout.dart';
import 'result.dart';

/// Extension on [LayoutGraph] for hierarchical tree and forest layouts.
extension TreeLayoutExtension<V> on LayoutGraph<V> {
  /// Positions vertices in a hierarchical tree or forest using the Buchheim-Walker
  /// algorithm, dynamically spacing subtrees based on vertex dimensions to prevent overlap.
  LayoutResult<V> tree({
    Iterable<V>? roots,
    double? levelDistance,
    double siblingDistance = 20.0,
    LayoutOrientation orientation = LayoutOrientation.topToBottom,
  }) {
    final allVertices = vertices.toSet();
    if (allVertices.isEmpty) {
      return const LayoutResult(
        positions: {},
        bounds: LayoutRect(minX: 0, minY: 0, maxX: 0, maxY: 0),
      );
    }

    var maxH = 0.0;
    for (final v in allVertices) {
      final h = heightOf(v);
      if (h > maxH) maxH = h;
    }
    final effectiveLevelDistance = levelDistance ?? (maxH + 40.0);

    final List<V> effectiveRoots;
    if (roots != null && roots.isNotEmpty) {
      effectiveRoots = roots.where(allVertices.contains).toList();
    } else {
      final inDegree = <V, int>{for (final v in allVertices) v: 0};
      for (final v in allVertices) {
        for (final child in successorsOf(v)) {
          if (inDegree.containsKey(child)) {
            inDegree[child] = (inDegree[child] ?? 0) + 1;
          }
        }
      }
      final zeroInDegree = allVertices.where((v) => inDegree[v] == 0).toList();
      effectiveRoots = zeroInDegree.isNotEmpty
          ? zeroInDegree
          : [allVertices.first];
    }

    final visited = <V>{};
    final forest = <_TreeNode<V>>[];

    for (final root in effectiveRoots) {
      if (!visited.contains(root)) {
        final tree = _buildTree(root, successorsOf, visited, allVertices);
        if (tree != null) forest.add(tree);
      }
    }

    for (final v in allVertices) {
      if (!visited.contains(v)) {
        visited.add(v);
        forest.add(_TreeNode<V>(value: v, depth: 0));
      }
    }

    var currentXOffset = 0.0;
    final rawPositions = <V, (double, double)>{};

    for (final rootNode in forest) {
      _initializeNodes(rootNode);
      _firstWalk(rootNode, this, siblingDistance);
      final minX = _getMinPrelim(rootNode);
      final shift = currentXOffset - minX;
      final maxX = _secondWalk(
        rootNode,
        shift,
        0.0,
        effectiveLevelDistance,
        rawPositions,
      );
      final rootW = widthOf(rootNode.value);
      currentXOffset = maxX + rootW + siblingDistance;
    }

    final orientedPositions = <V, LayoutPoint>{};
    for (final entry in rawPositions.entries) {
      final x = entry.value.$1;
      final y = entry.value.$2;
      final (ox, oy) = switch (orientation) {
        LayoutOrientation.topToBottom => (x, y),
        LayoutOrientation.bottomToTop => (x, -y),
        LayoutOrientation.leftToRight => (y, x),
        LayoutOrientation.rightToLeft => (-y, x),
      };
      orientedPositions[entry.key] = LayoutPoint(ox, oy);
    }

    final rawBounds = LayoutRect.fromPoints(orientedPositions.values);
    final finalPositions = <V, LayoutPoint>{};
    final dx = -rawBounds.minX;
    final dy = -rawBounds.minY;

    for (final entry in orientedPositions.entries) {
      finalPositions[entry.key] = entry.value.translate(dx, dy);
    }

    return LayoutResult<V>(
      positions: finalPositions,
      bounds: LayoutRect.fromPoints(finalPositions.values),
    );
  }
}

_TreeNode<V>? _buildTree<V>(
  V value,
  Iterable<V> Function(V) successorsOf,
  Set<V> visited,
  Set<V> allVertices,
) {
  if (!visited.add(value)) return null;

  final node = _TreeNode<V>(value: value, depth: 0);
  final queue = <_TreeNode<V>>[node];

  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    var siblingIndex = 0;
    for (final childVal in successorsOf(current.value)) {
      if (allVertices.contains(childVal) && visited.add(childVal)) {
        final childNode = _TreeNode<V>(
          value: childVal,
          parent: current,
          depth: current.depth + 1,
          number: siblingIndex++,
        );
        current.children.add(childNode);
        queue.add(childNode);
      }
    }
  }

  return node;
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
  LayoutGraph<V> layout,
  double siblingDistance,
) {
  if (v.children.isEmpty) {
    if (v.leftSibling != null) {
      final gap = _nodeGap(
        v.leftSibling!.value,
        v.value,
        layout,
        siblingDistance,
      );
      v.prelim = v.leftSibling!.prelim + gap;
    } else {
      v.prelim = 0.0;
    }
  } else {
    var defaultAncestor = v.children.first;
    for (final w in v.children) {
      _firstWalk(w, layout, siblingDistance);
      defaultAncestor = _apportion(w, defaultAncestor, layout, siblingDistance);
    }
    _executeShifts(v);
    final midpoint = (v.children.first.prelim + v.children.last.prelim) / 2.0;
    if (v.leftSibling != null) {
      final gap = _nodeGap(
        v.leftSibling!.value,
        v.value,
        layout,
        siblingDistance,
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
  LayoutGraph<V> layout,
  double siblingDistance,
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
      final gap = _nodeGap(vim.value, vip.value, layout, siblingDistance);
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

double _nodeGap<V>(V left, V right, LayoutGraph<V> layout, double spacing) =>
    (layout.widthOf(left) + layout.widthOf(right)) / 2.0 + spacing;

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
  double depthY,
  double levelDistance,
  Map<V, (double, double)> positions,
) {
  final x = v.prelim + m;
  final y = depthY;
  positions[v.value] = (x, y);

  var maxX = x;
  for (final w in v.children) {
    final childMax = _secondWalk(
      w,
      m + v.mod,
      depthY + levelDistance,
      levelDistance,
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
