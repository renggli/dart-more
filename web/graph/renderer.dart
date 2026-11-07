import 'dart:js_interop';
import 'dart:math' as math;

import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'state.dart';
import 'viz_interop.dart';

/// Callback signatures for interactive SVG events.
typedef VertexCallback = void Function(String vertex, web.MouseEvent event);
typedef EdgeCallback = void Function(
  String source,
  String target,
  web.MouseEvent event,
);

/// Renders graph states into interactive SVG via Viz.js and Graphviz.
final class GraphRenderer {
  new({
    required this.container,
    required this.transformLayer,
    required this.onVertexClick,
    required this.onEdgeClick,
    required this.onBackgroundClick,
  }) {
    _initViewportControls();
  }

  final web.HTMLElement container;
  final web.HTMLElement transformLayer;
  final VertexCallback onVertexClick;
  final EdgeCallback onEdgeClick;
  final void Function(web.MouseEvent event) onBackgroundClick;

  VizInstance? _viz;
  web.SVGSVGElement? _currentSvg;

  // Viewport CSS transform state
  double _scale = 1.0;
  double _panX = 0.0;
  double _panY = 0.0;
  bool _isPanning = false;
  double _startX = 0.0;
  double _startY = 0.0;

  web.SVGSVGElement? get currentSvg => _currentSvg;

  static const List<String> _palette = [
    '#93c5fd', // Light Blue
    '#86efac', // Light Green
    '#fde047', // Light Yellow
    '#fca5a5', // Light Red
    '#c4b5fd', // Light Purple
    '#fdba74', // Light Orange
    '#6ee7b7', // Light Emerald
    '#f9a8d4', // Light Pink
    '#cbd5e1', // Slate
    '#a5b4fc', // Indigo
    '#f0abfc', // Fuchsia
    '#5eead4', // Teal
  ];

  /// Initializes the WebAssembly Viz instance.
  Future<void> initialize() async {
    final promise = vizInstance();
    _viz = await promise.toDart;
  }

