# Ideation Implementation Tasks

All graph algorithms below must follow the project's decoupled architecture:
- Place standalone algorithm functions in `lib/src/graph/algorithms/<name>.dart` operating purely on closures (`vertices`, `successorsOf`, `predecessorsOf`, `neighboursOf`, `vertexStrategy`) with zero dependency on `Graph<V, E>`.
- Expose convenience forwarding methods on `AlgorithmsGraphExtension<V, E>` in `lib/src/graph/algorithms.dart`.
- Export standalone functions from `lib/graph.dart`.
- Add unit tests in `test/graph/algorithms/<name>_test.dart` using `package:checks` and verify architecture rules with `dart test test/deps_test.dart`.

---

## 1. Distance, Centrality & Graph Properties

- [x] **Degree Centrality and Eigenvector Centrality**
  - **Files**: `lib/src/graph/algorithms/eigenvector_centrality.dart`, `lib/src/graph/algorithms/structural_metrics.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/eigenvector_centrality_test.dart`, `test/graph/algorithms/structural_metrics_test.dart`
  - **Design & Instructions**:
    1. In `lib/src/graph/algorithms/structural_metrics.dart`, add `degreeCentrality<V>({required Iterable<V> vertices, required int Function(V vertex) degreeOf, StorageStrategy<V>? vertexStrategy})` returning `Map<V, double>` where each vertex has score $\frac{\deg(v)}{|V| - 1}$ (or `0.0` if $|V| \le 1$).
    2. Create `lib/src/graph/algorithms/eigenvector_centrality.dart` implementing `eigenvectorCentrality<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) successorsOf, Iterable<V> Function(V vertex)? predecessorsOf, num Function(V source, V target)? edgeWeight, int maxIterations = 100, double tolerance = 1e-6, StorageStrategy<V>? vertexStrategy})`:
       - Initialize $x_v^{(0)} = 1 / |V|$ for all $v \in V$.
       - In each iteration, compute $x_v^{(t+1)} = \sum_{u \in N_{\text{in}}(v)} w(u, v) \, x_u^{(t)}$ (excluding or including self-loops consistently with adjacency matrix convention).
       - Normalize $x^{(t+1)}$ by its Euclidean $L_2$ norm $\|x^{(t+1)}\|_2 = \sqrt{\sum_v (x_v^{(t+1)})^2}$ (if norm is `0.0`, return all zeros).
       - Stop when $\sum_v |x_v^{(t+1)} - x_v^{(t)}| < \text{tolerance}$ or after `maxIterations`.
    3. Expose `degreeCentrality`, `inDegreeCentrality`, `outDegreeCentrality`, and `eigenvectorCentrality` on `AlgorithmsGraphExtension` in `lib/src/graph/algorithms.dart` and export from `lib/graph.dart`.

- [x] **Degree Assortativity Coefficient**
  - **Files**: `lib/src/graph/algorithms/structural_metrics.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/structural_metrics_test.dart`
  - **Design & Instructions**:
    1. In `lib/src/graph/algorithms/structural_metrics.dart`, implement `degreeAssortativity<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) successorsOf, Iterable<V> Function(V vertex)? predecessorsOf, required bool isDirected, StorageStrategy<V>? vertexStrategy})`:
       - Compute Newman's Pearson correlation coefficient of vertex degrees across all directed edges $(u, v)$ (for undirected graphs, iterating over all $u \in V$ and $v \in \text{successorsOf}(u)$ with $u \ne v$ naturally counts each undirected edge in both directions):
         $$r = \frac{\frac{1}{M} \sum_{e=(u,v)} j_u k_v - \left(\frac{1}{M} \sum_{e=(u,v)} j_u\right)\left(\frac{1}{M} \sum_{e=(u,v)} k_v\right)}{\sqrt{\left(\frac{1}{M}\sum_{e} j_u^2 - \bar{j}^2\right)\left(\frac{1}{M}\sum_{e} k_v^2 - \bar{k}^2\right)}}$$
         where $j_u = \deg_{\text{out}}(u)$ and $k_v = \deg_{\text{in}}(v)$ (for undirected graphs, $j_u = \deg(u), k_v = \deg(v)$).
       - Return `double.nan` if $M == 0$ or if the denominator variance is `0.0` (e.g., regular graphs).
    2. Expose `double get degreeAssortativity` on `AlgorithmsGraphExtension` in `lib/src/graph/algorithms.dart` and export `degreeAssortativity` from `lib/graph.dart`.

