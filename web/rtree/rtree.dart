import 'dart:js_interop';
import 'dart:math';

import 'package:more/collection.dart';
import 'package:web/web.dart';

const guttmann = 'guttmann_';

final select = document.querySelector('#select') as HTMLSelectElement;
final clear = document.querySelector('#clear') as HTMLButtonElement;
final random = document.querySelector('#random') as HTMLButtonElement;
final canvas = document.querySelector('#canvas') as HTMLCanvasElement;

var tree = createTree();
var index = 0;

RTree<int> createTree() {
  if (select.value.startsWith(guttmann)) {
    final values = select.value
        .removePrefix(guttmann)
        .split('_')
        .map(int.parse)
        .toList();
    return RTree<int>.guttmann(minEntries: values[0], maxEntries: values[1]);
  }
  throw StateError('Invalid tree type: ${select.value}');
}

void selectImplementation(Event event) {
  final newTree = createTree();
  for (final entry in tree.traverse((node) => node.entries)) {
    if (entry.isLeaf) {
      newTree.insert(entry.bounds, entry.data!);
    }
  }
  tree = newTree;
  update();
}

void clearTree(MouseEvent event) {
  tree = createTree();
  index = 0;
  update();
}

void addPoints(MouseEvent event) {
  final random = Random();
  final rect = canvas.getBoundingClientRect();
  for (var i = 0; i < 100; i++) {
    final point = Bounds.fromPoint([
      rect.width * random.nextDouble(),
      rect.height * random.nextDouble(),
    ]);
    tree.insert(point, index++);
  }
  update();
}

void addPoint(MouseEvent event) {
  final point = Bounds.fromPoint([
    event.offsetX.toDouble(),
    event.offsetY.toDouble(),
  ]);
  tree.insert(point, index++);
  update();
}

void update() {
  // Get the DPR and size of the canvas
  final dpr = window.devicePixelRatio;
  final rect = canvas.getBoundingClientRect();
  // Set the "actual" size of the canvas
  final width = (rect.width * dpr).truncate();
  final height = (rect.height * dpr).truncate();
  canvas
    ..width = width
    ..height = height;
  // Scale the context to ensure correct drawing operations
  final context = canvas.context2D;
  context.scale(dpr, dpr);
  context.clearRect(0, 0, width, height);
  // Draw all the entries.
  for (final entry in tree.traverse((node) => node.entries)) {
    if (entry.isLeaf) {
      context.fillStyle = 'black'.toJS;
      context.textAlign = 'center';
      context.textBaseline = 'middle';
      context.fillText(
        entry.data.toString(),
        entry.bounds.min[0],
        entry.bounds.min[1],
      );
    } else {
      context.fillStyle = 'gray'.toJS;
      context.strokeStyle = 'gray'.toJS;
      context.strokeRect(
        entry.bounds.min[0] - 5,
        entry.bounds.min[1] - 5,
        entry.bounds.max[0] - entry.bounds.min[0] + 10,
        entry.bounds.max[1] - entry.bounds.min[1] + 10,
      );
      context.textAlign = 'start';
      context.textBaseline = 'top';
      context.fillText(
        entry.child!.entries.length.toString(),
        entry.bounds.min[0],
        entry.bounds.min[1],
      );
    }
  }
}

void main() {
  select.onChange.listen(selectImplementation);
  clear.onClick.listen(clearTree);
  random.onClick.listen(addPoints);
  canvas.onClick.listen(addPoint);
  update();
}
