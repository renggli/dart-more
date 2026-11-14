# Graph Web App – Task List

> **Read "Execution Guide" and "Detailed Instructions" (bottom) before starting any task.** Tasks are small contracts; the detailed section has steps, pitfalls and acceptance checks.

Executable by an agent, in order. After each task: `dart format web/graph && dart analyze web/graph`. Verify in browser (`webdev serve` / `dart compile js`) where UI-affecting. Do not commit.

Findings come from a targeted review (not every line of `modifiers.dart` was read); verify each before changing.

## P0 – Bugs / Security

- [x] **T1 XSS via labels.** `renderer.dart` (~L461) interpolates `node.label` (and likely edge labels) into SVG via `svg.innerHTML`. `inspector.dart` (L160, 240, 302, 309) and `graph.dart` (L425) build HTML with unescaped strings (`overlay.title`, labels). Labels come from imported JSON/URL hash/Mermaid, so this is exploitable via a shared link.
  - Add `escapeHtml(String)` (`& < > " '`) and apply it to every interpolated user/modifier-derived string; keep the `innerHTML` markup approach.
  - Test: vertex labelled `<img src=x onerror=alert(1)>` renders as literal text in canvas, inspector, stats overlay.
- [x] **T2 `matchesKey` special-cases by command id** (`commands.dart` L~45-70: `edit.delete`, `select.all`, `select.none`, `edit.redo`). `select.all` and `select.none` both declare shortcut `A`, so both match; dispatch relies on `canExecute`. Replace with a declarative `List<String> shortcuts` per command (e.g. `['Ctrl+Shift+Z','Ctrl+Y']`); remove id checks. Ensure dispatcher picks the first command whose `canExecute` is true.
- [x] **T3 Undo/redo and export drop styling.** `GraphSnapshot.fromGraph`, `GraphNode.toJson/fromJson` and `exportToJson` keep only id/label/x/y. Persist **user-set** node styles (fill, border, text color, border width, opacity) in snapshots and JSON (optional keys; old files still load). Prerequisite: T9 (split persistent user style from transient modifier-applied style, so modifier output is never saved or restored). Add round-trip tests.
- [x] **T4 Edge style / selection keys are direction-sensitive.** `AppState.edgeStyles` and `selectedEdges` use `(u, v)`; for undirected graphs `(a,b)` and `(b,a)` are the same edge (inspector already does `getEdge(u,v) ?? getEdge(v,u)`). Add `AppState.edgeKey(u, v)` normalizing for undirected graphs (sorted) and use it in `getEdgeStyle`, selection, renderer, commands (`SelectAll`, `Delete`, `Copy`, `Paste`, `Reverse`, `Subdivide`).
- [x] **T5 Mermaid import loses state.** `GraphIO.importFromMermaid` uses `vertexParser: (id, label) => id`, discarding Mermaid labels; `isWeighted` inferred as `any(value != 1)`. Keep labels in `GraphNode.label`; check `GraphFactory.fromMermaid` for the real label API. Fix isWeighted heuristic (a graph with explicit weight 1 labels is still weighted).
- [x] **T6 URL hash restore** (`graph.dart` ~L92-100, `importFromUrlHash`): failures are swallowed (`catch (_)` → null). Show a user-visible error message when a `#g=` hash fails to decode/parse (catch `FormatException`, not everything). Keep the current `#g=<base64url JSON>` format; no compression. Also drop the redundant `vertices` + `nodes` duplication in `exportToJson` (keep `nodes`; keep reading `vertices` for old files).
- [x] **T7 `GraphIO.importFromJson` robustness.** Casts (`as bool?`, `as List?`, `as num?`) throw `TypeError`, not `FormatException`. Replace with pattern matching and throw `FormatException` with a clear message; edges referencing unknown vertices should add the vertex + node (currently `nodes` may lack entries; `syncNodes` masks it).
- [x] **T8 `GraphLayout.applyLayout`** (`layout.dart`): `fitted` uses fixed bounds (120–780 × 100–560) independent of canvas size; `force` default `true` makes `force: false` path dead unless a caller uses it – grep callers, remove param if unused. `initialPositions` is only used by `forceDirected`; compute lazily inside that branch. Magic numbers (48, 8.5, 24, 32, 40, 80) → named constants shared with `renderer.dart` node-size calculation (verify renderer uses the same width formula, otherwise overlap occurs).

## P1 – Inconsistencies

