import 'dart:io';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  late final graph = createDependencyGraph();

  setUpAll(() {
    final dot = graph.toDot(
      graphAttributes: const {
        'rankdir': 'LR',
        'concentrate': 'true',
        'newrank': 'true',
        'compound': 'true',
        'fontname': 'Helvetica,Arial,sans-serif',
        'nodesep': '0.2',
        'ranksep': '0.5',
      },
      subgraph: subLibraryOf,
      subgraphName: (subgraph) => 'cluster_$subgraph',
      subgraphLabel: (subgraph) => subgraph,
      subgraphAttributes: (subgraph) => const {
        'style': 'filled,rounded',
        'fillcolor': '#f8fafc',
        'color': '#94a3b8',
        'fontname': 'Helvetica,Arial,sans-serif',
        'fontsize': '13',
        'fontcolor': '#0f172a',
        'labeljust': 'l',
        'penwidth': '1.5',
      },
      vertexLabel: (vertex) {
        final normalized = vertex.replaceAll(r'\', '/');
        if (normalized == 'lib/more.dart') return 'more.dart';
        if (normalized.startsWith('lib/src/')) {
          final sub = normalized.substring('lib/src/'.length);
          final slash = sub.indexOf('/');
          return slash != -1 ? sub.substring(slash + 1) : sub;
        }
        if (normalized.startsWith('lib/')) {
          return normalized.substring('lib/'.length);
        }
        return normalized;
      },
      vertexAttributes: (vertex) {
        final isRoot = !vertex.startsWith('lib/src/');
        if (vertex == 'lib/more.dart') {
          return const {
            'shape': 'box',
            'style': 'filled,rounded',
            'fillcolor': '#1e40af',
            'fontcolor': '#ffffff',
            'fontname': 'Helvetica,Arial,sans-serif',
            'fontsize': '11',
            'penwidth': '2.0',
            'color': '#1d4ed8',
          };
        } else if (isRoot) {
          return const {
            'shape': 'box',
            'style': 'filled,rounded',
            'fillcolor': '#dbeafe',
            'fontcolor': '#1e3a8a',
            'fontname': 'Helvetica,Arial,sans-serif',
            'fontsize': '10',
            'penwidth': '1.5',
            'color': '#3b82f6',
          };
        }
        return const {
          'shape': 'box',
          'style': 'filled,rounded',
          'fillcolor': '#ffffff',
          'fontcolor': '#334155',
          'fontname': 'Helvetica,Arial,sans-serif',
          'fontsize': '9',
          'color': '#cbd5e1',
          'height': '0.2',
          'margin': '0.08,0.03',
        };
      },
      edgeAttributes: (edge) {
        if (edge.source == 'lib/more.dart') {
          return const {
            'color': '#93c5fd',
            'weight': '0',
            'arrowsize': '0.6',
            'style': 'dashed',
          };
        }
        final sourceLib = subLibraryOf(edge.source);
        final targetLib = subLibraryOf(edge.target);
        final isInternal = sourceLib != null && sourceLib == targetLib;
        if (isInternal) {
          return const {'color': '#cbd5e1', 'weight': '3', 'arrowsize': '0.5'};
        }
        return const {
          'color': '#2563eb',
          'weight': '1',
          'arrowsize': '0.7',
          'penwidth': '1.5',
        };
      },
    );
    final dotFile = File('docs/deps.dot');
    dotFile.parent.createSync(recursive: true);
    dotFile.writeAsStringSync(dot);
  });

  group('structure', () {
    test('contains all library files', () {
      check(graph.vertices.length).isGreaterThan(250);
      check(graph)
        ..hasFile('lib/more.dart')
        ..hasFile('lib/async.dart')
        ..hasFile('lib/cache.dart')
        ..hasFile('lib/char_matcher.dart')
        ..hasFile('lib/collection.dart')
        ..hasFile('lib/comparator.dart')
        ..hasFile('lib/diff.dart')
        ..hasFile('lib/feature.dart')
        ..hasFile('lib/functional.dart')
        ..hasFile('lib/graph.dart')
        ..hasFile('lib/interval.dart')
        ..hasFile('lib/math.dart')
        ..hasFile('lib/number.dart')
        ..hasFile('lib/pragma.dart')
        ..hasFile('lib/printer.dart')
        ..hasFile('lib/temporal.dart')
        ..hasFile('lib/tuple.dart');
    });
  });

  group('umbrella library', () {
    test('nothing depends on the umbrella library', () {
      check(graph).hasNoIncomingDependencies('lib/more.dart');
    });

    test('directly exports public sub-libraries', () {
      check(graph)
        ..hasDirectDependency('lib/more.dart', 'lib/async.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/cache.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/char_matcher.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/collection.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/comparator.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/feature.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/functional.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/graph.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/interval.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/math.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/number.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/pragma.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/printer.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/temporal.dart')
        ..hasDirectDependency('lib/more.dart', 'lib/tuple.dart');
    });

    test('transitively reaches internal implementations', () {
      check(graph)
        ..hasTransitiveDependency('lib/more.dart', 'lib/src/async/buffer.dart')
        ..hasTransitiveDependency(
          'lib/more.dart',
          'lib/src/collection/multimap/list.dart',
        )
        ..hasTransitiveDependency(
          'lib/more.dart',
          'lib/src/graph/operations/export.dart',
        )
        ..hasTransitiveDependency(
          'lib/more.dart',
          'lib/src/tuple/tuple_2.dart',
        );
    });
  });

  group('sub-library entry points', () {
    test('exports internal implementations', () {
      check(graph)
        ..hasDirectDependency('lib/async.dart', 'lib/src/async/buffer.dart')
        ..hasDirectDependency('lib/cache.dart', 'lib/src/cache/cache.dart')
        ..hasDirectDependency(
          'lib/char_matcher.dart',
          'lib/src/char_matcher/char_matcher.dart',
        )
        ..hasDirectDependency(
          'lib/collection.dart',
          'lib/src/collection/bimap.dart',
        )
        ..hasDirectDependency(
          'lib/comparator.dart',
          'lib/src/comparator/constructors/natural.dart',
        )
        ..hasDirectDependency(
          'lib/diff.dart',
          'lib/src/diff/sequence_matcher.dart',
        )
        ..hasDirectDependency('lib/graph.dart', 'lib/src/graph/graph.dart')
        ..hasDirectDependency(
          'lib/interval.dart',
          'lib/src/interval/interval.dart',
        )
        ..hasDirectDependency('lib/math.dart', 'lib/src/math/primes/sieve.dart')
        ..hasDirectDependency('lib/number.dart', 'lib/src/number/fraction.dart')
        ..hasDirectDependency(
          'lib/printer.dart',
          'lib/src/printer/printer.dart',
        )
        ..hasDirectDependency(
          'lib/temporal.dart',
          'lib/src/temporal/interval/duration.dart',
        )
        ..hasDirectDependency('lib/tuple.dart', 'lib/src/tuple/tuple_2.dart');
    });
  });

  group('isolation', () {
    test('independent libraries have no direct dependencies', () {
      check(graph)
        ..hasNoDirectDependency('lib/tuple.dart', 'lib/graph.dart')
        ..hasNoDirectDependency('lib/async.dart', 'lib/more.dart');
    });

    test('independent libraries have no transitive dependencies', () {
      check(graph)
        ..hasNoTransitiveDependency('lib/tuple.dart', 'lib/graph.dart')
        ..hasNoTransitiveDependency('lib/tuple.dart', 'lib/math.dart')
        ..hasNoTransitiveDependency('lib/tuple.dart', 'lib/printer.dart')
        ..hasNoTransitiveDependency('lib/async.dart', 'lib/math.dart')
        ..hasNoTransitiveDependency('lib/async.dart', 'lib/printer.dart')
        ..hasNoTransitiveDependency('lib/interval.dart', 'lib/cache.dart')
        ..hasNoTransitiveDependency('lib/interval.dart', 'lib/graph.dart')
        ..hasNoTransitiveDependency('lib/feature.dart', 'lib/graph.dart');
    });

    test('sub-libraries do not depend on the umbrella library', () {
      check(graph)
        ..hasNoTransitiveDependency('lib/async.dart', 'lib/more.dart')
        ..hasNoTransitiveDependency('lib/tuple.dart', 'lib/more.dart')
        ..hasNoTransitiveDependency('lib/feature.dart', 'lib/more.dart')
        ..hasNoTransitiveDependency('lib/functional.dart', 'lib/more.dart');
    });
  });

  group('orphans', () {
    test('all internal files are imported or exported', () {
      check(graph).hasNoOrphans();
    });

    test('all files are reachable from root libraries', () {
      check(graph).allFilesReachable();
    });
  });
}

