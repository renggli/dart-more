import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/enums.dart';

void main() {
  group('Generator enums', () {
    test('GeneratorShape fromId', () {
      check(GeneratorShape.fromId('atlas')).equals(GeneratorShape.atlas);
      check(GeneratorShape.fromId('complete')).equals(GeneratorShape.complete);
      check(GeneratorShape.fromId('cycle')).equals(GeneratorShape.cycle);
      check(GeneratorShape.fromId('star')).equals(GeneratorShape.star);
      check(GeneratorShape.fromId('path')).equals(GeneratorShape.path);
      check(GeneratorShape.fromId('tree')).equals(GeneratorShape.tree);
      check(GeneratorShape.fromId('bipartite'))
          .equals(GeneratorShape.bipartite);
      check(GeneratorShape.fromId('grid')).equals(GeneratorShape.grid);
      check(GeneratorShape.fromId('random')).equals(GeneratorShape.random);
      check(GeneratorShape.fromId('unknown')).equals(GeneratorShape.atlas);
    });

    test('GeneratorCombineMode fromId', () {
      check(GeneratorCombineMode.fromId('replace'))
          .equals(GeneratorCombineMode.replace);
      check(GeneratorCombineMode.fromId('union'))
          .equals(GeneratorCombineMode.union);
      check(GeneratorCombineMode.fromId('unknown'))
          .equals(GeneratorCombineMode.replace);
    });
  });

  group('Shortest path and traversal enums', () {
    test('ShortestPathAlgorithm fromId', () {
      check(ShortestPathAlgorithm.fromId('dijkstra'))
          .equals(ShortestPathAlgorithm.dijkstra);
      check(ShortestPathAlgorithm.fromId('astar'))
          .equals(ShortestPathAlgorithm.aStar);
      check(ShortestPathAlgorithm.fromId('bellmanFord'))
          .equals(ShortestPathAlgorithm.bellmanFord);
      check(ShortestPathAlgorithm.fromId('bfs'))
          .equals(ShortestPathAlgorithm.bfs);
      check(ShortestPathAlgorithm.fromId('dfs'))
          .equals(ShortestPathAlgorithm.dfs);
      check(ShortestPathAlgorithm.fromId('unknown'))
          .equals(ShortestPathAlgorithm.dijkstra);
    });
  });

  group('Metric and analysis enums', () {
    test('CentralityMetric fromId', () {
      check(CentralityMetric.fromId('degree')).equals(CentralityMetric.degree);
      check(CentralityMetric.fromId('betweenness'))
          .equals(CentralityMetric.betweenness);
      check(CentralityMetric.fromId('closeness'))
          .equals(CentralityMetric.closeness);
      check(CentralityMetric.fromId('pagerank'))
          .equals(CentralityMetric.pagerank);
      check(CentralityMetric.fromId('eigenvector'))
          .equals(CentralityMetric.eigenvector);
      check(CentralityMetric.fromId('unknown')).equals(CentralityMetric.degree);
    });

    test('ComponentMode fromId', () {
      check(ComponentMode.fromId('weakly')).equals(ComponentMode.weakly);
      check(ComponentMode.fromId('strongly')).equals(ComponentMode.strongly);
      check(ComponentMode.fromId('biconnected'))
          .equals(ComponentMode.biconnected);
      check(ComponentMode.fromId('unknown')).equals(ComponentMode.weakly);
    });

    test('KCoreRemovedStyle fromId', () {
      check(KCoreRemovedStyle.fromId('dim')).equals(KCoreRemovedStyle.dim);
      check(KCoreRemovedStyle.fromId('dash')).equals(KCoreRemovedStyle.dash);
      check(KCoreRemovedStyle.fromId('hide')).equals(KCoreRemovedStyle.hide);
      check(KCoreRemovedStyle.fromId('unknown')).equals(KCoreRemovedStyle.dash);
    });

    test('CliquesMode fromId', () {
      check(CliquesMode.fromId('cliques')).equals(CliquesMode.cliques);
      check(CliquesMode.fromId('independentSet'))
          .equals(CliquesMode.independentSet);
      check(CliquesMode.fromId('unknown')).equals(CliquesMode.cliques);
    });
  });
}
