import 'bounds.dart';
import 'entry.dart';

/// Selects a child entry that requires least area enlargement for inserting an
/// entry with the given bounding box. This is used as the sole criterion for
/// choosing a leaf node in the original Guttman implementation of the R-tree,
/// and is also used in the R*-tree implementation for the level above the leaf
/// nodes (for higher levels, R*-tree uses least overlap enlargement instead of
/// least area enlargement).
RTreeEntry<T> entryWithLeastAreaEnlargement<T>(
  List<RTreeEntry<T>> entries,
  Bounds bounds,
) {
  var minIndex = -1;
  var minArea = double.infinity;
  var minEnlargement = double.infinity;
  for (var i = 0; i < entries.length; i++) {
    final entry = entries[i];
    final beforeArea = entry.bounds.area;
    final afterArea = entry.bounds.union(bounds).area;
    final enlargement = afterArea - beforeArea;
    // If there are multiple entries having the same enlargement, choose the
    // entry having the smallest area as a tie-breaker.
    if (enlargement < minEnlargement ||
        (enlargement == minEnlargement && minArea < beforeArea)) {
      minIndex = i;
      minArea = beforeArea;
      minEnlargement = enlargement;
    }
  }
  return entries[minIndex];
}
