import 'dart:convert' as convert;
import 'dart:js_interop';
import 'dart:math' as math;

import 'package:more/collection.dart';
import 'package:web/web.dart' as web;

enum RTreeAlgorithm {
  guttman('Guttman (Quadratic)'),
  linear('Linear R-Tree'),
  rStar('R*-Tree (Beckmann)');

  new(this.label);
  final String label;
}

enum InteractionTool {
  addPoint('Add Points', '1'),
  addBox('Add Boxes', '2'),
  query('Window Query', '3'),
  nearest('k-NN Radar', '4'),
  delete('Eraser', '5');

  new(this.label, this.key);
  final String label;
  final String key;
}

/// Represents an item stored in the visualizer state.
class SpatialItem {
  const new(this.id, this.bounds, this.label);

  final int id;
  final Bounds bounds;
  final String label;
}

/// Manages application data, RTree instances, datasets, history, and metrics.
class RTreeAppState {
  new() {
    rebuildTree();
  }

  // Algorithm & capacity
  RTreeAlgorithm algorithm = RTreeAlgorithm.rStar;
  int minEntries = 4;
  int maxEntries = 8;

  // Active tool
  InteractionTool currentTool = InteractionTool.addPoint;

  // Visual toggles
  bool showLabels = true;
  bool showBadges = true;
  bool showOverlaps = false;
  int? filterLevel; // null = all levels

  // Stored items
  final List<SpatialItem> items = [];
  int _nextId = 1;

  // Underlying R-Tree
  late RTree<SpatialItem> tree;

  // Query / Selection state
  Bounds? activeQueryBounds;
  List<double>? activeKnnPoint;
  int knnK = 5;
  Set<RTreeEntry<SpatialItem>> lastQueryHits = {};
  Set<RTreeNode<SpatialItem>> lastVisitedNodes = {};
  int lastNodesTestedCount = 0;
  SpatialItem? selectedItem;
  RTreeNode<SpatialItem>? hoveredNode;

  // Undo / Redo history snapshots
  final List<List<SpatialItem>> _undoStack = [];
  final List<List<SpatialItem>> _redoStack = [];

