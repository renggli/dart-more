# 4.8.0 Pre-Release Tasks

## Obvious Bugs

### Number & Math

- [x] **`Quaternion.operator /` divides by dividend norm instead of divisor norm** ([`lib/src/number/quaternion.dart`](lib/src/number/quaternion.dart#L204-L209)):
  - Line 205 computes `final f = 1 / norm();` (`this.norm()`) instead of `final f = 1 / other.norm();`, so `(a / b) * b != a` whenever `a.norm() != b.norm()`.
  - Update existing division assertions in [`test/number/quaternion_test.dart`](test/number/quaternion_test.dart) accordingly.
- [x] **`Quaternion.exp()` and `Quaternion.log()` return `NaN` for real/scalar quaternions** ([`lib/src/number/quaternion.dart`](lib/src/number/quaternion.dart#L221-L232)):
  - In `exp()`, when `x == 0 && y == 0 && z == 0`, `norm` is `0.0` and `exp / norm * norm.sin()` evaluates `Infinity * 0.0 == NaN`.
  - In `log()`, when `vectorNorm == 0`, `vectorNorm.atan2(w) / vectorNorm` evaluates `0.0 / 0.0 == NaN` (for `w >= 0`) or `pi / 0.0 == Infinity` (for `w < 0`), breaking `Quaternion.pow` on real quaternions as well.
- [x] **`Fraction.pow` and `Fraction.compareTo` edge cases** ([`lib/src/number/fraction.dart`](lib/src/number/fraction.dart#L199-L209), [`lib/src/number/fraction.dart`](lib/src/number/fraction.dart#L268-L269)):
  - `pow(int n)` checks `if (a == 0) return this;` before `n == 0` or `n < 0`, so `Fraction.zero.pow(0)` returns `Fraction.zero` instead of `Fraction.one`, and `Fraction.zero.pow(-1)` returns `Fraction.zero` instead of `Fraction.infinity`.
  - `compareTo(Fraction other)` computes `(a * other.b).compareTo(other.a * b)`, which evaluates `(1 * 0).compareTo(-1 * 0) == 0` when comparing `Fraction.infinity` and `Fraction.negativeInfinity` (or `Fraction.nan`).
  - `round()`, `floor()`, `ceil()`, and `truncate()` ([`lib/src/number/fraction.dart`](lib/src/number/fraction.dart#L231-L240)) delegate to `toDouble()`, losing precision for large 64-bit integer components (`> 2^53`).
- [x] **`parseWithUnits` silently ignores invalid characters and parses lone signs as `±1`** ([`lib/src/number/utils.dart`](lib/src/number/utils.dart#L11-L41)):
  - `numberAndUnitExtractor.allMatches(source.replaceAll(' ', ''))` skips unmatched characters (e.g. `Complex.tryParse('10#')` succeeds) and merges whitespace-separated digits (`'1 2'` parses as `12`).
  - A bare `'+'` or `'-'` with no digits or unit parses as `1` or `-1` because `numberString` is `'+'`/`'-'` and `unit` is `''` (lines 27–30).
  - The doc comment on `parseWithUnits` (lines 9–10) states it throws `FormatException`, whereas it returns `null`.

### Graph

- [x] **`UndirectedGraph.removeVertex` throws `ConcurrentModificationError` on self-loops** ([`lib/src/graph/model/undirected.dart`](lib/src/graph/model/undirected.dart#L76-L83)):
  - Iterating `for (final target in vertexAdjacency.keys)` while calling `adjacency[target]?.remove(vertex)` mutates `vertexAdjacency` when `target == vertex`.
- [x] **`DirectedGraph.getEdge` and `UndirectedGraph.getEdge` return phantom edges when `E` is nullable** ([`lib/src/graph/model/directed.dart`](lib/src/graph/model/directed.dart#L50-L55), [`lib/src/graph/model/undirected.dart`](lib/src/graph/model/undirected.dart#L49-L54)):
  - `if (targetAdjacency[target] case final E value)` matches `null` whenever `E` is nullable (e.g. `Graph<int, int?>` or `Graph<int, void>`), returning an `Edge` even when `target` is not in `targetAdjacency`. Guard with `targetAdjacency.containsKey(target)`.
- [x] **`Graph.isBipartite` fails on directed graphs and self-loops** ([`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart#L235-L240), [`lib/src/graph/algorithms/bipartite_check.dart`](lib/src/graph/algorithms/bipartite_check.dart#L14-L42)):
  - `isBipartite` passes `successorsOf: successorsOf` instead of `neighboursOf`. For a directed graph such as `c -> a -> b`, if `a` and `b` are colored in the first BFS pass (`a: true, b: false`), the subsequent pass starting at `c` colors `c: true` and fails on edge `c -> a`. Using `neighboursOf` fixes both directed graphs and self-loop detection.
- [x] **`bronKerboschCliques` drops cliques for vertices with self-loops** ([`lib/src/graph/algorithms/bron_kerbosch_cliques.dart`](lib/src/graph/algorithms/bron_kerbosch_cliques.dart#L32-L46)):
  - When `pivot` has a self-loop, `neighboursOf(pivot)` includes `pivot`, so `some..removeAll(neighboursOf(pivot))` removes `pivot` from candidate exploration. Filter `v != u` from neighbor sets.
- [ ] **`StoerWagnerMinCut` includes self-loop weights in cut values** ([`lib/src/graph/algorithms/stoer_wagner_min_cut.dart`](lib/src/graph/algorithms/stoer_wagner_min_cut.dart#L36-L44), [`lib/src/graph/algorithms/stoer_wagner_min_cut.dart`](lib/src/graph/algorithms/stoer_wagner_min_cut.dart#L130-L133)):
  - Self-loops copied into `_workingGraph` are included in `_workingGraph.incomingEdgesOf(current)`, inflating the cut weight. Skip edges where `edge.source == edge.target`.
- [ ] **`DinicMaxFlow` infinite loop when `source == target`** ([`lib/src/graph/algorithms/dinic_max_flow.dart`](lib/src/graph/algorithms/dinic_max_flow.dart#L75-L92), [`lib/src/graph/algorithms/dinic_max_flow.dart`](lib/src/graph/algorithms/dinic_max_flow.dart#L112-L114)):
  - When `source == target`, `_bfs` returns `true` (`target.level == 0`) and `_dfs(source, target, double.infinity)` repeatedly returns `double.infinity` without saturating any edge, hanging the `while (true)` loop at line 85.
- [ ] **`dijkstraSearch` and `aStarSearch` zero-weight cycle handling & alternative path edge values** ([`lib/src/graph/algorithms/search/dijkstra.dart`](lib/src/graph/algorithms/search/dijkstra.dart#L49-L59), [`lib/src/graph/algorithms/search/a_star.dart`](lib/src/graph/algorithms/search/a_star.dart#L52-L62), [`lib/src/graph/algorithms/search/utils.dart`](lib/src/graph/algorithms/search/utils.dart#L14-L71)):
  - Pass `startVertices: startVertices` to `createShortestPath` / `createAllShortestPaths` (matching `bellmanFordSearch`) so zero-weight cycles reaching a start vertex do not cause infinite predecessor traversal.
  - `SearchState` stores only a single edge `value` per vertex (line 14), so when `includeAlternativePaths: true`, alternative predecessors with different edge weights reuse the first predecessor's edge value.
- [ ] **`Graph.randomWalk` ignores `random` parameter and default `vertexStrategy`** ([`lib/src/graph/traverse/random.dart`](lib/src/graph/traverse/random.dart#L11-L23)):
  - `randomWalk` accepts `Random? random` (line 15) but does not forward `random: random` to `RandomWalkIterable`, and passes `vertexStrategy: vertexStrategy` instead of `vertexStrategy: vertexStrategy ?? this.vertexStrategy`.

### Collection & CharMatcher

- [ ] **`CharMatcher` optimizer corrupts nested ranges and misidentifies `AnyCharMatcher`** ([`lib/src/char_matcher/custom/optimize.dart`](lib/src/char_matcher/custom/optimize.dart#L25-L27), [`lib/src/char_matcher/custom/optimize.dart`](lib/src/char_matcher/custom/optimize.dart#L41-L42)):
  - Line 26 merges overlapping/adjacent ranges with `RangeCharMatcher(lastRange.start, thisRange.stop)` instead of `math.max(lastRange.stop, thisRange.stop)`, shrinking enclosing ranges (e.g. `a-z` merged with `c-d` becomes `a-d`).
  - Line 41 checks `else if (matchingCount - 1 == 0xffff)` (`65536`), returning `AnyCharMatcher()` for any range of length `0x10000` regardless of start/stop.
- [ ] **`BitList` dirty tail bits corrupt `operator >>`, `operator +`, and `BitList.of`** ([`lib/src/collection/bitlist.dart`](lib/src/collection/bitlist.dart#L23), [`lib/src/collection/bitlist.dart`](lib/src/collection/bitlist.dart#L45-L46), [`lib/src/collection/bitlist.dart`](lib/src/collection/bitlist.dart#L156-L160), [`lib/src/collection/bitlist.dart`](lib/src/collection/bitlist.dart#L266-L294)):
  - `BitList.filled(length, true)`, `not()`, and `operator <<` leave unmasked `1` bits above `length` in the final `Uint32List` word.
  - `operator >>` shifts those high bits from `buffer.last` into `[length - amount, length)`, and `BitList.of(..., growable: true)` exposes them when grown.
- [ ] **`SortedList.removeWhere` and `retainWhere` throw `UnsupportedError`** ([`lib/src/collection/sorted_list.dart`](lib/src/collection/sorted_list.dart#L29-L34)):
  - `ListBase.removeWhere` / `retainWhere` mutate elements via `this[i] = ...` and `this.length = ...`, both of which throw `UnsupportedError` in `SortedList`. Forward `removeWhere` and `retainWhere` to `_list`.
- [ ] **`RangeIterator` skips boundary element when reversing direction after exhaustion** ([`lib/src/collection/range.dart`](lib/src/collection/range.dart#L98-L117)):
  - When `moveNext()` returns `false` at the end of the range, `_index` remains `range.length - 1` instead of advancing to `range.length`, so a subsequent `movePrevious()` jumps to `range.length - 2` and skips the last element (and symmetrically at the start when `movePrevious()` returns `false` and `moveNext()` is called).
- [ ] **`FenwickTree.update` lacks bounds checking** ([`lib/src/collection/fenwick.dart`](lib/src/collection/fenwick.dart#L69-L78)):
  - `update(int index, int value)` silently ignores `index >= length` instead of throwing `RangeError`. Add `RangeError.checkValidIndex(index, this)`.
- [ ] **`MultimapAsMap` aliasing and `Map` contract bugs** ([`lib/src/collection/multimap.dart`](lib/src/collection/multimap.dart#L91-L93), [`lib/src/collection/multimap.dart`](lib/src/collection/multimap.dart#L183-L213)):
  - `asMap().remove(key)` grabs the live `MultimapValues` view (`this[key]`) and then calls `_multimap.removeAll(key)`, clearing the returned collection in-place so `remove(key)` always returns an empty collection (and never returns `null` for absent keys).
  - `asMap()[key]` returns a non-null empty `MultimapValues` view for absent keys even when `containsKey(key)` is `false`.
  - `replaceAll(key, values)` clears the backing collection before iterating `values`, losing all elements if `values` is `multimap[key]`.

### Async & Temporal

- [ ] **`Stream.buffer` subscription leak, closed-controller error, and `maxAge` debounce reset** ([`lib/src/async/buffer.dart`](lib/src/async/buffer.dart#L36-L74)):
  - `onTriggerDone()` and `onSourceDone()` close `controller` without cancelling the other subscription or `maxAgeTimer`, causing subsequent events to add to a closed controller.
  - `maybeFlush()` resets `maxAgeTimer` on every element instead of starting it only when the buffer transitions from empty to non-empty (`maxAgeTimer == null`), preventing `maxAge` flushes on high-frequency streams.
- [ ] **`Stream.tap` cancels subscription on first error without closing controller** ([`lib/src/async/tap.dart`](lib/src/async/tap.dart#L35-L39)):
  - `dispatchOnError` unconditionally calls `subscription.cancel()`, hanging downstream listeners forever on the first error instead of forwarding errors according to `cancelOnError`.
- [ ] **`DateTime.truncateTo` and `DateTime.periodical` lose UTC flag, miscalculate negative centuries/decades, and `Interval<DateTime>.toDuration` drops microseconds** ([`lib/src/temporal/date_time/truncate.dart`](lib/src/temporal/date_time/truncate.dart#L6-L50), [`lib/src/temporal/date_time/periodical.dart`](lib/src/temporal/date_time/periodical.dart#L38-L226), [`lib/src/temporal/interval/duration.dart`](lib/src/temporal/interval/duration.dart#L6-L8)):
  - `truncateTo` and `periodical` always construct local `DateTime(...)` objects even when `isUtc` is `true`.
  - `year ~/ 1000 * 1000`, `year ~/ 100 * 100`, and `year ~/ 10 * 10` truncate toward zero for negative years.
  - `Interval<DateTime>.toDuration` uses `millisecondsSinceEpoch` instead of `upper.difference(lower)` (or `microsecondsSinceEpoch`), losing microsecond precision.

---

## Omissions & API Inconsistencies

- [ ] **Bump version in `pubspec.yaml` to `4.8.0`** ([`pubspec.yaml`](pubspec.yaml#L2)):
  - [`CHANGELOG.md`](CHANGELOG.md#L1-L3) lists `## 4.8.0`, while `pubspec.yaml` is still `4.7.0`.
- [ ] **Export `FloydWarshall` from `lib/graph.dart`** ([`lib/graph.dart`](lib/graph.dart#L16-L17)):
  - `Graph.allShortestPaths` and `floydWarshallSearch` return `FloydWarshall<V>`, which is currently hidden by `show floydWarshallSearch`.
- [ ] **Export `Multimap` base class from `lib/collection.dart`** ([`lib/collection.dart`](lib/collection.dart#L48-L54)):
  - `ListMultimap` and `SetMultimap` subclass `Multimap` and accept `Multimap` in `.of` constructors, but `Multimap` is not exported.
- [ ] **Add `Fraction.parse` factory constructor** ([`lib/src/number/fraction.dart`](lib/src/number/fraction.dart#L126)):
  - `Complex.parse` and `Quaternion.parse` exist alongside `tryParse`, whereas `Fraction` only provides `tryParse`.
- [ ] **Support `num` in `DoubleRange.indexOf` / `contains` on Dart VM** ([`lib/src/collection/range/double.dart`](lib/src/collection/range/double.dart#L135)):
  - `if (element is double)` rejects `int` arguments on the VM (`DoubleRange(0, 5).contains(2)` is `false` on VM, `true` on JS).
- [ ] **Avoid `Map.identity()` on `Type` keys in `TypeMap`** ([`lib/src/collection/typemap.dart`](lib/src/collection/typemap.dart#L8)):
  - Dart guarantees `==` and `hashCode` for `Type` instances, not `identical()`. Use a regular `Map<Type, Object?>`.

---

## Performance Optimizations

- [ ] **Avoid repeated `Iterable.elementAt` calls in `Differ` implementations** ([`lib/src/diff/differ/context.dart`](lib/src/diff/differ/context.dart#L45-L73), [`lib/src/diff/differ/normal.dart`](lib/src/diff/differ/normal.dart#L60), [`lib/src/diff/differ/readable.dart`](lib/src/diff/differ/readable.dart#L105-L250), [`lib/src/diff/differ/unified.dart`](lib/src/diff/differ/unified.dart#L56)):
  - Materialize `source` and `target` as `List<String>` once so indexing is $O(1)$ instead of $O(n)$ per line, and compare strings directly in `ReadableDiffer._replace` instead of re-Decoding `.runes` inside the nested loop.
- [ ] **Use binary search for `SortedList.indexOf` and `lastIndexOf` and batch shift in `OrderedList.removeRange`** ([`lib/src/collection/sorted_list.dart`](lib/src/collection/sorted_list.dart#L46-L76), [`lib/src/collection/ordered_list.dart`](lib/src/collection/ordered_list.dart#L201-L204)):
  - Override `indexOf` and `lastIndexOf` in `SortedList` using `_comparator.binarySearchLower` / `binarySearchUpper` ($O(\log n)$ vs $O(n)$).
  - Replace the per-element `removeAt(start)` loop in `OrderedList.removeRange` with `_elements.removeRange(start, end)`.
- [ ] **Preserve `vertexStrategy` in `Graph.map` and hoist map lookups in `floydWarshallSearch`** ([`lib/src/graph/operations/map.dart`](lib/src/graph/operations/map.dart#L23), [`lib/src/graph/algorithms/search/floyd_warshall.dart`](lib/src/graph/algorithms/search/floyd_warshall.dart#L48-L62)):
  - Use `vertexStrategy.createMap<VR>()` instead of `<V, VR>{}` in `Graph.map`.
  - Hoist `pairs[i]!` and `pairs[k]!` out of the innermost loop in `floydWarshallSearch`.

---

## Cleanups & Documentation

- [ ] **Rename `FloyWarshallState` -> `FloydWarshallState`** ([`lib/src/graph/algorithms/search/floyd_warshall.dart`](lib/src/graph/algorithms/search/floyd_warshall.dart#L21), [`lib/src/graph/algorithms/search/floyd_warshall.dart`](lib/src/graph/algorithms/search/floyd_warshall.dart#L135)).
- [ ] **Fix hyperbolic doc comment typos** ([`lib/src/math/hyperbolic.dart`](lib/src/math/hyperbolic.dart#L65), [`lib/src/math/hyperbolic.dart`](lib/src/math/hyperbolic.dart#L68)):
  - `acoth()` says `tangent` instead of `cotangent`; `asech()` has duplicate `the the`.
- [ ] **Fix `BigIntRange` constructor doc comments** ([`lib/src/collection/range/bigint.dart`](lib/src/collection/range/bigint.dart#L55), [`lib/src/collection/range/bigint.dart`](lib/src/collection/range/bigint.dart#L77)):
  - `BigIntRange.of` and `BigIntRange.length` say `Const constructor to create an arithmetic progression of [int] values`.
- [ ] **Fix `StoerWagnerMinCut` complexity doc comment** ([`lib/src/graph/algorithms/stoer_wagner_min_cut.dart`](lib/src/graph/algorithms/stoer_wagner_min_cut.dart#L8)):
  - Change `_O(V*E + V*log(V))_` to `_O(V*E + V^2*log(V))_`.
- [ ] **Throw `StateError` instead of `UnimplementedError` in `TrieNodeEntry`** ([`lib/src/collection/trie.dart`](lib/src/collection/trie.dart#L284-L287)).
- [ ] **Enforce `base >= 2` at runtime in `int.digits` and `BigInt.digits`** ([`lib/src/math/digits.dart`](lib/src/math/digits.dart#L13), [`lib/src/math/digits.dart`](lib/src/math/digits.dart#L39)):
  - Replace `assert(base >= 2)` with `RangeError.checkValueInInterval(base, 2, ...)` or `ArgumentError.value` so release builds do not loop infinitely on `base == 1`.
- [ ] **Mask receiver to 32 bits in `BitUint32Extension.hasSingleBit`, `bitFloor`, and `bitCeil`** ([`lib/src/math/bit.dart`](lib/src/math/bit.dart#L21-L29)) for consistency with `bitCount`, `setBit`, `clearBit`, and `toggleBit`.
