import 'dart:js_interop';
import 'dart:math' as math;

import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'dom_utils.dart';
import 'state.dart';

/// Manages graph invariant computations and the vertex/edge inspector panel.
final class GraphInspector {
  static void updateInvariants(AppState state) {
    final graph = state.renderGraph;
    final vCount = graph.vertices.length;
    final eCount = graph.edges.unique().length;

    _setText('#stat-nodes', vCount.toString());
    _setText('#stat-edges', eCount.toString());

    if (vCount < 2) {
      _setText('#stat-density', '0.00');
    } else {
      _setText('#stat-density', graph.density().toStringAsFixed(3));
    }

    try {
      _setText('#stat-components', graph.connected().length.toString());
    } catch (_) {
      _setText('#stat-components', '-');
    }

    if (!graph.isDirected) {
      try {
        _setText('#stat-planar', graph.isPlanar() ? 'Yes' : 'No');
      } catch (_) {
        _setText('#stat-planar', '-');
      }
    } else {
      _setText('#stat-planar', 'N/A');
    }

    try {
      _setText('#stat-bipartite', graph.isBipartite() ? 'Yes' : 'No');
    } catch (_) {
      _setText('#stat-bipartite', '-');
    }

    if (graph.isDirected) {
      try {
        _setText('#stat-cycle', graph.hasCycle() ? 'Yes' : 'No');
      } catch (_) {
        _setText('#stat-cycle', '-');
      }
    } else {
      _setText('#stat-cycle', 'N/A');
    }

    try {
      if (graph.hasEulerianCircuit()) {
        _setText('#stat-eulerian', 'Circuit');
      } else if (graph.hasEulerianPath()) {
        _setText('#stat-eulerian', 'Path');
      } else {
        _setText('#stat-eulerian', 'No');
      }
    } catch (_) {
      _setText('#stat-eulerian', '-');
    }
  }

