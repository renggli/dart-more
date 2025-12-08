import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:more/functional.dart';
import 'package:more/graph.dart';
import 'package:more/math.dart';
import 'package:test/test.dart';

import '../utils/graph.dart';

void main() {
  group('search', () {
    test('directed path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      final allShortestPaths = graph.allShortestPaths();
      for (var i = 0; i < 10; i++) {
        expect(graph.shortestPath(0, i), isPath(source: 0, target: i, cost: i));
        expect(allShortestPaths.distance(0, i), i);
        expect(
          allShortestPaths.path(0, i),
          isPath(source: 0, target: i, cost: i),
        );
        if (i != 0) {
          expect(graph.shortestPath(i, 0), isNull);
          expect(allShortestPaths.distance(i, 0), double.infinity);
          expect(allShortestPaths.path(i, 0), isNull);
        }
      }
    });
    test('directed path with alternatives', () {
      final builder = GraphFactory<int, void>().newBuilder()
        ..addEdge(0, 1)
        ..addEdge(0, 2)
        ..addEdge(1, 3)
        ..addEdge(2, 3)
        ..addEdge(3, 4)
        ..addEdge(3, 5)
        ..addEdge(4, 6)
        ..addEdge(5, 6)
        ..addEdge(6, 7);
      final graph = builder.build();
      expect(graph.shortestPath(0, 7), isNot(isNull));
      expect(graph.shortestPathAll(0), hasLength(8));
      expect(
        graph.shortestPathAll(
          0,
          targetPredicate: (v) => v == 7,
          includeAlternativePaths: true,
        ),
        unorderedEquals([
          isPath(vertices: [0, 1, 3, 4, 6, 7], cost: 5),
          isPath(vertices: [0, 1, 3, 5, 6, 7], cost: 5),
          isPath(vertices: [0, 2, 3, 4, 6, 7], cost: 5),
          isPath(vertices: [0, 2, 3, 5, 6, 7], cost: 5),
        ]),
      );
    });
    test('directed path with cost', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      int edgeCost(int _, int target) => target;
      final allShortestPaths = graph.allShortestPaths(edgeCost: edgeCost);
      for (var i = 0; i < 10; i++) {
        final cost = i * (i + 1) ~/ 2;
        expect(
          graph.shortestPath(0, i, edgeCost: edgeCost),
          isPath(source: 0, target: i, cost: cost),
        );
        expect(allShortestPaths.distance(0, i), cost);
        expect(
          allShortestPaths.path(0, i),
          isPath(source: 0, target: i, cost: cost),
        );
        if (i != 0) {
          expect(graph.shortestPath(i, 0, edgeCost: edgeCost), isNull);
          expect(allShortestPaths.distance(i, 0), double.infinity);
          expect(allShortestPaths.path(i, 0), isNull);
        }
      }
    });
    test('directed path with cost on edge', () {
      final graph = GraphFactory<int, int>(
        edgeProvider: (source, target) => target,
      ).path(vertexCount: 10);
      final allShortestPaths = graph.allShortestPaths();
      for (var i = 0; i < 10; i++) {
        final cost = i * (i + 1) ~/ 2;
        expect(
          graph.shortestPath(0, i),
          isPath(source: 0, target: i, cost: cost),
        );
        expect(allShortestPaths.distance(0, i), cost);
        expect(
          allShortestPaths.path(0, i),
          isPath(source: 0, target: i, cost: cost),
        );
        if (i != 0) {
          expect(graph.shortestPath(i, 0), isNull);
          expect(allShortestPaths.distance(i, 0), double.infinity);
          expect(allShortestPaths.path(i, 0), isNull);
        }
      }
    });
    test('undirected path', () {
      final graph = GraphFactory<int, void>(
        isDirected: false,
      ).path(vertexCount: 10);
      final allShortestPaths = graph.allShortestPaths();
      for (var i = 0; i < 10; i++) {
        expect(graph.shortestPath(0, i), isPath(source: 0, target: i, cost: i));
        expect(graph.shortestPath(i, 0), isPath(source: i, target: 0, cost: i));
        expect(allShortestPaths.distance(0, i), i);
        expect(
          allShortestPaths.path(0, i),
          isPath(source: 0, target: i, cost: i),
        );
        expect(allShortestPaths.distance(i, 0), i);
        expect(
          allShortestPaths.path(i, 0),
          isPath(source: i, target: 0, cost: i),
        );
      }
    });
    test('undirected graph with edge cost', () {
      expect(
        dijkstraGraph.shortestPath(1, 5),
        isPath(source: 1, target: 5, vertices: [1, 3, 6, 5], cost: 20),
      );
      expect(
        dijkstraGraph.shortestPathAll(1),
        unorderedEquals([
          isPath(vertices: [1], cost: 0),
          isPath(vertices: [1, 2], cost: 7),
          isPath(vertices: [1, 3], cost: 9),
          isPath(vertices: [1, 3, 6], cost: 11),
          isPath(vertices: [1, 3, 4], cost: 20),
          isPath(vertices: [1, 3, 6, 5], cost: 20),
        ]),
      );
      expect(
        dijkstraGraph.allShortestPaths().allPaths(),
        unorderedEquals([
          isPath(vertices: [1], cost: 0),
          isPath(vertices: [1, 2], cost: 7),
          isPath(vertices: [1, 3], cost: 9),
          isPath(vertices: [1, 3, 4], cost: 20),
          isPath(vertices: [1, 3, 6, 5], cost: 20),
          isPath(vertices: [1, 3, 6], cost: 11),
          isPath(vertices: [2, 1], cost: 7),
          isPath(vertices: [2], cost: 0),
          isPath(vertices: [2, 3], cost: 10),
          isPath(vertices: [2, 4], cost: 15),
          isPath(vertices: [2, 3, 6, 5], cost: 21),
          isPath(vertices: [2, 3, 6], cost: 12),
          isPath(vertices: [3, 1], cost: 9),
          isPath(vertices: [3, 2], cost: 10),
          isPath(vertices: [3], cost: 0),
          isPath(vertices: [3, 4], cost: 11),
          isPath(vertices: [3, 6, 5], cost: 11),
          isPath(vertices: [3, 6], cost: 2),
          isPath(vertices: [4, 3, 1], cost: 20),
          isPath(vertices: [4, 2], cost: 15),
          isPath(vertices: [4, 3], cost: 11),
          isPath(vertices: [4], cost: 0),
          isPath(vertices: [4, 5], cost: 6),
          isPath(vertices: [4, 3, 6], cost: 13),
          isPath(vertices: [5, 6, 3, 1], cost: 20),
          isPath(vertices: [5, 6, 3, 2], cost: 21),
          isPath(vertices: [5, 6, 3], cost: 11),
          isPath(vertices: [5, 4], cost: 6),
          isPath(vertices: [5], cost: 0),
          isPath(vertices: [5, 6], cost: 9),
          isPath(vertices: [6, 3, 1], cost: 11),
          isPath(vertices: [6, 3, 2], cost: 12),
          isPath(vertices: [6, 3], cost: 2),
          isPath(vertices: [6, 3, 4], cost: 13),
          isPath(vertices: [6, 5], cost: 9),
          isPath(vertices: [6], cost: 0),
        ]),
      );
    });
    test('undirected graph with constant cost', () {
      expect(
        dijkstraGraph.shortestPath(1, 5, edgeCost: constantFunction2(1)),
        isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2),
      );
      expect(
        dijkstraGraph.shortestPathAll(1, edgeCost: constantFunction2(1)),
        unorderedEquals([
          isPath(vertices: [1], cost: 0),
          isPath(vertices: [1, 6], cost: 1),
          isPath(vertices: [1, 3], cost: 1),
          isPath(vertices: [1, 2], cost: 1),
          isPath(vertices: [1, 3, 4], cost: 2),
          isPath(vertices: [1, 6, 5], cost: 2),
        ]),
      );
      expect(
        dijkstraGraph
            .allShortestPaths(edgeCost: constantFunction2(1))
            .allPaths(),
        unorderedEquals([
          isPath(vertices: [1], cost: 0),
          isPath(vertices: [1, 2], cost: 1),
          isPath(vertices: [1, 3], cost: 1),
          isPath(vertices: [1, 2, 4], cost: 2),
          isPath(vertices: [1, 6, 5], cost: 2),
          isPath(vertices: [1, 6], cost: 1),
          isPath(vertices: [2, 1], cost: 1),
          isPath(vertices: [2], cost: 0),
          isPath(vertices: [2, 3], cost: 1),
          isPath(vertices: [2, 4], cost: 1),
          isPath(vertices: [2, 4, 5], cost: 2),
          isPath(vertices: [2, 1, 6], cost: 2),
          isPath(vertices: [3, 1], cost: 1),
          isPath(vertices: [3, 2], cost: 1),
          isPath(vertices: [3], cost: 0),
          isPath(vertices: [3, 4], cost: 1),
          isPath(vertices: [3, 6, 5], cost: 2),
          isPath(vertices: [3, 6], cost: 1),
          isPath(vertices: [6, 1], cost: 1),
          isPath(vertices: [6, 1, 2], cost: 2),
          isPath(vertices: [6, 3], cost: 1),
          isPath(vertices: [6, 3, 4], cost: 2),
          isPath(vertices: [6, 5], cost: 1),
          isPath(vertices: [6], cost: 0),
          isPath(vertices: [4, 2, 1], cost: 2),
          isPath(vertices: [4, 2], cost: 1),
          isPath(vertices: [4, 3], cost: 1),
          isPath(vertices: [4], cost: 0),
          isPath(vertices: [4, 5], cost: 1),
          isPath(vertices: [4, 3, 6], cost: 2),
          isPath(vertices: [5, 6, 1], cost: 2),
          isPath(vertices: [5, 4, 2], cost: 2),
          isPath(vertices: [5, 6, 3], cost: 2),
          isPath(vertices: [5, 4], cost: 1),
          isPath(vertices: [5], cost: 0),
          isPath(vertices: [5, 6], cost: 1),
        ]),
      );
    });
    test('undirected graph with cost estimate', () {
      expect(
        dijkstraGraph.shortestPath(
          1,
          5,
          edgeCost: constantFunction2(1),
          costEstimate: (vertex) => 6 - vertex,
        ),
        isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2),
      );
      expect(
        dijkstraGraph.shortestPathAll(
          1,
          edgeCost: constantFunction2(1),
          costEstimate: (vertex) => 6 - vertex,
        ),
        unorderedEquals([
          isPath(vertices: [1], cost: 0),
          isPath(vertices: [1, 6], cost: 1),
          isPath(vertices: [1, 3], cost: 1),
          isPath(vertices: [1, 2], cost: 1),
          isPath(vertices: [1, 3, 4], cost: 2),
          isPath(vertices: [1, 6, 5], cost: 2),
        ]),
      );
    });
    test('undirected graph with cost estimate and negative edges', () {
      expect(
        () => dijkstraGraph.shortestPath(
          1,
          5,
          edgeCost: constantFunction2(1),
          costEstimate: (vertex) => 6 - vertex,
          hasNegativeEdges: true,
        ),
        throwsGraphError,
      );
      expect(
        () => dijkstraGraph.shortestPathAll(
          1,
          edgeCost: constantFunction2(1),
          costEstimate: (vertex) => 6 - vertex,
          hasNegativeEdges: true,
        ),
        throwsGraphError,
      );
    });
    test('unsupported negative edges', () {
      expect(() => bellmanFordGraph.shortestPath('s', 'z'), throwsGraphError);
      expect(
        () => bellmanFordGraph.shortestPath(
          's',
          'z',
          costEstimate: constantFunction1(1),
        ),
        throwsGraphError,
      );
    });
    test('directed graph with negative edges', () {
      expect(
        bellmanFordGraph.shortestPath('s', 'z', hasNegativeEdges: true),
        isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2),
      );
      expect(
        bellmanFordGraph.shortestPathAll('s', hasNegativeEdges: true),
        unorderedEquals([
          isPath(vertices: ['s'], cost: 0),
          isPath(vertices: ['s', 'y'], cost: 7),
          isPath(vertices: ['s', 'y', 'x'], cost: 4),
          isPath(vertices: ['s', 'y', 'x', 't'], cost: 2),
          isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2),
        ]),
      );
      final allShortestPaths = bellmanFordGraph.allShortestPaths();
      expect(
        allShortestPaths.allPaths(sourceVertices: ['s']),
        unorderedEquals([
          isPath(vertices: ['s'], cost: 0),
          isPath(vertices: ['s', 'y'], cost: 7),
          isPath(vertices: ['s', 'y', 'x'], cost: 4),
          isPath(vertices: ['s', 'y', 'x', 't'], cost: 2),
          isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2),
        ]),
      );
      expect(
        allShortestPaths.allPaths(targetVertices: ['z']),
        unorderedEquals([
          isPath(vertices: ['z'], cost: 0),
          isPath(vertices: ['t', 'z'], cost: -4),
          isPath(vertices: ['x', 't', 'z'], cost: -6),
          isPath(vertices: ['y', 'x', 't', 'z'], cost: -9),
          isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2),
        ]),
      );
    });
    test('directed graph with negative edge', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: 3);
      final path = graph.shortestPath(0, 2, hasNegativeEdges: true);
      expect(path, isPath(source: 0, target: 2, cost: 1));
      expect(
        graph.allShortestPaths().path(0, 2),
        isPath(source: 0, target: 2, cost: 1),
      );
    });
    test('directed graph with negative cycle', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: -3)
        ..addEdge(2, 0, value: -1);
      expect(
        () => graph.shortestPath(0, 2, hasNegativeEdges: true),
        throwsGraphError,
      );
      expect(graph.allShortestPaths, throwsGraphError);
    });
    test('directed graph with negative edge and positive cycle', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: 3)
        ..addEdge(2, 0, value: 1);
      final path = graph.shortestPath(0, 2, hasNegativeEdges: true);
      expect(path, isPath(source: 0, target: 2, cost: 1));
      expect(
        graph.allShortestPaths().path(0, 2),
        isPath(source: 0, target: 2, cost: 1),
      );
    });
    group('hills', () {
      final hills = [
        '00000002345677899876543355557775557777',
        '00110023456678899876543555677777777777',
        '00011234566778998776654555667777777877',
        '00000234566788998776654355666888778777',
        '11000234567778999876554244666888888777',
        '11000034566677899876543244666888888777',
        '21111023456677898776542244466888887777',
        '22221002335667787765432444666888999777',
        '22221001123566777654322444668888777777',
        '22221111112356666543224446668877777777',
        '33222111111135555332224466688888877788',
        '44322211111113331112244466688888877788',
        '54332221111111111112244466666886887777',
      ].map((line) => line.split('').map(int.parse).toList()).toList();
      const source = Point(0, 0), target = Point(12, 37);
      bool targetPredicate(Point<int> vertex) => target == vertex;
      Iterable<Point<int>> successorsOf(Point<int> vertex) =>
          const [
                Point(-1, -1), Point(-1, 0), Point(-1, 1), Point(0, -1), //
                Point(0, 1), Point(1, -1), Point(1, 0), Point(1, 1),
              ]
              .map((offset) => vertex + offset)
              .where(
                (point) =>
                    point.x.between(source.x, target.x) &&
                    point.y.between(source.y, target.y) &&
                    hills[point.x][point.y] < 8,
              );
      num edgeCost(Point<int> source, Point<int> target) =>
          ((source.x - target.x).pow(2) +
                  (source.y - target.y).pow(2) +
                  (2 * hills[source.x][source.y] -
                          2 * hills[target.x][target.y])
                      .pow(2))
              .sqrt();
      num costEstimate(Point<int> vertex) =>
          ((vertex.x - target.x).pow(2) +
                  (vertex.y - target.y).pow(2) +
                  (2 * hills[vertex.x][vertex.y] -
                          2 * hills[target.x][target.y])
                      .pow(2))
              .sqrt();
      test('dijkstra', () {
        final search = dijkstraSearch<Point<int>>(
          startVertices: [source],
          targetPredicate: targetPredicate,
          successorsOf: successorsOf,
        );
        expect(
          search.single,
          isPath(
            source: source,
            target: target,
            vertices: hasLength(46),
            cost: 45,
          ),
        );
      });
      test('dijkstra (custom cost)', () {
        final search = dijkstraSearch<Point<int>>(
          startVertices: [source],
          targetPredicate: targetPredicate,
          successorsOf: successorsOf,
          edgeCost: edgeCost,
        );
        expect(
          search.single,
          isPath(
            source: source,
            target: target,
            vertices: hasLength(47),
            cost: closeTo(63.79, 0.1),
          ),
        );
      });
      test('a-star', () {
        final search = aStarSearch<Point<int>>(
          startVertices: [source],
          targetPredicate: targetPredicate,
          successorsOf: successorsOf,
          costEstimate: costEstimate,
        );
        expect(
          search.single,
          isPath(
            source: source,
            target: target,
            vertices: hasLength(46),
            cost: 45,
          ),
        );
      });
      test('a-star (custom cost)', () {
        final search = aStarSearch<Point<int>>(
          startVertices: [source],
          targetPredicate: targetPredicate,
          successorsOf: successorsOf,
          edgeCost: edgeCost,
          costEstimate: costEstimate,
        );
        expect(
          search.single,
          isPath(
            source: source,
            target: target,
            vertices: hasLength(47),
            cost: closeTo(63.79, 0.1),
          ),
        );
      });
      test('bellman-ford', () {
        final search = bellmanFordSearch<Point<int>>(
          startVertices: [source],
          targetPredicate: targetPredicate,
          successorsOf: successorsOf,
        );
        expect(
          search.single,
          isPath(
            source: source,
            target: target,
            vertices: hasLength(46),
            cost: 45,
          ),
        );
      });
      test('bellman-ford (custom cost)', () {
        final search = bellmanFordSearch<Point<int>>(
          startVertices: [source],
          targetPredicate: targetPredicate,
          successorsOf: successorsOf,
          edgeCost: edgeCost,
        );
        expect(
          search.single,
          isPath(
            source: source,
            target: target,
            vertices: hasLength(47),
            cost: closeTo(63.79, 0.1),
          ),
        );
      });
    });
    group('maze', () {
      final maze = [
        '#########################',
        '        #     #         #',
        '# ### ### # ### ##### # #',
        '# #   #   #     #     # #',
        '# # ### ######### # #####',
        '# #   # #   # #   #     #',
        '# ### # # # # # # # #####',
        '# #   #   #   # # # #   #',
        '# # # ####### # ### # # #',
        '# # #   #     #   # # # #',
        '# # ##### ####### ##### #',
        '# #             #        ',
        '#########################',
      ].map((line) => line.split('').toList()).toList();
      const source = Point(1, 0), target = Point(11, 24);
      bool targetPredicate(Point<int> vertex) => target == vertex;
      Iterable<Point<int>> successorsOf(Point<int> vertex) =>
          const [
                Point(-1, 0), Point(0, -1), Point(0, 1), Point(1, 0), //
              ]
              .map((offset) => vertex + offset)
              .where(
                (point) =>
                    point.x.between(source.x, target.x) &&
                    point.y.between(source.y, target.y) &&
                    maze[point.x][point.y] != '#',
              );
      num costEstimate(Point<int> vertex) =>
          ((vertex.x - target.x).pow(2) + (vertex.y - target.y).pow(2)).sqrt();
      const solution = <Point<int>>[
        Point(1, 0), Point(1, 1), Point(1, 2), Point(1, 3), Point(1, 4), //
        Point(1, 5), Point(2, 5), Point(3, 5), Point(3, 4), Point(3, 3),
        Point(4, 3), Point(5, 3), Point(5, 4), Point(5, 5), Point(6, 5),
        Point(7, 5), Point(7, 4), Point(7, 3), Point(8, 3), Point(9, 3),
        Point(10, 3), Point(11, 3), Point(11, 4), Point(11, 5), Point(11, 6),
        Point(11, 7), Point(11, 8), Point(11, 9), Point(10, 9), Point(9, 9),
        Point(9, 10), Point(9, 11), Point(9, 12), Point(9, 13), Point(8, 13),
        Point(7, 13), Point(7, 12), Point(7, 11), Point(6, 11), Point(5, 11),
        Point(5, 10), Point(5, 9), Point(6, 9), Point(7, 9), Point(7, 8),
        Point(7, 7), Point(6, 7), Point(5, 7), Point(4, 7), Point(3, 7),
        Point(3, 8), Point(3, 9), Point(2, 9), Point(1, 9), Point(1, 10),
        Point(1, 11), Point(2, 11), Point(3, 11), Point(3, 12), Point(3, 13),
        Point(3, 14), Point(3, 15), Point(2, 15), Point(1, 15), Point(1, 16),
        Point(1, 17), Point(1, 18), Point(1, 19), Point(1, 20), Point(1, 21),
        Point(2, 21), Point(3, 21), Point(3, 20), Point(3, 19), Point(3, 18),
        Point(3, 17), Point(4, 17), Point(5, 17), Point(5, 16), Point(5, 15),
        Point(6, 15), Point(7, 15), Point(8, 15), Point(9, 15), Point(9, 16),
        Point(9, 17), Point(10, 17), Point(11, 17), Point(11, 18),
        Point(11, 19), Point(11, 20), Point(11, 21), Point(11, 22),
        Point(11, 23), Point(11, 24),
      ];
      test('dijkstra', () {
        expect(
          dijkstraSearch<Point<int>>(
            startVertices: [source],
            targetPredicate: targetPredicate,
            successorsOf: successorsOf,
          ).single,
          isPath(
            source: source,
            target: target,
            vertices: solution,
            cost: solution.length - 1,
          ),
        );
      });
      test('a-star', () {
        expect(
          aStarSearch<Point<int>>(
            startVertices: [source],
            targetPredicate: targetPredicate,
            successorsOf: successorsOf,
            costEstimate: costEstimate,
          ).single,
          isPath(
            source: source,
            target: target,
            vertices: solution,
            cost: solution.length - 1,
          ),
        );
      });
      test('a-star (bad estimate)', () {
        final generator = Random(85642);
        expect(
          aStarSearch<Point<int>>(
            startVertices: [source],
            targetPredicate: targetPredicate,
            successorsOf: successorsOf,
            costEstimate: (vertex) => generator.nextDouble(),
          ).single,
          isPath(
            source: source,
            target: target,
            vertices: solution,
            cost: solution.length - 1,
          ),
        );
      });
      test('bellman-ford', () {
        expect(
          bellmanFordSearch<Point<int>>(
            startVertices: [source],
            targetPredicate: targetPredicate,
            successorsOf: successorsOf,
          ).single,
          isPath(
            source: source,
            target: target,
            vertices: solution,
            cost: solution.length - 1,
          ),
        );
      });
      test('floyd-warshall', () {
        expect(
          floydWarshallSearch<Point<int>>(
            vertices: BreadthFirstIterable([
              source,
            ], successorsOf: successorsOf),
            successorsOf: successorsOf,
          ).path(source, target),
          isPath(
            source: source,
            target: target,
            vertices: solution,
            cost: solution.length - 1,
          ),
        );
      });
    });
  });
  group('max flow', () {
    test('line with default edge capacity', () {
      final graph = GraphFactory<String, void>().fromPath(['A', 'B', 'C', 'D']);
      final flow = graph.maxFlow();
      expect(flow('A', 'D'), 1);
    });
    test('line with custom edge capacity', () {
      final graph = GraphFactory<String, void>().fromPath(['A', 'B', 'C', 'D']);
      final flow = graph.maxFlow(edgeCapacity: constantFunction2(2));
      expect(flow('A', 'D'), 2);
    });
    test('line with standard edge capacity', () {
      final graph = GraphFactory<String, num>(
        edgeProvider: (a, b) => 3,
      ).fromPath(['A', 'B', 'C', 'D']);
      final flow = graph.maxFlow();
      expect(flow('A', 'D'), 3);
    });
    test('undirected graph', () {
      final graph = GraphFactory<int, void>(
        isDirected: false,
      ).ring(vertexCount: 10);
      final flow = graph.maxFlow();
      expect(flow(0, 4), 2);
    });
    test('error', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 3);
      final flow = graph.maxFlow();
      expect(() => flow(0, 4), throwsArgumentError);
      expect(() => flow(4, 0), throwsArgumentError);
    });
    test('example 1', () {
      final graph = Graph<String, int>(isDirected: true);
      graph.addEdge('S', '1', value: 2);
      graph.addEdge('S', '2', value: 2);
      graph.addEdge('1', 'E', value: 2);
      graph.addEdge('2', 'E', value: 2);
      graph.addEdge('1', '2', value: 1);
      final flow = graph.maxFlow();
      expect(flow('S', 'E'), 4);
      expect(flow('E', 'S'), 0);
    });
    test('example 2', () {
      final graph = Graph<int, int>(isDirected: true);
      graph.addEdge(0, 1, value: 16);
      graph.addEdge(0, 2, value: 13);
      graph.addEdge(1, 2, value: 10);
      graph.addEdge(1, 3, value: 12);
      graph.addEdge(2, 1, value: 4);
      graph.addEdge(2, 4, value: 14);
      graph.addEdge(3, 2, value: 9);
      graph.addEdge(3, 5, value: 20);
      graph.addEdge(4, 3, value: 7);
      graph.addEdge(4, 5, value: 4);
      final flow = graph.maxFlow();
      expect(flow(0, 5), 23);
      expect(flow(5, 0), 0);
    });
    test('example 3', () {
      final graph = Graph<String, int>(isDirected: true);
      graph.addEdge('A', 'B', value: 3);
      graph.addEdge('A', 'D', value: 3);
      graph.addEdge('B', 'C', value: 4);
      graph.addEdge('C', 'A', value: 3);
      graph.addEdge('C', 'D', value: 1);
      graph.addEdge('C', 'E', value: 2);
      graph.addEdge('D', 'E', value: 2);
      graph.addEdge('D', 'F', value: 6);
      graph.addEdge('E', 'B', value: 1);
      graph.addEdge('E', 'G', value: 1);
      graph.addEdge('F', 'G', value: 9);
      final flow = graph.maxFlow();
      expect(flow('A', 'G'), 5);
      expect(flow('G', 'A'), 0);
    });
    test('example 4', () {
      final graph = Graph<String, int>(isDirected: true);
      graph.addEdge('s', 'a', value: 15);
      graph.addEdge('s', 'c', value: 4);
      graph.addEdge('a', 'b', value: 12);
      graph.addEdge('b', 'c', value: 3);
      graph.addEdge('b', 't', value: 7);
      graph.addEdge('c', 'd', value: 10);
      graph.addEdge('d', 'a', value: 5);
      graph.addEdge('d', 't', value: 10);
      final flow = graph.maxFlow();
      expect(flow('s', 't'), 14);
      expect(flow('t', 's'), 0);
    });
  });
  group('min cut', () {
    test('example 1', () {
      final graph = Graph<int, int>(isDirected: false);
      graph.addEdge(1, 2, value: 2);
      graph.addEdge(1, 5, value: 3);
      graph.addEdge(2, 1, value: 2);
      graph.addEdge(2, 3, value: 3);
      graph.addEdge(2, 5, value: 2);
      graph.addEdge(2, 6, value: 2);
      graph.addEdge(3, 2, value: 3);
      graph.addEdge(3, 4, value: 4);
      graph.addEdge(3, 7, value: 2);
      graph.addEdge(4, 3, value: 4);
      graph.addEdge(4, 7, value: 2);
      graph.addEdge(4, 8, value: 2);
      graph.addEdge(5, 1, value: 3);
      graph.addEdge(5, 6, value: 3);
      graph.addEdge(5, 2, value: 2);
      graph.addEdge(6, 2, value: 2);
      graph.addEdge(6, 5, value: 3);
      graph.addEdge(6, 7, value: 1);
      graph.addEdge(7, 6, value: 1);
      graph.addEdge(7, 3, value: 2);
      graph.addEdge(7, 4, value: 2);
      graph.addEdge(7, 8, value: 3);
      graph.addEdge(8, 4, value: 2);
      graph.addEdge(8, 7, value: 3);
      final minCut = graph.minCut();
      expect(minCut.graphs, hasLength(2));
      expect(minCut.graphs.first.vertices, [3, 4, 7, 8]);
      expect(minCut.graphs.last.vertices, [1, 2, 5, 6]);
      expect(
        minCut.edges,
        unorderedEquals([
          isEdge(2, 3, value: 3),
          isEdge(3, 2, value: 3),
          isEdge(6, 7, value: 1),
          isEdge(7, 6, value: 1),
        ]),
      );
      expect(minCut.weight, 4);
    });
    test('example 2', () {
      final graph = Graph<int, void>(isDirected: false);
      graph.addEdge(0, 3);
      graph.addEdge(3, 2);
      graph.addEdge(2, 1);
      graph.addEdge(1, 0);
      graph.addEdge(0, 2);
      graph.addEdge(2, 4);
      graph.addEdge(4, 1);
      final minCut = graph.minCut();
      expect(minCut.graphs, hasLength(2));
      expect(minCut.graphs.first.vertices, unorderedEquals([3]));
      expect(minCut.graphs.last.vertices, unorderedEquals([0, 1, 2, 4]));
      expect(
        minCut.edges,
        unorderedEquals([
          isEdge(0, 3),
          isEdge(3, 0),
          isEdge(2, 3),
          isEdge(3, 2),
        ]),
      );
      expect(minCut.weight, 2);
    });
    test('example 3', () {
      final graph = Graph<int, int>(isDirected: false);
      graph.addEdge(0, 1, value: 2);
      graph.addEdge(0, 4, value: 3);
      graph.addEdge(1, 2, value: 3);
      graph.addEdge(1, 4, value: 2);
      graph.addEdge(1, 5, value: 2);
      graph.addEdge(2, 3, value: 4);
      graph.addEdge(2, 6, value: 2);
      graph.addEdge(3, 6, value: 2);
      graph.addEdge(3, 7, value: 2);
      graph.addEdge(4, 5, value: 3);
      graph.addEdge(5, 6, value: 1);
      graph.addEdge(6, 7, value: 3);
      final minCut = graph.minCut();
      expect(minCut.graphs, hasLength(2));
      expect(minCut.graphs.first.vertices, unorderedEquals([2, 3, 6, 7]));
      expect(minCut.graphs.last.vertices, unorderedEquals([0, 1, 4, 5]));
      expect(
        minCut.edges,
        unorderedEquals([
          isEdge(1, 2, value: 3),
          isEdge(2, 1, value: 3),
          isEdge(5, 6, value: 1),
          isEdge(6, 5, value: 1),
        ]),
      );
      expect(minCut.weight, 4);
    });
    test('example 4', () {
      final graph = Graph<String, int>(isDirected: false);
      graph.addEdge('x', 'a', value: 3);
      graph.addEdge('x', 'b', value: 1);
      graph.addEdge('a', 'c', value: 3);
      graph.addEdge('b', 'c', value: 5);
      graph.addEdge('b', 'd', value: 4);
      graph.addEdge('d', 'e', value: 2);
      graph.addEdge('c', 'y', value: 2);
      graph.addEdge('e', 'y', value: 3);
      final minCut = graph.minCut();
      expect(minCut.graphs, hasLength(2));
      expect(minCut.graphs.first.vertices, unorderedEquals(['e', 'y']));
      expect(
        minCut.graphs.last.vertices,
        unorderedEquals(['x', 'a', 'b', 'c', 'd']),
      );
      expect(
        minCut.edges,
        unorderedEquals([
          isEdge('c', 'y', value: 2),
          isEdge('y', 'c', value: 2),
          isEdge('d', 'e', value: 2),
          isEdge('e', 'd', value: 2),
        ]),
      );
      expect(minCut.weight, 4);
    });
    test('empty graph error', () {
      final graph = Graph<String, void>(isDirected: false);
      expect(graph.minCut, throwsArgumentError);
    });
    test('directed graph error', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2);
      expect(graph.minCut, throwsArgumentError);
    });
  });
  group('spanning tree', () {
    test('empty', () {
      final graph = Graph<String, int>(isDirected: false);
      final spanning = graph.spanningTree();
      expect(spanning.vertices, isEmpty);
      expect(spanning.edges, isEmpty);
    });
    test('edgeless', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addVertices(['a', 'b']);
      final spanning = graph.spanningTree();
      expect(spanning.vertices, ['a', 'b']);
      expect(spanning.edges, isEmpty);
    });
    test('edgeless (with start vertex)', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addVertices(['a', 'b']);
      final spanning = graph.spanningTree(startVertex: 'a');
      expect(spanning.vertices, ['a']);
      expect(spanning.edges, isEmpty);
    });
    test('undirected', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree();
      expect(spanning.isDirected, isFalse);
      expect(spanning.vertices, unorderedEquals(graph.vertices));
      expect(
        spanning.edges.unique(),
        unorderedEquals([
          isEdge('a', 'd', value: 1),
          isEdge('a', 'b', value: 2),
          isEdge('d', 'c', value: 3),
        ]),
      );
    });
    test('undirected (with start vertex)', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree(startVertex: 'a');
      expect(spanning.isDirected, isFalse);
      expect(spanning.vertices, unorderedEquals(graph.vertices));
      expect(
        spanning.edges.unique(),
        unorderedEquals([
          isEdge('a', 'd', value: 1),
          isEdge('d', 'b', value: 2),
          isEdge('d', 'c', value: 3),
        ]),
      );
    });
    test('maximum', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree(
        weightComparator: reverseComparable<num>,
      );
      expect(spanning.isDirected, isFalse);
      expect(spanning.vertices, unorderedEquals(graph.vertices));
      expect(
        spanning.edges.unique(),
        unorderedEquals([
          isEdge('a', 'b', value: 2),
          isEdge('b', 'd', value: 2),
          isEdge('d', 'c', value: 3),
        ]),
      );
    });
    test('maximum (with start vertex)', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree(
        weightComparator: reverseComparable<num>,
        startVertex: 'a',
      );
      expect(spanning.isDirected, isFalse);
      expect(spanning.vertices, unorderedEquals(graph.vertices));
      expect(
        spanning.edges.unique(),
        unorderedEquals([
          isEdge('a', 'b', value: 2),
          isEdge('b', 'd', value: 2),
          isEdge('d', 'c', value: 3),
        ]),
      );
    });
    test('directed', () {
      final graph = Graph<String, int>(isDirected: true)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree();
      expect(spanning.isDirected, isTrue);
      expect(spanning.vertices, unorderedEquals(graph.vertices));
      expect(
        spanning.edges,
        unorderedEquals([
          isEdge('a', 'd', value: 1),
          isEdge('a', 'b', value: 2),
          isEdge('d', 'c', value: 3),
        ]),
      );
    });
    test('large', () {
      final graph = Graph<int, int>(isDirected: false)
        ..addEdge(1, 2, value: 2)
        ..addEdge(1, 4, value: 1)
        ..addEdge(1, 5, value: 4)
        ..addEdge(2, 3, value: 3)
        ..addEdge(2, 4, value: 3)
        ..addEdge(2, 6, value: 7)
        ..addEdge(3, 4, value: 5)
        ..addEdge(3, 6, value: 8)
        ..addEdge(4, 5, value: 9);
      final spanning = graph.spanningTree();
      expect(spanning.vertices, unorderedEquals(graph.vertices));
      expect(
        spanning.edges.unique(),
        unorderedEquals([
          isEdge(1, 2, value: 2),
          isEdge(1, 4, value: 1),
          isEdge(1, 5, value: 4),
          isEdge(2, 3, value: 3),
          isEdge(2, 6, value: 7),
        ]),
      );
    });
    test('large (with start vertex)', () {
      final graph = Graph<int, int>(isDirected: false)
        ..addEdge(1, 2, value: 2)
        ..addEdge(1, 4, value: 1)
        ..addEdge(1, 5, value: 4)
        ..addEdge(2, 3, value: 3)
        ..addEdge(2, 4, value: 3)
        ..addEdge(2, 6, value: 7)
        ..addEdge(3, 4, value: 5)
        ..addEdge(3, 6, value: 8)
        ..addEdge(4, 5, value: 9);
      final spanning = graph.spanningTree(startVertex: 1);
      expect(spanning.vertices, unorderedEquals(graph.vertices));
      expect(
        spanning.edges.unique(),
        unorderedEquals([
          isEdge(1, 2, value: 2),
          isEdge(1, 4, value: 1),
          isEdge(1, 5, value: 4),
          isEdge(2, 3, value: 3),
          isEdge(2, 6, value: 7),
        ]),
      );
    });
    test('disconnected', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 1)
        ..addEdge('x', 'y', value: 1)
        ..addEdge('x', 'z', value: 5)
        ..addEdge('y', 'z', value: 1);
      final spanning = graph.spanningTree();
      expect(spanning.vertices, ['a', 'b', 'x', 'y', 'z']);
      expect(
        spanning.edges.unique(),
        unorderedEquals([
          isEdge('a', 'b', value: 1),
          isEdge('x', 'y', value: 1),
          isEdge('y', 'z', value: 1),
        ]),
      );
    });
    test('disconnected (with start vertices)', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 1)
        ..addEdge('x', 'y', value: 1)
        ..addEdge('x', 'z', value: 5)
        ..addEdge('y', 'z', value: 1);
      final spanning1 = graph.spanningTree(startVertex: 'a');
      expect(spanning1.vertices, ['a', 'b']);
      expect(
        spanning1.edges.unique(),
        unorderedEquals([isEdge('a', 'b', value: 1)]),
      );
      final spanning2 = graph.spanningTree(startVertex: 'x');
      expect(spanning2.vertices, ['x', 'y', 'z']);
      expect(
        spanning2.edges.unique(),
        unorderedEquals([
          isEdge('x', 'y', value: 1),
          isEdge('y', 'z', value: 1),
        ]),
      );
    });
  });
  group('maximal cliques', () {
    test('empty graph', () {
      final graph = Graph<int, void>(isDirected: false);
      expect(graph.findCliques(), isEmpty);
    });
    test('single vertex', () {
      final graph = Graph<int, void>(isDirected: false);
      graph.addVertex(1);
      expect(graph.findCliques(), {
        {1},
      });
    });
    test('disconnected pair', () {
      final graph = Graph<int, void>(isDirected: false);
      graph.addVertex(1);
      graph.addVertex(2);
      expect(graph.findCliques(), {
        {1},
        {2},
      });
    });
    test('connected pair', () {
      final graph = Graph<int, void>(isDirected: false);
      graph.addEdge(2, 1);
      expect(graph.findCliques(), {
        {1, 2},
      });
    });
    test('wikipedia', () {
      final graph = Graph<int, void>(isDirected: false);
      graph.addEdge(1, 2);
      graph.addEdge(1, 5);
      graph.addEdge(2, 5);
      graph.addEdge(2, 3);
      graph.addEdge(3, 4);
      graph.addEdge(4, 6);
      graph.addEdge(4, 5);
      graph.addEdge(4, 6);
      expect(graph.findCliques(), {
        {1, 2, 5},
        {2, 3},
        {3, 4},
        {4, 5},
        {4, 6},
      });
    });
    test('aoc', () {
      final graph = Graph<String, void>(isDirected: false);
      for (final (source, target) in [
        ('kh', 'tc'),
        ('qp', 'kh'),
        ('de', 'cg'),
        ('ka', 'co'),
        ('yn', 'aq'),
        ('qp', 'ub'),
        ('cg', 'tb'),
        ('vc', 'aq'),
        ('tb', 'ka'),
        ('wh', 'tc'),
        ('yn', 'cg'),
        ('kh', 'ub'),
        ('ta', 'co'),
        ('de', 'co'),
        ('tc', 'td'),
        ('tb', 'wq'),
        ('wh', 'td'),
        ('ta', 'ka'),
        ('td', 'qp'),
        ('aq', 'cg'),
        ('wq', 'ub'),
        ('ub', 'vc'),
        ('de', 'ta'),
        ('wq', 'aq'),
        ('wq', 'vc'),
        ('wh', 'yn'),
        ('ka', 'de'),
        ('kh', 'ta'),
        ('co', 'tc'),
        ('wh', 'qp'),
        ('tb', 'vc'),
        ('td', 'yn'),
      ]) {
        graph.addEdge(source, target);
      }
      expect(graph.findCliques(), {
        {'cg', 'de'},
        {'cg', 'tb'},
        {'co', 'tc'},
        {'ka', 'tb'},
        {'kh', 'ta'},
        {'kh', 'tc'},
        {'aq', 'cg', 'yn'},
        {'aq', 'vc', 'wq'},
        {'kh', 'qp', 'ub'},
        {'qp', 'td', 'wh'},
        {'tb', 'vc', 'wq'},
        {'tc', 'td', 'wh'},
        {'td', 'wh', 'yn'},
        {'ub', 'vc', 'wq'},
        {'co', 'de', 'ka', 'ta'},
      });
    });
    test('complete graph', () {
      for (var i = 1; i < 25; i++) {
        final graph = GraphFactory<int, void>(
          isDirected: false,
        ).complete(vertexCount: i);
        expect(graph.findCliques().single, 0.to(i).toSet());
      }
    });
    test('complete graph with missing edge', () {
      const count = 10;
      for (var x = 0; x < count; x++) {
        for (var y = 0; y < count; y++) {
          if (x == y) continue;
          final graph = GraphFactory<int, void>(
            isDirected: false,
          ).complete(vertexCount: count);
          graph.removeEdge(x, y);
          expect(
            graph.findCliques(),
            unorderedEquals([
              0.to(count).toSet()..remove(x),
              0.to(count).toSet()..remove(y),
            ]),
          );
        }
      }
    });
    test('directed graph error', () {
      final graph = Graph<int, void>(isDirected: true);
      expect(graph.findCliques, throwsGraphError);
    });
  });
  group('strongly connected', () {
    test('empty graph', () {
      final graph = Graph<int, void>(isDirected: true);
      expect(graph.stronglyConnected(), isEmpty);
    });
    test('single vertex', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addVertex(1);
      expect(graph.stronglyConnected(), {
        {1},
      });
    });
    test('self-connected vertex', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addEdge(1, 1);
      expect(graph.stronglyConnected(), {
        {1},
      });
    });
    test('disconnected pair', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addVertex(1);
      graph.addVertex(2);
      expect(graph.stronglyConnected(), {
        {1},
        {2},
      });
    });
    test('weakly connected pair', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addEdge(2, 1);
      expect(graph.stronglyConnected(), {
        {1},
        {2},
      });
    });
    test('strongly connected pair', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addEdge(1, 2);
      graph.addEdge(2, 1);
      expect(graph.stronglyConnected(), {
        {1, 2},
      });
    });
    test('wikipedia', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addEdge(1, 5);
      graph.addEdge(2, 1);
      graph.addEdge(3, 2);
      graph.addEdge(3, 4);
      graph.addEdge(4, 3);
      graph.addEdge(5, 2);
      graph.addEdge(6, 2);
      graph.addEdge(6, 5);
      graph.addEdge(6, 7);
      graph.addEdge(7, 3);
      graph.addEdge(7, 6);
      graph.addEdge(8, 4);
      graph.addEdge(8, 7);
      graph.addEdge(8, 8);
      expect(graph.stronglyConnected(), {
        {1, 2, 5},
        {3, 4},
        {6, 7},
        {8},
      });
    });
    test('undirected graph error', () {
      final graph = Graph<int, void>(isDirected: false);
      expect(graph.stronglyConnected, throwsGraphError);
    });
  });
  group('isBipartite', () {
    test('empty graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: true);
      expect(graph.isBipartite(), isTrue);
    });
    test('single vertex graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addVertex(1);
      expect(graph.isBipartite(), isTrue);
    });
    test('path graph is bipartite', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 5);
      expect(graph.isBipartite(), isTrue);
    });
    test('cycle graph (even length) is bipartite', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 4);
      expect(graph.isBipartite(), isTrue);
    });
    test('cycle graph (odd length) is not bipartite', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 3);
      expect(graph.isBipartite(), isFalse);
    });
    test('complete bipartite graph is bipartite', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [2, 3]);
      expect(graph.isBipartite(), isTrue);
    });
    test('complete graph is bipartite only if n <= 2', () {
      expect(
        GraphFactory<int, void>().complete(vertexCount: 1).isBipartite(),
        isTrue,
      );
      expect(
        GraphFactory<int, void>().complete(vertexCount: 2).isBipartite(),
        isTrue,
      );
      expect(
        GraphFactory<int, void>().complete(vertexCount: 3).isBipartite(),
        isFalse,
      );
      expect(
        GraphFactory<int, void>().complete(vertexCount: 4).isBipartite(),
        isFalse,
      );
    });
    test('disconnected bipartite graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(3, 4)
        ..addEdge(5, 6);
      expect(graph.isBipartite(), isTrue);
    });
    test('disconnected graph with non-bipartite part is not bipartite', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1)
        ..addEdge(4, 5);
      expect(graph.isBipartite(), isFalse);
    });
    test('directed acyclic graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(0, 3);
      expect(graph.isBipartite(), isTrue);
    });
    test('directed graph with odd cycle is not bipartite', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 0);
      expect(graph.isBipartite(), isFalse);
    });
    test('directed graph with even cycle is bipartite', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 0);
      expect(graph.isBipartite(), isTrue);
    });
    test('graph with self-loop is not bipartite', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addVertex(0)
        ..addEdge(0, 0);
      expect(graph.isBipartite(), isFalse);
    });
  });
  group('hasCycle', () {
    test('empty graph has no cycle', () {
      final graph = Graph<int, void>(isDirected: true);
      expect(graph.hasCycle(), isFalse);
    });
    test('single vertex graph has no cycle', () {
      final graph = Graph<int, void>(isDirected: true)..addVertex(1);
      expect(graph.hasCycle(), isFalse);
    });
    test('single vertex with self-loop has a cycle', () {
      final graph = Graph<int, void>(isDirected: true)..addEdge(1, 1);
      expect(graph.hasCycle(), isTrue);
    });
    test('path graph has no cycle', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 5);
      expect(graph.hasCycle(), isFalse);
    });
    test('ring graph has a cycle', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 5);
      expect(graph.hasCycle(), isTrue);
    });
    test('dag has no cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(0, 2)
        ..addEdge(1, 3)
        ..addEdge(2, 3);
      expect(graph.hasCycle(), isFalse);
    });
    test('graph with a cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 0);
      expect(graph.hasCycle(), isTrue);
    });
    test('graph with a longer cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 0);
      expect(graph.hasCycle(), isTrue);
    });
    test('disconnected graph without cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(2, 3);
      expect(graph.hasCycle(), isFalse);
    });
    test('disconnected graph with cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(2, 3)
        ..addEdge(3, 4)
        ..addEdge(4, 2);
      expect(graph.hasCycle(), isTrue);
    });
    test('undirected graph error', () {
      final graph = Graph<int, void>(isDirected: false);
      expect(graph.hasCycle, throwsGraphError);
    });
  });
  group('graph coloring', () {
    test('empty', () {
      final graph = GraphFactory<int, int>().empty();
      expect(graph.vertexColoring(), isEmpty);
    });
    test('seperate vertices', () {
      final graph = Graph<int, void>(isDirected: false);
      for (var i = 1; i <= 10; i++) {
        graph.addVertex(i);
        final coloring = graph.vertexColoring();
        expect(coloring, hasLength(i));
        expect(coloring.values.toSet(), hasLength(1));
      }
    });
    test('bipartite graphs', () {
      for (var i = 1; i <= 10; i++) {
        final graph = GraphFactory<int, void>(
          isDirected: false,
        ).partite(vertexCounts: [i, i]);
        final coloring = graph.vertexColoring();
        expect(coloring.values.toSet(), hasLength(2));
      }
    });
    test('complete graphs', () {
      for (var i = 3; i <= 10; i++) {
        final graph = GraphFactory<int, void>(
          isDirected: false,
        ).complete(vertexCount: i);
        final coloring = graph.vertexColoring();
        expect(coloring.values.toSet(), hasLength(i));
      }
    });
    test('star graphs', () {
      for (var i = 2; i <= 10; i++) {
        final graph = GraphFactory<int, void>(
          isDirected: false,
        ).star(vertexCount: i);
        final coloring = graph.vertexColoring();
        expect(coloring.values.toSet(), hasLength(2));
      }
    });
  });
}
