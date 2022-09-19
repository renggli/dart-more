import 'dart:html';

import 'package:more/collection.dart' show RTree, Bounds;

final select = querySelector('#select')! as SelectElement;
final clear = querySelector('#clear')! as ButtonElement;
final canvas = querySelector('#canvas')! as CanvasElement;
final console = querySelector('#console')! as ParagraphElement;

var tree = createTree();
var index = 0;

RTree<int> createTree() {
  switch (select.value) {
    case 'guttman':
      return RTree<int>.guttmann();
    case 'rstar':
      return RTree<int>.rstar();
    default:
      throw StateError('Invalid tree type: ${select.value}');
  }
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

void addPoint(MouseEvent event) {
  final point = Bounds.fromPoint([
    event.offset.x.toDouble(),
    event.offset.y.toDouble(),
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
      context.fillStyle = 'black';
      context.textAlign = 'center';
      context.textBaseline = 'middle';
      context.fillText(
          entry.data.toString(), entry.bounds.min[0], entry.bounds.min[1]);
    } else {
      context.fillStyle = 'gray';
      context.strokeStyle = 'gray';
      context.strokeRect(
        entry.bounds.min[0] - 5,
        entry.bounds.min[1] - 5,
        entry.bounds.max[0] - entry.bounds.min[0] + 10,
        entry.bounds.max[1] - entry.bounds.min[1] + 10,
      );
      context.textAlign = 'start';
      context.textBaseline = 'top';
      context.fillText(entry.child!.entries.length.toString(),
          entry.bounds.min[0], entry.bounds.min[1]);
    }
  }
}

void main() {
  select.onChange.listen(selectImplementation);
  clear.onClick.listen(clearTree);
  canvas.onClick.listen(addPoint);
  update();
}