---

## 2. Path and Circuit Algorithms

- [ ] **Hamiltonian Path and Circuit Detection**
  - **Files**: `lib/src/graph/algorithms/hamiltonian.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/hamiltonian_test.dart`
  - **Design & Instructions**:
    1. Create `lib/src/graph/algorithms/hamiltonian.dart` with standalone functions:
       - `bool hasHamiltonianCircuit<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) successorsOf, StorageStrategy<V>? vertexStrategy})`
       - `bool hasHamiltonianPath<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) successorsOf, StorageStrategy<V>? vertexStrategy})`
       - `List<V>? findHamiltonianPath<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) successorsOf, bool circuit = false, StorageStrategy<V>? vertexStrategy})`
    2. **Edge cases & preconditions**:
       - Empty graph ($|V| = 0$): return empty list `[]` (`true` for both path and circuit).
       - Single vertex ($|V| = 1$): return `[v]` for path; for circuit, return `[v, v]` only if `v` has a self-loop (`successorsOf(v).contains(v)`), or `[v]` if trivial circuits are defined as length 0 — match `eulerian.dart` conventions (`Path.fromVertices([v])` when $|V| == 1$, or check if $|V| == 2$ in undirected graphs requires edge). Note: in undirected graphs without parallel edges, a simple cycle requires $|V| \ge 3$ unless $|V| == 1$.
       - Quick degree rejection: if `circuit == true`, every vertex must have at least 1 outgoing and 1 incoming distinct neighbour (and for undirected graphs with $|V| \ge 3$, degree $\ge 2$). If `circuit == false`, at most one vertex can have out-degree 0 and at most one can have in-degree 0.
    3. **Algorithm**:
       - Index vertices $0 \dots n-1$ and build compact adjacency lists (and bitmasks for $n \le 30$).
       - For $n \le 20$: use Held–Karp bitmask dynamic programming (`Uint32List` / `Int32List` table of size $1 \ll n$ storing reachable endpoint bitmasks) to decide existence and reconstruct the path in $O(n^2 2^n)$ worst-case time.
       - For $n > 20$: use backtracking DFS with Warnsdorff's heuristic (order candidate next vertices by ascending number of unvisited successors) and dead-end pruning (abort immediately if any unvisited vertex loses its last unvisited predecessor/successor).
    4. Expose `hasHamiltonianCircuit`, `hasHamiltonianPath`, and `findHamiltonianPath({bool circuit = false})` (returning `Path<V, E>?`) on `AlgorithmsGraphExtension` in `lib/src/graph/algorithms.dart`.

---

## 3. Matching and Covering

- [ ] **Maximum Weight Bipartite Matching (Hungarian / Kuhn–Munkres Algorithm)**
  - **Files**: `lib/src/graph/algorithms/bipartite_matching.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/bipartite_matching_test.dart`
  - **Design & Instructions**:
    1. In `lib/src/graph/algorithms/bipartite_matching.dart`, add `weightedBipartiteMatching<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) neighboursOf, required num Function(V source, V target) edgeWeight, bool maximumWeight = true, StorageStrategy<V>? vertexStrategy})`:
       - Partition the graph into left and right sets $U, W$ via 2-coloring (throw `ArgumentError` if odd cycle exists).
       - Implement the $O(|U| \cdot |W| \cdot \min(|U|, |W|))$ Dijkstra-based primal–dual Hungarian / Jonker–Volgenant augmenting path algorithm with vertex potentials $u_i, v_j$ to find the maximum-weight (or minimum-weight maximum-cardinality) matching.
       - Return symmetric `Map<V, V>` containing matched pairs $(u \mapsto w, w \mapsto u)$, matching the return format of `bipartiteMatching`.
    2. Expose `weightedBipartiteMatching` on `AlgorithmsGraphExtension`.

