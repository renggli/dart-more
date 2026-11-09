import 'dart:js_interop';
import 'dart:math' as math;

import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'dom_utils.dart';
import 'state.dart';

typedef SelectVertexCallback = void Function(String vertex, {bool isShift});
typedef SelectEdgeCallback = void Function(String u, String v, {bool isShift});

/// Manages the vertex/edge inspector panel.
final class GraphInspector {
  static void updateInspector(
    AppState state, {
    required SelectVertexCallback onSelectVertex,
    required SelectEdgeCallback onSelectEdge,
  }) {
    final container =
        web.document.querySelector('#inspector-content') as web.HTMLElement?;
    if (container == null) return;

    final graph = state.renderGraph;
    container.textContent = '';

    // 1. Multi-selection aggregate metrics (when >1 vertex or >1 edge selected)
    if (state.selectedVertices.length > 1 || state.selectedEdges.length > 1) {
      _renderMultiSelection(
        container,
        state,
        graph,
        onSelectVertex,
        onSelectEdge,
      );
      return;
    }

    // 2. Single Edge inspector
    if (state.selectedEdge != null) {
      final (u, v) = state.selectedEdge!;
      final edge = graph.getEdge(u, v) ?? graph.getEdge(v, u);
      if (edge != null || graph.containsEdge(u, v)) {
        _renderSingleEdge(
          container,
          state,
          graph,
          u,
          v,
          edge?.value ?? 1,
          onSelectVertex,
          onSelectEdge,
        );
        return;
      }
    }

    // 3. Single Vertex inspector
    final selectedVertex =
        state.activeVertex ??
        state.selectedSource ??
        (state.selectedVertices.isNotEmpty
            ? state.selectedVertices.first
            : state.selectedTarget);

    if (selectedVertex != null && graph.containsVertex(selectedVertex)) {
      _renderSingleVertex(
        container,
        state,
        graph,
        selectedVertex,
        onSelectVertex,
        onSelectEdge,
      );
      return;
    }

    // 4. Empty state
    final emptySpan =
        span('Click or marquee-select vertices and edges to inspect.')
          ..style.color = 'var(--text-muted)'
          ..style.fontSize = '11.5px';
    container.appendChild(emptySpan);
  }

  static void _renderMultiSelection(
    web.HTMLElement container,
    AppState state,
    Graph<String, num> graph,
    SelectVertexCallback onSelectVertex,
    SelectEdgeCallback onSelectEdge,
  ) {
    final titleP = p()..style.margin = '0 0 6px 0';
    titleP.appendChild(span('Aggregate Selection')..style.fontWeight = '600');
    container.appendChild(titleP);

    final selV = state.selectedVertices;
    final selE = state.selectedEdges;

    // Aggregate statistics
    final metricsBuffer = StringBuffer();
    metricsBuffer.writeln('<b>Vertices Selected:</b> ${selV.length}<br>');
    metricsBuffer.writeln('<b>Edges Selected:</b> ${selE.length}<br>');

    if (selV.length > 1) {
      var internalEdges = 0;
      for (final u in selV) {
        for (final v in graph.successorsOf(u)) {
          if (selV.contains(v)) internalEdges++;
        }
      }
      final possibleEdges = graph.isDirected
          ? selV.length * (selV.length - 1)
          : (selV.length * (selV.length - 1)) ~/ 2;
      final density = possibleEdges > 0 ? internalEdges / possibleEdges : 0.0;
      metricsBuffer.writeln(
        '<b>Induced Density:</b> ${density.toStringAsFixed(3)} ($internalEdges edges)<br>',
      );

      final avgDegree =
          selV.map(graph.degreeOf).reduce((a, b) => a + b) / selV.length;
      metricsBuffer.writeln(
        '<b>Avg Degree:</b> ${avgDegree.toStringAsFixed(2)}<br>',
      );
    }

    if (selE.isNotEmpty) {
      final weights = <num>[];
      var totalLength = 0.0;
      for (final (u, v) in selE) {
        final e = graph.getEdge(u, v) ?? graph.getEdge(v, u);
        if (e != null) weights.add(e.value);
        final nU = state.nodes[u];
        final nV = state.nodes[v];
        if (nU?.x != null && nU?.y != null && nV?.x != null && nV?.y != null) {
          final dx = nV!.x! - nU!.x!;
          final dy = nV.y! - nU.y!;
          totalLength += math.sqrt(dx * dx + dy * dy);
        }
      }
      if (weights.isNotEmpty) {
        final totalWeight = weights.reduce((a, b) => a + b);
        final avgWeight = totalWeight / weights.length;
        metricsBuffer.writeln(
          '<b>Total Weight:</b> $totalWeight | <b>Avg:</b> ${avgWeight.toStringAsFixed(2)}<br>',
        );
      }
      if (totalLength > 0) {
        metricsBuffer.writeln(
          '<b>Total Length:</b> ${totalLength.round()} px<br>',
        );
      }
    }

    final metricsP = p()
      ..style.fontSize = '11px'
      ..style.color = 'var(--text-secondary)'
      ..style.lineHeight = '1.5'
      ..style.margin = '0 0 8px 0';
    metricsP.innerHTML = metricsBuffer.toString().toJS;
    container.appendChild(metricsP);

    // Selected Vertices Pills
    if (selV.isNotEmpty) {
      final vRow = div()..style.margin = '4px 0';
      vRow.appendChild(
        span('Vertices: ')
          ..style.fontSize = '10.5px'
          ..style.fontWeight = '600',
      );
      for (final v in selV) {
        final pill = span(state.nodes[v]?.label ?? v, 'pill')
          ..style.cursor = 'pointer'
          ..style.margin = '2px'
          ..title = 'Click to select $v (Shift-click to add)';
        pill.onClick.listen((e) => onSelectVertex(v, isShift: e.shiftKey));
        vRow.appendChild(pill);
      }
      container.appendChild(vRow);
    }

    // Selected Edges Pills
    if (selE.isNotEmpty) {
      final eRow = div()..style.margin = '4px 0';
      eRow.appendChild(
        span('Edges: ')
          ..style.fontSize = '10.5px'
          ..style.fontWeight = '600',
      );
      final arrow = graph.isDirected ? '→' : '—';
      for (final (u, v) in selE) {
        final pill = span('$u$arrow$v', 'pill')
          ..style.cursor = 'pointer'
          ..style.margin = '2px'
          ..title = 'Click to select edge $u$arrow$v (Shift-click to add)';
        pill.onClick.listen((e) => onSelectEdge(u, v, isShift: e.shiftKey));
        eRow.appendChild(pill);
      }
      container.appendChild(eRow);
    }
  }