  void saveSnapshot() {
    _undoStack.add(List.of(items));
    _redoStack.clear();
    if (_undoStack.length > 50) {
      _undoStack.removeAt(0);
    }
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void undo() {
    if (!canUndo) return;
    _redoStack.add(List.of(items));
    final prev = _undoStack.removeLast();
    items
      ..clear()
      ..addAll(prev);
    rebuildTree();
  }

  void redo() {
    if (!canRedo) return;
    _undoStack.add(List.of(items));
    final next = _redoStack.removeLast();
    items
      ..clear()
      ..addAll(next);
    rebuildTree();
  }

  void rebuildTree() {
    switch (algorithm) {
      case RTreeAlgorithm.guttman:
        tree = RTree<SpatialItem>.guttman(
          minEntries: minEntries,
          maxEntries: maxEntries,
        );
      case RTreeAlgorithm.linear:
        tree = RTree<SpatialItem>.linear(
          minEntries: minEntries,
          maxEntries: maxEntries,
        );
      case RTreeAlgorithm.rStar:
        tree = RTree<SpatialItem>.rStar(
          minEntries: minEntries,
          maxEntries: maxEntries,
        );
    }
    for (final item in items) {
      tree.insert(item.bounds, item);
    }
    clearTransientQueries();
  }

  void addItem(Bounds bounds, [String? label]) {
    saveSnapshot();
    final item = SpatialItem(_nextId++, bounds, label ?? 'Item $_nextId');
    items.add(item);
    tree.insert(bounds, item);
  }

  void addItemsBatch(Iterable<Bounds> boundsList, [Iterable<String>? labels]) {
    saveSnapshot();
    final labelIter = labels?.iterator;
    for (final b in boundsList) {
      final label = (labelIter != null && labelIter.moveNext())
          ? labelIter.current
          : 'P$_nextId';
      final item = SpatialItem(_nextId++, b, label);
      items.add(item);
      tree.insert(b, item);
    }
  }

  bool removeItemAtPoint(List<double> point, double tolerance) {
    final queryBox = Bounds.from2D(
      point[0] - tolerance,
      point[1] - tolerance,
      point[0] + tolerance,
      point[1] + tolerance,
    );
    final hits = tree.queryEntries(queryBox).toList();
    if (hits.isEmpty) return false;

    saveSnapshot();
    // Pick the closest hit
    hits.sort(
      (a, b) => a.bounds
          .minDistanceToPointSquared(point)
          .compareTo(b.bounds.minDistanceToPointSquared(point)),
    );
    final toRemove = hits.first;
    final item = toRemove.data!;
    items.remove(item);
    tree.remove(toRemove.bounds, dataPredicate: (d) => d.id == item.id);
    if (selectedItem == item) selectedItem = null;
    return true;
  }

  void clearAll() {
    saveSnapshot();
    items.clear();
    tree.clear();
    selectedItem = null;
    clearTransientQueries();
  }

  void clearTransientQueries() {
    activeQueryBounds = null;
    activeKnnPoint = null;
    lastQueryHits.clear();
    lastVisitedNodes.clear();
    lastNodesTestedCount = 0;
  }

  void performRangeQuery(Bounds bounds) {
    activeQueryBounds = bounds;
    activeKnnPoint = null;
    lastQueryHits.clear();
    lastVisitedNodes.clear();
    lastNodesTestedCount = 0;

    tree.traverse((node) {
      lastNodesTestedCount++;
      lastVisitedNodes.add(node);
      if (node.isLeaf) {
        for (final entry in node.entries) {
          if (entry.bounds.intersects(bounds)) {
            lastQueryHits.add(entry);
          }
        }
      }
      return const [];
    }, condition: (node) => node.bounds?.intersects(bounds) ?? false).toList();
  }

  void performKnnQuery(List<double> point, int k) {
    activeKnnPoint = point;
    activeQueryBounds = null;
    lastQueryHits.clear();
    lastVisitedNodes.clear();
    lastNodesTestedCount = 0;

    final hits = tree.nearestEntries(point.toBounds(), k: k).toList();
    lastQueryHits.addAll(hits);
  }

  // --- Metrics Computation ---

  int get treeHeight {
    var height = 0;
    var curr = tree.root;
    while (!curr.isLeaf && curr.entries.isNotEmpty) {
      height++;
      curr = curr.entries.first.child!;
    }
    return height + 1;
  }

  int get totalNodes {
    var count = 0;
    tree.traverse((n) {
      count++;
      return const [];
    }).toList();
    return count;
  }

  double get averageFillFactor {
    var totalEntries = 0;
    var nodeCount = 0;
    tree.traverse((n) {
      nodeCount++;
      totalEntries += n.entries.length;
      return const [];
    }).toList();
    if (nodeCount == 0) return 0.0;
    return (totalEntries / (nodeCount * maxEntries)) * 100.0;
  }

  double get totalOverlapArea {
    var overlapSum = 0.0;
    tree.traverse((node) {
      if (!node.isLeaf) {
        final entries = node.entries;
        for (var i = 0; i < entries.length; i++) {
          for (var j = i + 1; j < entries.length; j++) {
            final intersection = entries[i].bounds.intersection(
              entries[j].bounds,
            );
            if (intersection != null) {
              overlapSum += intersection.area;
            }
          }
        }
      }
      return const [];
    }).toList();
    return overlapSum;
  }

  // --- Preset Generators ---

  final math.Random _presetRandom = math.Random();
  double viewportWidth = 800.0;
  double viewportHeight = 600.0;

  Future<void> loadPreset(String type, double width, double height) async {
    viewportWidth = width;
    viewportHeight = height;
    final rng = _presetRandom;
    final list = <Bounds>[];

    switch (type) {
      case 'random_points':
        for (var i = 0; i < 100; i++) {
          list.add(
            [
              30.0 + rng.nextDouble() * (width - 60.0),
              30.0 + rng.nextDouble() * (height - 60.0),
            ].toBounds(),
          );
        }
        addItemsBatch(list);

      case 'random_boxes':
        for (var i = 0; i < 50; i++) {
          final x = 30.0 + rng.nextDouble() * (width - 100.0);
          final y = 30.0 + rng.nextDouble() * (height - 100.0);
          final w = 15.0 + rng.nextDouble() * 45.0;
          final h = 15.0 + rng.nextDouble() * 35.0;
          list.add(Bounds.from2D(x, y, x + w, y + h));
        }
        addItemsBatch(list);

      case 'gaussian_clusters':
        final clusterCount = 2 + rng.nextInt(3);
        final centers = List.generate(
          clusterCount,
          (_) => [
            width * (0.2 + rng.nextDouble() * 0.6),
            height * (0.2 + rng.nextDouble() * 0.6),
          ],
        );
        for (var i = 0; i < 120; i++) {
          final center = centers[rng.nextInt(centers.length)];
          final u1 = rng.nextDouble();
          final u2 = rng.nextDouble();
          final r = math.sqrt(-2.0 * math.log(u1.clamp(1e-6, 1.0))) * 35.0;
          final theta = 2.0 * math.pi * u2;
          final x = (center[0] + r * math.cos(theta)).clamp(20.0, width - 20.0);
          final y = (center[1] + r * math.sin(theta)).clamp(
            20.0,
            height - 20.0,
          );
          list.add([x, y].toBounds());
        }
        addItemsBatch(list);

      case 'spiral':
        final cx = width * (0.3 + rng.nextDouble() * 0.4);
        final cy = height * (0.3 + rng.nextDouble() * 0.4);
        final maxR = (math.min(width, height) / 2.0) - 40.0;
        final startAngle = rng.nextDouble() * 2 * math.pi;
        for (var i = 0; i < 100; i++) {
          final t = startAngle + (i / 100.0) * 4.0 * math.pi;
          final r = (i / 100.0) * maxR;
          final x = (cx + r * math.cos(t) + (rng.nextDouble() - 0.5) * 8.0)
              .clamp(20.0, width - 20.0);
          final y = (cy + r * math.sin(t) + (rng.nextDouble() - 0.5) * 8.0)
              .clamp(20.0, height - 20.0);
          list.add([x, y].toBounds());
        }
        addItemsBatch(list);

      case 'swiss_villages':
        clearAll();
        await _loadGeo('swiss_villages.json');

      case 'world_cities':
        clearAll();
        await _loadGeo('world_cities.json');
    }
  }

  Future<void> _loadGeo(String filename) async {
    final response = await web.window.fetch(filename.toJS).toDart;
    final text = (await response.text().toDart).toDart;
    final decoded = convert.jsonDecode(text) as List<dynamic>;

    final points = <({String name, double lat, double lon})>[];
    for (final item in decoded) {
      final map = item as Map<String, dynamic>;
      points.add((
        name: map['name'] as String,
        lat: (map['lat'] as num).toDouble(),
        lon: (map['lon'] as num).toDouble(),
      ));
    }
    _applyGeo(points);
  }

  void _applyGeo(List<({String name, double lat, double lon})> points) {
    if (points.isEmpty) return;

    var minLat = double.infinity;
    var maxLat = -double.infinity;
    var minLon = double.infinity;
    var maxLon = -double.infinity;

    for (final p in points) {
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lon < minLon) minLon = p.lon;
      if (p.lon > maxLon) maxLon = p.lon;
    }

    // Mid-latitude cosine dynamically preserves local aspect ratio without distortion
    final midLat = (minLat + maxLat) / 2.0;
    final cosMidLat = math.cos(midLat * math.pi / 180.0);

    final spanLon = (maxLon - minLon) * cosMidLat;
    final spanLat = maxLat - minLat;

    final availableW = math.max(viewportWidth - 80.0, 100.0);
    final availableH = math.max(viewportHeight - 80.0, 100.0);

    final scale = math.min(
      spanLon > 0 ? availableW / spanLon : 1.0,
      spanLat > 0 ? availableH / spanLat : 1.0,
    );

    final mapW = spanLon * scale;
    final mapH = spanLat * scale;
    final offsetX = 40.0 + (availableW - mapW) / 2.0;
    final offsetY = 40.0 + (availableH - mapH) / 2.0;

    final boundsList = <Bounds>[];
    final labelsList = <String>[];

    for (final p in points) {
      final x = offsetX + (p.lon - minLon) * cosMidLat * scale;
      final y = offsetY + (maxLat - p.lat) * scale;
      boundsList.add([x, y].toBounds());
      labelsList.add(p.name);
    }

    addItemsBatch(boundsList, labelsList);
  }
}
