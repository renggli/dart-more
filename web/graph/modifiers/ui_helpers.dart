import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';

/// Mode for displaying vertices and edges excluded or removed by a modifier.
enum RemovedMode {
  dim('dim', 'Dim removed'),
  hide('hide', 'Hide removed');

  new(this.id, this.label);

  /// Unique identifier.
  final String id;

  /// User-facing display label.
  final String label;

  /// Looks up [RemovedMode] by [id], defaulting to [RemovedMode.dim].
  static RemovedMode fromId(String id) =>
      values.firstWhere((m) => m.id == id, orElse: () => RemovedMode.dim);
}

/// Builds a dropdown setting for an enum with [id] and [label].
web.HTMLElement enumDropdownSetting<T>({
  required String label,
  required T current,
  required Iterable<T> values,
  required String Function(T) id,
  required String Function(T) display,
  required void Function(T) onChanged,
}) => dropdownSetting(
  label,
  id(current),
  [for (final v in values) (id(v), display(v))],
  onChanged: (val) {
    final match = values.firstWhere((v) => id(v) == val);
    onChanged(match);
  },
);

/// Shared styling and output configuration for modifiers.
class OutputStyleOptions {
  new({
    String color = '#10b981',
    String pattern = 'none',
    RemovedMode removedMode = RemovedMode.dim,
    this.hasRemovedMode = false,
  }) : color = color,
       pattern = pattern,
       removedMode = removedMode,
       _defaultColor = color,
       _defaultPattern = pattern,
       _defaultRemovedMode = removedMode;

  String color;
  String pattern;
  RemovedMode removedMode;
  final bool hasRemovedMode;

  final String _defaultColor;
  final String _defaultPattern;
  final RemovedMode _defaultRemovedMode;

  /// Resets visual styling options back to their initial defaults.
  void resetDefaults() {
    color = _defaultColor;
    pattern = _defaultPattern;
    removedMode = _defaultRemovedMode;
  }

  /// Serializes output styling settings to a JSON map.
  Map<String, dynamic> toJson() => {
    'color': color,
    'pattern': pattern,
    if (hasRemovedMode) 'removedMode': removedMode.id,
  };

  /// Restores output styling settings from [json].
  void applyJson(Map<String, dynamic> json) {
    if (json['color'] case final String c) color = c;
    if (json['pattern'] case final String p) pattern = p;
    if (json['removedMode'] case final String rm) {
      removedMode = RemovedMode.fromId(rm);
    }
  }

  /// Converted dash pattern string (or null if none).
  String? get dashPattern => pattern != 'none' ? pattern : null;

  /// Converted highlight color string (or null if none).
  String? get highlightColor => color != 'none' ? color : null;

