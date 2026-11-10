/// Encapsulates selection state for vertices and edges in the graph editor.
class Selection {
  /// Creates an empty selection.
  new();

  final Set<String> _vertices = {};
  final Set<(String, String)> _edges = {};
  String? _activeVertex;
  (String, String)? _selectedEdge;

  /// Unmodifiable view of currently selected vertices.
  Set<String> get vertices => _vertices;

  /// Unmodifiable view of currently selected edges.
  Set<(String, String)> get edges => _edges;

  /// The active (primary) selected vertex, if any.
  String? get activeVertex => _activeVertex;

  /// The active (primary) selected vertex setter.
  set activeVertex(String? v) {
    _activeVertex = v;
    if (v != null) {
      _vertices.add(v);
    }
  }

  /// The most recently selected or active edge, if any.
  (String, String)? get selectedEdge => _selectedEdge;

  /// The active selected edge setter.
  set selectedEdge((String, String)? edge) {
    _selectedEdge = edge;
    if (edge != null) {
      _edges.add(edge);
    }
  }

  /// Algorithm source vertex (the active vertex or first selected vertex).
  String? get source =>
      _activeVertex ?? (_vertices.isNotEmpty ? _vertices.first : null);

  /// Algorithm target vertex (the second selected vertex different from source).
  String? get target {
    final s = source;
    for (final v in _vertices) {
      if (v != s) return v;
    }
    return null;
  }

  /// Whether the selection is empty.
  bool get isEmpty =>
      _vertices.isEmpty && _edges.isEmpty && _selectedEdge == null;

  /// Whether any vertex or edge is selected.
  bool get isNotEmpty => !isEmpty;

  /// Clears all vertex and edge selections.
  void clear() {
    _vertices.clear();
    _edges.clear();
    _activeVertex = null;
    _selectedEdge = null;
  }

  /// Sets the selected vertices, clearing any previously selected vertices.
  void setVertices(Iterable<String> vertices) {
    _vertices.clear();
    _vertices.addAll(vertices);
    if (_activeVertex == null || !_vertices.contains(_activeVertex)) {
      _activeVertex = _vertices.isNotEmpty ? _vertices.last : null;
    }
  }

  /// Sets the selected edges, clearing any previously selected edges.
  void setEdges(Iterable<(String, String)> edges) {
    _edges.clear();
    _edges.addAll(edges);
    if (_selectedEdge == null || !_edges.contains(_selectedEdge)) {
      _selectedEdge = _edges.isNotEmpty ? _edges.last : null;
    }
  }

  /// Selects or toggles a vertex.
  void selectVertex(String v, {bool toggle = false, bool clearOthers = true}) {
    if (clearOthers) {
      _vertices.clear();
      _edges.clear();
      _selectedEdge = null;
    }
    if (toggle) {
      if (_vertices.contains(v)) {
        _vertices.remove(v);
        if (_activeVertex == v) {
          _activeVertex = _vertices.isNotEmpty ? _vertices.last : null;
        }
      } else {
        _vertices.add(v);
        _activeVertex = v;
      }
    } else {
      _vertices.add(v);
      _activeVertex = v;
    }
  }

  /// Toggles selection of vertex [v].
  void toggleVertex(String v) =>
      selectVertex(v, toggle: true, clearOthers: false);

  /// Removes vertex [v] and any incident edges from the selection.
  void removeVertex(String v) {
    _vertices.remove(v);
    if (_activeVertex == v) {
      _activeVertex = _vertices.isNotEmpty ? _vertices.last : null;
    }
    _edges.removeWhere((e) => e.$1 == v || e.$2 == v);
    if (_selectedEdge != null &&
        (_selectedEdge!.$1 == v || _selectedEdge!.$2 == v)) {
      _selectedEdge = _edges.isNotEmpty ? _edges.last : null;
    }
  }

  /// Selects or toggles an edge.
  void selectEdge(
    (String, String) edge, {
    bool toggle = false,
    bool clearOthers = true,
  }) {
    if (clearOthers) {
      _vertices.clear();
      _edges.clear();
      _selectedEdge = null;
      _activeVertex = null;
    }
    if (toggle) {
      if (_edges.contains(edge)) {
        _edges.remove(edge);
        if (_selectedEdge == edge) {
          _selectedEdge = _edges.isNotEmpty ? _edges.last : null;
        }
      } else {
        _edges.add(edge);
        _selectedEdge = edge;
      }
    } else {
      _edges.add(edge);
      _selectedEdge = edge;
    }
  }

  /// Toggles selection of [edge].
  void toggleEdge((String, String) edge) =>
      selectEdge(edge, toggle: true, clearOthers: false);

  /// Removes an edge from the selection.
  void removeEdge((String, String) edge) {
    _edges.remove(edge);
    if (_selectedEdge == edge) {
      _selectedEdge = _edges.isNotEmpty ? _edges.last : null;
    }
  }

  /// Filters selected vertices and edges using [predicate].
  void filterVertices(bool Function(String v) predicate) {
    _vertices.removeWhere((v) => !predicate(v));
    if (_activeVertex != null && !predicate(_activeVertex!)) {
      _activeVertex = _vertices.isNotEmpty ? _vertices.last : null;
    }
    _edges.removeWhere((e) => !predicate(e.$1) || !predicate(e.$2));
    if (_selectedEdge != null &&
        (!predicate(_selectedEdge!.$1) || !predicate(_selectedEdge!.$2))) {
      _selectedEdge = _edges.isNotEmpty ? _edges.last : null;
    }
  }
}
