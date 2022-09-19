import '../rtree.dart';
import 'bounds.dart';
import 'entry.dart';

class RStarTree<T> extends RTree<T> {
  RStarTree({super.minEntries, super.maxEntries});

  @override
  RTreeEntry<T> insert(Bounds bound, T data) {
    // TODO: implement insert
    throw UnimplementedError();
  }
}