  /// Appends standard styling controls (color, line pattern, and optional removed mode) to [root].
  void buildUI(
    web.HTMLElement root,
    void Function() onModified, {
    String colorLabel = 'Highlight Color:',
    String patternLabel = 'Line Style:',
    String removedLabel = 'Show Removed as:',
  }) {
    root.appendChild(
      colorSetting(
        colorLabel,
        color,
        onChanged: (c) {
          color = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      lineStyleSetting(
        patternLabel,
        pattern,
        onChanged: (p) {
          pattern = p;
          onModified();
        },
      ),
    );
    if (hasRemovedMode) {
      root.appendChild(
        dropdownSetting(
          removedLabel,
          removedMode.id,
          [for (final m in RemovedMode.values) (m.id, m.label)],
          onChanged: (val) {
            removedMode = RemovedMode.fromId(val);
            onModified();
          },
        ),
      );
    }
  }

  /// Applies styling options (border color and dash pattern) to [vertices].
  void applyToVertices(AppState state, Iterable<String> vertices) {
    final c = highlightColor;
    final d = dashPattern;
    if (c == null && d == null) return;
    for (final v in vertices) {
      final node = state.nodes[v];
      if (node != null) {
        if (c != null) {
          node.style.borderColor = c;
          node.style.borderWidth = 2.5;
        }
        node.style.dashPattern = d;
      }
    }
  }

  /// Dims or hides edges not contained in [keptEdges].
  void dimUnselectedEdges(
    AppState state,
    Iterable<Edge<String, num>> allEdges,
    Set<(String, String)> keptEdges,
  ) {
    final opacity = removedMode == RemovedMode.hide ? 0.0 : 0.25;
    for (final e in allEdges) {
      if (!keptEdges.contains((e.source, e.target))) {
        state.getEdgeStyle(e.source, e.target).opacity = opacity;
      }
    }
  }
}

/// Builds an accessible vertex selection dropdown within a stacked field.
web.HTMLElement vertexField(
  String labelText,
  AppState state,
  String? currentVal,
  String defaultLabel,
  void Function(String?) onChange,
) {
  final s = selectElement();
  s.className = 'vertex-select';
  s.setAttribute('data-default', defaultLabel);
  s.appendChild(optionElement('', defaultLabel));
  for (final v in state.renderGraph.vertices) {
    s.appendChild(optionElement(v, v));
  }
  s.value = currentVal ?? '';
  s.onChange.listen((_) {
    onChange(s.value.isEmpty ? null : s.value);
  });
  return stackedField(labelText, s);
}

/// Builds a generated pattern or secondary graph based on [shape], [count], and [atlasIndex].
Graph<String, num> buildShapedGraph({
  required bool isDirected,
  required GeneratorShape shape,
  required int count,
  required int atlasIndex,
  required String Function(int index) vertexProvider,
}) {
  final factory = GraphFactory<String, num>(
    isDirected: isDirected,
    vertexProvider: vertexProvider,
    edgeProvider: (source, target) => 1,
  );
  final countClamped = count.clamp(1, 100);
  switch (shape) {
    case GeneratorShape.atlas:
      final atlasIdx = atlasIndex.clamp(0, factory.atlasLength - 1);
      final atlas = factory.atlas(atlasIdx);
      if (isDirected) {
        final bidi = Graph<String, num>(isDirected: true);
        for (final v in atlas.vertices) {
          bidi.addVertex(v);
        }
        for (final e in atlas.edges) {
          bidi.addEdge(e.source, e.target, value: e.value);
          bidi.addEdge(e.target, e.source, value: e.value);
        }
        return bidi;
      }
      return atlas;
    case GeneratorShape.complete:
      return factory.complete(vertexCount: countClamped);
    case GeneratorShape.cycle:
      return factory.ring(vertexCount: countClamped);
    case GeneratorShape.star:
      return factory.star(vertexCount: countClamped);
    case GeneratorShape.path:
      return factory.path(vertexCount: countClamped);
    case GeneratorShape.tree:
      return factory.completeTree(vertexCount: countClamped, arity: 2);
    case GeneratorShape.bipartite:
      return factory.partite(
        vertexCounts: [countClamped ~/ 2 + 1, countClamped ~/ 2 + 1],
      );
    case GeneratorShape.grid:
      final rows = countClamped > 4 ? 3 : 2;
      final cols = countClamped ~/ rows + 1;
      return factory.grid(rows: rows, columns: cols);
    case GeneratorShape.random:
      return factory.randomErdosRenyi(
        vertexCount: countClamped,
        probability: 0.3,
      );
  }
}

/// Builds the complete generator shape UI (dropdown and dynamic count/atlas inputs).
void appendShapeControls(
  web.HTMLElement root, {
  required String shapeLabel,
  required GeneratorShape shape,
  required int count,
  required int atlasIndex,
  required String countLabel,
  required int maxCount,
  required void Function(GeneratorShape shape, int count, int atlasIndex)
  onChanged,
}) {
  final dynamicSection = div('form-column');

  void rebuildDynamic(GeneratorShape currentShape) {
    dynamicSection.textContent = '';
    dynamicSection.appendChild(
      buildShapeDynamicSetting(
        shape: currentShape,
        count: count,
        atlasIndex: atlasIndex,
        countLabel: countLabel,
        maxCount: maxCount,
        onCountChanged: (v) => onChanged(currentShape, v, atlasIndex),
        onAtlasIndexChanged: (v) => onChanged(currentShape, count, v),
      ),
    );
  }

  root.appendChild(
    dropdownSetting(
      shapeLabel,
      shape.id,
      [for (final s in GeneratorShape.values) (s.id, s.label)],
      onChanged: (val) {
        final newShape = GeneratorShape.fromId(val);
        onChanged(newShape, count, atlasIndex);
        rebuildDynamic(newShape);
      },
    ),
  );

  rebuildDynamic(shape);
  root.appendChild(dynamicSection);
}

web.HTMLElement buildShapeDynamicSetting({
  required GeneratorShape shape,
  required int count,
  required int atlasIndex,
  required String countLabel,
  required int maxCount,
  required void Function(int) onCountChanged,
  required void Function(int) onAtlasIndexChanged,
}) {
  if (shape == GeneratorShape.atlas) {
    return rangeSetting(
      'Atlas Index (0..1252):',
      atlasIndex,
      min: 0,
      max: 1252,
      onChanged: (v) => onAtlasIndexChanged(v.toInt()),
    );
  }
  return rangeSetting(
    countLabel,
    count,
    min: 2,
    max: maxCount,
    onChanged: (v) => onCountChanged(v.toInt()),
  );
}
