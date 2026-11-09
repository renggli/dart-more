import 'dart:js_interop';
import 'dart:math' as math;

import 'package:web/web.dart' as web;

import 'layout.dart';
import 'state.dart';

/// Callback signatures for interactive graph events.
typedef VertexCallback = void Function(String vertex, web.MouseEvent event);
typedef VertexDblClickCallback = void Function(String vertex);
typedef EdgeCallback = void Function(
  String source,
  String target,
  web.MouseEvent event,
);
typedef NodePositionCallback = void Function(
  String vertex,
  double canvasX,
  double canvasY,
);
typedef LassoSelectionCallback = void Function(
  List<String> vertices,
  List<(String, String)> edges,
  bool isShift,
);

/// Renders graph states natively into high-performance interactive SVG.
final class GraphRenderer {
  new({
    required this.container,
    required this.transformLayer,
    required this.onVertexClick,
    required this.onEdgeClick,
    required this.onBackgroundClick,
    required this.onLassoSelection,
    this.onVertexDblClick,
    this.onEdgeWeightEdit,
    this.onNodesMoved,
    this.onPlacementConfirmed,
  }) {
    _initViewportControls();
  }

  final web.HTMLElement container;
  final web.HTMLElement transformLayer;
  final VertexCallback onVertexClick;
  final VertexDblClickCallback? onVertexDblClick;
  final EdgeCallback onEdgeClick;
  final void Function(String source, String target, num newWeight)?
  onEdgeWeightEdit;
  final void Function(web.MouseEvent event) onBackgroundClick;
  final LassoSelectionCallback onLassoSelection;
  final void Function(Map<String, (double, double)> moves)? onNodesMoved;
  final void Function(String vertexId)? onPlacementConfirmed;

  web.HTMLElement get viewport =>
      (container.closest('#viewport') ?? container.parentElement ?? container)
          as web.HTMLElement;

  web.SVGSVGElement? _currentSvg;
  AppState? _lastState;
  web.HTMLInputElement? _activeInlineInput;

  // Viewport CSS transform state
  double _scale = 1.0;
  double _panX = 0.0;
  double _panY = 0.0;
  bool _isPanning = false;
  double _startX = 0.0;
  double _startY = 0.0;
  bool _isSpaceDown = false;

  // Track canvas mouse coordinates for hotkey placement
  double _canvasMouseX = 400.0;
  double _canvasMouseY = 300.0;

  // Multi-node dragging state (Blender 'G' group grab)
  String? _dragAnchorVertex;
  bool _didDragNodes = false;
  double _dragStartClientX = 0.0;
  double _dragStartClientY = 0.0;
  final Map<String, (double, double)> _initialDragPositions = {};

  // Lasso selection state
  bool _isLassoing = false;
  bool _didLasso = false;
  double _lassoStartClientX = 0.0;
  double _lassoStartClientY = 0.0;

  // Edge click selection tracking
  (String, String)? _edgeClickAnchor;
  double _edgeClickStartX = 0.0;
  double _edgeClickStartY = 0.0;
  bool _edgeClickHandled = false;

  double get scale => _scale;
  double get panX => _panX;
  double get panY => _panY;
  double get canvasMouseX => _canvasMouseX;
  double get canvasMouseY => _canvasMouseY;

  web.SVGSVGElement? get currentSvg => _currentSvg;

  static const List<String> _palette = [
    '#93c5fd', // Light Blue
    '#86efac', // Light Green
    '#fde047', // Light Yellow
    '#fca5a5', // Light Red
    '#38bdf8', // Sky Blue
    '#fdba74', // Light Orange
    '#6ee7b7', // Light Emerald
    '#f9a8d4', // Light Pink
    '#cbd5e1', // Slate
    '#2dd4bf', // Teal
    '#fbbf24', // Amber
    '#34d399', // Mint
  ];

  /// Renders the current graph state natively into SVG.
  void render(AppState state) {
    state.syncNodes();
    _lastState = state;

    // Ensure all vertices have coordinates
    var needsLayout = false;
    for (final v in state.renderGraph.vertices) {
      final node = state.getOrCreateNode(v);
      if (node.x == null || node.y == null) {
        needsLayout = true;
        break;
      }
    }
    if (needsLayout) {
      GraphLayout.applyLayout(state);
    }

    final svg = _buildNativeSvg(state);
    container.replaceChildren(svg);
    _currentSvg = svg;
  }

  /// Re-runs layout on the state and updates the view.
  void autoLayout(AppState state) {
    GraphLayout.applyLayout(state);
    render(state);
  }