  static void _renderSingleEdge(
    web.HTMLElement container,
    AppState state,
    Graph<String, num> graph,
    String u,
    String v,
    num weight,
    SelectVertexCallback onSelectVertex,
    SelectEdgeCallback onSelectEdge,
  ) {
    final arrow = graph.isDirected ? '→' : '—';
    final titleP = p()..style.margin = '0 0 6px 0';
    titleP.appendChild(span('Edge: ')..style.fontWeight = '600');

    final pillU = span(u, 'pill')
      ..style.cursor = 'pointer'
      ..title = 'Click to inspect vertex $u (Shift-click to add)';
    pillU.onClick.listen((e) => onSelectVertex(u, isShift: e.shiftKey));
    titleP.appendChild(pillU);

    titleP.appendChild(span(arrow)..style.margin = '0 4px');

    final pillV = span(v, 'pill')
      ..style.cursor = 'pointer'
      ..title = 'Click to inspect vertex $v (Shift-click to add)';
    pillV.onClick.listen((e) => onSelectVertex(v, isShift: e.shiftKey));
    titleP.appendChild(pillV);

    container.appendChild(titleP);

    final isBidi = graph.isDirected && graph.containsEdge(v, u);

    final metricsP = p()
      ..style.fontSize = '11px'
      ..style.color = 'var(--text-secondary)'
      ..style.lineHeight = '1.5'
      ..style.margin = '0 0 8px 0';
    metricsP.innerHTML =
        '''
      <b>Weight:</b> $weight<br>
      <b>Direction:</b> ${graph.isDirected ? 'Directed ($arrow)' : 'Undirected'}<br>
      <b>Bidirectional:</b> ${isBidi ? 'Yes' : 'No'}<br>
      <b>Source Degree:</b> ${graph.degreeOf(u)} | <b>Target Degree:</b> ${graph.degreeOf(v)}
    '''
            .toJS;
    container.appendChild(metricsP);

    // Opposing edge button
    if (isBidi) {
      final bidiRow = div()..style.margin = '4px 0';
      final bidiBtn = button('Select Opposing ($v→$u)', 'button-small');
      bidiBtn.onClick.listen((_) => onSelectEdge(v, u));
      bidiRow.appendChild(bidiBtn);
      container.appendChild(bidiRow);
    }
  }