- [x] **T9 `GraphNode` mixes user data and modifier-applied styling** (`node.dart`). Split into persistent data (`id`, `label`, `x`, `y`) and a transient `NodeStyle` (like `GraphEdgeStyle`); `resetVisuals()` → `style.reset()`. Add doc comments to the public style fields (currently undocumented, violates AGENTS.md). Remove the duplicated default literals (`1.5`, `1.0`) by using constants.
- [x] **T10 Deprecated/odd constructor style.** Files use `new(...)` primary-constructor syntax; ensure all classes use it consistently (e.g. `GraphModifier` subclasses, `ModifierOutput`, `ModifierTableData`) per the `dart-use-primary-constructors` skill; `GraphModifier({bool? enabled}) : enabled = enabled ?? true` → `this.enabled = true`.
- [x] **T11 String-typed enums.** `layoutEngine`, `rankDir`, generator `type`, `combineMode`, shortest-path `algorithm`, and `ModifierRegistry` ids are raw strings with `_ =>` fallbacks (e.g. `create` silently returns `ShortestPathModifier` for unknown types). Introduce enums (`LayoutEngine`, `RankDir`, …); make `ModifierRegistry` a single table `type → (displayName, factory)` replacing the three parallel lists/switches (`availableTypes`, `getDisplayName`, `create`); unknown type must throw `ArgumentError`.
- [x] **T12 Docs mismatch.** `io.dart` class doc claims DSL, SVG, Dart code support; only JSON/Mermaid/DOT/URL exist. fix the doc to list only JSON, Mermaid, DOT and URL hash (no new exporters). `dom_utils.dart` doc comment is a floating comment, not attached to a declaration. `modifiers.dart` public classes lack `///` docs (AGENTS.md).
- [x] **T13 Selection state redundancy.** `selectedSource/selectedTarget/activeVertex/selectedVertices/selectedEdge/selectedEdges` overlap (`syncSelectionSourceTarget()` exists to reconcile them; commands set several by hand, e.g. `SelectAllCommand`). Encapsulate in a `Selection` class with a single mutation API (`selectVertices`, `selectEdges`, `clear`), derive `activeVertex`, `selectedEdge`, source/target.
- [x] **T14 Command boilerplate / duplication** (`commands.dart`, 1200 lines). `SelectAllCommand`/`SelectAllVerticesCommand`/`SelectAllEdgesCommand`, `DeselectAll`, `ExpandSelection`/`CollapseSelection`, `ComplementCommand`/`TransitiveClosureCommand`/`TransitiveReductionCommand` (duplicate the matching modifiers), `ExtrudeVertexCommand extends ExpandVertexCommand`. Add a lightweight `SimpleCommand` (id, title, shortcut, category, canExecute, execute as constructor fields/closures) and collapse simple commands into a table; make `GraphCommand.id/title/...` `final` fields instead of getters.
- [x] **T15 Inline styles in Dart.** `inspector.dart` (33), `modifiers.dart` (6), `graph.dart` set `style.fontSize/margin/color` repeatedly; move to CSS classes in `graph.css` (`.metrics`, `.form-field-stacked label`). Extract the repeated `p()..style...` metrics-paragraph creation in `inspector.dart` into one helper.
- [x] **T16 Inline SVG icon strings** in `graph.dart` L265-294: move to `graph.html` template/`<symbol>` or constants in a new `icons.dart`.

## P2 – Dead code / Simplification

- [x] **T17 Unused DOM helpers** in `dom_utils.dart`: `textInput`, `numberInput`, `rangeInput` have no callers (verify `label` too). Remove unused **except `numberInput`/`rangeInput`, which T29 (Atlas slider) needs**; dedupe `numberInput`/`rangeInput` into one `_input(type, …)` helper and use a generic `_create<T>(tag)` to remove the repeated `createElement … as` pattern.
- [x] **T18 Unused/low-value members.** Verify each with grep and delete if unused: `GraphModifier.updateConfig` (2 refs), `PathOverlay.activeStep`/`stepNumbers`, `PartitionOverlay.renderClusters`/`highlightedEdges` (2 refs each = declaration only?), `AppState.canUndo/canRedo` wrappers, `AppState.showStats`, `GraphClipboard.isEmpty`, `AppState._createDefaultGraph` (trivial wrapper), `GraphModifier.collapsed` placement (UI state in model).
- [x] **T19 `modifiers.dart` is 3,200 lines.** Split into `modifiers/` (one file per category: `base.dart`, `generation.dart`, `paths.dart`, `structure.dart`, `flow.dart`, `transform.dart`, `registry.dart`) keeping co-located base+subclasses; keep `modifiers.dart` as a thin export or update imports. Move shared UI helpers (`_field`, `_colorSelect`, `_patternSelect`, `_vertexSelect`) to `modifier_ui.dart`; merge `_colorSelect`/`_patternSelect` into one `_optionSelect(options, initial, onChange)`.
- [x] **T20 Modifier algorithm reimplementation.** `ShortestPathModifier` hand-rolls DFS/BFS (L~760-810) and several others (cycles, Euler, Hamiltonian, k-core, cliques, transitive ops) likely reimplement `package:more/graph.dart` algorithms. Replace with library calls where available (check `lib/src/graph/algorithms.dart`); delete duplicated logic.
- [x] **T21 `GeneratorModifier.apply`** (L361-545): one 190-line method with a string `if` chain; replace with the `GraphFactory`/generator APIs in `package:more/graph.dart` if present, else a `switch` expression on an enum into small private functions. Also remove the duplicated directed-edge coin-flip logic repeated for each type.
- [x] **T22 `graph.dart` (1,400 lines, single `main`).** Split into `toolbar.dart`, `canvas_input.dart` (mouse/keyboard), `modifier_panel.dart`, `menu.dart`; `main()` should only wire them. Replace `state.on*` nullable callbacks (`onOpenFile`, `onOpenImport`, `onOpenExport`, `onShowInlineEditor`) with a small `AppUi` interface passed to commands, so `AppState` carries no view concerns. Move UI-ish fields (`cursorX/Y`, `pendingPlacementVertex`) out of the model.
- [x] **T23 Subscription leaks.** 33 `.listen(...)` calls in `graph.dart`, plus listeners in `modifiers.dart` (`onChange.listen`) on elements recreated on every `buildConfigUI`; confirm elements are discarded (no leaks) and that global `window` listeners are registered once.
- [x] **T24 `AppState.evaluateModifiers`**: `catch (error)` swallows stack trace and catches `Error`s; catch `Exception`/specific types, keep `StackTrace` in the output for console debugging. Also the final loop adding missing nodes silently masks bugs in `syncNodes`; remove once T7 holds.
- [x] **T25 `nextAvailableNodeId`**: after A–Z it generates `N<count+1>`; fine, but dedupe the checks `containsVertex || nodes.containsKey` into one helper.

