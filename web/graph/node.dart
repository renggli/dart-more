/// Represents a dedicated graph vertex with customizable label, position, and styling.
final class GraphNode {
  new({
    required this.id,
    String? label,
    this.x,
    this.y,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.borderStyle = 'solid',
    this.dashPattern = 'none',
    this.borderWidth = 1.5,
    this.opacity = 1.0,
    this.visible = true,
  }) : label = (label != null && label.isNotEmpty) ? label : id;

  factory fromJson(Map<String, dynamic> json) => GraphNode(
    id: json['id']?.toString() ?? '',
    label: json['label']?.toString(),
    x: (json['x'] as num?)?.toDouble(),
    y: (json['y'] as num?)?.toDouble(),
  );

  /// Immutable unique identifier matching the vertex key in `Graph<String, num>`.
  final String id;

  /// User-editable display label.
  String label;

  /// Optional X canvas position.
  double? x;

  /// Optional Y canvas position.
  double? y;

  /// Visual styling attributes (can be modified by modifiers)
  String? fillColor;
  String? borderColor;
  String? textColor;
  String borderStyle; // 'solid', 'dashed', 'dotted'
  String dashPattern; // 'none', '4,4', '2,2', '6,3'
  double borderWidth;
  double opacity;
  bool visible;

  /// Resets modifier-applied visual styling attributes back to defaults.
  void resetVisuals() {
    fillColor = null;
    borderColor = null;
    textColor = null;
    borderStyle = 'solid';
    dashPattern = 'none';
    borderWidth = 1.5;
    opacity = 1.0;
    visible = true;
  }

  /// Copies styling from another [GraphNode].
  GraphNode copyWithPosition() => GraphNode(
    id: id,
    label: label,
    x: x,
    y: y,
    fillColor: fillColor,
    borderColor: borderColor,
    textColor: textColor,
    borderStyle: borderStyle,
    dashPattern: dashPattern,
    borderWidth: borderWidth,
    opacity: opacity,
    visible: visible,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    if (x != null) 'x': x,
    if (y != null) 'y': y,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is GraphNode && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => label;
}

/// Represents first-class visual styling attributes for a graph edge.
final class GraphEdgeStyle {
  new({
    this.color,
    this.strokeWidth = 1.8,
    this.style = 'solid',
    this.dashPattern = 'none',
    this.opacity = 1.0,
    this.label,
    this.visible = true,
  });

  String? color;
  double strokeWidth;
  String style; // 'solid', 'dashed', 'dotted'
  String dashPattern; // 'none', '6,4', '2,2', '8,4'
  double opacity;
  String? label;
  bool visible;

  /// Resets visual styling back to defaults.
  void reset() {
    color = null;
    strokeWidth = 1.8;
    style = 'solid';
    dashPattern = 'none';
    opacity = 1.0;
    label = null;
    visible = true;
  }
}
