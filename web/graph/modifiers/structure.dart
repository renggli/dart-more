import 'dart:math' as math;

import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

// ---------------------------------------------------------------------------
// Connected Components Modifier
// ---------------------------------------------------------------------------

class ComponentsModifier extends GraphModifier {
  new({super.enabled, this.mode = ComponentMode.weakly});

  ComponentMode mode;

  @override
  String get id => 'components';

  @override
  String get name => 'Components';

  @override
  ModifierCategory get category => ModifierCategory.structure;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      dropdownSetting(
        'Component Mode:',
        mode.id,
        [for (final m in ComponentMode.values) (m.id, m.label)],
        onChanged: (val) {
          mode = ComponentMode.fromId(val);
          onModified();
        },
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    List<Iterable<String>> components;
    try {
      switch (mode) {
        case ComponentMode.strongly:
          components = graph.isDirected
              ? graph.stronglyConnected().toList()
              : graph.connected().map((g) => g.vertices).toList();
        case ComponentMode.biconnected:
          components = !graph.isDirected
              ? graph.biconnectedComponents().map((g) => g.vertices).toList()
              : graph.connected().map((g) => g.vertices).toList();
        case ComponentMode.weakly:
          components = graph.connected().map((g) => g.vertices).toList();
      }
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    final vertexGroup = <String, int>{};
    final rows = <List<String>>[];
    for (var i = 0; i < components.length; i++) {
      final comp = components[i].toList();
      for (final v in comp) {
        vertexGroup[v] = i;
      }
      rows.add(['Component #${i + 1}', '${comp.length}', comp.join(', ')]);
    }

    final overlay = PartitionOverlay(
      vertexGroup: vertexGroup,
      title: 'Components ($mode)',
    );
    return ModifierOutput(
      overlay: overlay,
      statusSummary: '${components.length} components found',
      tableData: ModifierTableData(
        title: 'Connected Components ($mode)',
        headers: ['Component', 'Size', 'Vertices'],
        rows: rows,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Biconnected Components, Articulation Points & Bridges
// ---------------------------------------------------------------------------

class BiconnectedComponentsModifier extends GraphModifier {
  new({super.enabled});

  String pointColor = '#f59e0b';
  String bridgeColor = '#ef4444';
  String bridgePattern = '6,4';

  @override
  String get id => 'biconnected';

  @override
  String get name => 'Biconnected & Bridges';

  @override
  ModifierCategory get category => ModifierCategory.structure;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    root.appendChild(
      colorSetting(
        'Articulation Point Color:',
        pointColor,
        onChanged: (c) {
          pointColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      colorSetting(
        'Bridge Edge Color:',
        bridgeColor,
        onChanged: (c) {
          bridgeColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      lineStyleSetting(
        'Bridge Line Style:',
        bridgePattern,
        onChanged: (p) {
          bridgePattern = p;
          onModified();
        },
      ),
    );
    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage:
            'Biconnected components and bridges require an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    try {
      final cutVertices = graph.articulationPoints();
      final bridgeEdges = graph.bridges();
      final dash = bridgePattern != 'none' ? bridgePattern : null;
      final ptColor = pointColor != 'none' ? pointColor : null;
      final brColor = bridgeColor != 'none' ? bridgeColor : null;

      if (ptColor != null) {
        for (final v in cutVertices) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = ptColor;
            node.style.borderWidth = 3.5;
          }
        }
      }

      if (brColor != null || dash != null) {
        for (final b in bridgeEdges) {
          final es = state.getEdgeStyle(b.source, b.target);
          if (brColor != null) {
            es.color = brColor;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        }
      }

      return ModifierOutput(
        statusSummary:
            '${cutVertices.length} Articulation Points, ${bridgeEdges.length} Bridges',
        tableData: ModifierTableData(
          title: 'Articulation Points & Bridges',
          headers: ['Type', 'Element'],
          rows: [
            for (final v in cutVertices) ['Articulation Point', v],
            for (final b in bridgeEdges)
              ['Bridge Edge', '${b.source} ↔ ${b.target}'],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Biconnected error: $e',
        statusSummary: 'Error computing biconnected components',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Cycle Detection Modifier
// ---------------------------------------------------------------------------

class CycleDetectionModifier extends GraphModifier {
  new({super.enabled});

  final outputStyle = OutputStyleOptions(
    color: '#ef4444',
    pattern: '6,4',
    hasRemovedMode: true,
  );
  int selectedCycleIndex = -1; // -1 means All Discovered Cycles
  void Function(List<List<String>> cycles)? _onCyclesChanged;

  @override
  String get id => 'cycle_detection';

  @override
  String get name => 'Cycles';

  @override
  ModifierCategory get category => ModifierCategory.structure;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    final dropdownContainer = div();

    void updateDropdown(List<List<String>> currentCycles) {
      if (!dropdownContainer.isConnected) {
        _onCyclesChanged = null;
        return;
      }
      dropdownContainer.textContent = '';
      if (currentCycles.isNotEmpty) {
        if (selectedCycleIndex >= currentCycles.length) {
          selectedCycleIndex = -1;
        }
        final options = <(String, String)>[
          ('-1', 'All Discovered Cycles (${currentCycles.length})'),
          for (var i = 0; i < currentCycles.length; i++)
            (
              '$i',
              'Cycle #${i + 1} (${currentCycles[i].length - 1} edges: ${currentCycles[i].take(4).join(' → ')}${currentCycles[i].length > 5 ? ' …' : ''})',
            ),
        ];
        dropdownContainer.appendChild(
          dropdownSetting(
            'Display Cycle:',
            '$selectedCycleIndex',
            options,
            onChanged: (val) {
              selectedCycleIndex = int.tryParse(val) ?? -1;
              onModified();
            },
          ),
        );
      }
    }

    final cycles = _findCycles(state.renderGraph);
    updateDropdown(cycles);
    _onCyclesChanged = updateDropdown;
    root.appendChild(dropdownContainer);

    outputStyle.buildUI(
      root,
      onModified,
      colorLabel: 'Cycle Color:',
      patternLabel: 'Cycle Line Style:',
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      _onCyclesChanged?.call(const []);
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final cycles = _findCycles(graph);
    _onCyclesChanged?.call(cycles);
    if (cycles.isEmpty) {
      return const ModifierOutput(
        statusSummary: 'Graph is Acyclic (DAG)',
        tableData: ModifierTableData(
          title: 'Cycle Detection',
          headers: ['Property', 'Result'],
          rows: [
            ['Is Cyclic', 'No'],
            ['Acyclic (DAG)', 'Yes'],
            ['Total Cycles Discovered', '0'],
          ],
        ),
      );
    }

    // Determine which cycles to highlight
    final cyclesToHighlight = <List<String>>[];
    if (selectedCycleIndex >= 0 && selectedCycleIndex < cycles.length) {
      cyclesToHighlight.add(cycles[selectedCycleIndex]);
    } else {
      cyclesToHighlight.addAll(cycles);
    }

    final dash = outputStyle.dashPattern;
    final color = outputStyle.highlightColor;
    final cycleEdges = <(String, String)>[];
    final cycleEdgeSet = <(String, String)>{};
    for (final cycle in cyclesToHighlight) {
      for (var i = 0; i < cycle.length - 1; i++) {
        final u = cycle[i];
        final v = cycle[i + 1];
        cycleEdges.add((u, v));
        cycleEdgeSet.add((u, v));
        if (!graph.isDirected) {
          cycleEdges.add((v, u));
          cycleEdgeSet.add((v, u));
        }
        if (color != null || dash != null) {
          final edgeStyle = state.getEdgeStyle(
            u,
            v,
            isDirected: graph.isDirected,
          );
          if (color != null) {
            edgeStyle.color = color;
            edgeStyle.strokeWidth = 3.0;
          }
          edgeStyle.dashPattern = dash;
        }
      }
      for (final v in cycle) {
        final node = state.nodes[v];
        if (node != null && (color != null || dash != null)) {
          if (color != null) {
            node.style.borderColor = color;
            node.style.borderWidth = 2.5;
          }
          node.style.dashPattern = dash;
        }
      }
    }

    // Handle non-cycle edges
    for (final e in graph.edges.toSet()) {
      if (!cycleEdgeSet.contains((e.source, e.target))) {
        final edgeStyle = state.getEdgeStyle(e.source, e.target);
        edgeStyle.opacity = outputStyle.removedMode == RemovedMode.hide
            ? 0.0
            : 0.25;
      }
    }

    final primaryVertices = {for (final cycle in cyclesToHighlight) ...cycle}
        .toList();
    final overlay = PathOverlay(
      vertices: primaryVertices,
      edges: cycleEdges,
      title: 'Discovered ${cycles.length} Cycles',
      color: color,
    );

    return ModifierOutput(
      overlay: overlay,
      statusSummary:
          '${cycles.length} Cycle${cycles.length == 1 ? "" : "s"} found',
      tableData: ModifierTableData(
        title: 'Discovered Cycles',
        headers: ['#', 'Length', 'Sequence'],
        rows: [
          for (var i = 0; i < cycles.length; i++)
            [
              'Cycle #${i + 1}',
              '${cycles[i].length - 1}',
              cycles[i].join(' → '),
            ],
        ],
      ),
    );
  }

  static List<List<String>> _findCycles(
    Graph<String, num> graph, {
    int maxCycles = 30,
  }) {
    if (!graph.hasCycle()) return const [];
    final results = <List<String>>[];
    final seenCanonical = <String>{};

    void recordCycle(List<String> rawCycle) {
      if (rawCycle.length < 2) return;
      final nodes = rawCycle.sublist(0, rawCycle.length - 1);
      if (nodes.length < 2) return;
      if (!graph.isDirected && nodes.length < 3) return;

      final sorted = List.of(nodes)..sort();
      final key = graph.isDirected ? nodes.join('->') : sorted.join('-');
      if (!seenCanonical.contains(key)) {
        seenCanonical.add(key);
        results.add(List.of(rawCycle));
      }
    }

    if (graph.isDirected) {
      final visited = <String>{};
      final onStack = <String>{};
      final path = <String>[];

      void dfs(String v) {
        if (results.length >= maxCycles) return;
        visited.add(v);
        onStack.add(v);
        path.add(v);

        for (final next in graph.successorsOf(v)) {
          if (results.length >= maxCycles) break;
          if (onStack.contains(next)) {
            final cycleStart = path.indexOf(next);
            if (cycleStart != -1) {
              final cycle = path.sublist(cycleStart)..add(next);
              recordCycle(cycle);
            }
          } else if (!visited.contains(next)) {
            dfs(next);
          }
        }

        path.removeLast();
        onStack.remove(v);
      }

      for (final v in graph.vertices) {
        if (results.length >= maxCycles) break;
        if (!visited.contains(v)) {
          dfs(v);
        }
      }
    } else {
      final visited = <String>{};
      final parentMap = <String, String?>{};
      final depth = <String, int>{};

      void dfs(String u, String? parent, int d) {
        if (results.length >= maxCycles) return;
        visited.add(u);
        parentMap[u] = parent;
        depth[u] = d;

        for (final v in graph.neighboursOf(u)) {
          if (results.length >= maxCycles) break;
          if (v == parent) continue;
          if (visited.contains(v)) {
            if (depth[v]! < depth[u]!) {
              final cycle = <String>[];
              var curr = u;
              while (curr != v) {
                cycle.add(curr);
                final p = parentMap[curr];
                if (p == null) break;
                curr = p;
              }
              cycle.add(v);
              cycle.add(u);
              if (cycle.length >= 4) {
                recordCycle(cycle);
              }
            }
          } else {
            dfs(v, u, d + 1);
          }
        }
      }

      for (final v in graph.vertices) {
        if (results.length >= maxCycles) break;
        if (!visited.contains(v)) {
          dfs(v, null, 0);
        }
      }
    }

    return results;
  }
}

// ---------------------------------------------------------------------------
// Planarity Modifier
// ---------------------------------------------------------------------------

class PlanarityModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'planarity';

  @override
  String get name => 'Planarity';

  @override
  ModifierCategory get category => ModifierCategory.structure;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) =>
      div('form-column')..appendChild(
        p(
          'Tests whether the graph can be embedded in a plane with no edge crossings (Left-Right planarity test).',
        ),
      );

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'Planarity testing requires an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    try {
      final planar = graph.isPlanar();
      final vCount = graph.vertices.length;
      final eCount = graph.edges.toSet().length;
      final faces = (2 - vCount + eCount).clamp(1, 999999);

      return ModifierOutput(
        statusSummary: planar
            ? 'Planar (Embeddable)'
            : 'Non-Planar (Contains K5 or K3,3 minor)',
        tableData: ModifierTableData(
          title: 'Planarity Analysis',
          headers: ['Property', 'Value'],
          rows: [
            ['Is Planar', if (planar) 'Yes' else 'No'],
            ['Vertices (V)', '$vCount'],
            ['Edges (E)', '$eCount'],
            if (planar) ['Euler Faces (F = 2 - V + E)', '$faces'],
            ['Max Planar Edges (3V - 6)', '${math.max(0, 3 * vCount - 6)}'],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Planarity error: $e',
        statusSummary: 'Error checking planarity',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// k-Core Modifier (Safe across directed & undirected graphs)
// ---------------------------------------------------------------------------

class KCoreModifier extends GraphModifier {
  new({super.enabled, this.k = 2});

  int k;
  final outputStyle = OutputStyleOptions(
    color: '#ef4444',
    pattern: '6,4',
    hasRemovedMode: true,
  );

  @override
  String get id => 'k_core';

  @override
  String get name => 'k-Core';

  @override
  ModifierCategory get category => ModifierCategory.structure;

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    final out = apply(state.primaryGraph, state);
    if (out.transformedGraph != null) {
      state.saveSnapshot();
      state.primaryGraph = out.transformedGraph!;
      state.syncNodes();
      state.modifiers.remove(this);
    }
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');

    container.appendChild(
      rangeSetting(
        'Degree Threshold (k):',
        k,
        min: 1,
        max: 20,
        onChanged: (v) {
          k = v.toInt();
          onModified();
        },
      ),
    );

    outputStyle.buildUI(
      container,
      onModified,
      colorLabel: 'Removed Element Color:',
      patternLabel: 'Removed Line Style:',
      removedLabel: 'Show Removed as:',
    );

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'k-Core requires an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    Set<String> coreVerts;
    try {
      coreVerts = graph.kCore(k).vertices.toSet();
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    // Apply dashed styling or filter
    if (outputStyle.removedMode == RemovedMode.dim) {
      final dash = outputStyle.dashPattern;
      final color = outputStyle.highlightColor;
      for (final v in graph.vertices) {
        if (!coreVerts.contains(v)) {
          final node = state.nodes[v];
          if (node != null) {
            if (color != null) {
              node.style.borderColor = color;
              node.style.borderWidth = 2.0;
            }
            node.style.dashPattern = dash;
            node.style.opacity = 0.45;
          }
          for (final e in graph.edgesOf(v)) {
            final es = state.getEdgeStyle(e.source, e.target);
            if (color != null) {
              es.color = color;
            }
            es.dashPattern = dash;
            es.opacity = 0.35;
          }
        }
      }

      return ModifierOutput(
        statusSummary: 'k-Core (k=$k, ${coreVerts.length} surviving vertices)',
        tableData: ModifierTableData(
          title: 'k-Core Subgraph (k=$k)',
          headers: ['Property', 'Value'],
          rows: [
            ['Threshold k', '$k'],
            ['Surviving Vertices', '${coreVerts.length}'],
            ['Dimmed Vertices', '${graph.vertices.length - coreVerts.length}'],
          ],
        ),
      );
    }

    // Filter mode: extract subgraph
    final sub = Graph<String, num>(
      isDirected: graph.isDirected,
      vertexStrategy: graph.vertexStrategy,
    );
    for (final v in coreVerts) {
      sub.addVertex(v);
    }
    for (final e in graph.edges) {
      if (coreVerts.contains(e.source) && coreVerts.contains(e.target)) {
        sub.addEdge(e.source, e.target, value: e.value);
      }
    }

    return ModifierOutput(
      transformedGraph: sub,
      statusSummary: 'k-Core (k=$k, ${sub.vertices.length} vertices)',
      tableData: ModifierTableData(
        title: 'k-Core Subgraph (k=$k)',
        headers: ['Property', 'Value'],
        rows: [
          ['Threshold k', '$k'],
          ['Surviving Vertices', '${sub.vertices.length}'],
          ['Surviving Edges', '${sub.edges.length}'],
        ],
      ),
    );
  }
}