  web.SVGSVGElement _buildNativeSvg(AppState state) {
    final svg = web.document.createElementNS(
      'http://www.w3.org/2000/svg',
      'svg',
    ) as web.SVGSVGElement;
    svg.setAttribute('width', '100%');
    svg.setAttribute('height', '100%');
    svg.style.overflow = 'visible';

    final markup = StringBuffer();

    // Defs: Arrowheads & Glow Filters
    markup.writeln('<defs>');
    markup.writeln(
      '  <marker id="arrow-default" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">',
    );
    markup.writeln('    <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#64748b" />');
    markup.writeln('  </marker>');
    markup.writeln(
      '  <marker id="arrow-highlight" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">',
    );
    markup.writeln('    <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#38bdf8" />');
    markup.writeln('  </marker>');
    markup.writeln(
      '  <marker id="arrow-selected" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">',
    );
    markup.writeln(
      '    <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#64748b" stroke="#8b5cf6" stroke-width="2.0" stroke-linejoin="round" />',
    );
    markup.writeln('  </marker>');
    markup.writeln(
      '  <marker id="arrow-active" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">',
    );
    markup.writeln(
      '    <path d="M 0 1.5 L 9 5 L 0 8.5 z" fill="#64748b" stroke="#c084fc" stroke-width="2.0" stroke-linejoin="round" />',
    );
    markup.writeln('  </marker>');
    markup.writeln(
      '  <filter id="node-shadow" x="-20%" y="-20%" width="140%" height="140%">',
    );
    markup.writeln(
      '    <feDropShadow dx="0" dy="2" stdDeviation="2" flood-color="#000000" flood-opacity="0.35" />',
    );
    markup.writeln('  </filter>');
    markup.writeln('</defs>');

    // Viewport Zoom & Pan root SVG group
    markup.writeln(
      '<g id="viewport-transform" transform="translate($_panX, $_panY) scale($_scale)">',
    );

    final graph = state.renderGraph;
    final overlay = state.activeOverlay;

    // Calculate Heatmap Min/Max
    num minScore = 0;
    num maxScore = 1;
    if (overlay is HeatmapOverlay && overlay.scores.isNotEmpty) {
      final values = overlay.scores.values;
      minScore = values.reduce(math.min);
      maxScore = values.reduce(math.max);
      if (minScore == maxScore) maxScore = minScore + 1;
    }

    final activePathEdges = <(String, String)>{};
    final pathOverlayColor = (overlay is PathOverlay) ? overlay.color : null;
    if (overlay is PathOverlay && pathOverlayColor != null) {
      activePathEdges.addAll(overlay.edges);
    }

    const nodeRadius = 22.0;

    // Layer 1: Edges
    markup.writeln('<g class="layer-edges">');
    for (final edge in graph.edges) {
      final nodeU = state.nodes[edge.source];
      final nodeV = state.nodes[edge.target];
      if (nodeU == null ||
          nodeV == null ||
          nodeU.x == null ||
          nodeU.y == null ||
          nodeV.x == null ||
          nodeV.y == null) {
        continue;
      }

      final x1 = nodeU.x!;
      final y1 = nodeU.y!;
      final x2 = nodeV.x!;
      final y2 = nodeV.y!;

      final isLastSelectedEdge =
          state.selectedEdge == (edge.source, edge.target) ||
          (!graph.isDirected &&
              state.selectedEdge == (edge.target, edge.source));

      final isEdgeSelected =
          isLastSelectedEdge ||
          state.selectedEdges.contains((edge.source, edge.target)) ||
          (!graph.isDirected &&
              state.selectedEdges.contains((edge.target, edge.source)));

      final isPathEdge =
          activePathEdges.contains((edge.source, edge.target)) ||
          (!graph.isDirected &&
              activePathEdges.contains((edge.target, edge.source)));

      final edgeStyle =
          state.edgeStyles[(edge.source, edge.target)] ??
          (!graph.isDirected
              ? state.edgeStyles[(edge.target, edge.source)]
              : null);

      final strokeColor =
          edgeStyle?.color ?? (isPathEdge ? pathOverlayColor! : '#475569');
      final strokeWidth = edgeStyle != null
          ? '${edgeStyle.strokeWidth}'
          : (isPathEdge ? '3.0' : '1.8');
      final opacity = edgeStyle?.opacity ?? 1.0;
      final marker = graph.isDirected
          ? (isLastSelectedEdge
                ? 'url(#arrow-active)'
                : (isEdgeSelected
                      ? 'url(#arrow-selected)'
                      : (isPathEdge
                            ? 'url(#arrow-highlight)'
                            : 'url(#arrow-default)')))
          : '';

      final safeSource = Uri.encodeComponent(edge.source);
      final safeTarget = Uri.encodeComponent(edge.target);
      final edgeId = 'edge_${safeSource}__$safeTarget';

      // Self-loop
      if (edge.source == edge.target) {
        final loopPath =
            'M ${x1 - 10} ${y1 - nodeRadius} '
            'C ${x1 - 35} ${y1 - nodeRadius - 45}, ${x1 + 35} ${y1 - nodeRadius - 45}, ${x1 + 10} ${y1 - nodeRadius}';

        markup.writeln(
          '<g class="graph-edge" id="$edgeId" data-source="${edge.source}" data-target="${edge.target}">',
        );
        markup.writeln(
          '  <path d="$loopPath" fill="none" stroke="transparent" stroke-width="16" cursor="pointer" />',
        );
        if (isEdgeSelected) {
          final underlayColor = isLastSelectedEdge ? '#c084fc' : '#8b5cf6';
          const underlayWidth = 5.5;
          final underlayOpacity = isLastSelectedEdge ? 0.90 : 0.75;
          markup.writeln(
            '  <path d="$loopPath" fill="none" stroke="$underlayColor" stroke-width="$underlayWidth" opacity="$underlayOpacity" stroke-linecap="round" />',
          );
        }
        markup.writeln(
          '  <path d="$loopPath" fill="none" stroke="$strokeColor" stroke-width="$strokeWidth" opacity="$opacity" ${marker.isNotEmpty ? 'marker-end="$marker"' : ''} />',
        );
        if (state.isWeighted) {
          final labelY = y1 - nodeRadius - 38;
          markup.writeln(
            '  <g class="edge-weight-badge" data-source="${edge.source}" data-target="${edge.target}" style="cursor: pointer;">',
          );
          markup.writeln(
            '    <rect x="${x1 - 16}" y="${labelY - 10}" width="32" height="20" rx="4" fill="#1e293b" stroke="#334155" stroke-width="1" />',
          );
          markup.writeln(
            '    <text x="$x1" y="$labelY" text-anchor="middle" dominant-baseline="central" font-size="10" font-family="Inter, system-ui, sans-serif" font-weight="600" fill="#cbd5e1">${edge.value}</text>',
          );
          markup.writeln('  </g>');
        }
        markup.writeln('</g>');
        continue;
      }

      // Dual-directed edge detection (curve if opposing edge exists)
      final hasOpposing =
          graph.isDirected && graph.containsEdge(edge.target, edge.source);

      final dx = x2 - x1;
      final dy = y2 - y1;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist < 1e-4) continue;

      final ux = dx / dist;
      final uy = dy / dist;

      final startX = x1 + ux * nodeRadius;
      final startY = y1 + uy * nodeRadius;
      final endOffset = graph.isDirected ? nodeRadius + 6.0 : nodeRadius;
      final endX = x2 - ux * endOffset;
      final endY = y2 - uy * endOffset;

      String pathData;
      double labelX;
      double labelY;

      if (hasOpposing) {
        // Curve to the right of the direction
        final normalX = -uy;
        final normalY = ux;
        const curveDist = 20.0;
        final ctrlX = (x1 + x2) / 2 + normalX * curveDist;
        final ctrlY = (y1 + y2) / 2 + normalY * curveDist;
        pathData = 'M $startX $startY Q $ctrlX $ctrlY $endX $endY';
        labelX = (startX + 2 * ctrlX + endX) / 4;
        labelY = (startY + 2 * ctrlY + endY) / 4;
      } else {
        pathData = 'M $startX $startY L $endX $endY';
        labelX = (startX + endX) / 2;
        labelY = (startY + endY) / 2;
      }

      markup.writeln(
        '<g class="graph-edge" id="$edgeId" data-source="${edge.source}" data-target="${edge.target}">',
      );
      markup.writeln(
        '  <path d="$pathData" fill="none" stroke="transparent" stroke-width="16" cursor="pointer" />',
      );
      if (isEdgeSelected) {
        final underlayColor = isLastSelectedEdge ? '#c084fc' : '#8b5cf6';
        const underlayWidth = 5.5;
        final underlayOpacity = isLastSelectedEdge ? 0.90 : 0.75;
        markup.writeln(
          '  <path d="$pathData" fill="none" stroke="$underlayColor" stroke-width="$underlayWidth" opacity="$underlayOpacity" stroke-linecap="round" />',
        );
      }
      markup.writeln(
        '  <path d="$pathData" fill="none" stroke="$strokeColor" stroke-width="$strokeWidth" opacity="$opacity" ${marker.isNotEmpty ? 'marker-end="$marker"' : ''} />',
      );
      if (state.isWeighted) {
        markup.writeln(
          '  <g class="edge-weight-badge" data-source="${edge.source}" data-target="${edge.target}" style="cursor: pointer;">',
        );
        markup.writeln(
          '    <rect x="${labelX - 16}" y="${labelY - 10}" width="32" height="20" rx="4" fill="#1e293b" stroke="#334155" stroke-width="1" />',
        );
        markup.writeln(
          '    <text x="$labelX" y="$labelY" text-anchor="middle" dominant-baseline="central" font-size="10" font-family="Inter, system-ui, sans-serif" font-weight="600" fill="#cbd5e1">${edge.value}</text>',
        );
        markup.writeln('  </g>');
      }
      markup.writeln('</g>');
    }
    markup.writeln('</g>');

