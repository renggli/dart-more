import 'base.dart';
import 'flow.dart';
import 'generation.dart';
import 'layout.dart';
import 'matching.dart';
import 'metrics.dart';
import 'paths.dart';
import 'structure.dart';
import 'tours.dart';
import 'transform.dart';
import 'trees.dart';

/// Specification and metadata for a registered graph modifier.
class ModifierSpec {
  const new({
    required this.type,
    required this.name,
    required this.category,
    required this.factory,
  });

  /// Unique serialized identifier for this modifier.
  final String type;

  /// User-visible display name.
  final String name;

  /// Category grouping this modifier in menus and panels.
  final ModifierCategory category;

  /// Factory function instantiating a default instance of this modifier.
  final GraphModifier Function() factory;
}

/// Registry providing factory instantiation and metadata for all available modifiers.
abstract final class ModifierRegistry {
  static const List<ModifierSpec> specs = [
    // Generate
    ModifierSpec(
      type: 'generator',
      name: 'Graph Generator',
      category: ModifierCategory.generate,
      factory: GeneratorModifier.new,
    ),
    // Layout
    ModifierSpec(
      type: 'layout',
      name: 'Layout',
      category: ModifierCategory.layout,
      factory: LayoutModifier.new,
    ),
    // Paths & Traversal
    ModifierSpec(
      type: 'shortest_path',
      name: 'Shortest Path',
      category: ModifierCategory.paths,
      factory: ShortestPathModifier.new,
    ),
    ModifierSpec(
      type: 'all_pairs_path',
      name: 'All-Pairs Paths',
      category: ModifierCategory.paths,
      factory: AllPairsShortestPathModifier.new,
    ),
    // Structure & Connectivity
    ModifierSpec(
      type: 'components',
      name: 'Components',
      category: ModifierCategory.structure,
      factory: ComponentsModifier.new,
    ),
    ModifierSpec(
      type: 'biconnected',
      name: 'Biconnected & Bridges',
      category: ModifierCategory.structure,
      factory: BiconnectedComponentsModifier.new,
    ),
    ModifierSpec(
      type: 'cycle_detection',
      name: 'Cycles',
      category: ModifierCategory.structure,
      factory: CycleDetectionModifier.new,
    ),
    ModifierSpec(
      type: 'planarity',
      name: 'Planarity',
      category: ModifierCategory.structure,
      factory: PlanarityModifier.new,
    ),
    ModifierSpec(
      type: 'k_core',
      name: 'k-Core',
      category: ModifierCategory.structure,
      factory: KCoreModifier.new,
    ),
    // Centrality & Metrics
    ModifierSpec(
      type: 'centrality',
      name: 'Centrality',
      category: ModifierCategory.centrality,
      factory: CentralityModifier.new,
    ),
    // Trees
    ModifierSpec(
      type: 'spanning_tree',
      name: 'Spanning Tree',
      category: ModifierCategory.trees,
      factory: SpanningTreeModifier.new,
    ),
    // Flows & Cuts
    ModifierSpec(
      type: 'max_flow',
      name: 'Max Flow & Min s-t Cut',
      category: ModifierCategory.flows,
      factory: MaxFlowModifier.new,
    ),
    ModifierSpec(
      type: 'min_cut',
      name: 'Global Min Cut',
      category: ModifierCategory.flows,
      factory: MinCutModifier.new,
    ),
    // Matching, Cliques & Covers
    ModifierSpec(
      type: 'matching',
      name: 'Maximum Matching',
      category: ModifierCategory.matching,
      factory: MatchingModifier.new,
    ),
    ModifierSpec(
      type: 'cliques',
      name: 'Cliques & Independent Set',
      category: ModifierCategory.matching,
      factory: CliquesModifier.new,
    ),
    ModifierSpec(
      type: 'vertex_cover',
      name: 'Vertex Cover',
      category: ModifierCategory.matching,
      factory: VertexCoverModifier.new,
    ),
    ModifierSpec(
      type: 'vertex_coloring',
      name: 'Vertex Coloring',
      category: ModifierCategory.matching,
      factory: VertexColoringModifier.new,
    ),
    // Tours
    ModifierSpec(
      type: 'eulerian',
      name: 'Eulerian Trail & Circuit',
      category: ModifierCategory.tours,
      factory: EulerianModifier.new,
    ),
    ModifierSpec(
      type: 'hamiltonian',
      name: 'Hamiltonian Path & Cycle',
      category: ModifierCategory.tours,
      factory: HamiltonianModifier.new,
    ),
    // Transform
    ModifierSpec(
      type: 'complement',
      name: 'Complement',
      category: ModifierCategory.transform,
      factory: GraphComplementModifier.new,
    ),
    ModifierSpec(
      type: 'transitive_closure',
      name: 'Transitive Closure',
      category: ModifierCategory.transform,
      factory: TransitiveClosureModifier.new,
    ),
    ModifierSpec(
      type: 'transitive_reduction',
      name: 'Transitive Reduction',
      category: ModifierCategory.transform,
      factory: TransitiveReductionModifier.new,
    ),
  ];

  static final Map<String, ModifierSpec> _byType = {
    for (final s in specs) s.type: s,
  };

  /// Returns the registered list of all available modifier type keys.
  static List<String> get availableTypes => [for (final s in specs) s.type];

  /// Returns the spec for [type], throwing [ArgumentError] if unknown.
  static ModifierSpec getSpec(String type) {
    final spec = _byType[type];
    if (spec == null) {
      throw ArgumentError.value(type, 'type', 'Unknown modifier type');
    }
    return spec;
  }

  /// Looks up user-visible display name for [type], throwing [ArgumentError] on unknown type.
  static String getDisplayName(String type) => getSpec(type).name;

  /// Looks up the category for [type], throwing [ArgumentError] on unknown type.
  static ModifierCategory getCategory(String type) => getSpec(type).category;

  /// Creates a new instance of the modifier for [type], throwing [ArgumentError] on unknown type.
  static GraphModifier create(String type) => getSpec(type).factory();

  /// Returns all specs belonging to [category].
  static List<ModifierSpec> byCategory(ModifierCategory category) => [
    for (final s in specs)
      if (s.category == category) s,
  ];
}
