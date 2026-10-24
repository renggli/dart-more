@TestOn('vm')
library;

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  late final graph = createDependencyGraph();

  setUpAll(() {
    final dot = graph.toDot(
      graphAttributes: const {'rankdir': 'LR'},
      subgraph: subLibraryOf,
      subgraphName: (subgraph) => 'cluster_$subgraph',
      subgraphLabel: (subgraph) => subgraph,
      vertexLabel: vertexLabel,
    );
    final dotFile = File('docs/deps.dot');
    dotFile.parent.createSync(recursive: true);
    dotFile.writeAsStringSync(dot);
  });

  group('umbrella', () {
    test('no incoming dependencies', () {
      check(graph.predecessorsOf('lib/more.dart')).isEmpty();
    });

    test('exports all public sub-libraries', () {
      check(graph.successorsOf('lib/more.dart')).unorderedEquals([
        'lib/async.dart',
        'lib/cache.dart',
        'lib/char_matcher.dart',
        'lib/collection.dart',
        'lib/comparator.dart',
        'lib/feature.dart',
        'lib/functional.dart',
        'lib/graph.dart',
        'lib/interval.dart',
        'lib/math.dart',
        'lib/number.dart',
        'lib/pragma.dart',
        'lib/printer.dart',
        'lib/temporal.dart',
        'lib/tuple.dart',
      ]);
    });
  });

  group('dependencies', () {
    test('no top-level imports', () {
      check(
        graph.edges
            .where(
              (edge) =>
                  edge.source != 'lib/more.dart' &&
                  !edge.target.startsWith('lib/src/'),
            )
            .map((edge) => '${edge.source} -> ${edge.target}'),
      ).isEmpty();
    });

    test('no cycles', () {
      check(
        graph.stronglyConnected().where(
          (scc) =>
              scc.length > 1 || graph.getEdge(scc.first, scc.first) != null,
        ),
      ).isEmpty();
    });
  });

  group('reachability', () {
    test('no orphan files', () {
      check(
        graph.vertices
            .where((file) => file.startsWith('lib/src/'))
            .where((file) => graph.predecessorsOf(file).isEmpty),
      ).isEmpty();
    });

    test('all files reachable from root', () {
      final roots = graph.vertices.where(
        (file) => !file.startsWith('lib/src/'),
      );
      final reachable = <String>{...roots.expand(graph.depthFirst)};
      check(graph.vertices.where((file) => !reachable.contains(file)))
          .isEmpty();
    });
  });
}

/// Creates a dependency graph of all Dart files in the `lib` directory.
Graph<String, void> createDependencyGraph() {
  final graph = Graph<String, void>(isDirected: true);
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
  final directivePattern = RegExp(
    r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
    multiLine: true,
  );

  for (final file in files) {
    final source = file.path.replaceAll(r'\', '/');
    graph.addVertex(source);
    final content = file.readAsStringSync();
    for (final match in directivePattern.allMatches(content)) {
      final uri = match.group(1)!;
      if (uri.startsWith('dart:') ||
          (uri.startsWith('package:') && !uri.startsWith('package:more/'))) {
        continue;
      }
      final target = uri.startsWith('package:more/')
          ? 'lib/${uri.removePrefix('package:more/')}'
          : Uri.file(source).resolve(uri).toFilePath().replaceAll(r'\', '/');
      graph.addEdge(source, target);
    }
  }
  return graph;
}

/// Identifies the sub-library name for a given file path.
String? subLibraryOf(String path) {
  if (path.startsWith('lib/src/')) {
    return path.removePrefix('lib/src/').takeTo('/');
  } else if (path.startsWith('lib/') && path != 'lib/more.dart') {
    return path.removePrefix('lib/').removeSuffix('.dart');
  }
  return null;
}

/// Returns the short label for a given file path.
String vertexLabel(String vertex) {
  if (vertex.startsWith('lib/src/')) {
    final rest = vertex.removePrefix('lib/src/');
    return rest.contains('/') ? rest.skipTo('/') : rest;
  }
  return vertex.removePrefix('lib/');
}