    // Layer 2: Nodes
    markup.writeln('<g class="layer-nodes">');
    for (final v in graph.vertices) {
      final node = state.nodes[v];
      if (node == null || node.x == null || node.y == null) continue;

      final x = node.x!;
      final y = node.y!;

      final isActive = state.activeVertex == v;
      final isSelected = state.selectedVertices.contains(v);

      // Color & Visual Attributes computation
      var fillColor = node.fillColor ?? '#1e293b';
      var textColor = node.textColor ?? '#f8fafc';
      var borderColor = node.borderColor ?? '#64748b';
      final borderWidth = node.borderWidth;
      final opacity = node.opacity;

      if (overlay is HeatmapOverlay && node.fillColor == null) {
        final score = overlay.scores[v];
        if (score != null) {
          final t = ((score - minScore) / (maxScore - minScore)).clamp(
            0.0,
            1.0,
          );
          fillColor = _interpolateHeatmap(t);
          textColor = '#ffffff';
        }
      } else if (overlay is PartitionOverlay && node.fillColor == null) {
        final group = overlay.vertexGroup[v];
        if (group != null) {
          fillColor = _palette[group.abs() % _palette.length];
          textColor = '#0f172a';
        }
      } else if (overlay is PathOverlay && node.fillColor == null) {
        final inPath = overlay.vertices.contains(v);
        if (inPath && overlay.color != null) {
          fillColor = '#1e3a8a';
          borderColor = overlay.color!;
          textColor = '#f8fafc';
        }
      }

      final safeV = Uri.encodeComponent(v);
      final nodeId = 'node_$safeV';

      markup.writeln('<g class="graph-node" id="$nodeId" data-id="$v">');

      // Subtle Selection Underlay (purple of the application, fading to background)
      if (isActive) {
        markup.writeln(
          '  <circle cx="$x" cy="$y" r="26.0" fill="#8b5cf6" fill-opacity="0.30" stroke="#c084fc" stroke-width="2.0" stroke-opacity="0.95" />',
        );
      } else if (isSelected) {
        markup.writeln(
          '  <circle cx="$x" cy="$y" r="26.0" fill="#8b5cf6" fill-opacity="0.25" stroke="#8b5cf6" stroke-width="2.0" stroke-opacity="0.80" />',
        );
      }

      // Node Body Circle
      markup.writeln(
        '  <circle cx="$x" cy="$y" r="$nodeRadius" fill="$fillColor" stroke="$borderColor" stroke-width="$borderWidth" opacity="$opacity" filter="url(#node-shadow)" cursor="pointer" />',
      );

      // Node Label Text
      if (state.showLabels) {
        markup.writeln(
          '  <text x="$x" y="$y" text-anchor="middle" dominant-baseline="central" font-family="Inter, system-ui, sans-serif" font-weight="600" font-size="12" fill="$textColor" pointer-events="none">${node.label}</text>',
        );
      }

      markup.writeln('</g>');
    }
    markup.writeln('</g>'); // Close layer-nodes
    markup.writeln('</g>'); // Close viewport-transform

