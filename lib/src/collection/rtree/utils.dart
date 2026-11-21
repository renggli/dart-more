import 'bounds.dart';
import 'entry.dart';

/// Selects a child entry that requires least area enlargement for inserting an
/// entry with the given bounding box.
///
/// Used as the sole criterion for choosing a leaf node in the Guttman and
/// linear R-Tree implementations, and in the R*-Tree implementation for
/// internal levels whose children are not leaves (for the level directly above
/// leaves, R*-Tree uses least overlap enlargement instead).
RTreeEntry<T> entryWithLeastAreaEnlargement<T>(
  List<RTreeEntry<T>> entries,
  Bounds bounds,
) {
  var minIndex = 0;
  var minArea = double.infinity;
  var minEnlargement = double.infinity;
  for (var i = 0; i < entries.length; i++) {
    final entry = entries[i];
    final beforeArea = entry.bounds.area;
    final afterArea = entry.bounds.unionArea(bounds);
    final enlargement = afterArea - beforeArea;
    // If there are multiple entries having the same enlargement, choose the
    // entry having the smallest area as a tie-breaker.
    if (enlargement < minEnlargement ||
        (enlargement == minEnlargement && beforeArea < minArea)) {
      minIndex = i;
      minArea = beforeArea;
      minEnlargement = enlargement;
    }
  }
  return entries[minIndex];
}
