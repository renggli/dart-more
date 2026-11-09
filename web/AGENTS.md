# Web Applications Guide (`web/`)

## 1. Overview & Purpose

The `web/` directory hosts client-side demonstrations and interactive visualizers for `package:more`. All web applications are implemented in pure Dart using `package:web`, `dart:js_interop`, and MoreDart core libraries, with zero external JavaScript or WebAssembly dependencies.

### Entry Points

- **Portal Landing Page**: `web/index.html` (links to all web demos with shared dark styling).
- **Graph Laboratory**: `web/graph/graph.html` (interactive graph visualization, editing, layout, and algorithmic analysis).
- **R-Tree Visualizer**: `web/rtree/rtree.html` (spatial index partitioning and point query visualization).

### Building & Running

- **Development Server**:

  ```bash
  dart run build_runner serve web
  ```

- **Production Compilation**:

  ```bash
  dart compile js web/graph/graph.dart -o web/graph/graph.dart.js
  dart compile js web/rtree/rtree.dart -o web/rtree/rtree.dart.js
  ```

- **Static Analysis**:

  ```bash
  dart analyze web/
  ```

---

## 2. Summary of Web Application Demos

### 2.1 Graph Laboratory (`web/graph/`)

The Graph Laboratory is a full-featured browser-based workspace for creating, editing, laying out, and analyzing graphs using MoreDart algorithms:

- **Interactive Canvas (`renderer.dart`)**:
  - High-performance native SVG rendering with infinite pan and zoom (`scale`, `panX`, `panY`).
  - Smooth node dragging with multi-node group grab (Blender-style `G` key or click-and-drag).
  - Marquee selection for mass selecting vertices and edges.
  - Interactive edge creation by dragging between vertices with visual gesture arrow.
  - Inline vertex label and edge weight editing.
  - Canvas statistics HUD (vertex count, edge count, density, zoom level).
  - Classic presets (Königsberg Bridges, Swiss Railway Network with geographic coordinates, Petersen Graph, Florentine Families, ARPANET 1970, Dodecahedron, Course Prerequisites DAG, Network Flow, Web Hyperlinks).

- **Modifier Stack (`modifiers.dart`)**:
  - Non-destructive modifier pipeline where algorithms execute sequentially over the primary graph.
  - 25+ integrated modifiers covering:
    - *Generators & Layout*: Graph Generator (Atlas, Random, Path, Ring, Star, Complete, Complete Tree, Perfect Tree, Partite), Layout Algorithm.
    - *Paths*: Shortest Path (Dijkstra), All-Pairs Paths (Floyd-Warshall).
    - *Centrality*: Degree, Closeness, Betweenness, PageRank, Eigenvector, Local Clustering Coefficient, Eccentricity heatmaps.
    - *Connectivity & Clusters*: Connected / Strongly Connected Components, Louvain & Label Propagation Communities, Biconnected Components & Bridges.
    - *Trees & Cycles*: Minimum Spanning Tree (Prim / Kruskal), Cycle Detection.
    - *Cuts & Flows*: Max Flow & Min Cut (Dinic), Global Min Cut (Stoer-Wagner).
    - *Matching & Cliques*: Maximum Matching (Blossom), Maximal Cliques (Bron-Kerbosch), Maximum Independent Set, Minimum Vertex Cover.
    - *Graph Theory*: Planarity (Boyer-Myrvold & Kuratowski subgraphs), Eulerian Circuit/Trail, Hamiltonian Cycle/Path, Vertex Coloring (Welsh-Powell), k-Core subgraphs.
    - *Transformations*: Transitive Closure, Transitive Reduction, Graph Complement.
  - Live reactive updates: cards update their status summaries, error states, and result tables dynamically without dropping input focus.

- **Desktop Menus & Commands (`commands.dart`)**:
  - Central `CommandRegistry` managing actions across File, Edit, Select, Vertex, Edge, and Graph categories.
  - Standard keybindings (`Ctrl+Z`, `Ctrl+Y`, `Ctrl+C`, `Ctrl+V`, `Ctrl+X`, `Delete`, `A`, `1`, `2`, `L`, `F`, etc.).
  - Deep undo/redo stack based on immutable snapshots (`GraphSnapshot`).

- **Inspector (`inspector.dart`)**:
  - Context-sensitive sidebar panel showing live metrics for single vertices, single edges, or multi-selections.
  - Displays degrees, in/out degrees, clustering coefficients, incident edges, endpoints, and weight editors.

- **Import / Export (`io.dart`)**:
  - JSON serialization with node canvas coordinates and display labels.
  - Mermaid flowchart export and import.
  - Graphviz DOT export.
  - Base64 URL permalink hash sharing (`#g=...`).
  - Text and file downloads.

