/// A Disjoint-set data structure, also known as a union-find data structure or
/// merge-find set.
///
/// This data structure stores a collection of disjoint (non-overlapping) sets.
/// It provides operations for adding new sets, merging sets (replacing them by
/// their union), and finding a representative member of a set.
///
/// See https://en.wikipedia.org/wiki/Disjoint-set_data_structure.
class DisjointSet<T> {
  /// Constructs a disjoint set with the unique [elements], where each element
  /// is initially its own set.
  DisjointSet(Iterable<T> elements) {
    for (final element in elements) {
      _nodes[element] ??= (parent: element, size: 1);
    }
    _count = _nodes.length;
  }

  final _nodes = <T, _Node<T>>{};
  var _count = 0;

  /// Returns the original elements of the set.
  Iterable<T> get elements => _nodes.keys;

  /// Returns the number of disjoint sets.
  int get count => _count;

  /// Returns the size of all disjoint sets.
  Iterable<int> get sizes => _nodes.entries
      .where((entry) => entry.key == entry.value.parent)
      .map((entry) => entry.value.size);

  /// Returns all disjoint sets as an iterable of iterables.
  Iterable<Iterable<T>> get sets {
    final groups = <T, Set<T>>{};
    for (final element in _nodes.keys) {
      groups.putIfAbsent(find(element), () => <T>{}).add(element);
    }
    return groups.values;
  }

  /// Finds the representative of the set containing [element].
  ///
  /// This operation uses path compression to flatten the structure of the tree
  /// whenever [find] is used on it.
  T find(T element) {
    var root = element;
    while (true) {
      final node = _nodes[root] ?? _invalidElement(element);
      if (node.parent == root) break;
      root = node.parent;
    }
    var curr = element;
    while (curr != root) {
      final node = _nodes[curr]!;
      _nodes[curr] = (parent: root, size: node.size);
      curr = node.parent;
    }
    return root;
  }

  /// Merges the subsets containing elements [a] and [b].
  ///
  /// Returns `true` if the sets were merged (i.e., they were previously
  /// disjoint), and `false` otherwise.
  ///
  /// This operation uses union by size to attach the smaller tree to the root
  /// of the larger tree.
  bool union(T a, T b) {
    final rootA = find(a), rootB = find(b);
    if (rootA == rootB) return false;
    final nodeA = _nodes[rootA]!;
    final nodeB = _nodes[rootB]!;
    if (nodeA.size < nodeB.size) {
      _nodes[rootA] = (parent: rootB, size: nodeA.size);
      _nodes[rootB] = (parent: rootB, size: nodeA.size + nodeB.size);
    } else {
      _nodes[rootB] = (parent: rootA, size: nodeB.size);
      _nodes[rootA] = (parent: rootA, size: nodeA.size + nodeB.size);
    }
    _count--;
    return true;
  }

  Never _invalidElement(T element) => throw ArgumentError.value(
    element,
    'element',
    'Element not in disjoint set',
  );
}

typedef _Node<T> = ({T parent, int size});
