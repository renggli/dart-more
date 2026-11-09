---
name: more-dart-use-graph-library
description: "Patterns and API reference for MoreDart's graph library (package:more/graph.dart): graph data structures, standalone closure-based algorithms, factories, operations, traversals, and 2D layout strategies."
---

# MoreDart Graph Library (`package:more/graph.dart`)

The library is designed around a key architectural principle: **algorithms and 2D layouts do not depend on the `Graph` class**. They operate on arbitrary objects using functional closures (`successorsOf`, `predecessorsOf`, `edgeCost`). The `Graph<V, E>` class serves as a convenience data structure and adapter facade.

---

## Operating on Arbitrary Objects (Closure-Based API)

You can run traversals, search, algorithms, and layouts directly over domain models, file systems, ASTs, or tree nodes without wrapping them in a `Graph`:

```dart
import 'package:more/graph.dart';

class Node {
  Node(this.id, this.children);
  final String id;
  final List<Node> children;
}

final root = Node('1', [Node('2', []), Node('3', [Node('4', [])])]);

// 1. Traversals on arbitrary objects
final bfs = BreadthFirstIterable<Node>([root], successorsOf: (n) => n.children);
final topological = TopologicalIterable<Node>([root], successorsOf: (n) => n.children);

// 2. Standalone algorithms (no Graph instance required)
final path = dijkstraSearch<Node>(
  startVertices: [root],
  targetPredicate: (n) => n.id == '4',
  successorsOf: (n) => n.children,
).firstOrNull;

final cyclic = hasCycle<Node>(
  vertices: [root],
  successorsOf: (n) => n.children,
);

// 3. 2D Layouts on arbitrary objects
final layoutResult = const TreeLayout<Node>().layout(
  LayoutInput<Node>(
    vertices: bfs.toList(),
    successorsOf: (n) => n.children,
    vertexSize: (n) => (width: 40.0, height: 40.0),
  ),
);
print(layoutResult.positions[root]);
```

---

## `Graph<V, E>` Data Structure

When an explicit, mutable graph representation is needed:

```dart
final directed = Graph<String, void>.directed();
final undirected = Graph<String, void>.undirected();
final weighted = Graph<String, num>(isDirected: true);

// Fast integer vertex storage strategy
final intGraph = Graph<int, void>(
  isDirected: false,
  vertexStrategy: StorageStrategy.integer(min: 0, max: 1000),
);

// Topology mutation
graph.addVertex('A');
graph.addEdge('A', 'B', value: 3.5);
graph.removeEdge('A', 'B');

// Topology inspection
graph.successorsOf('A');
graph.predecessorsOf('B'); // Incoming for directed; equal to successorsOf for undirected
graph.degreeOf('A');
```

---

## Graph Factories

`GraphFactory<V, E>` builds standard topologies and parses Mermaid syntax:

```dart
final factory = GraphFactory<String, void>.directed();

final kn = factory.complete(vertexCount: 5);
final ring = factory.ring(vertexCount: 6);
final star = factory.star(vertexCount: 7);
final tree = factory.tree(vertexCount: 15, arity: 2);
final random = factory.random(vertexCount: 10, probability: 0.35, seed: 42);
final atlasGraph = factory.atlas(7); // 1,253 graphs up to 7 vertices

final fromMermaid = factory.fromMermaid('''
graph TD
  A --> B
  A --> C
''');
```

---

## Graph Operations

- **Filtering / Mapping**: `graph.where(...)`, `graph.map(...)`, `graph.copy()`, `graph.reversed`
- **Set Operations**: `graph.union(other)`, `graph.intersection(other)`, `graph.complement()`
- **Transitive**: `graph.transitiveClosure()`, `graph.transitiveReduction()` (requires DAG)
- **Components**: `graph.connected()` (iterable of subgraphs)
- **Serialization**: `graph.toDot()`, `graph.toMermaid()`

---

## Traversals

Lazy iterables exposed on both `Graph` and standalone classes:

| Traversal | `Graph` Method | Standalone Class |
| :--- | :--- | :--- |
| Breadth-First | `graph.breadthFirst(root)` | `BreadthFirstIterable<V>(roots, successorsOf: ...)` |
| Depth-First Pre-Order | `graph.depthFirst(root)` | `DepthFirstIterable<V>(roots, successorsOf: ...)` |
| Depth-First Post-Order | `graph.depthFirstPostOrder(root)` | `DepthFirstPostOrderIterable<V>(roots, successorsOf: ...)` |
| Topological Sort | `graph.topological(root)` | `TopologicalIterable<V>(roots, successorsOf: ...)` |
| Random Walk | `graph.randomWalk(root, maxLength: ...)` | `RandomWalkIterable<V>(root, successorsOf: ...)` |

