import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../state.dart';
import 'registry.dart';

/// Categories for grouping graph modifiers.
enum ModifierCategory {
  layout('Layout'),
  paths('Paths & Traversal'),
  structure('Structure & Connectivity'),
  centrality('Centrality & Metrics'),
  trees('Trees'),
  flows('Flows & Cuts'),
  matching('Matching, Cliques & Covers'),
  tours('Tours'),
  transform('Transform');

  new(this.label);

  /// User-visible display label.
  final String label;
}

/// Tabular data emitted by a modifier to be presented in the bottom drawer.
class ModifierTableData {
  const new({required this.title, required this.headers, required this.rows});

  final String title;
  final List<String> headers;
  final List<List<String>> rows;
}

/// Output computed by applying a modifier to the pipeline graph.
class ModifierOutput {
  const new({
    this.transformedGraph,
    this.overlay,
    this.tableData,
    this.statusSummary,
    this.errorMessage,
    this.hasError = false,
  });

  /// If non-null, this transformed graph replaces the pipeline graph for subsequent modifiers and rendering.
  final Graph<String, num>? transformedGraph;

  /// Extra visualization overlay (path, heatmap, or partition coloring) on the canvas.
  final VisualOverlay? overlay;

  /// Live tabular data to expose in the bottom drawer.
  final ModifierTableData? tableData;

  /// Brief status description for display in the modifier card and badge.
  final String? statusSummary;

  /// Human-readable error description when this modifier failed.
  final String? errorMessage;

  /// Whether this modifier failed during execution.
  final bool hasError;
}

/// Base contract for all graph modifiers in the non-destructive modifier stack.
abstract class GraphModifier {
  new({this.enabled = true});

  /// Unique identifier of this modifier.
  String get id;

  /// Display name of this modifier.
  String get name;

  /// Category grouping this modifier.
  ModifierCategory get category;

  /// Whether this modifier is enabled in the evaluation pipeline.
  bool enabled;

  /// UI state: whether this modifier card is collapsed in the sidebar.
  bool collapsed = false;

  /// One-line description of what this modifier does.
  String get description => ModifierRegistry.isRegistered(id)
      ? ModifierRegistry.getSpec(id).description
      : '';

  /// Big-O time complexity notation of this modifier algorithm (e.g. "O(V + E)").
  String? get complexity => ModifierRegistry.isRegistered(id)
      ? ModifierRegistry.getSpec(id).complexity
      : null;

  /// Whether this modifier is permanently pinned at index 0 (e.g. BaseGraphModifier).
  bool get isPinned => false;

  /// Whether this modifier can be baked permanently into the base graph.
  bool get canApply => false;

  /// Bakes changes permanently into the base graph and removes itself from the stack.
  void applyPermanent(AppState state) {
    final out = apply(state.primaryGraph, state);
    if (out.transformedGraph != null) {
      state.saveSnapshot();
      state.primaryGraph = out.transformedGraph!;
      state.syncNodes();
      state.modifiers.remove(this);
    }
  }

  /// Validates graph constraints (non-empty, directedness). Returns error output or null.
  ModifierOutput? validateGraph(
    Graph<String, num> graph, {
    bool undirected = false,
    bool directed = false,
    String? requirementMessage,
  }) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }
    if (undirected && graph.isDirected) {
      return ModifierOutput(
        hasError: true,
        errorMessage:
            requirementMessage ?? '$name requires an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }
    if (directed && !graph.isDirected) {
      return ModifierOutput(
        hasError: true,
        errorMessage: requirementMessage ?? '$name requires a directed graph.',
        statusSummary: 'Requires directed graph',
      );
    }
    return null;
  }

  /// Builds configuration UI controls inside the modifier card (accessible, stacked vertically).
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified);

  /// Executes this modifier in the pipeline over [graph].
  ModifierOutput apply(Graph<String, num> graph, AppState state);

  /// Serializes modifier state, including enabled status, collapsed UI state, and modifier-specific configuration.
  Map<String, dynamic> toJson() => {
    'id': id,
    'enabled': enabled,
    'collapsed': collapsed,
    'config': exportConfig(),
  };

  /// Restores modifier state from serialized [json].
  void applyJson(Map<String, dynamic> json) {
    if (json['enabled'] case final bool val) {
      enabled = val;
    }
    if (json['collapsed'] case final bool val) {
      collapsed = val;
    }
    if (json['config'] case final Map<String, dynamic> config) {
      applyConfig(config);
    } else if (json['config'] case final Map<dynamic, dynamic> config) {
      applyConfig(config.cast<String, dynamic>());
    }
  }

  /// Exports modifier-specific configuration attributes to a map.
  Map<String, dynamic> exportConfig() => {};

  /// Restores modifier-specific configuration attributes from [config].
  void applyConfig(Map<String, dynamic> config) {}

  /// Resets configuration options back to defaults.
  void resetDefaults() {}
}
