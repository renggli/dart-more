# Graph Layout Redesign – Tasks

Scope: `lib/src/graph/layout.dart`, `lib/src/graph/layout/*.dart` (1,444 lines), tests in `test/graph/layout/`. No backward compatibility required. The web app (`web/graph/layout.dart`) is the main consumer and must be adapted.

## Decisions (final)

- Geometry: use `dart:math` `Point<double>`/`Rectangle<double>` plus a small extension; delete `LayoutPoint`/`LayoutRect`.
- API: strategy classes (`const LayeredLayout(...)`) operating on a closure-based `LayoutInput<V>`; works on a `Graph` (via adapter) and on arbitrary implicit graph-like structures (see 2.2).
- Planar layout is **out of scope** (deferred until the planarity code exposes an embedding).
- Stress majorization is the default organic layout in the web app; force-directed stays available for large graphs.

## 1. Review findings

### Bugs / quality issues

| # | Where | Issue |
| --- | --- | --- |
| 1 | `layered.dart` `_barycenterOrdering` | One downward sweep only. No upward sweep, no iterations, no transposition, so crossing reduction is weak. Vertices without predecessors get barycenter `0.0` and are pushed to the left. |
| 2 | `layered.dart` | No dummy vertices for edges spanning more than one layer. Long edges cross unrelated vertices and ordering ignores them. Positions are packed and centered per layer (no coordinate assignment), so parents are not aligned over children. |
| 3 | `layered.dart` `_assignLayers` | Longest-path ranking only: wide layouts, long edges. Cycle removal by DFS back-edge reversal is fine but undocumented and not exposed. |
| 4 | `result.dart` `edgeRoutes` | Field and `fit` handling exist, but no layout ever fills it. Dead API. |
| 5 | `radial.dart` | Root choice uses `successorsOf(v).length` (out-degree) and BFS follows successors only, so directed graphs produce arbitrary extra "components" placed on later rings. `queue.removeAt(0)` is O(n²). `unvisited.remove(next)` is O(n). Component handling is a copy of the first BFS. |
| 6 | `tree.dart` | `_buildTree` is a BFS, which drops non-tree edges silently. For cyclic input it picks `allVertices.first`. Root heuristic is zero in-degree only. |
| 7 | `force_directed.dart` | O(n²) repulsion per iteration. Hard-coded magic numbers (`0.15` degree factor, `3.0` overlap factor, `/10` temperature, `0.75` area factor). Mixes four concerns (seeding, forces, cooling, overlap removal) in a 230-line method. Default seed `42` is silent. `bounds` is both the area for `k` and (probably) a clamp. Disconnected components fly apart or collapse. No edge weights, no pinned vertices. |
| 8 | `circular.dart` / `radial.dart` | Duplicated arc-length placement code. |
| 9 | `grid.dart`, `random.dart`, `circular.dart` | Position conventions differ: grid uses the top-left origin, circular uses the center, layered and tree translate to min = 0, random uses bounds. Callers cannot compose them. |
| 10 | Everywhere | Repeated boilerplate for empty and single-vertex results, `vertices.toList()/toSet()`, orientation switch (copied in `layered.dart` and `tree.dart`), "translate bounds to origin" (copied in both), `LayoutRect.fromPoints` recomputed per layout. |
| 11 | `result.dart` `fit` | Flags `keepAspectRatio`/`scaleDown`/`scaleUp` interact confusingly (`scaleDown:false` is applied with `max(1, …)`). A fixed 800×600 default hides intent. `LayoutPoint`/`LayoutRect` reimplement `math.Point`/`math.Rectangle`. |
| 12 | `layout.dart` | `LayoutGraph` is both a topology holder and the receiver of every algorithm via extension methods, so algorithms cannot be used without it (violates the repo rule that graph algorithms use plain closures). `predecessorsOf` falls back to `successorsOf`, which hides undirected vs directed semantics. `defaultVertexWidth/Height` plus nullable closures is redundant. `neighboursOf` builds a set per call. |
| 13 | API naming | Mixed parameter names: `spacing`, `nodeDistance`, `siblingDistance`, `layerDistance`, `levelDistance`, `radiusStep`; `vertex` vs `node`; `random`+`seed` vs none. |
| 14 | Tests | ~700 lines but no property tests (no overlap, determinism, bounds, directional monotonicity, all vertices present). |