/// Creates a dependency graph of all Dart files in the `lib` directory.
Graph<String, void> createDependencyGraph() {
  final graph = Graph<String, void>(isDirected: true);
  final libDir = Directory('lib');
  final files = libDir
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
      final String target;
      if (uri.startsWith('package:more/')) {
        target = 'lib/${uri.substring('package:more/'.length)}';
      } else {
        target = Uri.file(source)
            .resolve(uri)
            .toFilePath()
            .replaceAll(r'\', '/');
      }
      graph.addEdge(source, target);
    }
  }
  return graph;
}

/// Identifies the sub-library name for a given file path.
String? subLibraryOf(String path) {
  final normalized = path.replaceAll(r'\', '/');
  if (normalized.startsWith('lib/src/')) {
    final parts = normalized.substring('lib/src/'.length).split('/');
    return parts.first;
  } else if (normalized.startsWith('lib/')) {
    final file = normalized.substring('lib/'.length);
    final name = file.replaceAll('.dart', '');
    return name == 'more' ? null : name;
  }
  return null;
}

extension DependencyGraphChecks on Subject<Graph<String, void>> {
  /// Asserts that [file] is a vertex in the dependency graph.
  void hasFile(String file) =>
      has((g) => g.vertices.contains(file), 'contains file $file').isTrue();

  /// Asserts that nothing directly depends on [file].
  void hasNoIncomingDependencies(String file) => has(
    (g) => g.predecessorsOf(file),
    'incoming dependencies to $file',
  ).isEmpty();

  /// Asserts that [source] directly depends on [target].
  void hasDirectDependency(String source, String target) => has(
    (g) => g.getEdge(source, target) != null,
    'has direct dependency from $source to $target',
  ).isTrue();

  /// Asserts that [source] does not directly depend on [target].
  void hasNoDirectDependency(String source, String target) => has(
    (g) => g.getEdge(source, target) != null,
    'has no direct dependency from $source to $target',
  ).isFalse();

  /// Asserts that [source] transitively depends on [target].
  void hasTransitiveDependency(String source, String target) => has(
    (g) => g.shortestPath(source, target) != null,
    'has transitive dependency from $source to $target',
  ).isTrue();

  /// Asserts that [source] does not transitively depend on [target].
  void hasNoTransitiveDependency(String source, String target) => has(
    (g) => g.shortestPath(source, target) != null,
    'has no transitive dependency from $source to $target',
  ).isFalse();

  /// Asserts that all internal implementation files under `lib/src/` have at
  /// least one incoming dependency.
  void hasNoOrphans() => has(
    (g) => g.vertices
        .where((file) => file.startsWith('lib/src/'))
        .where((file) => g.predecessorsOf(file).isEmpty),
    'orphan internal files',
  ).isEmpty();

  /// Asserts that all files are transitively reachable from public library
  /// entry points (`lib/*.dart`).
  void allFilesReachable() => has((g) {
    final rootFiles = g.vertices.where((f) => !f.startsWith('lib/src/'));
    final reachable = <String>{};
    for (final root in rootFiles) {
      reachable.addAll(g.depthFirst(root));
    }
    return g.vertices.where((f) => !reachable.contains(f));
  }, 'unreachable files').isEmpty();
}