  static void updateInspector(
    AppState state, {
    required void Function(String vertex) onSelectVertex,
    required void Function(String u, String v, num newWeight) onUpdateWeight,
    required void Function(String vertex, String newLabel) onRenameNode,
  }) {
    final container =
        web.document.querySelector('#inspector-content') as web.HTMLElement?;
    if (container == null) return;

    final graph = state.renderGraph;
    container.textContent = '';

    // 1. Edge inspector
    if (state.selectedEdge != null) {
      final (u, v) = state.selectedEdge!;
      final edge = graph.getEdge(u, v) ?? graph.getEdge(v, u);
      final currentWeight = edge?.value ?? 1;
      final arrow = graph.isDirected ? '→' : '—';

      final titleP = p()..style.margin = '0 0 6px 0';
      titleP.appendChild(span('Edge: ')..style.fontWeight = '600');
      titleP.appendChild(
        span(u, 'pill pill-source')..style.marginRight = '4px',
      );
      titleP.appendChild(span(arrow)..style.margin = '0 4px');
      titleP.appendChild(span(v, 'pill pill-target'));
      container.appendChild(titleP);

      final formRow = div('form-row')..style.margin = '4px 0 8px 0';
      final lbl = label('Weight:')..style.fontSize = '11.5px';
      final input = numberInput(currentWeight)
        ..id = 'input-inspector-weight'
        ..style.maxWidth = '80px';
      final btn = button('Set', 'button-small');
      btn.onClick.listen((_) {
        final val = num.tryParse(input.value);
        if (val != null) {
          onUpdateWeight(u, v, val);
        }
      });
      input.onKeyDown.listen((e) {
        if (e.key == 'Enter') {
          final val = num.tryParse(input.value);
          if (val != null) onUpdateWeight(u, v, val);
        }
      });

      formRow.appendChild(lbl);
      formRow.appendChild(input);
      formRow.appendChild(btn);
      container.appendChild(formRow);

      // Edge Metrics
      final nodeU = state.nodes[u];
      final nodeV = state.nodes[v];
      var distStr = '-';
      if (nodeU?.x != null &&
          nodeU?.y != null &&
          nodeV?.x != null &&
          nodeV?.y != null) {
        final dx = nodeV!.x! - nodeU!.x!;
        final dy = nodeV.y! - nodeU.y!;
        distStr = '${math.sqrt(dx * dx + dy * dy).round()} px';
      }

      final metricsP = p()
        ..style.fontSize = '11px'
        ..style.color = 'var(--text-secondary)'
        ..style.lineHeight = '1.5';
      final isBidi = graph.isDirected && graph.containsEdge(v, u);
      metricsP.innerHTML =
          '''
        <b>Direction:</b> ${graph.isDirected ? 'Directed' : 'Undirected'}<br>
        <b>Bidirectional:</b> ${isBidi ? 'Yes (opposing edge exists)' : 'No'}<br>
        <b>Length:</b> $distStr<br>
        <b>Source deg:</b> ${graph.degreeOf(u)} | <b>Target deg:</b> ${graph.degreeOf(v)}
      '''
              .toJS;
      container.appendChild(metricsP);
      return;
    }

    // 2. Vertex inspector
    final selectedVertex =
        state.activeVertex ??
        state.selectedSource ??
        (state.selectedVertices.isNotEmpty
            ? state.selectedVertices.first
            : state.selectedTarget);
    if (selectedVertex != null && graph.containsVertex(selectedVertex)) {
      final v = selectedVertex;
      final nodeObj = state.nodes[v];
      final currentLabel = nodeObj?.label ?? v;
      final deg = graph.degreeOf(v);
      final inDeg = graph.isDirected ? graph.inDegreeOf(v) : deg;
      final outDeg = graph.isDirected ? graph.outDegreeOf(v) : deg;
      final clustering = graph.localClusteringCoefficient(v);

      final titleP = p()..style.margin = '0 0 6px 0';
      titleP.appendChild(span('Active Vertex: ')..style.fontWeight = '600');
      titleP.appendChild(span(v, 'pill pill-source'));
      container.appendChild(titleP);

      // Vertex Label Editor
      final labelRow = div('form-row')..style.margin = '4px 0 8px 0';
      final labelInput = textInput(currentLabel, 'Vertex label')
        ..id = 'input-vertex-label'
        ..style.maxWidth = '110px';
      final labelBtn = button('Rename', 'button-small');
      void commitRename() {
        final newLabel = labelInput.value.trim();
        if (newLabel.isNotEmpty) onRenameNode(v, newLabel);
      }

      labelBtn.onClick.listen((_) => commitRename());
      labelInput.onKeyDown.listen((e) {
        if (e.key == 'Enter') commitRename();
      });
      labelRow.appendChild(labelInput);
      labelRow.appendChild(labelBtn);
      container.appendChild(labelRow);

      // Coordinates
      if (nodeObj != null && nodeObj.x != null && nodeObj.y != null) {
        final posP =
            p('Position: X: ${nodeObj.x!.round()}px, Y: ${nodeObj.y!.round()}px')
              ..style.fontSize = '10.5px'
              ..style.color = 'var(--text-muted)'
              ..style.margin = '0 0 6px 0';
        container.appendChild(posP);
      }

      // Detailed Vertex Metrics
      final metricsP = p()
        ..style.fontSize = '11px'
        ..style.color = 'var(--text-secondary)'
        ..style.lineHeight = '1.5'
        ..style.margin = '0 0 6px 0';

      final overlay = state.activeOverlay;
      var extraMetric = '';
      if (overlay is HeatmapOverlay && overlay.scores.containsKey(v)) {
        extraMetric =
            '<br><b>${overlay.title}:</b> ${overlay.scores[v]!.toStringAsFixed(4)}';
      }

      if (graph.isDirected) {
        metricsP.innerHTML =
            '''
          <b>Degree:</b> $deg (In: $inDeg, Out: $outDeg)<br>
          <b>Clustering Coeff:</b> ${clustering.toStringAsFixed(3)}$extraMetric
        '''
                .toJS;
      } else {
        metricsP.innerHTML =
            '''
          <b>Degree:</b> $deg<br>
          <b>Clustering Coeff:</b> ${clustering.toStringAsFixed(3)}$extraMetric
        '''
                .toJS;
      }
      container.appendChild(metricsP);

      // Predecessors (if directed)
      if (graph.isDirected) {
        final preds = graph.predecessorsOf(v).toList();
        if (preds.isNotEmpty) {
          final predRow = div()..style.margin = '4px 0';
          predRow.appendChild(
            span('In-Neighbors: ')
              ..style.fontSize = '10.5px'
              ..style.fontWeight = '600',
          );
          for (final p in preds) {
            final pill = span(state.nodes[p]?.label ?? p, 'pill')
              ..style.cursor = 'pointer'
              ..style.margin = '2px';
            pill.onClick.listen((_) => onSelectVertex(p));
            predRow.appendChild(pill);
          }
          container.appendChild(predRow);
        }
      }

      // Successors / Neighbors
      final succs =
          (graph.isDirected ? graph.successorsOf(v) : graph.neighboursOf(v))
              .toList();
      if (succs.isNotEmpty) {
        final succRow = div()..style.margin = '4px 0';
        succRow.appendChild(
          span(graph.isDirected ? 'Out-Neighbors: ' : 'Neighbors: ')
            ..style.fontSize = '10.5px'
            ..style.fontWeight = '600',
        );
        for (final s in succs) {
          final pill = span(state.nodes[s]?.label ?? s, 'pill')
            ..style.cursor = 'pointer'
            ..style.margin = '2px';
          pill.onClick.listen((_) => onSelectVertex(s));
          succRow.appendChild(pill);
        }
        container.appendChild(succRow);
      }
      return;
    }

    // 3. Multi-selection summary
    if (state.selectedVertices.length > 1 || state.selectedEdges.length > 1) {
      final summaryP = p()
        ..style.fontSize = '11.5px'
        ..style.lineHeight = '1.5'
        ..style.color = 'var(--text-secondary)';
      summaryP.innerHTML =
          '''
        <b>Selection Summary:</b><br>
        • Vertices: <b>${state.selectedVertices.length}</b><br>
        • Edges: <b>${state.selectedEdges.length}</b>
      '''
              .toJS;
      container.appendChild(summaryP);
      return;
    }

    // 4. Empty state
    final emptySpan =
        span(
            'Click a vertex or edge on the canvas to inspect and edit its properties.',
          )
          ..style.color = 'var(--text-muted)'
          ..style.fontSize = '11.5px';
    container.appendChild(emptySpan);
  }

  static void _setText(String selector, String text) {
    final el = web.document.querySelector(selector);
    if (el != null) el.textContent = text;
  }
}