  /// Generates the DOT script for the given state and overlay.
  String generateDot(AppState state) {
    final graph = state.primaryGraph;
    final overlay = state.activeOverlay;

    // Pre-calculate min/max for heatmaps
    num minScore = 0;
    num maxScore = 1;
    if (overlay is HeatmapOverlay && overlay.scores.isNotEmpty) {
      final values = overlay.scores.values;
      minScore = values.reduce(math.min);
      maxScore = values.reduce(math.max);
      if (minScore == maxScore) {
        maxScore = minScore + 1;
      }
    }

    final activePathSet = <String>{};
    if (overlay is PathOverlay) {
      final limit = overlay.activeStep != null
          ? math.min(overlay.activeStep! + 1, overlay.vertices.length)
          : overlay.vertices.length;
      activePathSet.addAll(overlay.vertices.take(limit));
    }

    final dotString = graph.toDot<int>(
      graphAttributes: {
        'layout': state.layoutEngine,
        if (state.layoutEngine == 'dot') 'rankdir': state.rankDir,
        'overlap': 'false',
        'splines': 'true',
        'sep': '+25',
        'nodesep': '0.6',
        'ranksep': '0.7',
        'bgcolor': 'transparent',
        'pad': '0.3',
      },
      vertexLabel: (v) {
        var label = v;
        if (overlay is PathOverlay && overlay.stepNumbers) {
          final idx = overlay.vertices.indexOf(v);
          if (idx >= 0) {
            label = '#${idx + 1} $v';
          }
        } else if (overlay is HeatmapOverlay) {
          final score = overlay.scores[v];
          if (score != null) {
            label = '$v\n${_formatScore(score)}';
          }
        }
        return label;
      },
      vertexAttributes: (v) {
        final isSelected =
            state.selectedVertices.contains(v) ||
            state.selectedSource == v ||
            state.selectedTarget == v;

        final attrs = <String, String>{
          'id': 'node_$v',
          'shape': 'circle',
          'style': 'filled',
          'fontname': 'Inter, system-ui, sans-serif',
          'fontsize': '12',
          'margin': '0.12',
          'color': '#64748b',
          'fillcolor': '#f8fafc',
          'fontcolor': '#0f172a',
          'penwidth': isSelected ? '3.5' : '1.5',
        };

        // Selection border styling
        if (state.selectedSource == v) {
          attrs['color'] = '#16a34a'; // Green ring
          attrs['penwidth'] = '3.5';
        } else if (state.selectedTarget == v) {
          attrs['color'] = '#dc2626'; // Red ring
          attrs['penwidth'] = '3.5';
        } else if (state.selectedVertices.contains(v)) {
          attrs['color'] = '#2563eb'; // Blue ring
          attrs['penwidth'] = '3.5';
        }

        // Overlay specific styling
        if (overlay is PathOverlay) {
          final isActiveStep =
              overlay.activeStep != null &&
              overlay.activeStep! < overlay.vertices.length &&
              overlay.vertices[overlay.activeStep!] == v;

          if (isActiveStep) {
            attrs['fillcolor'] = '#2563eb';
            attrs['fontcolor'] = '#ffffff';
            attrs['penwidth'] = '3.5';
          } else if (activePathSet.contains(v)) {
            attrs['fillcolor'] = '#dbeafe';
            attrs['color'] = '#3b82f6';
          } else if (overlay.vertices.isNotEmpty) {
            attrs['fillcolor'] = '#f8fafc';
            attrs['fontcolor'] = '#94a3b8';
            attrs['color'] = '#e2e8f0';
          }
        } else if (overlay is HighlightOverlay) {
          if (overlay.highlightedVertices.contains(v)) {
            attrs['fillcolor'] = '#fef08a';
            attrs['color'] = '#ca8a04';
            attrs['penwidth'] = '2.5';
          } else if (overlay.secondaryVertices.contains(v)) {
            attrs['fillcolor'] = '#e0e7ff';
            attrs['color'] = '#4f46e5';
            attrs['penwidth'] = '2.5';
          } else if (overlay.highlightedVertices.isNotEmpty ||
              overlay.secondaryVertices.isNotEmpty) {
            attrs['fillcolor'] = '#f8fafc';
            attrs['fontcolor'] = '#94a3b8';
            attrs['color'] = '#e2e8f0';
          }
        } else if (overlay is PartitionOverlay) {
          final group = overlay.vertexGroup[v];
          if (group != null) {
            final color = _palette[group.abs() % _palette.length];
            attrs['fillcolor'] = color;
          }
        } else if (overlay is HeatmapOverlay) {
          final score = overlay.scores[v];
          if (score != null) {
            final t = ((score - minScore) / (maxScore - minScore)).clamp(
              0.0,
              1.0,
            );
            attrs['fillcolor'] = _interpolateHeatmap(t);
            if (t > 0.65) {
              attrs['fontcolor'] = '#ffffff';
            }
          }
        }

        return attrs;
      },
      edgeLabel: (e) {
        if (overlay is HighlightOverlay &&
            overlay.edgeLabels.containsKey((e.source, e.target))) {
          return overlay.edgeLabels[(e.source, e.target)]!;
        }
        if (state.isWeighted) {
          return e.value.toString();
        }
        return '';
      },
      edgeAttributes: (e) {
        final isSelected =
            state.selectedEdge == (e.source, e.target) ||
            (!graph.isDirected && state.selectedEdge == (e.target, e.source));

        final attrs = <String, String>{
          'id': 'edge_${e.source}__${e.target}',
          'fontname': 'Inter, system-ui, sans-serif',
          'fontsize': '11',
          'color': isSelected ? '#dc2626' : '#94a3b8',
          'penwidth': isSelected ? '3.0' : '1.5',
        };

        if (overlay is PathOverlay) {
          final inPath = overlay.edges.any(
            (p) =>
                (p.$1 == e.source && p.$2 == e.target) ||
                (!graph.isDirected && p.$1 == e.target && p.$2 == e.source),
          );
          if (inPath) {
            attrs['color'] = '#2563eb';
            attrs['penwidth'] = '3.0';
          } else if (overlay.edges.isNotEmpty) {
            attrs['color'] = '#e2e8f0';
          }
        } else if (overlay is HighlightOverlay) {
          final isHighlighted = overlay.highlightedEdges.any(
            (p) =>
                (p.$1 == e.source && p.$2 == e.target) ||
                (!graph.isDirected && p.$1 == e.target && p.$2 == e.source),
          );
          if (isHighlighted) {
            attrs['color'] = '#2563eb';
            attrs['penwidth'] = '3.0';
          } else if (overlay.highlightedEdges.isNotEmpty) {
            attrs['color'] = '#e2e8f0';
          }
        } else if (overlay is PartitionOverlay) {
          final isHighlighted = overlay.highlightedEdges.any(
            (p) =>
                (p.$1 == e.source && p.$2 == e.target) ||
                (!graph.isDirected && p.$1 == e.target && p.$2 == e.source),
          );
          if (isHighlighted) {
            attrs['color'] = '#ef4444';
            attrs['penwidth'] = '2.5';
            attrs['style'] = 'dashed';
          }
        }

        return attrs;
      },
      subgraph: overlay is PartitionOverlay && overlay.renderClusters
          ? (v) => overlay.vertexGroup[v]
          : null,
      subgraphName: (g) => 'cluster_$g',
      subgraphLabel: (g) => 'Group ${g + 1}',
      subgraphAttributes: (g) => {
        'style': 'rounded,dashed',
        'color': '#94a3b8',
        'bgcolor': '#f1f5f9',
      },
    );

    return dotString;
  }