## P3 – Tests & Tooling

- [x] **T26 No tests exist for web/graph logic.** Under `test/web_graph/` (VM-testable, no `package:web` imports): `GraphIO` JSON/Mermaid/hash round-trips and malformed input (needs `io.dart` split: `io_codec.dart` without `dart:js_interop`), `AppState` (undo/redo, `nextAvailableNodeId`, `evaluateModifiers` error path), `GraphCommand` shortcut matching and `canExecute`, `ModifierRegistry` round-trip for every type (`create(type).id == type`), each modifier `apply` on a small graph. Use `package:checks`.
- [x] **T27 Separate logic from DOM, incrementally.** Make DOM-free files VM-testable first: `io_codec.dart` (codecs without `dart:js_interop`), `node.dart`, `selection.dart` (T13), `layout.dart`, `html_utils.dart` (`escapeHtml`). Do the larger `GraphModifier` model/view split later (after T19), only as far as needed to test `state.dart`/`commands.dart`.
- [x] **T28 Add `web/graph/README.md`** with build/serve instructions, file map, and the module dependency rules established above.

## P4 – Modifier Organization, Consistency & Coverage

Library facts (verify in `lib/src/graph/`): `GraphFactory.atlas(n)` / `atlasMatching({vertexCount, edgeCount})` (1253 graphs), `ring`, `star`, `tree`, `complete`, `partite`, `path`, `random`; `Graph.union/intersection/complement`, `connected()`, `transitiveClosure/Reduction`; algorithms listed below.

- [x] **T29 Generator: expose the Atlas.** Add type `atlas` to `GeneratorModifier`: slider `0..1252` (`atlas(n)`) with a number box, plus optional vertex-count/edge-count filters backed by `atlasMatching` (slider then indexes the filtered list). Show "G{n}: V vertices, E edges" in the status summary. Atlas graphs are undirected: build with the pipeline input's directedness (`GraphFactory(isDirected: graph.isDirected)`); for a directed input each atlas edge becomes bidirectional.
- [x] **T30 Generator: use library factories, expose all parameters.** Replace hand-rolled complete/cycle/star/path/tree/bipartite/random with `GraphFactory` calls (`complete`, `ring`, `star`, `path`, `tree`, `partite`, `random`). Add a `grid(rows:, cols:)` factory to the library (`lib/src/graph/factory/grid.dart`, exported via the graph library, tests in `test/graph/`, doc example) and use it; remove the hand-rolled grid. Do not commit. Per-type controls: show only relevant inputs (e.g. m-ary `branching`, bipartite `partA/partB`, random `probability` + `seed`, grid `rows/cols`); add a random `seed` field so results are reproducible (currently re-rolled on each evaluate – verify). Expose `vertexCount` slider for every type.
- [x] **T31 Generator labels.** Option `directed`/`undirected` appears in the Base Graph modifier; ensure the generator wording matches ("Union with existing graph" vs "Union (Add to existing)" / "Replace existing graph" → "Replace existing graph" and "Merge into existing graph"). Rename `Erdős–Rényi Random` → `Random (Erdős–Rényi G(n,p))`, `m-ary Tree` → `Complete m-ary Tree`, `2D Grid Graph` → `Grid Graph`; fix the stale type comment (`// complete, cycle, star, tree, bipartite, random`).
- [x] **T32 Consistent names and categories.** Single source of truth: each modifier provides `name`, `category`; `ModifierRegistry.getDisplayName` duplicates and **disagrees** (class vs registry): `Components & Clusters` vs `Components & Communities`, `Spanning Tree` vs `Minimum Spanning Tree`, `Shortest Path / Traversal` (both), `Max Flow & Min s-t Cut`. Delete the registry copy. Proposed categories and members (add menu group order in registry):
  - **Generate:** Base Graph, Generator
  - **Layout:** Layout
  - **Paths & Traversal:** Shortest Path, Traversal (BFS/DFS/topological – split from shortest path, since BFS/DFS ignore weights), All-Pairs Paths
  - **Structure & Connectivity:** Components, Biconnected & Bridges, Cycle Detection, Planarity, k-Core, Bipartite check
  - **Centrality & Metrics:** Centrality, Graph Metrics (new)
  - **Trees:** Spanning Tree
  - **Flows & Cuts:** Max Flow & Min s-t Cut, Global Min Cut
  - **Matching, Cliques & Covers:** Matching, Cliques & Independent Set, Vertex Cover, Vertex Coloring
  - **Tours:** Eulerian, Hamiltonian
  - **Transform:** Complement, Transitive Closure/Reduction, k-Core subgraph (filter), Union/Intersection (new)
  Currently `Components` is in "Structure" but `Biconnected` in "Connectivity"; `Vertex Coloring` in "Structure"; `Planarity/Eulerian/Hamiltonian` in vague "Graph Theory"; `Cliques` under "Matching & Cliques" while Vertex Cover is a clique dual; `Layout` is both modifier and `AutoLayoutCommand`. Render the "Add modifier" menu grouped by category using this order (registry list order currently matches neither).
