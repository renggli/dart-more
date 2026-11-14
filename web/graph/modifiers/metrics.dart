import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';
import 'base.dart';

// ---------------------------------------------------------------------------
// Centrality Modifier (Guarded Against NaN & Non-Convergence)
// ---------------------------------------------------------------------------

class CentralityModifier extends GraphModifier {
  new({super.enabled, this.metric = CentralityMetric.betweenness});

  CentralityMetric metric;

  @override
  String get id => 'centrality';

  @override
  String get name => 'Centrality';

  @override
  ModifierCategory get category => ModifierCategory.centrality;

  @override
  Map<String, dynamic> exportConfig() => {'metric': metric.id};

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['metric'] case final String m) {
      metric = CentralityMetric.fromId(m);
    }
  }

  @override
  void resetDefaults() {
    metric = CentralityMetric.degree;
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      dropdownSetting(
        'Centrality Metric:',
        metric.id,
        [for (final m in CentralityMetric.values) (m.id, m.label)],
        onChanged: (val) {
          metric = CentralityMetric.fromId(val);
          onModified();
        },
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    Map<String, num> scores;
    try {
      switch (metric) {
        case CentralityMetric.closeness:
          scores = graph.closenessCentrality();
        case CentralityMetric.betweenness:
          scores = graph.betweennessCentrality();
        case CentralityMetric.pagerank:
          scores = graph.pageRank();
        case CentralityMetric.eigenvector:
          scores = graph.eigenvectorCentrality();
        case CentralityMetric.degree:
          scores = graph.degreeCentrality();
        case CentralityMetric.inDegree:
          scores = graph.inDegreeCentrality();
        case CentralityMetric.outDegree:
          scores = graph.outDegreeCentrality();
        case CentralityMetric.coreNumbers:
          scores = {
            for (final entry in graph.coreNumbers().entries)
              entry.key: entry.value,
          };
        case CentralityMetric.clustering:
          scores = {
            for (final v in vertices) v: graph.localClusteringCoefficient(v),
          };
        case CentralityMetric.katz:
          scores = graph.katzCentrality();
        case CentralityMetric.hitsHubs:
          final (_, hubs) = graph.hits();
          scores = hubs;
        case CentralityMetric.hitsAuthorities:
          final (auth, _) = graph.hits();
          scores = auth;
      }
    } catch (_) {
      // Graceful fallback to degree centrality if power iteration or brandes fails
      scores = {for (final v in vertices) v: graph.degreeOf(v)};
    }

    // Sanitize any non-finite values (NaN / Infinity)
    final cleanScores = <String, num>{};
    for (final v in vertices) {
      final s = scores[v];
      cleanScores[v] = (s != null && s.isFinite) ? s : 0.0;
    }

    final sorted = cleanScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxVal = sorted.isNotEmpty && sorted.first.value != 0
        ? sorted.first.value
        : 1.0;

    final rows = <List<String>>[];
    for (var i = 0; i < sorted.length; i++) {
      final entry = sorted[i];
      final norm = (entry.value / maxVal).clamp(0.0, 1.0);
      final pct = (norm * 100).toStringAsFixed(1);
      final rawStr = entry.value is double
          ? entry.value.toStringAsFixed(4)
          : entry.value.toString();
      rows.add(['#${i + 1}', entry.key, rawStr, '$pct%']);
    }

    final overlay = HeatmapOverlay(
      title: '$name ($metric)',
      scores: cleanScores,
    );
    final topStr = sorted.isNotEmpty
        ? 'Top: ${sorted.first.key} (${sorted.first.value is double ? sorted.first.value.toStringAsFixed(3) : sorted.first.value})'
        : '';

    return ModifierOutput(
      overlay: overlay,
      tableData: ModifierTableData(
        title: '$name ($metric)',
        headers: ['Rank', 'Vertex', 'Score', 'Relative %'],
        rows: rows,
      ),
      statusSummary: topStr,
    );
  }
}

// ---------------------------------------------------------------------------
// Graph Metrics Modifier (Comprehensive Global & Local Properties)
// ---------------------------------------------------------------------------

class GraphMetricsModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'graph_metrics';

  @override
  String get name => 'Graph Metrics';

  @override
  ModifierCategory get category => ModifierCategory.centrality;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) =>
      div('form-column')..appendChild(
        p(
            'Computes structural properties, density, clustering, connectivity, and degree metrics.',
          )
          ..style.fontSize = '11px'
          ..style.color = 'var(--text-muted)',
      );

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vCount = graph.vertices.length;
    final eCount = graph.edges.length;
    if (vCount == 0) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final density = graph.density();
    final transitivity = graph.transitivity();
    final avgClustering = graph.averageClusteringCoefficient();
    final assortativity = graph.degreeAssortativity();
    final isBip = graph.isBipartite();
    final isAcyclic = !graph.hasCycle();
    final isPlanar = !graph.isDirected ? graph.isPlanar() : null;
    final edgeConn = graph.edgeConnectivity();
    final vertConn = graph.vertexConnectivity();

    num? diameter;
    num? radius;
    Set<String>? center;
    try {
      diameter = graph.diameter();
      radius = graph.radius();
      center = graph.center();
    } catch (_) {}

    var minDeg = double.infinity.toInt();
    var maxDeg = 0;
    var totalDeg = 0;
    for (final v in graph.vertices) {
      final deg = graph.degreeOf(v);
      if (deg < minDeg) minDeg = deg;
      if (deg > maxDeg) maxDeg = deg;
      totalDeg += deg;
    }
    final avgDeg = totalDeg / vCount;

    return ModifierOutput(
      statusSummary:
          'Density: ${density.toStringAsFixed(3)}, Clustering: ${avgClustering.toStringAsFixed(3)}',
      tableData: ModifierTableData(
        title: 'Graph Structural Metrics',
        headers: ['Metric', 'Value'],
        rows: [
          ['Vertices (V)', '$vCount'],
          ['Edges (E)', '$eCount'],
          ['Type', if (graph.isDirected) 'Directed' else 'Undirected'],
          ['Density', density.toStringAsFixed(4)],
          ['Transitivity', transitivity.toStringAsFixed(4)],
          ['Average Clustering', avgClustering.toStringAsFixed(4)],
          [
            'Degree Assortativity',
            if (assortativity.isNaN)
              'N/A'
            else
              assortativity.toStringAsFixed(4),
          ],
          ['Bipartite', if (isBip) 'Yes' else 'No'],
          ['Acyclic (DAG)', if (isAcyclic) 'Yes' else 'No'],
          if (isPlanar != null) ['Planar', if (isPlanar) 'Yes' else 'No'],
          ['Edge Connectivity', '$edgeConn'],
          ['Vertex Connectivity', '$vertConn'],
          if (diameter != null && !diameter.isInfinite) ...[
            ['Diameter', '$diameter'],
            ['Radius', '$radius'],
            ['Center Vertices', center?.join(', ') ?? '-'],
          ],
          [
            'Degree Sequence',
            'Min: $minDeg, Max: $maxDeg, Avg: ${avgDeg.toStringAsFixed(2)}',
          ],
        ],
      ),
    );
  }
}
