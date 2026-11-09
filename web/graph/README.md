# Graph Laboratory (`web/graph/`)

Interactive graph visualization, layout, and algorithmic analysis laboratory powered by MoreDart.

## 1. Quick Start

### Development Server

Run the development server via `build_runner`:

```bash
dart run build_runner serve web:8080
```

Open `http://localhost:8080/graph/graph.html` in your browser.

### Production Compilation

Compile Dart code to JavaScript:

```bash
dart compile js web/graph/graph.dart -o web/graph/graph.dart.js
```

### Static Analysis & Tests

```bash
dart analyze web/graph/
dart test test/web_graph/
```

---

## 2. Architecture & File Map

The application is structured into cohesive modules maintaining a strict separation between DOM-free core logic and browser view layers:

| File | Purpose | DOM-Free (VM-Testable) |
| :--- | :--- | :---: |
| `html_utils.dart` | Safe HTML/SVG text escaping for XSS prevention | Yes |
| `node.dart` | Vertex records (`GraphNode`), transient styles (`NodeStyle`, `GraphEdgeStyle`) | Yes |
| `layout_options.dart`| Layout strategy enums (`LayoutEngine`, `RankDir`) & sizing constants | Yes |
| `io_codec.dart` | Codecs for JSON, Mermaid, Graphviz DOT, and URL hash permalinks | Yes |
| `dom_utils.dart` | Lightweight DOM element creation helpers (`div`, `span`, `button`, etc.) | No |
| `icons.dart` | Shared inline SVG icon markup constants | Yes |
| `layout.dart` | Facade invoking MoreDart layout algorithms (`StressLayout`, `ForceLayout`, etc.) | No |
| `state.dart` | Application workspace state (`AppState`), undo/redo history, and overlays | No |
| `io.dart` | Browser file downloads and DOM I/O integration | No |
| `commands.dart` | Central command registry, keyboard shortcut dispatcher, and operations | No |
| `modifiers.dart` | Non-destructive algorithmic pipeline modifier stack | No |
| `inspector.dart` | Context-sensitive sidebar displaying vertex, edge, and multi-selection metrics | No |
| `renderer.dart` | Native SVG canvas rendering engine, pan/zoom viewports, and edge routing | No |
| `graph.dart` | Main application entrypoint wiring UI events, menus, and presets | No |
| `graph.html` | Application HTML skeleton, toolbar, desktop menus, and modals | - |
| `graph.css` | Dark-theme tokens, canvas styling, inspector layout, and animations | - |

---

## 3. Core Design Principles

1. **Pure Dart, Zero External JS/WASM**:
   All graph operations, layouts, and SVG rendering are executed in pure Dart via `package:more` and `package:web`. No external Graphviz WASM or third-party visualization libraries are used.

2. **Non-Destructive Modifier Pipeline**:
   Algorithms execute in sequence over the primary graph pipeline. Visual results are applied non-destructively through transient `NodeStyle`, `GraphEdgeStyle`, and `VisualOverlay` objects, leaving the editable `primaryGraph` intact until explicitly baked via "Apply".

3. **DOM-Free Testability**:
   Core codecs and data representations (`html_utils.dart`, `node.dart`, `layout_options.dart`, `io_codec.dart`) do not import `package:web` or `dart:js_interop`. They are thoroughly unit tested under `test/web_graph/` using the Dart VM and `package:checks`.

4. **Snapshot-Based History**:
   State transitions are managed through `GraphSnapshot` capturing immutable topology and persistent user styling (`fillColor`, `borderColor`, `textColor`, `borderWidth`, `opacity`) without saving transient modifier artifacts.
