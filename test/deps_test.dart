@TestOn('vm')
library;

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

/// Major architectural subsystems in `package:more`.
enum Subsystem {
  async('#f4d7d7'),
  cache('#f4e2d7'),
  charMatcher('#f4edd7', dirName: 'char_matcher'),
  collection('#f0f4d7'),
  comparator('#e6f4d7'),
  diff('#dbf4d7', isExported: false),
  feature('#d7f4de'),
  functional('#d7f4e9'),
  graph('#d7f4f4'),
  interval('#d7e9f4'),
  math('#d7def4'),
  number('#dbd7f4'),
  pragma('#e6d7f4'),
  printer('#f0d7f4'),
  temporal('#f4d7ed'),
  tuple('#f4d7e2');

  new(this.color, {this.dirName, this.isExported = true});

  final String color;
  final String? dirName;
  final bool isExported;

  String get directory => dirName ?? name;
  String get entrypoint => 'lib/$directory.dart';
  String get sourceDir => 'lib/src/$directory/';

  static Subsystem? byNameOrNull(String? name) {
    for (final s in values) {
      if (s.directory == name || s.name == name) return s;
    }
    return null;
  }

  bool containsPath(String path) =>
      path == entrypoint || path.startsWith(sourceDir);
}

void main() {
  late final filesGraph = createFilesGraph();
  late final libsGraph = createLibsGraph(filesGraph);

  setUpAll(() {
    final filesDot = filesGraph.toDot(
      graphAttributes: const {'rankdir': 'LR', 'concentrate': 'true'},
      subgraph: subLibraryOf,
      subgraphName: (subgraph) => 'cluster_$subgraph',
      subgraphLabel: (subgraph) => subgraph,
      subgraphAttributes: (subgraph) => {
        'style': 'rounded,filled',
        'fillcolor': Subsystem.byNameOrNull(subgraph)?.color ?? '#f8f9fa',
      },
      vertexLabel: vertexLabel,
      vertexAttributes: (vertex) => {
        'shape': 'box',
        'style': 'rounded,filled',
        'fillcolor': '#ffffff',
      },
      edgeAttributes: (edge) => const {'arrowsize': '0.8'},
    );
    final filesDotFile = File('doc/files_deps.dot');
    filesDotFile.parent.createSync(recursive: true);
    filesDotFile.writeAsStringSync(filesDot);

    final libsDot = libsGraph.toDot(
      graphAttributes: const {'rankdir': 'LR'},
      vertexAttributes: (vertex) => {
        'shape': 'box',
        'style': 'rounded,filled',
        'fillcolor': Subsystem.byNameOrNull(vertex)?.color ?? '#f0f4f8',
      },
      edgeAttributes: (edge) => const {'arrowsize': '0.8'},
    );
    final libsDotFile = File('doc/libs_deps.dot');
    libsDotFile.parent.createSync(recursive: true);
    libsDotFile.writeAsStringSync(libsDot);
  });

  group('umbrella', () {
    test('no incoming dependencies', () {
      check(filesGraph.predecessorsOf('lib/more.dart')).isEmpty();
    });

    test('exports all public sub-libraries', () {
      check(filesGraph.successorsOf('lib/more.dart')).unorderedEquals(
        Subsystem.values
            .where((s) => s.isExported)
            .map((s) => s.entrypoint)
            .toList(),
      );
    });
  });

  group('dependencies', () {
    test('no top-level imports', () {
      final badEdges = filesGraph.edges
          .where(
            (edge) =>
                edge.source != 'lib/more.dart' &&
                !edge.target.startsWith('lib/src/'),
          )
          .map((edge) => '${edge.source} -> ${edge.target}')
          .toList();
      check(badEdges).isEmpty();
    });

    test('no cycles between sub-libraries', () {
      check(
        libsGraph.stronglyConnected().where(
          (scc) =>
              scc.length > 1 || libsGraph.getEdge(scc.first, scc.first) != null,
        ),
      ).isEmpty();
    });
  });

  group('reachability', () {
    test('no orphan files', () {
      check(
        filesGraph.vertices
            .where((file) => file.startsWith('lib/src/'))
            .where((file) => filesGraph.predecessorsOf(file).isEmpty),
      ).isEmpty();
    });

    test('all files reachable from root', () {
      final roots = filesGraph.vertices.where(
        (file) => !file.startsWith('lib/src/'),
      );
      final reachable = <String>{...roots.expand(filesGraph.depthFirst)};
      check(filesGraph.vertices.where((file) => !reachable.contains(file)))
          .isEmpty();
    });
  });

  group('architectural decoupling', () {
    Set<Subsystem> reachedSubsystems(Subsystem subsystem) {
      final reachable = filesGraph.breadthFirst(subsystem.entrypoint);
      final reached = <Subsystem>{};
      for (final file in reachable) {
        for (final other in Subsystem.values) {
          if (other != subsystem && other.containsPath(file)) {
            reached.add(other);
          }
        }
      }
      return reached;
    }

    test('async is completely self-contained', () {
      check(reachedSubsystems(Subsystem.async)).isEmpty();
    });

    test('feature is completely self-contained', () {
      check(reachedSubsystems(Subsystem.feature)).isEmpty();
    });

    test('functional is completely self-contained', () {
      check(reachedSubsystems(Subsystem.functional)).isEmpty();
    });

    test('tuple is completely self-contained', () {
      check(reachedSubsystems(Subsystem.tuple)).isEmpty();
    });

    test('pragma depends only on feature', () {
      check(reachedSubsystems(Subsystem.pragma))
          .unorderedEquals([Subsystem.feature]);
    });

    test('comparator depends only on functional', () {
      check(reachedSubsystems(Subsystem.comparator))
          .unorderedEquals([Subsystem.functional]);
    });

    test('interval depends only on collection', () {
      check(reachedSubsystems(Subsystem.interval))
          .unorderedEquals([Subsystem.collection]);
    });

    test('temporal depends only on collection and interval', () {
      check(reachedSubsystems(Subsystem.temporal))
          .unorderedEquals([Subsystem.collection, Subsystem.interval]);
    });

    group('decoupling from graph', () {
      final nonGraph = Subsystem.values.where((s) => s != Subsystem.graph);
      for (final s in nonGraph) {
        test('${s.directory} never transitively depends on graph', () {
          check(reachedSubsystems(s))
              .not((sub) => sub.contains(Subsystem.graph));
        });
      }
    });

    group('decoupling from cache', () {
      final nonCache = Subsystem.values.where((s) => s != Subsystem.cache);
      for (final s in nonCache) {
        test('${s.directory} never transitively depends on cache', () {
          check(reachedSubsystems(s))
              .not((sub) => sub.contains(Subsystem.cache));
        });
      }
    });

    group('decoupling from diff', () {
      final nonDiff = Subsystem.values.where((s) => s != Subsystem.diff);
      for (final s in nonDiff) {
        test('${s.directory} never transitively depends on diff', () {
          check(reachedSubsystems(s))
              .not((sub) => sub.contains(Subsystem.diff));
        });
      }
    });
  });
}

