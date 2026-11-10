import 'dart:js_interop';

import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'dom_utils.dart';
import 'html_utils.dart';
import 'state.dart';

typedef SelectVertexCallback = void Function(String v, {bool isShift});
typedef SelectEdgeCallback = void Function(String u, String v, {bool isShift});

/// Component rendering inspection details for selected graph vertices and edges.
final class GraphInspector {
  /// Updates the inspector panel contents based on active selection state.
  static void updateInspector(
    AppState state, {
    required SelectVertexCallback onSelectVertex,
    required SelectEdgeCallback onSelectEdge,
  }) {
    final container =
        web.document.querySelector('#inspector-content') as web.HTMLElement?;
    if (container == null) return;
    container.innerHTML = ''.toJS;

    final graph = state.renderGraph;

    // 1. Multiple Elements Selected
    if (state.selectedVertices.length + state.selectedEdges.length > 1) {
      _renderMultiSelection(
        container,
        state,
        graph,
        onSelectVertex,
        onSelectEdge,
      );
      return;
    }

    // 2. Single Edge Selected
    if (state.selectedEdge != null) {
      final (u, v) = state.selectedEdge!;
      final edge = graph.getEdge(u, v) ?? graph.getEdge(v, u);
      if (edge != null) {
        _renderSingleEdge(
          container,
          state,
          graph,
          edge.source,
          edge.target,
          edge.value,
          onSelectVertex,
          onSelectEdge,
        );
        return;
      }
    }

    // 3. Single Vertex Selected
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
    final emptySpan = span(
      'Click or marquee-select vertices and edges to inspect.',
      'inspector-muted-hint',
    );
    container.appendChild(emptySpan);
  }

  static void _renderMultiSelection(
    web.HTMLElement container,
    AppState state,
    Graph<String, num> graph,
    SelectVertexCallback onSelectVertex,
    SelectEdgeCallback onSelectEdge,
  ) {
    container.appendChild(p('Aggregate Selection', 'inspector-title'));

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
      for (final (u, v) in selE) {
        final e = graph.getEdge(u, v) ?? graph.getEdge(v, u);
        if (e != null) weights.add(e.value);
      }
      if (weights.isNotEmpty) {
        final totalWeight = weights.reduce((a, b) => a + b);
        final avgWeight = totalWeight / weights.length;
        metricsBuffer.writeln(
          '<b>Total Weight:</b> $totalWeight | <b>Avg:</b> ${avgWeight.toStringAsFixed(2)}<br>',
        );
      }
    }

    container.appendChild(_metricsParagraph(metricsBuffer.toString()));

    // Selected Vertices Pills
    if (selV.isNotEmpty) {
      final vRow = _sectionRow('Vertices: ');
      for (final v in selV) {
        final pill = span(
          state.nodes[v]?.label ?? v,
          'pill inspector-clickable',
        )..title = 'Click to select $v (Shift-click to add)';
        pill.onClick.listen((e) => onSelectVertex(v, isShift: e.shiftKey));
        vRow.appendChild(pill);
      }
      container.appendChild(vRow);
    }

