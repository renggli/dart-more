/// Mode of repulsive force calculation in force-directed simulation.
enum RepulsionMode {
  /// All-pairs exact repulsion ($O(n^2)$).
  exact,

  /// Barnes-Hut quadtree approximation ($O(n \log n)$).
  barnesHut,
}

/// Configuration parameters for force-directed simulation.
final class ForceConfig {
  /// Constructs a force-directed configuration.
  const new({
    this.iterations = 100,
    this.repulsionMultiplier = 1.0,
    this.attractionMultiplier = 1.0,
    this.gravity = 0.05,
    this.coolingFactor = 1.5,
    this.optimalDistance,
    this.repulsionMode = RepulsionMode.exact,
    this.theta = 0.8,
  });

  /// Total number of simulation iterations.
  final int iterations;

  /// Multiplier applied to repulsive forces between vertices.
  final double repulsionMultiplier;

  /// Multiplier applied to attractive spring forces along edges.
  final double attractionMultiplier;

  /// Gravitational pull towards the center of the layout area.
  final double gravity;

  /// Power exponent governing temperature cooling: $T_{iter} = T_0 (1 - iter/N)^{coolingFactor}$.
  final double coolingFactor;

  /// Natural resting length of edges $k$. If null, auto-calculated from area and vertex count.
  final double? optimalDistance;

  /// Algorithm used to compute repulsive forces.
  final RepulsionMode repulsionMode;

  /// Barnes-Hut opening threshold ratio $\theta = s / d$.
  final double theta;
}
