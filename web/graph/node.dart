/// Represents a dedicated graph node with customizable label and spatial position.
final class GraphNode {
  new({required this.id, String? label, this.x, this.y})
    : label = (label != null && label.isNotEmpty) ? label : id;

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