### Missing algorithms (ordered by value)

1. **Component packing** for disconnected graphs, applied automatically by every layout. This is the most visible gap for force and radial.
2. **Proper Sugiyama**: dummy vertices, iterated barycenter/median sweeps with transposition, Brandes–Köpf coordinate assignment, edge routes (fills `edgeRoutes`). Optionally network-simplex ranking.
3. **Stress majorization (SMACOF)**, optionally with Kamada–Kawai-style initialization. Deterministic, high quality for small to medium graphs, uses shortest path distances (the library already has BFS/Dijkstra/Floyd–Warshall). Becomes the recommended default instead of force-directed.
4. **Scalable force**: Barnes–Hut quadtree repulsion (O(n log n)); ForceAtlas2-style options (linear/log attraction, weights, gravity).
5. **Spectral layout** (Fiedler vectors, via power iteration): good seeding for force and stress.
6. *(Deferred)* Planar straight-line embedding (needs a planarity embedding API first).
7. **Bipartite / multipartite layers**: vertex → layer map, optionally with crossing minimization (reuse the Sugiyama ordering).
8. **Concentric/shell layout** by a score (degree, core number, betweenness): `radial` generalization.
9. **Hierarchical views of trees**: icicle, sunburst, treemap (low priority).
10. **Edge routing**: straight, polyline through dummy vertices, orthogonal (optional). Result-only; not needed by all layouts.
11. **Overlap removal** (post-process): scanline/PRISM, replacing the ad-hoc loop at the end of `forceDirected`.
12. **Constraints**: pinned vertices and initial positions as a general option for iterative layouts (incremental layout after edits in the web app).

## 2. Target design

### 2.1 Layering

```text
lib/src/graph/layout.dart                  facade: Graph.layout(...) extension + exports
lib/src/graph/layout/
  geometry.dart        LayoutPoint (= math.Point<double> typedef or thin extension), LayoutRect typedef/extension
  layout.dart          abstract GraphLayout<V> (strategy), LayoutInput<V>, LayoutResult<V>
  orientation.dart     LayoutOrientation + transform helper (single place)
  postprocess.dart     fit, center, translateToOrigin, packComponents, removeOverlaps
  circular.dart  radial.dart  grid.dart  random.dart  shell.dart(new)
  tree.dart  layered/ (sugiyama pieces)  force/ (fruchterman, forceatlas2, barnes_hut)
  stress.dart  spectral.dart  bipartite.dart
```

Algorithms live in `lib/src/graph/layout/` and depend only on `LayoutInput<V>` (closures), never on `Graph` (consistent with `AGENTS.md` for algorithms). `layout.dart` (facade) is the only adapter from `Graph`.

### 2.2 Core types

```dart
/// Immutable topology + sizing, algorithm-independent.
final class LayoutInput<V> {
  const new({
    required this.vertices,                       // List<V> (materialized once)
    required this.successorsOf,
    this.predecessorsOf,                          // null => undirected (neighbours = successors)
    this.vertexSize,                              // Size? Function(V) ; null => unitSize
    this.edgeWeight,                              // num Function(V,V)?
    this.vertexStrategy,                          // StorageStrategy<V>? like other algorithms
  });
  bool get isDirected => predecessorsOf != null;
  Size sizeOf(V v);                               // (width, height), default 40x40
  Iterable<V> neighboursOf(V v);                  // cached adjacency, built lazily once
}

/// Strategy: one class per algorithm, configuration = constructor fields.
abstract interface class GraphLayout<V> {
  LayoutResult<V> layout(LayoutInput<V> input);
}

final class LayoutResult<V> {
  final Map<V, LayoutPoint> positions;            // vertex CENTERS
  final Map<(V, V), List<LayoutPoint>> edgeRoutes; // filled by layered/planar; else empty
  LayoutRect get bounds;                          // computed once, lazily, includes vertex extents
  LayoutResult<V> transform(LayoutPoint Function(V, LayoutPoint) f);
}
```

