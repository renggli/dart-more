/// A Disjoint-set data structure, also known as a union-find data structure or
/// merge-find set.
///
/// This data structure stores a collection of disjoint (non-overlapping) sets.
/// It provides operations for merging sets (replacing them by their union) and
/// finding a representative member of a set.
///
/// See https://en.wikipedia.org/wiki/Disjoint-set_data_structure.
class DisjointSet<T> {
  /// Constructs a disjoint set with the unique [elements], where each element
  /// is initially its own set.
  ///
  /// An optional [nodes] map may be provided to customize element equality
  /// (for example, `Map.identity()` or a custom `HashMap`).
  new(Iterable<T> elements, {Map<T, DisjointSetNode<T>>? nodes})
    : _nodes = nodes ?? <T, DisjointSetNode<T>>{} {
    final wasEmpty = _nodes.isEmpty;
    for (final element in elements) {
      _nodes[element] ??= (parent: element, size: 1);
    }
    _count = wasEmpty
        ? _nodes.length
        : _nodes.entries
              .where((entry) => identical(entry.key, entry.value.parent))
              .length;
  }

  final Map<T, DisjointSetNode<T>> _nodes;
  var _count = 0;

  /// Returns the original elements of the set.
  Iterable<T> get elements => _nodes.keys;

  /// Returns the number of disjoint sets.
  int get count => _count;

  /// Returns the size of all disjoint sets.
  Iterable<int> get sizes => _nodes.entries
      .where((entry) => identical(entry.key, entry.value.parent))
      .map((entry) => entry.value.size);

  /// Returns all disjoint sets as an iterable of iterables.
  Iterable<Iterable<T>> get sets {
    final groups = Map<T, List<T>>.identity();
    for (final element in _nodes.keys) {
      groups.putIfAbsent(find(element), () => <T>[]).add(element);
    }
    return groups.values;
  }

  /// Finds the representative of the set containing [element].
  ///
  /// Uses path compression to flatten the tree structure. Throws an
  /// [ArgumentError] if [element] is not in this disjoint set.
  T find(T element) => _findRoot(element, 'element').root;

  /// Merges the subsets containing elements [a] and [b].
  ///
  /// Returns `true` if the sets were merged (i.e., they were previously
  /// disjoint), and `false` otherwise. Uses union by size to attach the
  /// smaller tree to the root of the larger tree.
  ///
  /// Throws an [ArgumentError] if [a] or [b] is not in this disjoint set.
  bool union(T a, T b) {
    final (root: rootA, node: nodeA) = _findRoot(a, 'a');
    final (root: rootB, node: nodeB) = _findRoot(b, 'b');
    if (identical(rootA, rootB)) return false;
    final totalSize = nodeA.size + nodeB.size;
    if (nodeA.size < nodeB.size) {
      _nodes[rootA] = (parent: rootB, size: nodeA.size);
      _nodes[rootB] = (parent: rootB, size: totalSize);
    } else {
      _nodes[rootB] = (parent: rootA, size: nodeB.size);
      _nodes[rootA] = (parent: rootA, size: totalSize);
    }
    _count--;
    return true;
  }

  ({T root, DisjointSetNode<T> node}) _findRoot(T element, String name) {
    final first = _nodes[element] ?? _invalidElement(element, name);
    var root = first.parent;
    var rootNode = first;
    if (!identical(root, element)) {
      while (true) {
        rootNode = _nodes[root] ?? _invalidElement(element, name);
        if (identical(rootNode.parent, root)) break;
        root = rootNode.parent;
      }
      var curr = element;
      var currNode = first;
      while (!identical(currNode.parent, root)) {
        final next = currNode.parent;
        _nodes[curr] = (parent: root, size: currNode.size);
        curr = next;
        currNode = _nodes[curr] ?? _invalidElement(element, name);
      }
    }
    return (root: root, node: rootNode);
  }

  Never _invalidElement(T element, String name) =>
      throw ArgumentError.value(element, name, 'Element not in disjoint set');
}

/// Internal node entry stored in [DisjointSet]'s backing map.
typedef DisjointSetNode<T> = ({T parent, int size});