- [ ] **General Graph Maximum Matching (Edmonds' Blossom Algorithm)**
  - **Files**: `lib/src/graph/algorithms/blossom_matching.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/blossom_matching_test.dart`
  - **Design & Instructions**:
    1. Create `lib/src/graph/algorithms/blossom_matching.dart` implementing `maximumMatching<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) neighboursOf, StorageStrategy<V>? vertexStrategy})`:
       - Map vertices to integer indices $0 \dots n-1$.
       - Maintain `match`, `parent`, `base` (current blossom representative), and BFS queue state.
       - From each unmatched vertex, run BFS to grow an alternating tree:
         - When an edge connects two even-level vertices in the same tree, find their lowest common ancestor `lca`, contract the odd cycle (blossom) by updating `base[v] = lca`, and push newly even vertices onto the queue.
         - When an augmenting path to another unmatched vertex is found, flip matched/unmatched edges along the path.
       - Return symmetric `Map<V, V>` mapping each matched vertex to its partner.
    2. Expose `maximumMatching` on `AlgorithmsGraphExtension` in `lib/src/graph/algorithms.dart` (which works for any undirected graph, bipartite or non-bipartite) and export from `lib/graph.dart`.

- [ ] **General Graph Minimum Vertex Cover and Maximum Independent Set (Approximation & Exact)**
  - **Files**: `lib/src/graph/algorithms/vertex_cover.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/vertex_cover_test.dart`
  - **Design & Instructions**:
    1. Create `lib/src/graph/algorithms/vertex_cover.dart` with:
       - `approximateMinimumVertexCover<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) neighboursOf, StorageStrategy<V>? vertexStrategy})`:
         - Standard 2-approximation algorithm: greedily pick an uncovered edge $(u, v)$ (ignoring self-loops, or adding $u$ immediately for a self-loop) and add both $u$ and $v$ to the cover, removing all incident edges, in $O(V + E)$ time.
       - `approximateMaximumIndependentSet<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) neighboursOf, StorageStrategy<V>? vertexStrategy})`:
         - Greedy minimum-degree algorithm: iteratively select the remaining vertex $v$ with minimum degree, add $v$ to the independent set, and remove $v$ and all its neighbours.
       - Update `minimumVertexCover` and `maximumIndependentSet` on `AlgorithmsGraphExtension` with an optional `{bool approximate = false, StorageStrategy<V>? vertexStrategy}` parameter (or fallback to exact branch-and-bound / complement clique search via `bronKerboschCliques` when non-bipartite so `minimumVertexCover()` and `maximumIndependentSet()` work on general undirected graphs as well).

---

## 4. Community Detection and Graph Partitioning

- [ ] **Community Detection (Label Propagation & Louvain Modularity)**
  - **Files**: `lib/src/graph/algorithms/community.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/community_test.dart`
  - **Design & Instructions**:
    1. Create `lib/src/graph/algorithms/community.dart` with:
       - `double modularity<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) successorsOf, required Iterable<Set<V>> communities, num Function(V source, V target)? edgeWeight, required bool isDirected, StorageStrategy<V>? vertexStrategy})`:
         - Computes Newman–Girvan modularity $Q = \frac{1}{m} \sum_{u,v} \left[ A_{uv} - \frac{k_u^{\text{out}} k_v^{\text{in}}}{m} \right] \delta(c_u, c_v)$ (where $m = \sum_{u,v} A_{uv}$ is total directed edge weight, or $2|E|$ for unweighted undirected graphs).
       - `Iterable<Set<V>> labelPropagationCommunities<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) neighboursOf, num Function(V source, V target)? edgeWeight, int maxIterations = 100, Random? random, StorageStrategy<V>? vertexStrategy})`:
         - Assign each vertex a unique initial label $0 \dots n-1$.
         - In each pass, iterate over vertices (shuffled if `random != null`, or in deterministic vertex order) and update each vertex's label to the label with the maximum total incident edge weight among its neighbours (breaking ties deterministically by smallest label ID).
         - Terminate when no vertex changes label or `maxIterations` is reached; group vertices by label into `Set<V>` communities.
       - `Iterable<Set<V>> louvainCommunities<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) neighboursOf, num Function(V source, V target)? edgeWeight, double resolution = 1.0, StorageStrategy<V>? vertexStrategy})`:
         - Phase 1 (Local moving): start with each vertex in its own community; repeatedly move each vertex $i$ to the neighbour community $C$ that maximizes positive modularity gain $\Delta Q = k_{i, C} - \gamma \frac{\Sigma_{\text{tot}, C} \cdot k_i}{2m}$ until convergence.
         - Phase 2 (Aggregation): contract communities into super-vertices with summed intra- and inter-community edge weights and repeat Phase 1 until no further modularity improvement is possible.
    2. Expose `modularity`, `labelPropagationCommunities`, and `louvainCommunities` on `AlgorithmsGraphExtension` and export from `lib/graph.dart`.

---

## 5. Structural Analysis

- [ ] **Planar Graph Testing (Left–Right Planarity Test)**
  - **Files**: `lib/src/graph/algorithms/planarity.dart`, `lib/src/graph/algorithms.dart`, `lib/graph.dart`
  - **Tests**: `test/graph/algorithms/planarity_test.dart`
  - **Design & Instructions**:
    1. **Scope Assessment**: Full Boyer–Myrvold planar embedding construction is overly complex (~1,500 lines), whereas the **de Fraysseix–Ossona de Mendez–Rosenstiehl Left–Right Planarity Test** (`isPlanar`) is linear-time $O(V + E)$, self-contained (~250 lines), and reuses biconnected thinking.
    2. Create `lib/src/graph/algorithms/planarity.dart` implementing `bool isPlanar<V>({required Iterable<V> vertices, required Iterable<V> Function(V vertex) neighboursOf, StorageStrategy<V>? vertexStrategy})`:
       - Treat graph as simple undirected (ignore self-loops and deduplicate parallel edges).
       - Trivial cases: if $|V| \le 4$, return `true`.
       - Euler's formula fast reject: count undirected edges $|E|$ in each connected component; if $|E| > 3|V_c| - 6$ for any component with $|V_c| \ge 3$, return `false`.
       - Run the Left–Right Planarity Test (or Hopcroft–Tarjan / Demoucron–Malgrange–Pertuiset):
         - Phase 1 (DFS orientation & lowpoints): orient edges into DFS tree edges and return (back) edges; compute `height`, `lowpt` (lowest return point), `lowpt2` (second lowest return point), and `nestingDepth` for each edge.
         - Phase 2 (Left–Right Embedding check): traverse the DFS tree in ordered adjacency order (`nestingDepth`), maintaining a stack of conflict pairs $(L, R)$ of return-edge intervals (`LowptInterval(low, high)`), merging constraints when embedding return edges and pruning resolved intervals when backtracking from a tree edge. Return `false` if conflicting left/right intervals cannot be merged.
    3. Verify against classic planar and non-planar graphs in `test/graph/algorithms/planarity_test.dart`:
       - Trees, cycles $C_n$, complete graphs $K_1 \dots K_4$, wheel graphs, cube graph $Q_3$, icosahedral / dodecahedral / octahedral graphs (`true`).
       - Kuratowski subgraphs $K_5$ and $K_{3,3}$, Petersen graph, subdivision of $K_5$ and $K_{3,3}$, and disjoint union of planar + $K_5$ (`false`).
    4. Expose `bool isPlanar({StorageStrategy<V>? vertexStrategy})` on `AlgorithmsGraphExtension` in `lib/src/graph/algorithms.dart` and export `isPlanar` from `lib/graph.dart`.