Decisions:

- **Two entry points, one implementation.** (a) Arbitrary/implicit graphs: `strategy.layout(LayoutInput<V>(vertices: ..., successorsOf: ..., predecessorsOf: ..., vertexSize: ...))`, exactly like the other closure-based algorithms in `lib/src/graph/algorithms/` (no `Graph` import). (b) `Graph`: extension `graph.layout(strategy, vertexSize: ..., edgeWeight: ...)` in `lib/src/graph/layout.dart` that only builds the `LayoutInput` from the graph (`vertices`, `successorsOf`, `isDirected ? predecessorsOf : null`) and calls (a), then applies the post-pipeline.
- **Strategy objects instead of extension methods**: `const LayeredLayout(orientation: ..., nodeDistance: 40)`, `ForceLayout(iterations: 300, seed: 1)`, `StressLayout()`. Config is reusable, comparable (`==`), testable and easy to list in a UI. The facade keeps a convenience: `graph.layout(const TreeLayout(), vertexSize: …)`. Add a test that lays out the same structure through both entry points and compares results.
- **One position convention**: centers, no implied origin. Every layout returns raw coordinates; normalization is explicit through postprocessing (`result.normalized()` moves the bounds' top-left to `(0,0)`; `result.fit(...)`).
- **Common post-pipeline** applied by the facade, opt-out via flags: `packComponents` (for layouts declaring `handlesComponents == false`) → optional `removeOverlaps` → `normalize`. Layouts handling components themselves (tree, layered) opt out.
- **Naming unified**: `vertexDistance` (gap between neighbours in the same layer/siblings), `layerDistance` (between layers/levels/rings), `seed` (never a hidden default; `Random` injection via `random:` only for tests), `orientation`.
- **Size**: use a `Size` record `(double width, double height)` (or `math.Rectangle`) instead of two closures plus two defaults.
- **Drop** `LayoutPoint`/`LayoutRect` classes: use `math.Point<double>` / `math.Rectangle<double>` with a small extension (`center`, `expandToInclude`, `boundingBox(points)`). If equality/hash on `Point` is sufficient (it is), nothing else is needed.
- **Edge routes**: keep, but only layouts that compute them (layered via dummy vertices, optionally planar) fill them. Document that the empty map means "draw straight".

### 2.3 Algorithm designs

**Shared helpers (new `layout/support/`)**

- `bfsLevels(input, roots)` returning levels, using an `ListQueue` (fixes O(n²)).
- `components(input)` returning `List<List<V>>` (undirected sense; wraps the library's connectivity helper if usable via closures).
- `arcPlacement(ring vertices, radius, start, sweep, sizes)` used by circular, radial and shell.
- `Orientation.apply(point, orientation)` + `Orientation.axis(...)`: replaces the duplicated switches.

**Circular / Radial / Shell**: `RadialLayout(root, rootSelector, layerDistance)` where root default = the vertex with maximum *total* degree (documented), BFS over neighbours (undirected view) so directed graphs behave; each disconnected component is laid out separately with its own root and packed. `ShellLayout(shells: List<List<V>>)` or `shellOf: int Function(V)`; `CircularLayout` becomes `ShellLayout` with one shell (keep as a named constructor).

**Grid / Random**: keep, but through the strategy API; `GridLayout(columns, order: Iterable<V>? )` and the random one takes only `seed`/`bounds`.

**Tree**: keep Walker/Reingold–Tilford (`_firstWalk/_secondWalk`), but replace BFS tree-building with DFS spanning forest: roots = given, else vertices with in-degree 0 in the directed case or highest-degree vertex per component (undirected). Non-tree edges are reported in `edgeRoutes`-free form (ignored for placement, documented). Use one `Orientation.apply`.

**Layered (Sugiyama)** in `layered/`:

1. `cycle_removal.dart`: DFS back-edge reversal (existing logic); optional greedy feedback arc set later.
2. `ranking.dart`: longest path (default) and network simplex (option `ranking: Ranking.networkSimplex`), then normalize ranks.
3. `dummy_vertices.dart`: split edges spanning > 1 layer into chains; internal vertex type `_Node` (real or dummy).
4. `ordering.dart`: initial DFS order, then `sweeps` (default 24) alternating down/up weighted-median/barycenter, plus adjacent transposition, keep the best crossing count (`crossings(layerA, layerB)` with bit-indexed tree, O(E log V)). Vertices without neighbours in the adjacent layer keep their position (not 0).
5. `coordinates.dart`: Brandes–Köpf (4 alignments, balanced median) for the cross axis; layer axis from `max size of layer + layerDistance`.
6. Edge routes from dummy chain coordinates; reversed edges flagged by the result's route direction.
Components are laid out independently and packed left to right.

**Force family (`force/`)**

- `ForceLayout` (Fruchterman–Reingold with explicit config class `ForceConfig` documenting every constant: `repulsion`, `attraction`, `gravity`, `cooling`, `iterations`). Repulsion pluggable: `exact` (n ≤ 200) or `barnesHut(theta)` (quadtree in `barnes_hut.dart`).
- Options: `pinned: Set<V>`, `initialPositions`, `edgeWeight`, `seed`. Seeding: spectral (when n > 2) else circular. Overlap removal moved to `postprocess.removeOverlaps` and enabled by default through the facade.
- Components: run per component then pack (kills the drift problem).

**Stress (`stress.dart`)**: all-pairs distances via BFS (unweighted) or Dijkstra (weighted) on each component (unreachable pairs → skip), weights `w_ij = d_ij⁻²`, SMACOF iterations with convergence threshold, init from spectral/classical MDS, scale so the average edge length ≈ `vertexDistance`. Deterministic. Recommended as the default "organic" layout for n ≤ ~500; fall back to Barnes–Hut force above.

**Spectral (`spectral.dart`)**: Laplacian eigenvectors 2 and 3 through power iteration with deflation (no linear-algebra dependency); used as seeding and also exposed.

**Bipartite/Multipartite**: `LayeredColumnsLayout(layerOf: int Function(V), orientation)`: uses `ordering.dart` from layered with fixed layers, no cycle removal or ranking.

### 2.4 Postprocessing API

```dart
extension LayoutResultExtension<V> on LayoutResult<V> {
  LayoutResult<V> normalized({Point<double> origin = const Point(0, 0)});
  LayoutResult<V> fit(Rectangle<double> target, {double margin = 0, FitMode mode = FitMode.contain});
  LayoutResult<V> removeOverlaps(LayoutInput<V> input, {double padding = 4});
}
enum FitMode { contain /* uniform, both directions */, stretch, shrinkOnly, growOnly }
```

`FitMode` replaces the three booleans.

## 3. Execution plan (for an agent)

Rules: follow `AGENTS.md`; after each step run `dart format`, `dart analyze`, `dart test test/graph test/deps_test.dart`. Never commit. Max 2 fix attempts then halt report.

1. **T-L1 Baseline.** Record the current behavior of all layouts in `test/graph/layout/` (they pass). List callers: `grep -rn "\.layout(\|LayoutGraph\|LayoutPoint\|LayoutRect\|LayoutResult\|LayoutOrientation" lib web test example 2>/dev/null`. Check `README`/docs/`example/` mentions.
2. **T-L2 Geometry.** Introduce `geometry.dart` (typedefs/extensions over `math.Point<double>`/`math.Rectangle<double>`), migrate `result.dart` and all layouts mechanically, delete `LayoutPoint`/`LayoutRect` and their tests (move meaningful cases to geometry tests).
3. **T-L3 Core types.** Add `LayoutInput`, `GraphLayout`, `LayoutResult` (lazy bounds, vertex centers), `Orientation` helper, `support/` helpers (`bfsLevels`, `components`, `arcPlacement`). Unit-test each helper (empty, single vertex, disconnected, directed vs undirected).
4. **T-L4 Postprocessing.** `normalized`, `fit(FitMode)`, `packComponents` (shelf packing sorted by height, honors `vertexDistance`), `removeOverlaps` (move the loop from `force_directed.dart`, add a deterministic scanline variant). Tests: no overlaps, order-preserving, idempotent normalization.
5. **T-L5 Port simple layouts** (circular → shell, grid, random, radial) to strategy classes with the unified naming (`vertexDistance`, `layerDistance`, `seed`). Fix radial root/BFS/components. Keep old tests as ported tests; add property tests ("all vertices positioned", "no two vertices closer than their sizes plus distance" where applicable, determinism for a fixed seed).
6. **T-L6 Tree.** Port, switch to DFS spanning forest, fix cyclic input. Tests: path, star, binary tree, forest, cycle, undirected input, all four orientations.
7. **T-L7 Force.** Split into `ForceConfig`, `Quadtree` (Barnes–Hut), the iteration loop, and seeding. Remove the magic numbers into documented config defaults. Pinned vertices, per-component run + packing. Tests: determinism with seed, connected vertices closer than unconnected on average, pinned vertices unchanged, Barnes–Hut vs exact produce a similar energy (tolerance), 2,000-vertex smoke test under a time bound.
8. **T-L8 Layered rewrite** in `layered/` as specified (steps 1–6). Tests: crossing count on known graphs (K₂,₃ layered, a ladder has 0, a classic 2-crossing example improved by sweeps), long-edge dummy chain routes, cycle graph handling, ranks monotone along non-reversed edges, orientation variants, determinism.
9. **T-L9 New: spectral, stress.** Tests: path graph in stress layout has near-uniform spacing; cycle becomes near-circular; complete graph symmetric; disconnected input handled; spectral deterministic.
10. **T-L10 New: shell and bipartite/multipartite columns.** (Planar layout is deferred; do not implement.)
11. **T-L11 Facade.** Rewrite `lib/src/graph/layout.dart`: `Graph.layout(GraphLayout<V> strategy, {vertexSize, edgeWeight, normalize = true, packComponents = true, removeOverlaps = false})` returning `LayoutResult<V>`. Update the `lib/graph.dart` exports (explicit `show` lists). Update `test/deps_test.dart` expectations if needed (layout must not import `Graph`, only the facade does).
12. **T-L12 Web app.** Update `web/graph/layout.dart` (`GraphLayout.applyLayout`) to the new API. Map `LayoutEngine` enum (web task T11) → strategy instances. Add engines `stress` (**the new default**; replaces `force` as `AppState.layoutEngine` default, force stays selectable for large graphs), `shell`, `bipartite`. Replace the web app's duplicate node-size formula with a single `vertexSize` closure shared with the renderer. Use `result.edgeRoutes` in the renderer for layered edges (polyline) if present.
13. **T-L13 Docs & examples.** Doc comments with runnable examples on every strategy (verify they compile and output as advertised), a `doc`/README section "Layouts" with a comparison table (complexity, deterministic, handles directed, handles disconnected), and update `CHANGELOG.md`.
14. **T-L14 Cleanup.** Remove any leftover old files, run `dart fix --apply`, full `dart test`, and check coverage for `lib/src/graph/layout/` (target ≥ 95%, use the `dart-collect-coverage` skill).

### Suggested order & checkpoints

`L1 → L2 → L3 → L4` (foundation, tests still green) → `L5, L6` → `L7` → `L8` → `L9, L10` → `L11` → `L12` → `L13, L14`. After L5 the old and new APIs may briefly coexist behind the facade; delete the old extensions in L11.