- [x] **T33 Use sentence-style naming consistently.** Mix of "Planarity & Kuratowski" (jargon), `Maximum Matching (Blossom)`, `Global Min Cut (Stoer-Wagner)`, `Strongly Connected (Tarjan)`, `Maximal Cliques (Bron-Kerbosch)`. Rule: user-facing name = problem ("Maximum Matching"); algorithm in a secondary dropdown/tooltip. Rename "Planarity & Kuratowski" → "Planarity"; "Cycle Detection" → "Cycles"; "Centrality Heatmap" → "Centrality". Layout dropdown: `Hierarchical DAG (Layered)` vs `Hierarchical Tree / Forest`, `Concentric Radial Rings`, `Grid Alignment`, `Random Spread` → "Force-directed / Layered / Tree / Radial / Circular / Grid / Random". Direction options order TB, LR, BT, RL → Top→Bottom, Left→Right, Bottom→Top, Right→Left; hide direction when engine ignores it (force, circular, grid, radial, random); `AppState.rankDir` default `'LR'` but `GraphLayout` falls through `_` to TB for the unknown `'TB'` — make enum (T11).
- [x] **T34 Shared option conventions.** Every modifier should offer the same "output" controls: highlight color (`_colorSelect`), line pattern (`_patternSelect`), "Show removed as: dash/filter/strip" (currently only some modifiers: spanning tree `treePattern`, shortest path `pathPattern`, cycle detection `dash/filter`, k-core `dashed/remove`). Extract `OutputStyleOptions` (color, pattern, removed-mode) reused everywhere; unify option wording (`Dash & Dim Removed Vertices`, `Filter / Remove From View`, `Keep ... Dashed`, `Strip ... Completely` → "Dim removed", "Hide removed").
- [x] **T35 Show status/summary and errors uniformly.** Every `ModifierOutput` should return `statusSummary` plus a `tableData` where meaningful (components sizes, cliques, matching pairs, flow per edge, centrality scores sorted, coloring classes, shortest path edge list). Audit which modifiers return neither; add an "Export table as CSV" button for `activeModifierTable`. Modifiers that need directed/weighted/connected input should state the requirement in a `hint` line instead of silently returning empty (e.g. transitive reduction throws `Graph contains a cycle`; Eulerian/Hamiltonian/planarity limits; bipartite matching requires bipartite).
- [x] **T36 Expose unused library algorithms (new modifiers or options):**
  - Centrality: add `closenessCentrality`, `inDegree/outDegree` centrality, coreNumbers (k-core heatmap), local clustering coefficient.
  - Communities: add `louvainCommunities`, `labelPropagationCommunities` + show `modularity` in summary (Components currently weakly/strongly/biconnected only).
  - New **Graph Metrics** modifier (table): `density`, `transitivity`, `averageClusteringCoefficient`, `degreeAssortativity`, `isBipartite`, `isPlanar`, `hasCycle`, `edgeConnectivity`, `vertexConnectivity`, degree sequence.
  - Matching: add `bipartiteMatching` / `weightedBipartiteMatching` as algorithm choice (Hungarian) alongside Blossom.
  - Shortest paths: `shortestPathAll` (k-best/all equal-cost paths), configurable A* heuristic (Euclidean using node positions; currently check what is passed), negative-cycle detection message from Bellman-Ford.
  - Traversal: topological order (`traverse/topological.dart`), DFS post-order, random walk (`traverse/random.dart`) with seed; show visit order as numbered `PathOverlay`.
  - Isomorphism: new "Subgraph / Isomorphism" modifier using `isIsomorphicTo`/subgraph matching against an atlas graph (T29) or a saved pattern; highlight matched vertices.
  - Operations: new "Combine" modifier for `union`, `intersection` with a generated/atlas second graph; `Graph.connected()` → "Largest component only" option in Components.
  - Eulerian: show `hasEulerianCircuit/hasEulerianPath` explanation (odd-degree vertices highlighted).
  - Cliques: maximum clique size/clique number, and display `maximumIndependentSet` in the same card (already present – verify).
