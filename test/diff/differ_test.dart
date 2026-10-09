import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

class _CustomDiffer extends Differ {
  const new();

  @override
  Iterable<String> compareLines(
    Iterable<String> source,
    Iterable<String> target, {
    String? sourceLabel,
    String? targetLabel,
  }) => [
    if (sourceLabel != null) 'source: $sourceLabel',
    if (targetLabel != null) 'target: $targetLabel',
    '${source.length} -> ${target.length}',
  ];
}

void main() {
  group('differ', () {
    const differ = _CustomDiffer();

    test('compareStrings', () {
      check(
        differ.compareStrings(
          'a\nb\nc',
          'd\ne',
          sourceLabel: 'src.txt',
          targetLabel: 'dst.txt',
        ),
      ).deepEquals(['source: src.txt', 'target: dst.txt', '3 -> 2']);
    });

    test('compareStrings with no labels', () {
      check(differ.compareStrings('a\n', '')).deepEquals(['1 -> 0']);
    });
  });
}
