/// Default visual constants for vertex styling.
const double defaultBorderWidth = 1.5;
const double defaultOpacity = 1.0;

/// Transient visual styling attributes applied by graph modifiers.
final class NodeStyle {
  new({
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.borderWidth = defaultBorderWidth,
    this.opacity = defaultOpacity,
    this.visible = true,
  });

  /// Override fill color for the vertex body.
  String? fillColor;

  /// Override border stroke color.
  String? borderColor;

  /// Override label text color.
  String? textColor;

  /// Width of vertex border stroke.
  double borderWidth;

  /// Opacity factor between 0.0 and 1.0.
  double opacity;

  /// Whether the vertex is currently rendered.
  bool visible;

  /// Resets transient visual styling back to defaults.
  void reset() {
    fillColor = null;
    borderColor = null;
    textColor = null;
    borderWidth = defaultBorderWidth;
    opacity = defaultOpacity;
    visible = true;
  }
}

/// Represents a dedicated graph vertex with customizable label, position, and styling.
final class GraphNode {
  new({
    required this.id,
    String? label,
    this.x,
    this.y,
    this.userFillColor,
    this.userBorderColor,
    this.userTextColor,
    this.userBorderWidth,
    this.userOpacity,
    NodeStyle? style,
  }) : label = (label != null && label.isNotEmpty) ? label : id,
       style = style ?? NodeStyle();

  factory fromJson(Map<String, dynamic> json) => GraphNode(
    id: json['id']?.toString() ?? '',
    label: json['label']?.toString(),
    x: (json['x'] as num?)?.toDouble(),
    y: (json['y'] as num?)?.toDouble(),
    userFillColor: json['fillColor']?.toString(),
    userBorderColor: json['borderColor']?.toString(),
    userTextColor: json['textColor']?.toString(),
    userBorderWidth: (json['borderWidth'] as num?)?.toDouble(),
    userOpacity: (json['opacity'] as num?)?.toDouble(),
  );

  /// Immutable unique identifier matching the vertex key in `Graph<String, num>`.
  final String id;

  /// User-editable display label.
  String label;

  /// Optional X canvas position.
  double? x;

  /// Optional Y canvas position.
  double? y;

  /// Optional user-defined persistent fill color.
  String? userFillColor;

  /// Optional user-defined persistent border color.
  String? userBorderColor;

  /// Optional user-defined persistent text color.
  String? userTextColor;

  /// Optional user-defined persistent border width.
  double? userBorderWidth;

  /// Optional user-defined persistent opacity.
  double? userOpacity;

  /// Transient styling applied non-destructively by modifiers.
  final NodeStyle style;

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    if (x != null) 'x': x,
    if (y != null) 'y': y,
    if (userFillColor != null) 'fillColor': userFillColor,
    if (userBorderColor != null) 'borderColor': userBorderColor,
    if (userTextColor != null) 'textColor': userTextColor,
    if (userBorderWidth != null) 'borderWidth': userBorderWidth,
    if (userOpacity != null) 'opacity': userOpacity,
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
    this.opacity = 1.0,
    this.label,
    this.visible = true,
  });

  /// Override stroke color.
  String? color;

  /// Width of the edge stroke.
  double strokeWidth;

  /// Opacity factor between 0.0 and 1.0.
  double opacity;

  /// Optional custom label override for this edge.
  String? label;

  /// Whether the edge is currently rendered.
  bool visible;

  /// Resets visual styling back to defaults.
  void reset() {
    color = null;
    strokeWidth = 1.8;
    opacity = 1.0;
    label = null;
    visible = true;
  }
}