- [x] **T37 Missing algorithms (add to `lib/src/graph/algorithms/` first, with tests, then expose):** topological sort / DAG check as modifier, minimum-cost flow, minimum arborescence (Edmonds), Bipartite 2-coloring display, edge coloring, graph diameter/radius/center, Steiner/TSP heuristic (nearest neighbour + 2-opt), dominating set, chromatic number (exact for small), line graph, graph products (Cartesian), contraction, Girvan–Newman, HITS, Katz centrality, bridges-tree/block-cut tree, maximal independent set (greedy), Dijkstra with k alternatives (Yen), random graph models (Barabási–Albert, Watts–Strogatz) for the generator.
- [x] **T38 Remove redundancy between commands and modifiers.** `ComplementCommand`, `TransitiveClosureCommand`, `TransitiveReductionCommand`, `AutoLayoutCommand` duplicate modifiers + "Apply" (`canApply` / `applyPermanent`). Keep one path: commands add the modifier and `applyPermanent` immediately; share parameters. Ensure menu names in Graph menu equal modifier names (T32).
- [ ] **T39 Modifier UI state.** Persist modifier stack (type, enabled, config) in the JSON export/URL hash (currently only graph is saved – verify) via `toJson/fromJson` per modifier; add reorder (drag) and per-card help text (one-line description + complexity, e.g. "O(V·E²) Dinic"). Add an on/off eye icon label "Enabled" consistently and a "Reset to defaults".

---

# Execution Guide (for the executing agent)

## Rules

1. One task per working session. Finish, verify, then tick the box. Never start a refactor task (T9–T14, T19, T22, T27) with uncommitted half-done work from another.
2. Pure refactors must not change behavior. Before refactoring, record the baseline: `dart analyze web/graph` clean, and manually load the app and note: add vertices, connect, undo/redo, open the Generator/Layout/Shortest Path modifiers.
3. After every task: `dart format web/graph test && dart analyze` (whole repo) and `dart test test/deps_test.dart`. Fix all new warnings.
4. Build/serve: web apps in this repo are compiled with `dart compile js web/graph/graph.dart -o /tmp/graph.js` for a compile check (a type error shows here even if `dart analyze` passes for the VM). Serving: `dart run build_runner serve web:8080` (dev dependency `build_runner` is in `pubspec.yaml`), then open `http://localhost:8080/graph/graph.html`. Use the Chrome DevTools MCP to check the console for errors and take screenshots.
5. VM tests cannot import `package:web` or `dart:js_interop`. Any file imported by a test must be free of those (see T27 prerequisites).
6. Follow `AGENTS.md`: 2-space indent, `///` docs on public members, relative imports, `const` where possible, tests with `package:checks`.
7. Never commit. If a task is blocked after 2 fix attempts, stop and report using the Halt Format from the user rules.
8. If a line number in a task no longer matches, locate by symbol (`grep -n`).

## Recommended order (dependencies)

`T17, T18` (cheap dead-code cleanup) → `T1` (security) → `T27` (testability split) → `T26` (tests for existing behavior) → `T7, T6, T5, T3` (IO) → `T11` (enums) → `T13` (Selection) → `T4` (edge keys) → `T2, T14` (commands) → `T9, T10, T12, T15, T16, T24, T25, T8` → `T19` (split modifiers) → `T32, T33, T34, T35` (consistency) → `T29, T30, T31` (generator) → `T36–T39` → `T20, T21, T22, T23` → `T28`.
Reason: tests (T26) lock behavior before the large refactors; T19 before modifier feature work avoids merge pain; T11 before T32/T33 because names move into enums/registry.

# Detailed Instructions

## T1 XSS (do first)

1. In `dom_utils.dart` add:

   ```dart
   /// Escapes [text] for safe use in HTML/SVG markup.
   String escapeHtml(String text) => text
       .replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;')
       .replaceAll('"', '&quot;').replaceAll("'", '&#39;');
   ```

   (Replace `&` first.) Put it in a DOM-free `html_utils.dart` so it is unit-testable (T27).