### 2.2 R-Tree Visualizer (`web/rtree/`)

- Interactive HTML5 2D Canvas visualizer for spatial indexing via `RTree<int>.guttmann()`.
- Interactive point insertion on click or batch addition (+100 random points).
- Visualizes hierarchical tree bounds, child node capacities, and bounding box nesting.

---

## 3. Important Design Decisions Taken

### 3.1 Native SVG & Native Layouts (No External WASM / Graphviz)

- **Decision**: Avoid external WebAssembly binaries (such as `@viz-js/viz`) or CDN-loaded Graphviz engines.
- **Rationale**:
  - Zero external JavaScript/WASM dependencies; pure Dart compilation.
  - Seamless pan/zoom and direct element manipulation (dragging, lassoing, inline editing) without rebuilding the SVG DOM on every frame.
  - Directly exercises and validates MoreDart's own layout package (`lib/src/graph/layout/`).

### 3.2 Non-Destructive Modifier Pipeline

- **Decision**: Algorithmic transformations and analyses do not destructively mutate `primaryGraph`.
- **Rationale**:
  - Users can compose multiple analysis modifiers (e.g. Layout $\rightarrow$ Components $\rightarrow$ Shortest Path) while retaining the original editable base graph.
  - Any modifier can be reordered, enabled/disabled, or configured in real-time.
  - Modifiers only write permanently to `primaryGraph` if the user clicks "Apply".

### 3.3 Separation of Graph Structure from Visual State

- **Decision**: `primaryGraph` is typed strictly as `Graph<String, num>`, while spatial positions, user display labels, and modifier colors reside in `AppState.nodes` (`GraphNode`) and `AppState.edgeStyles` (`GraphEdgeStyle`).
- **Rationale**:
  - Decouples core graph theoretical operations from visual rendering concerns.
  - Facilitates serialization: core topology exports cleanly to DOT or Mermaid, while layout coordinates are preserved in JSON and URL hash states.

### 3.4 Command Pattern with Snapshot-Based Undo/Redo

- **Decision**: All state mutations route through `GraphCommand` with a simple signature `void execute(AppState state)` and `AppState.saveSnapshot()`.
- **Rationale**:
  - Consistent keyboard shortcut handling and validation (`canExecute`).
  - Zero context overhead: UI actions, modal triggers, and coordinates live in `AppState`.
  - Reliable history management without complex inverse delta tracking.

### 3.5 Consistent Dark Theme Tokens

- **Decision**: Unified CSS variables in `web/style.css` shared by all demos.
- **Rationale**:
  - Visual consistency across `index.html`, `graph.html`, and `rtree.html`.
  - Accessible contrast ratios and clean hierarchy without heavy CSS framework dependencies.

---

## 4. Guidelines for Future Evolution

When adding new features or maintaining `web/`:

1. **Adding New Modifiers**:
   - Create a class extending `GraphModifier` in `web/graph/modifiers.dart`.
   - Implement `id`, `name`, `compute(Graph<String, num> graph, AppState state)`, and `buildConfigUI(AppState state, void Function() onConfigChanged)`.
   - Register the modifier in `select-add-modifier` in `web/graph/graph.html` and `ModifierRegistry.create(id)`.
   - Modifiers should style nodes/edges via `state.nodes` or `state.getEdgeStyle(...)`, or produce a `VisualOverlay` (`PathOverlay`, `HeatmapOverlay`, `PartitionOverlay`).
   - If modifier inputs depend on the current graph (e.g. source/target vertex selectors), implement `updateConfig(AppState state)` to refresh dropdown options dynamically.

2. **Adding New Layout Engines**:
   - Implement the core algorithm under `lib/src/graph/layout/`.
   - Expose the method on `GraphLayoutExtension` in `lib/src/graph/layout.dart`.
   - Add the engine key to `GraphLayout.applyLayout` in `web/graph/layout.dart` and the Layout modifier options.

3. **Adding New Commands**:
   - Subclass `GraphCommand` in `web/graph/commands.dart`.
   - Register the command in `CommandRegistry.all`.
   - Wire any UI triggers (menu items, buttons) in `web/graph/graph.html` or `graph.dart`.

4. **Code Quality & Maintenance**:
   - Adhere strictly to [Effective Dart](https://dart.dev/effective-dart) and 2-space indentation.
   - Run `dart analyze web/` to verify zero linter warnings.
   - Run `dart format .` on all changed files.
   - Verify production compilation with `dart compile js web/graph/graph.dart -o web/graph/graph.dart.js`.