---

## Algorithms

Most algorithms exist both as standalone functions taking closures, and as extension methods on `Graph`:

- **Shortest Paths**: `shortestPath()` (Dijkstra / A*), `shortestPathAll()`, `floydWarshall()`, `bellmanFord()`
- **Connectivity & Cycles**: `hasCycle()`, `stronglyConnected()` (Tarjan), `biconnectedComponents()`, `articulationPoints()`, `bridges()`, `isBipartite()`, `isPlanar()`, `edgeConnectivity()`, `vertexConnectivity()`
- **Spanning Trees**: `kruskalSpanningTree()`, `primSpanningTree()`
- **Flows & Cuts**: `maxFlow(source, target)` (Dinic), `minCut()` (Stoer-Wagner global min-cut)
- **Matching & Cliques**: `bipartiteMatching()`, `weightedBipartiteMatching()`, `maximumMatching()` (Blossom), `findCliques()` (Bron-Kerbosch), `maximumIndependentSet()`, `minimumVertexCover()`
- **Metrics & Centrality**: `degreeCentrality()`, `betweennessCentrality()`, `pageRank()`, `eigenvectorCentrality()`, `density()`, `averageClusteringCoefficient()`, `transitivity()`, `degreeAssortativity()`
- **Communities**: `louvainCommunities()`, `labelPropagationCommunities()`, `modularity(partition)`
- **Tours**: `hasEulerianCircuit()`, `findEulerianPath()`, `hasHamiltonianCircuit()`, `findHamiltonianPath()`

---

## 2D Graph Layouts

Layouts produce 2D vertex coordinates (`positions`), bounds (`bounds`), and polyline paths (`edgeRoutes`).

### Strategy Classes

| Strategy | Complexity | Directed / Undirected | Disconnected Components | Description |
| :--- | :--- | :--- | :--- | :--- |
| `StressLayout` | $O(V^2 + V E \log V)$ | Both | Packed | Stress Majorization (SMACOF) on shortest path distances (default). |
| `ForceLayout` | $O(V \log V)$ or $O(V^2)$ | Both | Packed | Force-directed simulation with Barnes-Hut or exact repulsion. |
| `LayeredLayout` | $O(V + E)$ | Directed (DAG) | Packed | Sugiyama hierarchical layout with crossing reduction & edge routes. |
| `TreeLayout` | $O(V)$ | Directed / Tree | Forest | Buchheim-Walker aesthetic tidy tree layout (4 orientations). |
| `RadialLayout` | $O(V + E)$ | Both | Packed | Concentric BFS topological levels expanding outwards from a root. |
| `ShellLayout` | $O(V)$ | Both | Packed | Concentric rings assigned by explicit shell lists or mapping function. |
| `CircularLayout` | $O(V)$ | Both | Single ring | Vertices placed uniformly along a circular circumference. |
| `SpectralLayout` | $O(k \cdot (V + E))$ | Both | Packed | Laplacian eigenvectors (Fiedler vectors) via power iteration. |
| `PartiteLayout` | $O(V + E)$ | Both | Columns | Parallel columns for bipartite/multipartite layouts with crossing sweeps. |
| `GridLayout` | $O(V)$ | Both | Grid | Row and column grid alignment. |
| `RandomLayout` | $O(V)$ | Both | Bounds | Uniform random coordinates within a bounding rectangle. |

### Running on a `Graph`

```dart
final result = graph.layout(
  const StressLayout(),
  vertexSize: (v) => (width: 40.0, height: 40.0),
  normalize: true,       // Translates min bounds to (0, 0)
  removeOverlaps: true,  // Resolves vertex overlaps
);

for (final MapEntry(key: v, value: pt) in result.positions.entries) {
  print('$v: (${pt.x}, ${pt.y})');
}
```

### Running Standalone on `LayoutInput<V>`

```dart
final input = LayoutInput<String>(
  vertices: ['A', 'B', 'C'],
  successorsOf: (v) => v == 'A' ? ['B', 'C'] : const [],
  vertexSize: (v) => const (width: 40.0, height: 40.0),
);

final result = const TreeLayout<String>().layout(input);
print(result.positions);
print(result.bounds);
```

### Geometry Types

- `LayoutPoint`: `math.Point<double>` with `.translate(dx, dy)` and `.scale(sx, [sy])`.
- `LayoutRectangle`: `math.Rectangle<double>` with `.center`, `.minX`, `.maxX`, `.expandToInclude()`.
- `LayoutSize`: `({double width, double height})`.
- `boundingBox(points)`: Smallest enclosing `LayoutRectangle`.
