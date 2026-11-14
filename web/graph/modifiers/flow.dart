import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

// ---------------------------------------------------------------------------
// Max Flow & Min s-t Cut (Dinic)
// ---------------------------------------------------------------------------

class MaxFlowModifier extends GraphModifier {
  new({super.enabled});

  String? sourceVertex;
  String? targetVertex;
  String flowColor = '#10b981';
  String cutColor = '#ef4444';
  String cutPattern = '6,4';
  String sourcePartitionColor = '#06b6d4';
  String sinkPartitionColor = '#f59e0b';

  @override
  String get id => 'max_flow';

  @override
  String get name => 'Max Flow & Min s-t Cut';

  @override
  ModifierCategory get category => ModifierCategory.flows;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      vertexField(
        'Source Vertex (s):',
        state,
        sourceVertex,
        '(Selected / First)',
        (v) {
          sourceVertex = v;
          onModified();
        },
      ),
    );

    root.appendChild(
      vertexField(
        'Sink Vertex (t):',
        state,
        targetVertex,
        '(Selected / Last)',
        (v) {
          targetVertex = v;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Flow Edge Color:',
        flowColor,
        onChanged: (c) {
          flowColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Cut Edge Color:',
        cutColor,
        onChanged: (c) {
          cutColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      lineStyleSetting(
        'Cut Line Style:',
        cutPattern,
        onChanged: (p) {
          cutPattern = p;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Source Partition Color:',
        sourcePartitionColor,
        onChanged: (c) {
          sourcePartitionColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Sink Partition Color:',
        sinkPartitionColor,
        onChanged: (c) {
          sinkPartitionColor = c;
          onModified();
        },
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.length < 2) {
      return const ModifierOutput(statusSummary: 'Need at least 2 vertices');
    }

    final s = sourceVertex ?? state.selectedSource ?? vertices.first;
    final t = targetVertex ?? state.selectedTarget ?? vertices.last;

    if (s == t) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'Source and sink cannot be identical',
        statusSummary: 'Source == Sink',
      );
    }

    try {
      num capacityOf(String u, String v) {
        final edge = graph.getEdge(u, v);
        final cap = edge?.value ?? 1;
        return cap > 0 ? cap : 1;
      }

      final dinic = graph.maxFlow(edgeCapacity: capacityOf);
      final maxFlowValue = dinic(s, t);

      // Identify source partition S via BFS reachability in residual graph
      final reachable = <String>{s};
      final queue = <String>[s];
      while (queue.isNotEmpty) {
        final curr = queue.removeAt(0);
        for (final next in graph.successorsOf(curr)) {
          if (!reachable.contains(next) &&
              dinic.flow(curr, next) < capacityOf(curr, next)) {
            reachable.add(next);
            queue.add(next);
          }
        }
        for (final prev in graph.predecessorsOf(curr)) {
          if (!reachable.contains(prev) && dinic.flow(prev, curr) > 0) {
            reachable.add(prev);
            queue.add(prev);
          }
        }
      }

      // Style source and target sets
      for (final v in vertices) {
        final node = state.nodes[v];
        final partColor = reachable.contains(v)
            ? sourcePartitionColor
            : sinkPartitionColor;
        if (node != null && partColor != 'none') {
          node.style.borderColor = partColor;
          node.style.borderWidth = (v == s || v == t) ? 3.5 : 2.0;
        }
      }

      final dash = cutPattern != 'none' ? cutPattern : null;
      final cColor = cutColor != 'none' ? cutColor : null;
      final fColor = flowColor != 'none' ? flowColor : null;

      // Highlight flow edges and cut edges
      for (final edge in graph.edges.toSet()) {
        final isCut =
            reachable.contains(edge.source) && !reachable.contains(edge.target);
        final f = dinic.flow(edge.source, edge.target);
        if (isCut && (cColor != null || dash != null)) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          if (cColor != null) {
            es.color = cColor;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        } else if (f > 0 && fColor != null) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          es.color = fColor;
          es.strokeWidth = 2.8;
        }
      }

      final rows = <List<String>>[
        ['Max Flow Value', '$maxFlowValue', 'Total capacity $s → $t'],
        [
          'Source Partition S',
          '${reachable.length} vertices',
          reachable.join(', '),
        ],
        [
          'Sink Partition T',
          '${vertices.length - reachable.length} vertices',
          vertices.where((v) => !reachable.contains(v)).join(', '),
        ],
      ];
      for (final edge in graph.edges) {
        final f = dinic.flow(edge.source, edge.target);
        final cap = capacityOf(edge.source, edge.target);
        final isCut =
            reachable.contains(edge.source) && !reachable.contains(edge.target);
        if (f > 0 || isCut) {
          rows.add([
            '${edge.source} → ${edge.target}',
            'Flow: $f / Cap: $cap',
            if (isCut) 'Min-Cut Edge' else 'Flow Edge',
          ]);
        }
      }

      return ModifierOutput(
        statusSummary: 'Max Flow ($s → $t) = $maxFlowValue',
        tableData: ModifierTableData(
          title: 'Max Flow / Min Cut ($s → $t)',
          headers: ['Element', 'Flow / Capacity', 'Detail'],
          rows: rows,
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Max flow error: $e',
        statusSummary: 'Error computing max flow',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Global Minimum Cut (Stoer-Wagner)
// ---------------------------------------------------------------------------

class MinCutModifier extends GraphModifier {
  new({super.enabled});

  String cutColor = '#ef4444';
  String cutPattern = '6,4';
  String partitionAColor = '#06b6d4';
  String partitionBColor = '#f59e0b';

  @override
  String get id => 'min_cut';

  @override
  String get name => 'Global Min Cut';

  @override
  ModifierCategory get category => ModifierCategory.flows;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    root.appendChild(
      colorSetting(
        'Cut Edges Color:',
        cutColor,
        onChanged: (c) {
          cutColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      lineStyleSetting(
        'Cut Line Style:',
        cutPattern,
        onChanged: (p) {
          cutPattern = p;
          onModified();
        },
      ),
    );
    root.appendChild(
      colorSetting(
        'Partition A Color:',
        partitionAColor,
        onChanged: (c) {
          partitionAColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      colorSetting(
        'Partition B Color:',
        partitionBColor,
        onChanged: (c) {
          partitionBColor = c;
          onModified();
        },
      ),
    );
    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage:
            'Stoer-Wagner global min-cut requires an undirected graph',
        statusSummary: 'Requires Undirected Graph',
      );
    }
    final vertices = graph.vertices.toList();
    if (vertices.length < 2) {
      return const ModifierOutput(statusSummary: 'Need at least 2 vertices');
    }

    try {
      final minCutObj = graph.minCut(
        edgeWeight: (u, v) {
          final edge = graph.getEdge(u, v);
          return edge?.value ?? 1;
        },
      );
      final weight = minCutObj.weight;
      final partition = minCutObj.graphs[0].vertices.toSet();
      final dash = cutPattern != 'none' ? cutPattern : null;
      final cColor = cutColor != 'none' ? cutColor : null;

      for (final v in vertices) {
        final node = state.nodes[v];
        final partColor = partition.contains(v)
            ? partitionAColor
            : partitionBColor;
        if (node != null && partColor != 'none') {
          node.style.borderColor = partColor;
          node.style.borderWidth = 2.5;
        }
      }

      // Color internal partition edges subtly and cut edges prominently
      for (final edge in graph.edges.toSet()) {
        final inA1 = partition.contains(edge.source);
        final inA2 = partition.contains(edge.target);
        if (inA1 == inA2) {
          final partColor = inA1 ? partitionAColor : partitionBColor;
          if (partColor != 'none') {
            final es = state.getEdgeStyle(edge.source, edge.target);
            es.color = partColor;
          }
        }
      }

      if (cColor != null || dash != null) {
        for (final edge in minCutObj.edges) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          if (cColor != null) {
            es.color = cColor;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        }
      }

      return ModifierOutput(
        statusSummary: 'Global Min Cut = $weight',
        tableData: ModifierTableData(
          title: 'Global Minimum Cut',
          headers: ['Metric', 'Value'],
          rows: [
            ['Min Cut Weight', '$weight'],
            ['Partition A (|A| = ${partition.length})', partition.join(', ')],
            [
              'Partition B (|B| = ${vertices.length - partition.length})',
              vertices.where((v) => !partition.contains(v)).join(', '),
            ],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Min cut error: $e',
        statusSummary: 'Error computing min cut',
      );
    }
  }
}
