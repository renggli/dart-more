@TestOn('vm')
library;

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  final skillsDir = Directory('skills');
  final skillDirs = skillsDir.listSync().whereType<Directory>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  group('skills structure and metadata', () {
    test('every public sub-library has a skill', () {
      final libFiles = Directory('lib')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .map((f) => f.uri.pathSegments.last.replaceAll('.dart', ''))
          .where((name) => !const {'more', 'feature', 'pragma'}.contains(name))
          .toSet();
      final skillLibraries = skillDirs
          .map(
            (d) => d.uri.pathSegments
                .where((s) => s.isNotEmpty)
                .last
                .replaceFirst('more-use-', '')
                .replaceFirst('-library', '')
                .replaceAll('-', '_'),
          )
          .toSet();
      check(skillLibraries).deepEquals(libFiles);
    });

    for (final dir in skillDirs) {
      final dirName = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
      final skillFile = File('${dir.path}/SKILL.md');

      test('$dirName conforms to Agent Skills spec', () {
        check(skillFile.existsSync()).isTrue;
        final content = skillFile.readAsStringSync();

        // Frontmatter extraction
        final frontmatterMatch = RegExp(r'^---\n([\s\S]*?)\n---\n')
            .firstMatch(content);
        check(frontmatterMatch).isNotNull();
        final frontmatter = frontmatterMatch!.group(1)!;

        // Name matches directory name and spec pattern
        final nameMatch = RegExp(
          r'^name:\s*(.+)$',
          multiLine: true,
        ).firstMatch(frontmatter);
        check(nameMatch).isNotNull();
        final name = nameMatch!.group(1)!.trim();
        check(name).equals(dirName);
        check(name.length).isLessOrEqual(64);
        check(RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$').hasMatch(name)).isTrue;

        // Description is non-empty, bounded, actionable, and references library
        final descMatch = RegExp(
          r'^description:\s*"(.+)"$',
          multiLine: true,
        ).firstMatch(frontmatter);
        check(descMatch).isNotNull();
        final description = descMatch!.group(1)!.trim();
        check(description).isNotEmpty;
        check(description.length).isLessOrEqual(1024);
        check(description).contains('Use when');
        final expectedLib = dirName
            .replaceFirst('more-use-', '')
            .replaceFirst('-library', '')
            .replaceAll('-', '_');
        check(description).contains('package:more/$expectedLib.dart');

        // Balanced fenced code blocks
        final fenceCount = RegExp(
          r'^```',
          multiLine: true,
        ).allMatches(content).length;
        check(fenceCount % 2).equals(0);
        check(fenceCount).isGreaterThan(0);

        // Includes Common Pitfalls section
        check(content).contains('## Common Pitfalls');

        // No LaTeX math outside code blocks
        final withoutCodeBlocks = content.replaceAll(
          RegExp(r'```[\s\S]*?```'),
          '',
        );
        check(
          RegExp(r'\$[^$\n]+\$').hasMatch(withoutCodeBlocks),
          because: 'Avoid LaTeX math in skill prose',
        ).isFalse;
      });
    }
  });
}