  /// Renders the current graph state into the container element.
  void render(AppState state) {
    if (_viz == null) return;

    final dotString = generateDot(state);
    try {
      final svg = _viz!.renderSVGElement(
        dotString,
        VizRenderOptions(engine: state.layoutEngine),
      );

      svg.style.width = '100%';
      svg.style.height = '100%';
      svg.style.overflow = 'visible';

      _attachSvgListeners(svg);

      container.replaceChildren(svg);
      _currentSvg = svg;
    } catch (error) {
      container.replaceChildren(
        web.HTMLParagraphElement()
          ..className = 'render-error'
          ..textContent = 'Rendering failed: $error',
      );
    }
  }

  void _initViewportControls() {
    final viewport = (container.parentElement ?? container) as web.HTMLElement;

    // Smooth CSS-pixel panning
    viewport.onmousedown = ((web.MouseEvent event) {
      final target = event.target as web.Element?;
      if (target != null &&
          (target.closest('.node') != null ||
              target.closest('.edge') != null)) {
        return;
      }
      _isPanning = true;
      _startX = event.clientX - _panX;
      _startY = event.clientY - _panY;
      viewport.style.cursor = 'grabbing';
    }).toJS;

    web.window.onmousemove = ((web.MouseEvent event) {
      if (!_isPanning) return;
      _panX = event.clientX - _startX;
      _panY = event.clientY - _startY;
      _updateTransform();
    }).toJS;

    web.window.onmouseup = ((web.MouseEvent event) {
      if (_isPanning) {
        _isPanning = false;
        viewport.style.cursor = 'default';
      }
    }).toJS;

    // Smooth CSS-pixel zooming centered on cursor
    viewport.onwheel = ((web.WheelEvent event) {
      event.preventDefault();
      final rect = viewport.getBoundingClientRect();
      final mouseX = event.clientX - rect.left;
      final mouseY = event.clientY - rect.top;

      final zoomFactor = event.deltaY < 0 ? 1.15 : 0.85;
      final newScale = (_scale * zoomFactor).clamp(0.1, 8.0);

      _panX = mouseX - (mouseX - _panX) * (newScale / _scale);
      _panY = mouseY - (mouseY - _panY) * (newScale / _scale);
      _scale = newScale;

      _updateTransform();
    }).toJS;

    viewport.onclick = ((web.MouseEvent event) {
      final target = event.target as web.Element?;
      if (target != null &&
          target.closest('.node') == null &&
          target.closest('.edge') == null) {
        onBackgroundClick(event);
      }
    }).toJS;
  }

  void _attachSvgListeners(web.SVGSVGElement svg) {
    // Attach click events on nodes
    final nodes = svg.querySelectorAll('.node');
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes.item(i) as web.SVGGElement?;
      if (node == null) continue;
      final title = node.querySelector('title')?.textContent?.trim() ?? '';
      node.style.cursor = 'pointer';
      node.onclick = ((web.MouseEvent event) {
        event.stopPropagation();
        onVertexClick(title, event);
      }).toJS;
    }

    // Attach click events on edges
    final edges = svg.querySelectorAll('.edge');
    for (var i = 0; i < edges.length; i++) {
      final edge = edges.item(i) as web.SVGGElement?;
      if (edge == null) continue;
      final title = edge.querySelector('title')?.textContent?.trim() ?? '';
      final parts = title.contains('->')
          ? title.split('->')
          : title.split('--');
      if (parts.length == 2) {
        final source = parts[0].trim();
        final target = parts[1].trim();
        edge.style.cursor = 'pointer';
        edge.onclick = ((web.MouseEvent event) {
          event.stopPropagation();
          onEdgeClick(source, target, event);
        }).toJS;
      }
    }
  }

  void _updateTransform() {
    transformLayer.style.transform =
        'translate(${_panX}px, ${_panY}px) scale($_scale)';
  }

  /// Centers and fits the graph view to the viewport.
  void resetView() {
    _scale = 1.0;
    _panX = 0.0;
    _panY = 0.0;
    _updateTransform();
  }

  void zoomIn() {
    _scale = (_scale * 1.25).clamp(0.1, 8.0);
    _updateTransform();
  }

  void zoomOut() {
    _scale = (_scale * 0.8).clamp(0.1, 8.0);
    _updateTransform();
  }

  static String _formatScore(num value) {
    if (value is int || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(3);
  }

  /// Interpolates between cold blue (#2563eb), warm yellow (#fde047), and hot red (#dc2626).
  static String _interpolateHeatmap(double t) {
    int r, g, b;
    if (t < 0.5) {
      final f = t / 0.5;
      r = (37 + f * (253 - 37)).round();
      g = (99 + f * (224 - 99)).round();
      b = (235 + f * (71 - 235)).round();
    } else {
      final f = (t - 0.5) / 0.5;
      r = (253 + f * (220 - 253)).round();
      g = (224 + f * (38 - 224)).round();
      b = (71 + f * (38 - 71)).round();
    }
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
