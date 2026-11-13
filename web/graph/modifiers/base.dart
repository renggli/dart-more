import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../state.dart';

/// Categories for grouping graph modifiers.
enum ModifierCategory {
  generate('Generate'),
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

  /// Whether this modifier is permanently pinned at index 0 (e.g. BaseGraphModifier).
  bool get isPinned => false;

  /// Whether this modifier can be baked permanently into the base graph.
  bool get canApply => false;

  /// Bakes changes permanently into the base graph and removes itself from the stack.
  void applyPermanent(AppState state) {}

  /// Builds configuration UI controls inside the modifier card (accessible, stacked vertically).
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified);

  /// Executes this modifier in the pipeline over [graph].
  ModifierOutput apply(Graph<String, num> graph, AppState state);
}
