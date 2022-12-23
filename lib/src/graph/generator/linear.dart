import '../utils/defaults.dart';
import '../utils/next.dart';

NextEdges<int> linearGraph({
  required int vertexCount,
  num weight = defaultWeight,
}) =>
    (vertex) => 0 <= vertex && vertex < vertexCount
        ? [NextEdge<int>(vertex + 1, weight: weight)]
        : [];
