import 'dart:math';

import 'package:more/math.dart';

final hillsData = [
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

const hillsSource = Point(0, 0);
const hillsTarget = Point(12, 37);

bool hillsTargetPredicate(Point<int> vertex) => hillsTarget == vertex;

Iterable<Point<int>> hillsSuccessorsOf(Point<int> vertex) =>
    const [
          Point(-1, -1), Point(-1, 0), Point(-1, 1), Point(0, -1), //
          Point(0, 1), Point(1, -1), Point(1, 0), Point(1, 1),
        ]
        .map((offset) => vertex + offset)
        .where(
          (point) =>
              point.x.between(hillsSource.x, hillsTarget.x) &&
              point.y.between(hillsSource.y, hillsTarget.y) &&
              hillsData[point.x][point.y] < 8,
        );

num hillsEdgeCost(Point<int> source, Point<int> target) =>
    ((source.x - target.x).pow(2) +
            (source.y - target.y).pow(2) +
            (2 * hillsData[source.x][source.y] -
                    2 * hillsData[target.x][target.y])
                .pow(2))
        .sqrt();

num hillsCostEstimate(Point<int> vertex) =>
    ((vertex.x - hillsTarget.x).pow(2) +
            (vertex.y - hillsTarget.y).pow(2) +
            (2 * hillsData[vertex.x][vertex.y] -
                    2 * hillsData[hillsTarget.x][hillsTarget.y])
                .pow(2))
        .sqrt();

final mazeData = [
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

const mazeSource = Point(1, 0);
const mazeTarget = Point(11, 24);

bool mazeTargetPredicate(Point<int> vertex) => mazeTarget == vertex;

Iterable<Point<int>> mazeSuccessorsOf(Point<int> vertex) =>
    const [
          Point(-1, 0), Point(0, -1), Point(0, 1), Point(1, 0), //
        ]
        .map((offset) => vertex + offset)
        .where(
          (point) =>
              point.x.between(mazeSource.x, mazeTarget.x) &&
              point.y.between(mazeSource.y, mazeTarget.y) &&
              mazeData[point.x][point.y] != '#',
        );

num mazeCostEstimate(Point<int> vertex) =>
    ((vertex.x - mazeTarget.x).pow(2) + (vertex.y - mazeTarget.y).pow(2))
        .sqrt();

const mazeSolution = <Point<int>>[
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
