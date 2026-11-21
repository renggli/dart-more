---
name: more-use-graph-library
description: "Graph data structures, standalone closure-based algorithms, factories, operations, traversals, Mermaid/DOT export, and 2D layout strategies in package:more/graph.dart. Use when modeling directed/undirected graphs, running traversals, shortest paths, centrality, flows, matching, community detection, isomorphism, or computing 2D graph layouts (including directly on arbitrary domain objects without wrapping in a Graph). Don't use for spatial 2D bounding-box indexing (use RTree in more-use-collection-library)."
---

# MoreDart Graph Library (`package:more/graph.dart`)

The library is designed around a key architectural principle: **algorithms and 2D layouts do not depend on the `Graph` class**. They operate on arbitrary objects using functional closures (`successorsOf`, `predecessorsOf`, `edgeCost`). The `Graph<V, E>` class serves as a convenience data structure and adapter facade.

---

## Operating on Arbitrary Objects (Closure-Based API)

Run traversals, search, algorithms, and layouts directly over domain models, file systems, ASTs, or tree nodes without wrapping them in a `Graph`:

```dart
import 'package:more/graph.dart';

class Node {
  new(this.id, [this.children = const []]);
  final String id;
  final List<Node> children;
}

final root = Node('1', [Node('2'), Node('3', [Node('4')])]);

// 1. Traversals on arbitrary objects
final bfs = BreadthFirstIterable<Node>([root], successorsOf: (n) => n.children);
final dfs = DepthFirstIterable<Node>([root], successorsOf: (n) => n.children);

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
    vertexSize: (n) => const (width: 40.0, height: 40.0),
  ),
);
final rootPosition = layoutResult.positions[root];
```

---

## `Graph<V, E>` Data Structure

When an explicit, mutable graph representation is needed:

```dart
final directed = Graph<String, void>(isDirected: true);
final undirected = Graph<String, void>(isDirected: false);
final graph = Graph<String, num>(isDirected: true);

// Fast integer vertex storage strategy (also .defaultObject(), .identity(), .custom(...))
final intGraph = Graph<int, void>(
  isDirected: false,
  vertexStrategy: StorageStrategy.positiveInteger(),
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
import 'dart:math';
import 'package:more/graph.dart';

final factory = GraphFactory<int, void>(isDirected: true, random: Random(42));

final kn = factory.complete(vertexCount: 5);
final ring = factory.ring(vertexCount: 6);
final star = factory.star(vertexCount: 7);
final grid = factory.grid(rows: 3, columns: 4);
final tree = factory.completeTree(vertexCount: 15, arity: 2);
final random = factory.randomErdosRenyi(vertexCount: 10, probability: 0.35);
final atlasGraph = GraphFactory<int, void>(isDirected: false).atlas(7);

final fromMermaid = GraphFactory<String, String?>().fromMermaid('''
graph TD
  A --> B
  A --> C
''');
```

---

## Graph Operations

- **Filtering / Mapping**: `graph.where(...)`, `graph.map(...)`, `graph.copy()`, `graph.reversed`, `graph.unmodifiable`
- **Set Operations**: `graph.union(other)`, `graph.intersection(other)`, `graph.complement()`
- **Transitive**: `graph.transitiveClosure()`, `graph.transitiveReduction()` (requires DAG)
- **Components**: `graph.connected()` (iterable of connected subgraphs)
- **Serialization**: `graph.toDot()`, `graph.toMermaid()`

---

## Traversals

Lazy iterables exposed on both `Graph` and standalone classes:

| Traversal | `Graph` Method | Standalone Class |
| :--- | :--- | :--- |
| Breadth-First | `graph.breadthFirst(root)` / `breadthFirstAll(roots)` | `BreadthFirstIterable<V>(roots, successorsOf: ...)` |
| Depth-First Pre-Order | `graph.depthFirst(root)` / `depthFirstAll(roots)` | `DepthFirstIterable<V>(roots, successorsOf: ...)` |
| Depth-First Post-Order | `graph.depthFirstPostOrder(root)` / `depthFirstPostOrderAll(roots)` | `DepthFirstPostOrderIterable<V>(roots, successorsOf: ...)` |
| Topological Sort | `graph.topological(root)` / `topologicalAll(roots)` | `TopologicalIterable<V>(roots, predecessorsOf: ..., successorsOf: ...)` |
| Random Walk | `graph.randomWalk(root, selfAvoiding: ...)` | `RandomWalkIterable<V>(root, successorsOf: ...)` |

---

## Algorithms

Algorithms are available as extension methods on `Graph` (and most also as standalone closure-based functions):