  static void _renderSingleVertex(
    web.HTMLElement container,
    AppState state,
    Graph<String, num> graph,
    String v,
    SelectVertexCallback onSelectVertex,
    SelectEdgeCallback onSelectEdge,
  ) {
    final nodeObj = state.nodes[v];
    final currentLabel = nodeObj?.label ?? v;
    final deg = graph.degreeOf(v);
    final inDeg = graph.isDirected ? graph.inDegreeOf(v) : deg;
    final outDeg = graph.isDirected ? graph.outDegreeOf(v) : deg;
    final clustering = graph.localClusteringCoefficient(v);

    final titleP = p()..style.margin = '0 0 6px 0';
    titleP.appendChild(span('Vertex: ')..style.fontWeight = '600');
    titleP.appendChild(span(currentLabel, 'pill'));
    if (currentLabel != v) {
      titleP.appendChild(
        span(' (id: $v)')
          ..style.color = 'var(--text-muted)'
          ..style.fontSize = '10.5px',
      );
    }
    container.appendChild(titleP);

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

    // Predecessors / In-Neighbors (if directed)
    if (graph.isDirected) {
      final preds = graph.predecessorsOf(v).toList();
      if (preds.isNotEmpty) {
        final predRow = div()..style.margin = '6px 0';
        predRow.appendChild(
          span('In-Neighbors: ')
            ..style.fontSize = '10.5px'
            ..style.fontWeight = '600'
            ..style.display = 'block'
            ..style.marginBottom = '2px',
        );
        for (final p in preds) {
          final item = _buildNeighborItem(
            edgeText: '→',
            edgeTooltip: 'Select edge $p → $v (Shift-click to add)',
            onEdgeClick: (isShift) => onSelectEdge(p, v, isShift: isShift),
            vertexText: state.nodes[p]?.label ?? p,
            vertexTooltip: 'Select vertex $p (Shift-click to add)',
            onVertexClick: (isShift) => onSelectVertex(p, isShift: isShift),
            edgeFirst: true,
          );
          predRow.appendChild(item);
        }
        container.appendChild(predRow);
      }
    }

    // Successors / Neighbors
    final succs =
        (graph.isDirected ? graph.successorsOf(v) : graph.neighboursOf(v))
            .toList();
    if (succs.isNotEmpty) {
      final succRow = div()..style.margin = '6px 0';
      succRow.appendChild(
        span(graph.isDirected ? 'Out-Neighbors: ' : 'Neighbors: ')
          ..style.fontSize = '10.5px'
          ..style.fontWeight = '600'
          ..style.display = 'block'
          ..style.marginBottom = '2px',
      );
      for (final s in succs) {
        final edgeU = graph.isDirected ? v : (v.compareTo(s) <= 0 ? v : s);
        final edgeV = graph.isDirected ? s : (v.compareTo(s) <= 0 ? s : v);
        final arrow = graph.isDirected ? '→' : '—';
        final item = _buildNeighborItem(
          edgeText: arrow,
          edgeTooltip: 'Select edge $v $arrow $s (Shift-click to add)',
          onEdgeClick: (isShift) =>
              onSelectEdge(edgeU, edgeV, isShift: isShift),
          vertexText: state.nodes[s]?.label ?? s,
          vertexTooltip: 'Select vertex $s (Shift-click to add)',
          onVertexClick: (isShift) => onSelectVertex(s, isShift: isShift),
          edgeFirst: false,
        );
        succRow.appendChild(item);
      }
      container.appendChild(succRow);
    }

    // Connected Incident Edges
    final incidentEdges = graph.edgesOf(v).toList();
    if (incidentEdges.isNotEmpty) {
      final eRow = div()..style.margin = '6px 0';
      eRow.appendChild(
        span('Incident Edges: ')
          ..style.fontSize = '10.5px'
          ..style.fontWeight = '600'
          ..style.display = 'block'
          ..style.marginBottom = '2px',
      );
      for (final edge in incidentEdges) {
        final isIncoming =
            graph.isDirected && edge.target == v && edge.source != v;
        final otherV = isIncoming ? edge.source : edge.target;
        final arrow = graph.isDirected ? '→' : '—';
        final edgeText = arrow;
        final item = _buildNeighborItem(
          edgeText: edgeText,
          edgeTooltip:
              'Select edge ${edge.source} $arrow ${edge.target} (Shift-click to add)',
          onEdgeClick: (isShift) =>
              onSelectEdge(edge.source, edge.target, isShift: isShift),
          vertexText: state.nodes[otherV]?.label ?? otherV,
          vertexTooltip: 'Select vertex $otherV (Shift-click to add)',
          onVertexClick: (isShift) => onSelectVertex(otherV, isShift: isShift),
          edgeFirst: isIncoming,
        );
        eRow.appendChild(item);
      }
      container.appendChild(eRow);
    }
  }

  static web.HTMLElement _buildNeighborItem({
    required String edgeText,
    required String edgeTooltip,
    required void Function(bool isShift) onEdgeClick,
    required String vertexText,
    required String vertexTooltip,
    required void Function(bool isShift) onVertexClick,
    bool edgeFirst = true,
  }) {
    final wrapper = span('', 'neighbor-item');

    final edgeBtn = span(edgeText, 'neighbor-edge-btn')..title = edgeTooltip;
    edgeBtn.onClick.listen((event) {
      event.stopPropagation();
      onEdgeClick(event.shiftKey);
    });

    final vertBtn = span(vertexText, 'neighbor-vert-btn')
      ..title = vertexTooltip;
    vertBtn.onClick.listen((event) {
      event.stopPropagation();
      onVertexClick(event.shiftKey);
    });

    if (edgeFirst) {
      wrapper.appendChild(edgeBtn);
      wrapper.appendChild(vertBtn);
    } else {
      wrapper.appendChild(vertBtn);
      wrapper.appendChild(edgeBtn);
    }
    return wrapper;
  }
}
