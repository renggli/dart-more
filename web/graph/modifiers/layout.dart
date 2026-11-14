import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../layout.dart';
import '../state.dart';
import 'base.dart';

// ---------------------------------------------------------------------------
// Layout Modifier (Rearranges vertices non-destructively, can be applied)
// ---------------------------------------------------------------------------

class LayoutModifier extends GraphModifier {
  new({
    super.enabled,
    this.algorithm = LayoutEngine.stress,
    this.rankDir = RankDir.tb,
    this.componentDirection = RankDir.tb,
    this.vertexDistance = 60.0,
    this.layerDistance = 80.0,
    this.iterations = 100,
    this.columns = 0,
    this.seed = 42,
    this.removeOverlaps = true,
  });

  LayoutEngine algorithm;
  RankDir rankDir;
  RankDir componentDirection;
  double vertexDistance;
  double layerDistance;
  int iterations;
  int columns;
  int seed;
  bool removeOverlaps;

  @override
  String get id => 'layout';

  @override
  String get name => 'Layout';

  @override
  ModifierCategory get category => ModifierCategory.layout;

  @override
  bool get canApply => true;

  @override
  Map<String, dynamic> exportConfig() => {
    'algorithm': algorithm.id,
    'rankDir': rankDir.id,
    'componentDirection': componentDirection.id,
    'vertexDistance': vertexDistance,
    'layerDistance': layerDistance,
    'iterations': iterations,
    'columns': columns,
    'seed': seed,
    'removeOverlaps': removeOverlaps,
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['algorithm'] case final String a) {
      algorithm = LayoutEngine.fromId(a);
    }
    if (config['rankDir'] case final String r) {
      rankDir = RankDir.fromId(r);
    }
    if (config['componentDirection'] case final String cd) {
      componentDirection = RankDir.fromId(cd);
    }
    if (config['vertexDistance'] case final num vd) {
      vertexDistance = vd.toDouble();
    }
    if (config['layerDistance'] case final num ld) {
      layerDistance = ld.toDouble();
    }
    if (config['iterations'] case final int it) iterations = it;
    if (config['columns'] case final int col) columns = col;
    if (config['seed'] case final int s) seed = s;
    if (config['removeOverlaps'] case final bool ro) removeOverlaps = ro;
  }

  @override
  void resetDefaults() {
    algorithm = LayoutEngine.stress;
    rankDir = RankDir.tb;
    componentDirection = RankDir.tb;
    vertexDistance = 60.0;
    layerDistance = 80.0;
    iterations = 100;
    columns = 0;
    seed = 42;
    removeOverlaps = true;
  }

  @override
  void applyPermanent(AppState state) {
    apply(state.renderGraph, state);
    state.saveSnapshot();
    state.modifiers.remove(this);
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');
    final dynamicSection = div('form-column');

    void rebuildDynamicFields() {
      dynamicSection.textContent = '';

      // Spacing / Vertex Distance control (applicable to all layouts except random)
      if (algorithm != LayoutEngine.random) {
        dynamicSection.appendChild(
          rangeSetting(
            'Node Spacing (px):',
            vertexDistance,
            min: 10,
            max: 250,
            step: 5,
            onChanged: (v) {
              vertexDistance = v.toDouble();
              onModified();
            },
          ),
        );
      }

      // Directional layout controls
      if (algorithm == LayoutEngine.layered || algorithm == LayoutEngine.tree) {
        dynamicSection.appendChild(
          dropdownSetting(
            'Flow Direction:',
            rankDir.id,
            [
              for (final dir in RankDir.values)
                (dir.id, '${dir.label} (${dir.id})'),
            ],
            onChanged: (val) {
              rankDir = RankDir.fromId(val);
              onModified();
            },
          ),
        );
      }

      if (algorithm == LayoutEngine.layered ||
          algorithm == LayoutEngine.tree ||
          algorithm == LayoutEngine.radial ||
          algorithm == LayoutEngine.shell) {
        dynamicSection.appendChild(
          rangeSetting(
            'Layer Distance (px):',
            layerDistance,
            min: 20,
            max: 300,
            step: 5,
            onChanged: (v) {
              layerDistance = v.toDouble();
              onModified();
            },
          ),
        );
      }

      // Iterative simulation controls
      if (algorithm == LayoutEngine.stress ||
          algorithm == LayoutEngine.force ||
          algorithm == LayoutEngine.spectral) {
        dynamicSection.appendChild(
          rangeSetting(
            'Iterations:',
            iterations,
            min: 10,
            max: 500,
            step: 10,
            onChanged: (v) {
              iterations = v.toInt();
              onModified();
            },
          ),
        );
      }

      // Grid columns control
      if (algorithm == LayoutEngine.grid) {
        dynamicSection.appendChild(
          intSetting(
            'Columns (0 for auto):',
            columns,
            min: 0,
            max: 50,
            onChanged: (v) {
              columns = v;
              onModified();
            },
          ),
        );
      }

      // Seed control
      if (algorithm == LayoutEngine.random ||
          algorithm == LayoutEngine.stress ||
          algorithm == LayoutEngine.force ||
          algorithm == LayoutEngine.spectral) {
        dynamicSection.appendChild(
          seedSetting(
            'Random Seed:',
            seed,
            onChanged: (v) {
              seed = v;
              onModified();
            },
          ),
        );
      }

      if (algorithm == LayoutEngine.stress ||
          algorithm == LayoutEngine.force ||
          algorithm == LayoutEngine.layered ||
          algorithm == LayoutEngine.spectral ||
          algorithm == LayoutEngine.radial) {
        dynamicSection.appendChild(
          dropdownSetting(
            'Component Direction:',
            componentDirection.id,
            [
              for (final dir in RankDir.values)
                (dir.id, '${dir.label} (${dir.id})'),
            ],
            onChanged: (val) {
              componentDirection = RankDir.fromId(val);
              onModified();
            },
          ),
        );
      }

      dynamicSection.appendChild(
        checkboxSetting(
          'Remove overlaps',
          removeOverlaps,
          onChanged: (v) {
            removeOverlaps = v;
            onModified();
          },
        ),
      );
    }

    container.appendChild(
      dropdownSetting(
        'Layout Algorithm:',
        algorithm.id,
        [for (final engine in LayoutEngine.values) (engine.id, engine.label)],
        onChanged: (val) {
          algorithm = LayoutEngine.fromId(val);
          rebuildDynamicFields();
          onModified();
        },
      ),
    );

    rebuildDynamicFields();
    container.appendChild(dynamicSection);

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (validateGraph(graph) case final err?) return err;

    GraphLayout.applyLayout(
      state,
      graph: graph,
      engine: algorithm,
      rankdir: rankDir,
      componentDirection: componentDirection,
      vertexDistance: vertexDistance,
      layerDistance: layerDistance,
      iterations: iterations,
      columns: columns > 0 ? columns : null,
      seed: seed,
      removeOverlaps: removeOverlaps,
    );

    return ModifierOutput(
      statusSummary: 'Layout applied: ${algorithm.label}',
      tableData: ModifierTableData(
        title: 'Layout Configuration',
        headers: ['Property', 'Value'],
        rows: [
          ['Algorithm', algorithm.label],
          ['Orientation', rankDir.label],
          ['Positioned Vertices', '${graph.vertices.length}'],
          ['Overlap Removal', if (removeOverlaps) 'Enabled' else 'Disabled'],
        ],
      ),
    );
  }
}