- **Shortest Paths**: `shortestPath(source, target)` (Dijkstra / A* with `costEstimate` / Bellman-Ford with `hasNegativeEdges: true`), `shortestPathAll(source)`, `allShortestPaths()` (`floydWarshallSearch`)
- **Distance Metrics**: `eccentricity(v)`, `diameter()`, `radius()`, `center()`, `periphery()`
- **Connectivity & Cycles**: `hasCycle()`, `stronglyConnected()` (`tarjanStronglyConnected`), `biconnectedComponents()`, `articulationPoints()`, `bridges()`, `isBipartite()`, `bipartiteColoring()`, `isPlanar()`, `edgeConnectivity()`, `vertexConnectivity()`, `coreNumbers()`, `kCore(k)`
- **Spanning Trees**: `spanningTree()` (`kruskalSpanningTree`, or `primSpanningTree` when `startVertex` is given)
- **Flows & Cuts**: `maxFlow().flow(source, target)` (`DinicMaxFlow`), `minCut()` (`StoerWagnerMinCut`)
- **Matching, Coloring, Covers & Cliques**: `bipartiteMatching()`, `weightedBipartiteMatching()`, `maximumMatching()` (Blossom), `vertexColoring()`, `findCliques()` (`bronKerboschCliques`), `maximumIndependentSet()`, `minimumVertexCover()`, `dominatingSet()`
- **Isomorphism**: `isIsomorphicTo(other)`, `containsSubgraph(pattern)` (`findIsomorphisms`)
- **Metrics & Centrality**: `degreeCentrality()`, `inDegreeCentrality()`, `outDegreeCentrality()`, `betweennessCentrality()`, `closenessCentrality()`, `pageRank()`, `eigenvectorCentrality()`, `katzCentrality()`, `hits()`, `density()`, `localClusteringCoefficient(v)`, `averageClusteringCoefficient()`, `transitivity()`, `degreeAssortativity()`
- **Communities**: `louvainCommunities()`, `labelPropagationCommunities()`, `modularity(communities)`
- **Tours**: `hasEulerianCircuit()`, `hasEulerianPath()`, `findEulerianPath()`, `hasHamiltonianCircuit()`, `hasHamiltonianPath()`, `findHamiltonianPath()`, `tspHeuristic()`

Weighted `Graph` methods automatically fall back to the graph's edge values (or `1` if non-numeric) when no explicit `edgeCost`/`edgeWeight`/`edgeCapacity` callback is provided.

---

## 2D Graph Layouts

Layouts produce 2D vertex coordinates (`positions`), bounds (`bounds`), and polyline paths (`edgeRoutes`).

### Strategy Classes

| Strategy | Complexity | Directed / Undirected | Disconnected Components | Description |
| :--- | :--- | :--- | :--- | :--- |
| `StressLayout` | `O(V^2 + V E log V)` | Both | Packed | Stress Majorization (SMACOF) on shortest path distances (default). |
| `ForceLayout` | `O(V log V)` or `O(V^2)` | Both | Packed | Force-directed simulation with Barnes-Hut or exact repulsion. |
| `LayeredLayout` | `O(V + E)` | Directed (DAG) | Packed | Sugiyama hierarchical layout with crossing reduction & edge routes. |
| `TreeLayout` | `O(V)` | Directed / Tree | Forest | Buchheim-Walker aesthetic tidy tree layout (4 orientations). |
| `RadialLayout` | `O(V + E)` | Both | Packed | Concentric BFS topological levels expanding outwards from a root. |
| `ShellLayout` | `O(V)` | Both | Packed | Concentric rings assigned by explicit shell lists or mapping function. |
| `CircularLayout` | `O(V)` | Both | Single ring | Vertices placed uniformly along a circular circumference. |
| `SpectralLayout` | `O(k * (V + E))` | Both | Packed | Laplacian eigenvectors (Fiedler vectors) via power iteration. |
| `GridLayout` | `O(V)` | Both | Grid | Row and column grid alignment. |
| `RandomLayout` | `O(V)` | Both | Bounds | Uniform random coordinates within a bounding rectangle. |

### Running on a `Graph` or `LayoutInput<V>`

```dart
// On a Graph instance:
final result = graph.layout(
  const StressLayout(),
  vertexSize: (v) => const (width: 40.0, height: 40.0),
  normalize: true,       // Translates min bounds to (0, 0)
  removeOverlaps: true,  // Resolves vertex overlaps
);

// Standalone on LayoutInput<V>:
final input = LayoutInput<String>(
  vertices: ['A', 'B', 'C'],
  successorsOf: (v) => v == 'A' ? ['B', 'C'] : const [],
  vertexSize: (v) => const (width: 40.0, height: 40.0),
);
final treeResult = const TreeLayout<String>().layout(input);
```

### Geometry Types

- `LayoutPoint`: `Point<double>` with `.translate(dx, dy)` and `.scale(sx, [sy])`.
- `LayoutRectangle`: `Rectangle<double>` with `.center`, `.minX`, `.maxX`, `.expandToInclude()`.
- `LayoutSize`: `({double width, double height})`.
- `boundingBox(points)`: Smallest enclosing `LayoutRectangle`.

---

## Common Pitfalls

- **Avoid unnecessary `Graph` wrapping**: If data already lives in domain objects, call `BreadthFirstIterable`, `dijkstraSearch`, `TreeLayout`, etc. directly with `successorsOf`.
- **Mutable or custom-equality vertices**: Pass `vertexStrategy: StorageStrategy.identity()` or `StorageStrategy.custom(...)` instead of relying on default `==`/`hashCode`.
- **Negative edge weights**: Set `hasNegativeEdges: true` in `shortestPath` (or call `bellmanFordSearch` directly); Dijkstra assumes non-negative weights.
- **No-argument metrics are methods**: Call `graph.density()`, `graph.diameter()`, `graph.degreeAssortativity()`, not getters.
