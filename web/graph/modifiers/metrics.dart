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