    svg.innerHTML = markup.toString().toJS;
    _attachSvgListeners(svg);
    return svg;
  }

  void _initViewportControls() {
    final viewport = this.viewport;

    // Track Space key for canvas panning
    web.window.onkeydown = ((web.KeyboardEvent event) {
      if (event.code == 'Space') {
        final activeTag = web.document.activeElement?.tagName.toLowerCase();
        if (activeTag != 'input' &&
            activeTag != 'textarea' &&
            activeTag != 'select') {
          _isSpaceDown = true;
          viewport.style.cursor = 'grab';
        }
      }
    }).toJS;

    web.window.onkeyup = ((web.KeyboardEvent event) {
      if (event.code == 'Space') {
        _isSpaceDown = false;
        viewport.style.cursor = 'default';
      }
    }).toJS;

    // Smooth CSS-pixel panning, lasso selection, node group dragging, and edge swiping
    viewport.onmousedown = ((web.MouseEvent event) {
      if (event.button == 1 || _isSpaceDown || event.altKey) {
        _isPanning = true;
        _startX = event.clientX - _panX;
        _startY = event.clientY - _panY;
        viewport.style.cursor = 'grabbing';
        return;
      }

      if (event.button != 0) return;

      _edgeClickHandled = false;
      final state = _lastState;

      // Click confirms cursor-attached vertex placement
      if (state != null && state.pendingPlacementVertex != null) {
        final placedVertex = state.pendingPlacementVertex!;
        state.pendingPlacementVertex = null;
        state.selectVertex(placedVertex, clearOthers: true);
        render(state);
        if (onPlacementConfirmed != null) {
          onPlacementConfirmed!(placedVertex);
        } else if (state.showLabels) {
          showInlineNodeEditor(state, placedVertex);
        }
        return;
      }

      final target = event.target as web.Element?;
      if (target?.closest('.edge-weight-badge') != null) {
        return;
      }
      final nodeElem = target?.closest('.graph-node') as web.SVGGElement?;
      final edgeElem = target?.closest('.graph-edge') as web.SVGGElement?;

      if (nodeElem != null && (state?.selectVerticesMode ?? true)) {
        final vertexId = nodeElem.getAttribute('data-id') ?? '';
        if (vertexId.isNotEmpty) {
          _dragAnchorVertex = vertexId;
          _dragStartClientX = event.clientX.toDouble();
          _dragStartClientY = event.clientY.toDouble();
          _didDragNodes = false;

          // Prepare multi-selection group drag positions
          _initialDragPositions.clear();
          if (state != null) {
            final movingNodes = state.selectedVertices.contains(vertexId)
                ? state.selectedVertices
                : {vertexId};
            for (final id in movingNodes) {
              final node = state.nodes[id];
              if (node?.x != null && node?.y != null) {
                _initialDragPositions[id] = (node!.x!, node.y!);
              }
            }
          }
          return;
        }
      }

      if (edgeElem != null) {
        if (state?.selectEdgesMode ?? true) {
          final source = edgeElem.getAttribute('data-source');
          final target = edgeElem.getAttribute('data-target');
          if (source != null && target != null) {
            _edgeClickAnchor = (source, target);
            _edgeClickStartX = event.clientX.toDouble();
            _edgeClickStartY = event.clientY.toDouble();
          }
        }
        return;
      }

      // Background mousedown: start lasso marquee selection
      _isLassoing = true;
      _lassoStartClientX = event.clientX.toDouble();
      _lassoStartClientY = event.clientY.toDouble();
      _didLasso = false;
    }).toJS;

    web.window.onmousemove = ((web.MouseEvent event) {
      final vRect = viewport.getBoundingClientRect();
      _canvasMouseX = (event.clientX.toDouble() - vRect.left - _panX) / _scale;
      _canvasMouseY = (event.clientY.toDouble() - vRect.top - _panY) / _scale;
      if (_lastState != null) {
        _lastState!.cursorX = _canvasMouseX;
        _lastState!.cursorY = _canvasMouseY;
      }

      // Pending placement vertex moves dynamically with cursor
      if (_lastState != null && _lastState!.pendingPlacementVertex != null) {
        final pNode = _lastState!.nodes[_lastState!.pendingPlacementVertex!];
        if (pNode != null) {
          pNode.x = _canvasMouseX;
          pNode.y = _canvasMouseY;
          render(_lastState!);
        }
        return;
      }

      if (_edgeClickAnchor != null) {
        final dx = event.clientX.toDouble() - _edgeClickStartX;
        final dy = event.clientY.toDouble() - _edgeClickStartY;
        if (math.sqrt(dx * dx + dy * dy) > 6.0) {
          _edgeClickAnchor = null;
        }
      }

      if (_isPanning) {
        _panX = event.clientX - _startX;
        _panY = event.clientY - _startY;
        _updateTransform();
        return;
      }

      if (_dragAnchorVertex != null && _initialDragPositions.isNotEmpty) {
        final dx = (event.clientX.toDouble() - _dragStartClientX) / _scale;
        final dy = (event.clientY.toDouble() - _dragStartClientY) / _scale;
        final dist = math.sqrt(dx * dx + dy * dy);

        if (dist > 6.0) {
          _didDragNodes = true;
          final state = _lastState;
          if (state != null) {
            for (final MapEntry(:key, :value)
                in _initialDragPositions.entries) {
              final node = state.nodes[key];
              if (node != null) {
                node.x = value.$1 + dx;
                node.y = value.$2 + dy;
              }
            }
            render(state);
          }
        }
        return;
      }

      if (_isLassoing) {
        final dist = math.sqrt(
          math.pow(event.clientX.toDouble() - _lassoStartClientX, 2) +
              math.pow(event.clientY.toDouble() - _lassoStartClientY, 2),
        );
        if (dist > 4.0) {
          _didLasso = true;
          final startX = _lassoStartClientX - vRect.left;
          final startY = _lassoStartClientY - vRect.top;
          final curX = event.clientX.toDouble() - vRect.left;
          final curY = event.clientY.toDouble() - vRect.top;

          final left = math.min(startX, curX);
          final top = math.min(startY, curY);
          final width = (curX - startX).abs();
          final height = (curY - startY).abs();

          _updateLassoMarquee(left, top, width, height);
        }
        return;
      }
    }).toJS;

    web.window.onmouseup = ((web.MouseEvent event) {
      if (_isPanning) {
        _isPanning = false;
        viewport.style.cursor = _isSpaceDown ? 'grab' : 'default';
        return;
      }

      if (_edgeClickAnchor != null) {
        final (s, t) = _edgeClickAnchor!;
        _edgeClickAnchor = null;
        _edgeClickHandled = true;
        onEdgeClick(s, t, event);
        return;
      }

      if (_dragAnchorVertex != null) {
        final v = _dragAnchorVertex!;
        _dragAnchorVertex = null;
        if (_didDragNodes) {
          _didDragNodes = false;
          final state = _lastState;
          if (state != null && onNodesMoved != null) {
            final moves = <String, (double, double)>{};
            for (final id in _initialDragPositions.keys) {
              final node = state.nodes[id];
              if (node?.x != null && node?.y != null) {
                moves[id] = (node!.x!, node.y!);
              }
            }
            onNodesMoved!(moves);
          }
        } else {
          onVertexClick(v, event);
        }
        _initialDragPositions.clear();
        viewport.style.cursor = 'default';
        return;
      }

      if (_isLassoing) {
        _isLassoing = false;
        _hideLassoMarquee();

        if (_didLasso) {
          _didLasso = false;
          final mLeft = math.min(_lassoStartClientX, event.clientX.toDouble());
          final mRight = math.max(_lassoStartClientX, event.clientX.toDouble());
          final mTop = math.min(_lassoStartClientY, event.clientY.toDouble());
          final mBottom = math.max(
            _lassoStartClientY,
            event.clientY.toDouble(),
          );

          final state = _lastState;
          final matchedVertices = <String>[];
          final matchedEdges = <(String, String)>[];

          final vRect = viewport.getBoundingClientRect();
          final minX = (mLeft - vRect.left - _panX) / _scale;
          final maxX = (mRight - vRect.left - _panX) / _scale;
          final minY = (mTop - vRect.top - _panY) / _scale;
          final maxY = (mBottom - vRect.top - _panY) / _scale;

          if (state != null) {
            if (state.selectVerticesMode) {
              for (final v in state.renderGraph.vertices) {
                final node = state.nodes[v];
                if (node?.x != null && node?.y != null) {
                  final nx = node!.x!;
                  final ny = node.y!;
                  if (nx >= minX && nx <= maxX && ny >= minY && ny <= maxY) {
                    matchedVertices.add(v);
                  }
                }
              }
            }

            if (state.selectEdgesMode) {
              for (final edge in state.renderGraph.edges) {
                final nodeU = state.nodes[edge.source];
                final nodeV = state.nodes[edge.target];
                if (nodeU?.x != null &&
                    nodeU?.y != null &&
                    nodeV?.x != null &&
                    nodeV?.y != null) {
                  final x1 = nodeU!.x!;
                  final y1 = nodeU.y!;
                  final x2 = nodeV!.x!;
                  final y2 = nodeV.y!;
                  final uIn =
                      x1 >= minX && x1 <= maxX && y1 >= minY && y1 <= maxY;
                  final vIn =
                      x2 >= minX && x2 <= maxX && y2 >= minY && y2 <= maxY;
                  if (uIn || vIn) {
                    matchedEdges.add((edge.source, edge.target));
                  }
                }
              }
            }
          }

          onLassoSelection(matchedVertices, matchedEdges, event.shiftKey);
          return;
        } else {
          // Plain click on background: invokes onBackgroundClick
          onBackgroundClick(event);
          return;
        }
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

    viewport.ondblclick = ((web.MouseEvent event) {
      final target = event.target as web.Element?;
      final badge = target?.closest('.edge-weight-badge');
      if (badge != null) {
        event.stopPropagation();
        final s = badge.getAttribute('data-source');
        final t = badge.getAttribute('data-target');
        if (s != null && t != null && _lastState != null) {
          showInlineEdgeEditor(
            _lastState!,
            s,
            t,
            onCommit: (w) => onEdgeWeightEdit?.call(s, t, w),
          );
        }
        return;
      }
      final nodeElem = target?.closest('.graph-node');
      if (nodeElem != null) {
        event.stopPropagation();
        final v = nodeElem.getAttribute('data-id');
        if (v != null && v.isNotEmpty) {
          onVertexDblClick?.call(v);
        }
        return;
      }
      final edgeElem = target?.closest('.graph-edge');
      if (edgeElem != null) {
        event.stopPropagation();
        final s = edgeElem.getAttribute('data-source');
        final t = edgeElem.getAttribute('data-target');
        if (s != null && t != null && _lastState != null) {
          showInlineEdgeEditor(
            _lastState!,
            s,
            t,
            onCommit: (w) => onEdgeWeightEdit?.call(s, t, w),
          );
        }
        return;
      }
    }).toJS;
  }

  void _attachSvgListeners(web.SVGSVGElement svg) {
    // Edge click listeners
    final edges = svg.querySelectorAll('.graph-edge');
    for (var i = 0; i < edges.length; i++) {
      final edge = edges.item(i) as web.SVGGElement?;
      if (edge == null) continue;

      final source = edge.getAttribute('data-source');
      final target = edge.getAttribute('data-target');

      if (source != null && target != null) {
        final s = source;
        final t = target;
        edge.style.cursor = 'pointer';
        edge.onclick = ((web.MouseEvent event) {
          event.stopPropagation();
          if (_edgeClickHandled) {
            _edgeClickHandled = false;
            return;
          }
          onEdgeClick(s, t, event);
        }).toJS;
        edge.ondblclick = ((web.MouseEvent event) {
          event.stopPropagation();
          final state = _lastState;
          if (state != null) {
            showInlineEdgeEditor(
              state,
              s,
              t,
              onCommit: (w) {
                onEdgeWeightEdit?.call(s, t, w);
              },
            );
          }
        }).toJS;
      }
    }

    // Edge weight badges click listeners for inline weight editing
    final badges = svg.querySelectorAll('.edge-weight-badge');
    for (var i = 0; i < badges.length; i++) {
      final badge = badges.item(i) as web.SVGGElement?;
      if (badge == null) continue;
      final source = badge.getAttribute('data-source');
      final target = badge.getAttribute('data-target');
      if (source != null && target != null) {
        badge.onmousedown = ((web.MouseEvent event) {
          event.stopPropagation();
        }).toJS;
        badge.onmouseup = ((web.MouseEvent event) {
          event.stopPropagation();
        }).toJS;
        badge.onclick = ((web.MouseEvent event) {
          event.stopPropagation();
          final state = _lastState;
          if (state != null) {
            showInlineEdgeEditor(
              state,
              source,
              target,
              onCommit: (w) {
                onEdgeWeightEdit?.call(source, target, w);
              },
            );
          }
        }).toJS;
      }
    }

    // Node double-click listener for immediate inline rename
    final nodes = svg.querySelectorAll('.graph-node');
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes.item(i) as web.SVGGElement?;
      if (node == null) continue;
      final v = node.getAttribute('data-id');
      if (v != null && v.isNotEmpty) {
        node.ondblclick = ((web.MouseEvent event) {
          event.stopPropagation();
          onVertexDblClick?.call(v);
        }).toJS;
      }
    }
  }

  /// Activates an inline text input directly over the given [vertex] to edit its label.
  void showInlineNodeEditor(
    AppState state,
    String vertex, {
    void Function(String newLabel)? onCommit,
  }) {
    _activeInlineInput?.remove();
    _activeInlineInput = null;

    final node = state.nodes[vertex];
    if (node == null || node.x == null || node.y == null) return;

    final input = web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'text';
    input.value = node.label;
    input.className = 'inline-node-editor';
    final screenX = node.x! * _scale + _panX;
    final screenY = node.y! * _scale + _panY;
    input.style.left = '${screenX}px';
    input.style.top = '${screenY}px';

    final nodeElem = _currentSvg?.querySelector('#node-$vertex');
    final textElem = nodeElem?.querySelector('text') as web.SVGTextElement?;
    final prevDisplay = textElem?.style.display ?? '';
    if (textElem != null) {
      textElem.style.display = 'none';
    }

    void cleanup() {
      if (textElem != null) {
        textElem.style.display = prevDisplay;
      }
      input.remove();
      _activeInlineInput = null;
    }

    var committed = false;
    void commit() {
      if (committed) return;
      committed = true;
      final val = input.value.trim();
      cleanup();
      if (val.isNotEmpty && val != node.label) {
        onCommit?.call(val);
      }
    }

    input.onkeydown = ((web.KeyboardEvent e) {
      if (e.key == 'Enter') {
        commit();
        e.preventDefault();
        e.stopPropagation();
      } else if (e.key == 'Escape') {
        committed = true;
        cleanup();
        e.preventDefault();
        e.stopPropagation();
      }
    }).toJS;

    input.onblur = ((web.Event _) {
      commit();
    }).toJS;

    viewport.appendChild(input);
    _activeInlineInput = input;
    input.focus();
    input.select();
  }

  /// Cancels any active inline node/edge editing.
  void cancelInlineEditor() {
    _activeInlineInput?.remove();
    _activeInlineInput = null;
  }

  /// Activates an inline numeric input directly over the given edge to edit its weight.
  void showInlineEdgeEditor(
    AppState state,
    String source,
    String target, {
    void Function(num newWeight)? onCommit,
  }) {
    _activeInlineInput?.remove();
    _activeInlineInput = null;

    final nodeU = state.nodes[source];
    final nodeV = state.nodes[target];
    if (nodeU?.x == null ||
        nodeU?.y == null ||
        nodeV?.x == null ||
        nodeV?.y == null) {
      return;
    }

    final edge =
        state.renderGraph.getEdge(source, target) ??
        state.renderGraph.getEdge(target, source);
    final currentWeight = edge?.value ?? 1;

    double posX;
    double posY;
    if (source == target) {
      posX = nodeU!.x!;
      posY = nodeU.y! - 46;
    } else {
      final x1 = nodeU!.x!;
      final y1 = nodeU.y!;
      final x2 = nodeV!.x!;
      final y2 = nodeV.y!;
      final hasOpposing =
          state.renderGraph.isDirected &&
          state.renderGraph.containsEdge(target, source);
      if (hasOpposing) {
        final dx = x2 - x1;
        final dy = y2 - y1;
        final dist = math.sqrt(dx * dx + dy * dy);
        final ux = dist > 1e-4 ? dx / dist : 0.0;
        final uy = dist > 1e-4 ? dy / dist : 0.0;
        final normalX = -uy;
        final normalY = ux;
        const curveDist = 20.0;
        final ctrlX = (x1 + x2) / 2 + normalX * curveDist;
        final ctrlY = (y1 + y2) / 2 + normalY * curveDist;
        posX = (x1 + 2 * ctrlX + x2) / 4;
        posY = (y1 + 2 * ctrlY + y2) / 4;
      } else {
        posX = (x1 + x2) / 2;
        posY = (y1 + y2) / 2;
      }
    }

    final input = web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'text';
    input.setAttribute('inputmode', 'decimal');
    input.value = currentWeight.toString();
    input.className = 'inline-edge-editor';
    final screenX = posX * _scale + _panX;
    final screenY = posY * _scale + _panY;
    input.style.left = '${screenX}px';
    input.style.top = '${screenY}px';

    final badgeElem = _currentSvg?.querySelector(
      '.edge-weight-badge[data-source="$source"][data-target="$target"]',
    );
    final badgeText = badgeElem?.querySelector('text') as web.SVGTextElement?;
    final prevDisplay = badgeText?.style.display ?? '';
    if (badgeText != null) {
      badgeText.style.display = 'none';
    }

    void cleanup() {
      if (badgeText != null) {
        badgeText.style.display = prevDisplay;
      }
      input.remove();
      _activeInlineInput = null;
    }

    var committed = false;
    void commit() {
      if (committed) return;
      committed = true;
      final val = num.tryParse(input.value.trim());
      cleanup();
      if (val != null && val != currentWeight) {
        onCommit?.call(val);
      }
    }

    input.onkeydown = ((web.KeyboardEvent e) {
      if (e.key == 'Enter') {
        commit();
        e.preventDefault();
        e.stopPropagation();
      } else if (e.key == 'Escape') {
        committed = true;
        cleanup();
        e.preventDefault();
        e.stopPropagation();
      }
    }).toJS;

    input.onblur = ((web.Event _) {
      commit();
    }).toJS;

    viewport.appendChild(input);
    _activeInlineInput = input;
    input.focus();
    input.select();
  }

  void _updateLassoMarquee(
    double left,
    double top,
    double width,
    double height,
  ) {
    final marquee =
        web.document.querySelector('#selection-marquee') as web.HTMLElement?;
    if (marquee == null) return;
    marquee.style.display = 'block';
    marquee.style.left = '${left}px';
    marquee.style.top = '${top}px';
    marquee.style.width = '${width}px';
    marquee.style.height = '${height}px';
  }

  void _hideLassoMarquee() {
    final marquee =
        web.document.querySelector('#selection-marquee') as web.HTMLElement?;
    if (marquee != null) marquee.style.display = 'none';
  }

  void _updateTransform() {
    final g =
        _currentSvg?.querySelector('#viewport-transform') as web.SVGGElement?;
    if (g != null) {
      g.setAttribute('transform', 'translate($_panX, $_panY) scale($_scale)');
    }
  }

  /// Centers and fits the graph view to the viewport.
  void resetView() {
    _scale = 1.0;
    _panX = 0.0;
    _panY = 0.0;
    _updateTransform();
    if (_lastState != null) {
      render(_lastState!);
    }
  }

  void zoomIn() {
    _scale = (_scale * 1.25).clamp(0.1, 8.0);
    _updateTransform();
  }

  void zoomOut() {
    _scale = (_scale * 0.8).clamp(0.1, 8.0);
    _updateTransform();
  }

  String _interpolateHeatmap(double t) {
    // Blue (0.0) -> Cyan (0.35) -> Yellow (0.7) -> Red (1.0)
    final clamped = t.clamp(0.0, 1.0);
    int r;
    int g;
    int b;
    if (clamped < 0.35) {
      final f = clamped / 0.35;
      r = (37 + f * (6 - 37)).round();
      g = (99 + f * (182 - 99)).round();
      b = (235 + f * (212 - 235)).round();
    } else if (clamped < 0.7) {
      final f = (clamped - 0.35) / 0.35;
      r = (6 + f * (234 - 6)).round();
      g = (182 + f * (179 - 182)).round();
      b = (212 + f * (8 - 212)).round();
    } else {
      final f = (clamped - 0.7) / 0.3;
      r = (234 + f * (220 - 234)).round();
      g = (179 + f * (38 - 179)).round();
      b = (8 + f * (38 - 8)).round();
    }
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
