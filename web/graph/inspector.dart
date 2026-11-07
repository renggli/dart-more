import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'state.dart';

/// Manages graph invariant computations and the vertex/edge inspector panel.
final class GraphInspector {
  static void updateInvariants(AppState state) {
    final graph = state.primaryGraph;
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

    final graph = state.primaryGraph;
    container.textContent = '';

    // 1. Edge inspector
    if (state.selectedEdge != null) {
      final (u, v) = state.selectedEdge!;
      final edge = graph.getEdge(u, v) ?? graph.getEdge(v, u);
      final currentWeight = edge?.value ?? 1;

      final p = web.HTMLParagraphElement();
      final arrow = graph.isDirected ? '→' : '—';
      p.textContent = 'Edge: $u $arrow $v';
      container.appendChild(p);

      final row = web.HTMLDivElement()..className = 'form-row';
      final lbl = web.HTMLLabelElement()..textContent = 'Weight:';
      final input = web.HTMLInputElement()
        ..id = 'input-inspector-weight'
        ..type = 'number'
        ..value = currentWeight.toString()
        ..style.maxWidth = '70px';
      final btn = web.HTMLButtonElement()
        ..className = 'button-small'
        ..textContent = 'Update';
      btn.onClick.listen((_) {
        final val = num.tryParse(input.value);
        if (val != null) {
          onUpdateWeight(u, v, val);
        }
      });

      row.appendChild(lbl);
      row.appendChild(input);
      row.appendChild(btn);
      container.appendChild(row);
      return;
    }

    // 2. Vertex inspector
    final selectedVertex =
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

      final titleP = web.HTMLParagraphElement();
      titleP.appendChild(web.HTMLSpanElement()..textContent = 'Node ID: ');
      titleP.appendChild(
        web.HTMLSpanElement()
          ..className = 'pill pill-source'
          ..textContent = v,
      );
      container.appendChild(titleP);

      // Node Label Editor
      final labelRow = web.HTMLDivElement()
        ..className = 'form-row'
        ..style.marginTop = '4px';
      final labelInput = web.HTMLInputElement()
        ..id = 'input-node-label'
        ..type = 'text'
        ..value = currentLabel
        ..placeholder = 'Node label'
        ..style.maxWidth = '110px';
      final labelBtn = web.HTMLButtonElement()
        ..className = 'button-small'
        ..textContent = 'Rename';
      labelBtn.onClick.listen((_) {
        final newLabel = labelInput.value.trim();
        if (newLabel.isNotEmpty) {
          onRenameNode(v, newLabel);
        }
      });
      labelRow.appendChild(labelInput);
      labelRow.appendChild(labelBtn);
      container.appendChild(labelRow);

      if (nodeObj != null && nodeObj.x != null && nodeObj.y != null) {
        final posP = web.HTMLParagraphElement()
          ..style.fontSize = '1.0rem'
          ..style.color = 'var(--text-muted)'
          ..style.margin = '2px 0 6px 0'
          ..textContent =
              'Position: X: ${nodeObj.x!.round()}px, Y: ${nodeObj.y!.round()}px';
        container.appendChild(posP);
      }

      final metricsP = web.HTMLParagraphElement()
        ..style.fontSize = '1.1rem'
        ..style.margin = '4px 0';
      if (graph.isDirected) {
        metricsP.textContent =
            'Degree: $deg (In: $inDeg, Out: $outDeg) | Clustering: ${clustering.toStringAsFixed(3)}';
      } else {
        metricsP.textContent =
            'Degree: $deg | Clustering: ${clustering.toStringAsFixed(3)}';
      }
      container.appendChild(metricsP);

      // Neighbours pills
      final neighbours = graph.neighboursOf(v).toList();
      if (neighbours.isNotEmpty) {
        final row = web.HTMLDivElement()..style.margin = '6px 0';
        row.appendChild(
          web.HTMLSpanElement()
            ..style.fontSize = '1.1rem'
            ..style.fontWeight = '600'
            ..textContent = 'Neighbours: ',
        );
        for (final n in neighbours) {
          final pill = web.HTMLSpanElement()
            ..className = 'pill'
            ..style.cursor = 'pointer'
            ..style.background = '#f1f5f9'
            ..style.margin = '2px'
            ..textContent = state.nodes[n]?.label ?? n;
          pill.onClick.listen((_) => onSelectVertex(n));
          row.appendChild(pill);
        }
        container.appendChild(row);
      }
      return;
    }

    // 3. Empty state
    container.appendChild(
      web.HTMLSpanElement()
        ..style.color = 'var(--text-muted)'
        ..textContent = 'Click a node or edge on the canvas to inspect and edit its properties.',
    );
  }

  static void _setText(String selector, String text) {
    final el = web.document.querySelector(selector);
    if (el != null) el.textContent = text;
  }
}
