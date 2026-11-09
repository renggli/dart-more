import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/node.dart';

void main() {
  group('GraphNode', () {
    test('default values and style separation', () {
      final node = GraphNode(id: 'A');
      check(node.id).equals('A');
      check(node.label).equals('A');
      check(node.style.borderWidth).equals(defaultBorderWidth);
      check(node.style.opacity).equals(defaultOpacity);
      check(node.style.visible).isTrue();

      // Transient modification
      node.style.borderColor = '#ff0000';
      node.style.borderWidth = 3.0;
      node.style.opacity = 0.5;
      node.style.reset();

      check(node.style.borderColor).isNull();
      check(node.style.borderWidth).equals(defaultBorderWidth);
      check(node.style.opacity).equals(defaultOpacity);
    });

    test(
      'toJson and fromJson preserves user styles and drops transient styles',
      () {
        final node = GraphNode(
          id: 'B',
          label: 'Node B',
          x: 100,
          y: 200,
          userFillColor: '#123456',
          userBorderColor: '#654321',
          userTextColor: '#abcdef',
          userBorderWidth: 2.0,
          userOpacity: 0.8,
        );
        // Transient styling applied by modifier
        node.style.borderColor = '#999999';

        final json = node.toJson();
        check(json['id']).equals('B');
        check(json['label']).equals('Node B');
        check(json['x']).equals(100.0);
        check(json['y']).equals(200.0);
        check(json['fillColor']).equals('#123456');
        check(json['borderColor']).equals('#654321');
        check(json['textColor']).equals('#abcdef');
        check(json['borderWidth']).equals(2.0);
        check(json['opacity']).equals(0.8);

        final restored = GraphNode.fromJson(json);
        check(restored.id).equals('B');
        check(restored.label).equals('Node B');
        check(restored.userFillColor).equals('#123456');
        check(restored.userBorderColor).equals('#654321');
        check(restored.style.borderColor).isNull();
      },
    );
  });
}
