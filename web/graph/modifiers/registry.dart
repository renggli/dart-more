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
    this.description = '',
    this.complexity,
    this.canAdd = true,
  });

  /// Unique serialized identifier for this modifier.
  final String type;

  /// User-visible display name.
  final String name;

  /// Category grouping this modifier in menus and panels.
  final ModifierCategory category;

  /// Factory function instantiating a default instance of this modifier.
  final GraphModifier Function() factory;

  /// One-line explanation of what the algorithm accomplishes.
  final String description;

  /// Big-O asymptotic time complexity notation.
  final String? complexity;

  /// Whether this modifier appears in the "+ Add Modifier" dropdown.
  final bool canAdd;
}

/// Registry providing factory instantiation and metadata for all available modifiers.
abstract final class ModifierRegistry {
  static const List<ModifierSpec> specs = [
    // Generate
    ModifierSpec(
      type: 'base_graph',
      name: 'Base Graph',
      category: ModifierCategory.generate,
      factory: BaseGraphModifier.new,
      canAdd: false,
      description: 'Base input graph configuration and directedness.',
      complexity: 'O(1)',
    ),
    ModifierSpec(
      type: 'generator',
      name: 'Graph Generator',
      category: ModifierCategory.generate,
      factory: GeneratorModifier.new,
      description: 'Generates standard synthetic or Atlas graphs.',
      complexity: 'O(V + E)',
    ),
    // Layout
    ModifierSpec(
      type: 'layout',
      name: 'Layout',
      category: ModifierCategory.layout,
      factory: LayoutModifier.new,
      description: 'Computes spatial vertex coordinates using selected layout algorithm.',
      complexity: 'O(V + E) to O(V²)',
    ),
    // Paths & Traversal
    ModifierSpec(
      type: 'shortest_path',
      name: 'Shortest Path',
      category: ModifierCategory.paths,
      factory: ShortestPathModifier.new,
      description: 'Finds single-pair shortest path or all equal-cost paths.',
      complexity: 'O(E + V log V)',
    ),
    ModifierSpec(
      type: 'all_pairs_path',
      name: 'All-Pairs Paths',
      category: ModifierCategory.paths,
      factory: AllPairsShortestPathModifier.new,
      description:
          'Computes shortest path distances between all pairs of vertices.',
      complexity: 'O(V³)',
    ),
    ModifierSpec(
      type: 'traversal',
      name: 'Traversal',
      category: ModifierCategory.paths,
      factory: TraversalModifier.new,
      description: 'Traverses the graph via BFS, DFS, topological order, or random walk.',
      complexity: 'O(V + E)',
    ),
    // Structure & Connectivity
    ModifierSpec(
      type: 'components',
      name: 'Components',
      category: ModifierCategory.structure,
      factory: ComponentsModifier.new,
      description: 'Finds connected components or community partitions.',
      complexity: 'O(V + E)',
    ),
    ModifierSpec(
      type: 'biconnected',
      name: 'Biconnected & Bridges',
      category: ModifierCategory.structure,
      factory: BiconnectedComponentsModifier.new,
      description: 'Finds biconnected components, articulation vertices, and bridge edges.',
      complexity: 'O(V + E)',
    ),
    ModifierSpec(
      type: 'cycle_detection',
      name: 'Cycles',
      category: ModifierCategory.structure,
      factory: CycleDetectionModifier.new,
      description: 'Detects cycles or finds chordless cycle basis.',
      complexity: 'O(V + E)',
    ),
    ModifierSpec(
      type: 'planarity',
      name: 'Planarity',
      category: ModifierCategory.structure,
      factory: PlanarityModifier.new,
      description: 'Tests planarity and identifies Kuratowski subgraphs.',
      complexity: 'O(V)',
    ),
    ModifierSpec(
      type: 'k_core',
      name: 'k-Core',
      category: ModifierCategory.structure,
      factory: KCoreModifier.new,
      description: 'Finds maximal connected subgraph where all vertices have degree >= k.',
      complexity: 'O(V + E)',
    ),
    ModifierSpec(
      type: 'isomorphism',
      name: 'Isomorphism',
      category: ModifierCategory.structure,
      factory: IsomorphismModifier.new,
      description: 'Tests graph isomorphism against Atlas graphs using VF2.',
      complexity: 'O(V! · V)',
    ),
    // Centrality & Metrics
    ModifierSpec(
      type: 'centrality',
      name: 'Centrality',
      category: ModifierCategory.centrality,
      factory: CentralityModifier.new,
      description: 'Ranks vertex importance via degree, closeness, betweenness, Katz, or HITS.',
      complexity: 'O(V · E)',
    ),
    ModifierSpec(
      type: 'graph_metrics',
      name: 'Graph Metrics',
      category: ModifierCategory.centrality,
      factory: GraphMetricsModifier.new,
      description:
          'Computes structural metrics, density, connectivity, and diameters.',
      complexity: 'O(V · E)',
    ),
    // Trees
    ModifierSpec(
      type: 'spanning_tree',
      name: 'Spanning Tree',
      category: ModifierCategory.trees,
      factory: SpanningTreeModifier.new,
      description: 'Finds minimum spanning tree or spanning forest.',
      complexity: 'O(E log V)',
    ),
    // Flows & Cuts
    ModifierSpec(
      type: 'max_flow',
      name: 'Max Flow & Min s-t Cut',
      category: ModifierCategory.flows,
      factory: MaxFlowModifier.new,
      description: 'Computes maximum network flow and minimum s-t cut (Dinic).',
      complexity: 'O(V² · E)',
    ),
    ModifierSpec(
      type: 'min_cut',
      name: 'Global Min Cut',
      category: ModifierCategory.flows,
      factory: MinCutModifier.new,
      description: 'Finds global minimum edge cut (Stoer-Wagner).',
      complexity: 'O(V · E + V² log V)',
    ),
    // Matching, Cliques & Covers
    ModifierSpec(
      type: 'matching',
      name: 'Maximum Matching',
      category: ModifierCategory.matching,
      factory: MatchingModifier.new,
      description: 'Finds maximum cardinality or maximum weight matching (Blossom / Hungarian).',
      complexity: 'O(V² · E)',
    ),
    ModifierSpec(
      type: 'cliques',
      name: 'Cliques & Independent Set',
      category: ModifierCategory.matching,
      factory: CliquesModifier.new,
      description:
          'Finds maximal cliques and maximum independent set (Bron-Kerbosch).',
      complexity: 'O(3^(V/3))',
    ),
    ModifierSpec(
      type: 'vertex_cover',
      name: 'Vertex Cover',
      category: ModifierCategory.matching,
      factory: VertexCoverModifier.new,
      description:
          'Finds minimum vertex cover dual to maximum independent set.',
      complexity: 'O(3^(V/3))',
    ),
    ModifierSpec(
      type: 'vertex_coloring',
      name: 'Vertex Coloring',
      category: ModifierCategory.matching,
      factory: VertexColoringModifier.new,
      description: 'Colors vertices such that adjacent vertices have distinct colors (Welsh-Powell).',
      complexity: 'O(V²)',
    ),
    // Tours
    ModifierSpec(
      type: 'eulerian',
      name: 'Eulerian Trail & Circuit',
      category: ModifierCategory.tours,
      factory: EulerianModifier.new,
      description:
          'Tests and reconstructs Eulerian trail or circuit (Hierholzer).',
      complexity: 'O(V + E)',
    ),
    ModifierSpec(
      type: 'hamiltonian',
      name: 'Hamiltonian Path & Cycle',
      category: ModifierCategory.tours,
      factory: HamiltonianModifier.new,
      description:
          'Searches for Hamiltonian path or cycle visiting every vertex once.',
      complexity: 'O(V!)',
    ),
    // Transform
    ModifierSpec(
      type: 'complement',
      name: 'Complement',
      category: ModifierCategory.transform,
      factory: GraphComplementModifier.new,
      description: 'Constructs the graph complement with inverted edge set.',
      complexity: 'O(V²)',
    ),
    ModifierSpec(
      type: 'transitive_closure',
      name: 'Transitive Closure',
      category: ModifierCategory.transform,
      factory: TransitiveClosureModifier.new,
      description: 'Constructs reachability transitive closure.',
      complexity: 'O(V³)',
    ),
    ModifierSpec(
      type: 'transitive_reduction',
      name: 'Transitive Reduction',
      category: ModifierCategory.transform,
      factory: TransitiveReductionModifier.new,
      description: 'Constructs minimal graph preserving reachability in DAGs.',
      complexity: 'O(V³)',
    ),
    ModifierSpec(
      type: 'combine',
      name: 'Combine',
      category: ModifierCategory.transform,
      factory: CombineModifier.new,
      description: 'Combines current graph with an Atlas graph via union or intersection.',
      complexity: 'O(V + E)',
    ),
  ];

  static final Map<String, ModifierSpec> _byType = {
    for (final s in specs) s.type: s,
  };

  /// Returns the registered list of all available modifier type keys.
  static List<String> get availableTypes => [for (final s in specs) s.type];

  /// Checks whether [type] is registered.
  static bool isRegistered(String type) => _byType.containsKey(type);

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

  /// Restores a modifier instance from its serialized [json] map.
  ///
  /// Returns null and logs a console warning if the modifier id is unknown.
  static GraphModifier? fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['type']?.toString();
    if (id == null) return null;
    final spec = _byType[id];
    if (spec == null) {
      // ignore: avoid_print
      print('Warning: unknown modifier id "$id" in serialized state.');
      return null;
    }
    final modifier = spec.factory();
    modifier.applyJson(json);
    return modifier;
  }

  /// Returns all specs belonging to [category].
  static List<ModifierSpec> byCategory(ModifierCategory category) => [
    for (final s in specs)
      if (s.category == category) s,
  ];
}