2. Find every sink: `grep -n "innerHTML" web/graph/*.dart` (10 hits: `graph.dart` 265/280/294 are static SVG icons – leave; `graph.dart` ~425 stats overlay; `inspector.dart` 160/240/302/309; `renderer.dart` 470 which assembles the whole SVG from the `markup` buffer).
3. In `renderer.dart` the `markup` string contains interpolations in `_buildMarkup`-style code at ~L311, L314, L382, L385, L461 (`${node.label}`, edge labels), plus colors/ids/dash patterns. Wrap **every** user- or modifier-derived text node with `escapeHtml(...)`: vertex labels, edge labels, overlay `title`/`summary` values, vertex ids used inside `data-*` attributes (attribute context needs the quote escaping above), colors from `fillColor` etc. (also escape; they come from modifiers but cheap).
4. In `inspector.dart` and `graph.dart` escape `overlay.title`, labels, ids, `summary` entries. Numbers (`toStringAsFixed`) need no escaping.
5. Acceptance: create a vertex via the rename editor with label `<img src=x onerror=alert(1)>` and an edge label `"><script>alert(2)</script>`; select it; inspector, canvas, stats overlay show literal text; no alert; import the same via JSON and URL hash. Add a unit test for `escapeHtml`.
Pitfall: do not escape the HTML tags *you* write (`<b>`, `<br>`); escape only the interpolated values.

## T2 / T14 Commands

- Add to `GraphCommand` a `List<String> get shortcuts` (first entry is the display text; replace the old `shortcut` getter and update menus showing it) using the syntax `Ctrl+Shift+Z`. Move the special cases: `edit.delete` → `['X','Delete','Backspace']`; `edit.redo` → `['Ctrl+Shift+Z','Ctrl+Y']`; `select.all`/`select.none` → both `['A']` (Blender style toggle).
- Parse once (`_Shortcut.parse`) into `(key, ctrl, shift, alt)`; `Cmd` is treated as `Ctrl` (macOS `metaKey` – check the caller in `graph.dart` ~L1279 passes `ctrl: e.ctrlKey || e.metaKey`). Keep the `+`/`=` and `-`/`_` equivalence.
- Dispatcher (`graph.dart` ~L1279): loop `CommandRegistry.all`; first command with `matchesKey && canExecute(state)` executes then `break`; call `preventDefault` only when a command ran.
- T14: Introduce `final class SimpleCommand extends GraphCommand` taking `id, title, shortcut, category, canExecute (closure), execute (closure)`. Convert only commands whose `execute` is < 10 lines and that have no private state (selection commands, toggles, Reverse, Complement, closures). Keep ids and titles unchanged (menus and shortcuts reference them – `grep -rn "findById\|'edit\.\|'select\." web/graph`).
- Acceptance: all shortcuts still work (A toggles select all/none, Delete/Backspace/X delete, Ctrl+Z/Ctrl+Shift+Z/Ctrl+Y). Add tests `matchesKey` per shortcut.

## T4 Edge keys

1. Add to `AppState`: `(String, String) edgeKey(String u, String v) => primaryGraph.isDirected ? (u, v) : (u.compareTo(v) <= 0 ? (u, v) : (v, u));` – careful: modifiers may output a *different* graph (`renderGraph`), so base it on `renderGraph.isDirected` for styles and on `primaryGraph.isDirected` for selection; simplest is a single static `edgeKey(u, v, {required bool directed})` and pass the right graph.
2. List all uses: `grep -n "edgeStyles\|getEdgeStyle\|selectedEdge\b\|selectedEdges" web/graph/*.dart` (≈67 hits). Normalize at every **write** (`add`, `contains`, map lookup). Do not normalize when iterating `graph.edges` for drawing – only when looking up styles/selection.
3. Pitfall: `Reverse`, `Subdivide`, `Paste`, `Delete` remove/add selected edges: after changing vertices re-key selection.
4. Acceptance: undirected graph, click edge A–B, then run Shortest Path B→A: highlight and selection refer to the same edge; delete works regardless of which endpoint order created it.

## T9 GraphNode split

Create `final class NodeStyle { String? fillColor, borderColor, textColor; double borderWidth = defaultBorderWidth; double opacity = 1; bool visible = true; void reset(); }`, `GraphNode.style` field. Update all reads: `grep -n "fillColor\|borderColor\|textColor\|borderWidth\|\.opacity\|\.visible\|resetVisuals" web/graph/*.dart` → `node.style.X`. Do mechanically, compile (`dart analyze`) until zero errors. Add a separate persistent user style (fill/border/text color, border width, opacity) saved per T3, distinct from the transient `NodeStyle` that modifiers write; JSON gains optional keys only.

## T11 Enums

Order of work: (1) `LayoutEngine {force, layered, tree, radial, circular, grid, random}`, `RankDir {tb, lr, bt, rl}` each with `label` and `id` (the old string) and `static fromId(String)` returning a default for unknown **only when parsing user JSON**; elsewhere use exhaustive `switch`. (2) generator type / combine mode, (3) shortest path algorithm, centrality, components modes, (4) modifier registry (see T32). For each enum: replace the `String` field, change `optionElement(...)` loops to `for (final v in X.values) optionElement(v.id, v.label)`, and `select.value = x.id`. Run the app after each enum; selects with a wrong `value` silently show empty. Keep persisted ids identical for back-compat (T39).