    // Selected Edges
    if (selE.isNotEmpty) {
      final eRow = _sectionRow('Edges: ');
      final arrow = graph.isDirected ? '→' : '—';
      for (final (u, v) in selE) {
        final item = _buildEdgeItem(
          sourceText: state.nodes[u]?.label ?? u,
          sourceTooltip: 'Select vertex $u (Shift-click to add)',
          onSourceClick: (isShift) => onSelectVertex(u, isShift: isShift),
          edgeText: arrow,
          edgeTooltip: 'Select edge $u $arrow $v (Shift-click to add)',
          onEdgeClick: (isShift) => onSelectEdge(u, v, isShift: isShift),
          targetText: state.nodes[v]?.label ?? v,
          targetTooltip: 'Select vertex $v (Shift-click to add)',
          onTargetClick: (isShift) => onSelectVertex(v, isShift: isShift),
        );
        eRow.appendChild(item);
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
    final titleP = p(null, 'inspector-title');
    titleP.appendChild(span('Edge: '));
    titleP.appendChild(
      _buildEdgeItem(
        sourceText: state.nodes[u]?.label ?? u,
        sourceTooltip: 'Select vertex $u (Shift-click to add)',
        onSourceClick: (isShift) => onSelectVertex(u, isShift: isShift),
        edgeText: arrow,
        edgeTooltip: 'Select edge $u $arrow $v (Shift-click to add)',
        onEdgeClick: (isShift) => onSelectEdge(u, v, isShift: isShift),
        targetText: state.nodes[v]?.label ?? v,
        targetTooltip: 'Select vertex $v (Shift-click to add)',
        onTargetClick: (isShift) => onSelectVertex(v, isShift: isShift),
      ),
    );
    container.appendChild(titleP);

    final isBidi = graph.isDirected && graph.containsEdge(v, u);

    container.appendChild(
      _metricsParagraph('''
      <b>Weight:</b> $weight<br>
      <b>Direction:</b> ${graph.isDirected ? 'Directed ($arrow)' : 'Undirected'}<br>
      <b>Bidirectional:</b> ${isBidi ? 'Yes' : 'No'}<br>
      <b>Source Degree:</b> ${graph.degreeOf(u)} | <b>Target Degree:</b> ${graph.degreeOf(v)}
    '''),
    );

    // Opposing edge button
    if (isBidi) {
      final bidiRow = div('inspector-row');
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

    final titleP = p(null, 'inspector-title');
    titleP.appendChild(span('Vertex: '));
    titleP.appendChild(span(currentLabel, 'pill'));
    if (currentLabel != v) {
      titleP.appendChild(span(' (id: $v)', 'inspector-muted-hint'));
    }
    container.appendChild(titleP);

    // Detailed Vertex Metrics
    final overlay = state.activeOverlay;
    var extraMetric = '';
    if (overlay is HeatmapOverlay && overlay.scores.containsKey(v)) {
      extraMetric =
          '<br><b>${escapeHtml(overlay.title)}:</b> ${overlay.scores[v]!.toStringAsFixed(4)}';
    }

    final String metricsHtml;
    if (graph.isDirected) {
      metricsHtml =
          '''
        <b>Degree:</b> $deg (In: $inDeg, Out: $outDeg)<br>
        <b>Clustering Coeff:</b> ${clustering.toStringAsFixed(3)}$extraMetric
      ''';
    } else {
      metricsHtml =
          '''
        <b>Degree:</b> $deg<br>
        <b>Clustering Coeff:</b> ${clustering.toStringAsFixed(3)}$extraMetric
      ''';
    }
    container.appendChild(_metricsParagraph(metricsHtml));

    // Predecessors / In-Neighbors (if directed)
    if (graph.isDirected) {
      final preds = graph.predecessorsOf(v).toList();
      if (preds.isNotEmpty) {
        final predRow = _sectionRow('In-Neighbors: ');
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
      final succRow = _sectionRow(
        graph.isDirected ? 'Out-Neighbors: ' : 'Neighbors: ',
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
  }

  static web.HTMLParagraphElement _metricsParagraph(String html) =>
      p(null, 'inspector-metrics')..innerHTML = html.toJS;

  static web.HTMLDivElement _sectionRow(String labelText) {
    final row = div('inspector-row');
    row.appendChild(span(labelText, 'inspector-row-label'));
    return row;
  }

  static web.HTMLElement _buildEdgeItem({
    required String sourceText,
    required String sourceTooltip,
    required void Function(bool isShift) onSourceClick,
    required String edgeText,
    required String edgeTooltip,
    required void Function(bool isShift) onEdgeClick,
    required String targetText,
    required String targetTooltip,
    required void Function(bool isShift) onTargetClick,
  }) {
    final wrapper = span('', 'neighbor-item');

    final sourceBtn = span(sourceText, 'neighbor-vert-btn')
      ..title = sourceTooltip;
    sourceBtn.onClick.listen((event) {
      event.stopPropagation();
      onSourceClick(event.shiftKey);
    });

    final edgeBtn = span(edgeText, 'neighbor-edge-btn')..title = edgeTooltip;
    edgeBtn.onClick.listen((event) {
      event.stopPropagation();
      onEdgeClick(event.shiftKey);
    });

    final targetBtn = span(targetText, 'neighbor-vert-btn')
      ..title = targetTooltip;
    targetBtn.onClick.listen((event) {
      event.stopPropagation();
      onTargetClick(event.shiftKey);
    });

    wrapper.appendChild(sourceBtn);
    wrapper.appendChild(edgeBtn);
    wrapper.appendChild(targetBtn);
    return wrapper;
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