/// Creates a dependency graph of all Dart files in the `lib` directory.
Graph<String, void> createFilesGraph() {
  final filesGraph = Graph<String, void>(isDirected: true);
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
  final directivePattern = RegExp(
    r'''^\s*(?:import|export|part)\b[^;]+;''',
    multiLine: true,
  );
  final stringPattern = RegExp(r'''['"]([^'"]+)['"]''');
  for (final file in files) {
    final source = file.path.replaceAll(r'\', '/');
    filesGraph.addVertex(source);
    final content = file.readAsStringSync();
    for (final match in directivePattern.allMatches(content)) {
      final directive = match.group(0)!;
      if (directive.trimLeft().startsWith('part of')) continue;
      for (final stringMatch in stringPattern.allMatches(directive)) {
        final uri = stringMatch.group(1)!;
        if (uri.startsWith('dart:') ||
            (uri.startsWith('package:') && !uri.startsWith('package:more/'))) {
          continue;
        }
        final target = uri.startsWith('package:more/')
            ? 'lib/${uri.removePrefix('package:more/')}'
            : Uri.file(source).resolve(uri).toFilePath().replaceAll(r'\', '/');
        filesGraph.addEdge(source, target);
      }
    }
  }
  return filesGraph;
}

/// Creates a coarse dependency graph between sub-libraries.
Graph<String, void> createLibsGraph(Graph<String, void> filesGraph) {
  final libsGraph = Graph<String, void>(isDirected: true);
  for (final edge in filesGraph.edges) {
    final sourceLib = subLibraryOf(edge.source);
    final targetLib = subLibraryOf(edge.target);
    if (sourceLib != null && targetLib != null && sourceLib != targetLib) {
      libsGraph.addEdge(sourceLib, targetLib);
    }
  }
  return libsGraph;
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