## T13 Selection class

Create `selection.dart`: `final class Selection { Set<String> vertices; Set<(String,String)> edges; String? active; ... }` with methods `clear()`, `setVertices(Iterable)`, `toggleVertex(v)`, `setEdges`, `toggleEdge`, `removeVertex(v)` (drops incident edges). Derived getters: `activeVertex`, `selectedEdge` (= last toggled/first), `source`/`target` (the first two selected vertices – read current `syncSelectionSourceTarget` for the exact rule and preserve it). Migrate in this order: commands (`select.*`) → `graph.dart` mouse handling → renderer/inspector (reads). Replace field access one file at a time, compiling between. Keep `AppState` forwarding getters only temporarily; delete at the end.

## T19 Splitting modifiers.dart

Pure move, **no edits to logic**. Steps: (1) create `modifiers/` with `modifier_base.dart` (`ModifierTableData`, `ModifierOutput`, `GraphModifier`), `modifier_ui.dart` (rename the `_`-prefixed helpers to public `field`, `colorSelect`, `patternSelect`, `vertexSelect`; update all call sites with find-replace of `_field(`, `_colorSelect(`…), (2) move each class to a category file per T32 (classes only reference base + ui + `state.dart`/`package:more`), (3) `registry.dart` last, (4) keep `modifiers.dart` as `export` of all files so existing imports compile, then fix imports to the specific files and delete the barrel (the barrel must not be imported from within the folder). (5) `state.dart` imports `modifiers.dart` and modifiers import `state.dart`: this is a circular import; Dart allows it but T27 requires breaking it by having `state.dart` depend only on `modifier_base.dart`. Verify after each file moved: `dart analyze web/graph`.

## T22 graph.dart split

Move by cohesive blocks (find them by the `// ---` or section comments / `final ... = web.document.querySelector` groups): DOM lookups → `ui_elements.dart`; menu construction → `menu.dart`; mouse/touch handlers → `canvas_input.dart`; modifier panel (build cards, add menu) → `modifier_panel.dart`; stats overlay → `stats_overlay.dart`. Pass dependencies explicitly (`AppState`, renderer, an `void Function() requestRender`) – no new globals. `main()` constructs and wires. After each extraction run the app and check the corresponding feature in the browser.

## T26/T27 Tests & testability

Incremental plan: (a) move `escapeHtml` to `html_utils.dart` and the `GraphIO` JSON/Mermaid/hash codecs into `io_codec.dart` (no `dart:js_interop`; `downloadTextFile` stays in `io.dart`); (b) test `io_codec`, `node`, `selection`, `layout` (if `layout.dart` pulls `package:web` via `state.dart`→`modifiers.dart`, pass needed values as parameters instead of `AppState`); (c) only after T19, split modifier model from `buildConfigUI` so `state.dart` and `commands.dart` compile on the VM, then test them.
Test files go to `test/web_graph/*_test.dart` mirroring file names. Minimum cases: JSON round trip (labels, positions, directed/weighted flags), malformed JSON (`FormatException`), hash round trip + garbage hash → null, undo/redo stack limit 50, `nextAvailableNodeId` (A…Z, then N27…), every command's `canExecute` on empty vs non-empty graph, every shortcut. Run: `dart test test/web_graph`.

## T29/T30 Generator (Atlas)

Current structure: `GeneratorModifier` fields `type`, `count`, `arity`, `prob`, `combineMode`; `buildConfigUI` makes a type select then conditionally shows inputs (lines ~300-360), and `apply()` builds into a new graph (~L361-545) then positions vertices (~L477-515) and unions or replaces.
Steps:

1. Add fields `int atlasIndex = 7` (a visually interesting default), `int? atlasVertices`, `int? atlasEdges`, `int? seed`.
2. In `apply()` add `case 'atlas'`: `final f = GraphFactory<String,num>(isDirected: false); final graph = f.atlas(index)` – check `lib/src/graph/factory/atlas.dart` for the vertex type: it creates vertices from `int` indices; use `GraphFactory<String,num>` with a vertex-name callback if the extension supports it, otherwise map `int→String` with `graph.map` (see `operations/map.dart`) and use vertex labels `'0','1',…` or `'A','B',…` (match `nextAvailableNodeId`). When filters are active: `final list = f.atlasMatching(vertexCount: atlasVertices, edgeCount: atlasEdges).toList(); index = index.clamp(0, list.length-1); list[index]` and handle empty list with `ModifierOutput(hasError: true, errorMessage: 'No atlas graph matches')`. Edge value `1`.
3. Directedness: build with the pipeline input's directedness (`GraphFactory<String,num>(isDirected: graph.isDirected)`); verify with a test that a directed result has both directions per atlas edge; if not, mirror each edge.
4. UI: `<input type=range min=0 max=1252>` (or `max=list.length-1` when filtered) + `<input type=number>` kept in sync (two-way listeners); label "Atlas graph #N". Two optional number inputs "Vertices" and "Edges" (empty = any). `rangeInput` and `numberInput` already exist in `dom_utils.dart` (do not delete them in T17 – they become used here). The slider must call `onModified()` on `input` (not `change`) for live preview; make sure layout positions are recomputed (the position code at ~L477 runs when `x==null` or `replace` mode).
5. Status summary `"Atlas G$index · V vertices · E edges"`; summary max constant: `1252` (library has 1253 entries; confirm `_atlas.length` via a test and use a public constant/getter if available, else add `static const atlasCount` in the library).
6. Acceptance: slider moves through graphs, preview updates live; filters narrow the range; replace and union both work; atlas #0 (empty graph) doesn't crash (layout with 0 vertices returns early).
T30 grid: implement `grid` in the library first (follow `ring.dart`/`star.dart`: extension on `GraphFactory`, `ArgumentError` validation), tests, then switch the app. T30 order: do the atlas first (self-contained), then refactor other types one at a time, comparing generated edge counts against old behavior (complete K5 → 10 undirected / 20 directed edges; cycle C5 → 5; star S5 → 4; tree arity 2, 7 vertices → 6).

## T32/T33 Registry & naming

Create `registry.dart` containing one `const`/final list of `ModifierSpec(type: 'k_core', name: 'k-Core', category: ModifierCategory.structure, factory: KCoreModifier.new)`. Then: `GraphModifier.id/name/category` getters return the spec data (or are removed in favor of `ModifierSpec` lookups). Delete `availableTypes`, `getDisplayName`, `create`'s switch. Find consumers: `grep -n "ModifierRegistry\|\.category\|\.name" web/graph/graph.dart` (the add-modifier menu and card title). `ModifierCategory` enum with `label` and a fixed order; the menu renders categories in enum order, entries alphabetically. Unknown types from persisted state must throw `ArgumentError` and be caught at the load boundary with a user message. Rename strings per T33 only after the registry is in place (one place to change). Acceptance: every modifier appears exactly once in the menu, under the T32 category; card title equals the menu entry.

## T34 OutputStyleOptions

Look at how `ShortestPathModifier` (fields `pathColor`, `pathPattern`, `_colorSelect/_patternSelect` at ~L692-710) and `SpanningTreeModifier` (`treePattern`) apply styles via `state.getEdgeStyle(u,v)`. Create `OutputStyle { String color; String pattern; RemovedMode removed; Element buildUI(onChange); void applyToEdge(GraphEdgeStyle) }`. Migrate **one** modifier per step and compare screenshots before/after. Keep each modifier's default color unchanged.

## T35 Summaries and tables

Make a checklist in a scratch file: for each `*Modifier.apply`, record whether it returns `statusSummary`, `tableData`, `overlay`. Add the missing ones. `ModifierTableData` shape: see `modifiers.dart` L11-19. The CSV export button goes next to where `activeModifierTable` is rendered (grep `activeModifierTable` in `graph.dart`); reuse `GraphIO.downloadTextFile`; escape CSV (quote fields containing `,`, `"`, newline; double the quotes) and unit test it.

## T36/T37 Exposing algorithms

Generic recipe for adding a modifier: (1) check the library signature in `lib/src/graph/algorithms.dart` (adapter extension on `Graph`) – note required directedness/weights and that `edgeWeight`/`edgeCost` closures use `(source, target)`; (2) add the class in its category file, with `id`, `name`, `category` (via registry), config fields with defaults, `buildConfigUI`, `apply` returning `ModifierOutput` – wrap library `GraphError` into `hasError: true` with `errorMessage`; (3) register in the registry; (4) add a VM test applying it to a tiny graph (use `AppState(initialGraph: …)`); (5) verify in the browser. Start with the cheapest, most visible ones: closeness/in/out-degree/core-number scores (add options to the existing Centrality select + `HeatmapOverlay`), Louvain/label propagation (extra options in Components; produce a `PartitionOverlay`; put `modularity` in `summary`), then the Graph Metrics table modifier (no overlay, only `tableData`). For library additions (T37) follow the repo's graph rules: implement as a standalone function in `lib/src/graph/algorithms/*.dart` using only closures (no `Graph`), expose via the adapter in `algorithms.dart` as **methods, not getters**, add tests in `test/graph/` and export docs with an example; then run `dart test test/graph test/deps_test.dart`.

## T38/T39

T38: For each duplicate command, replace `execute` body with: create the matching modifier via the registry, call `modifier.applyPermanent(state)` (which already does `saveSnapshot`, assign, `syncNodes`). Verify undo works as a single step. T39: add `Map<String,dynamic> toJson()` / `applyJson(Map)` to `GraphModifier` (id, enabled, config), write `modifiers` list in `exportToJson` as optional key (absent → empty stack for old files), restore through the registry; ignore unknown ids with a console warning.
