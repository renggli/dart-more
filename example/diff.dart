import 'dart:io';

import 'package:args/args.dart';
import 'package:more/diff.dart';

final differs = <String, Differ Function(int context)>{
  'normal': (context) => NormalDiffer(),
  'context': (context) => ContextDiffer(context: context),
  'unified': (context) => UnifiedDiffer(context: context),
  'readable': (context) => ReadableDiffer(),
};

const reset = '\u001b[0m';
const red = '\u001b[31m';
const green = '\u001b[32m';
const yellow = '\u001b[33m';

const colors = <String, Map<String, String>>{
  'normal': {'> ': green, '< ': red},
  'context': {'+ ': green, '- ': red, '! ': yellow},
  'unified': {'+': green, '-': red},
  'readable': {'+ ': green, '- ': red, '? ': yellow},
};

final ArgParser argParser =
    ArgParser()
      ..addOption(
        'format',
        abbr: 'f',
        allowed: differs.keys,
        defaultsTo: differs.keys.first,
        help: 'output format to print',
      )
      ..addOption(
        'context',
        abbr: 'c',
        help: 'lines of context to print',
        defaultsTo: '3',
      )
      ..addFlag(
        'color',
        help: 'colors the output',
        defaultsTo: stdout.supportsAnsiEscapes,
      );

Never printUsage() {
  stdout.writeln('Usage: diff [options] FILE1 FILE2');
  stdout.writeln();
  stdout.writeln(argParser.usage);
  exit(1);
}

Future<({List<String> lines, String label})> readFile(String name) async {
  final file = File(name);
  if (!await file.exists()) {
    stderr.writeln('File not found: $name');
    exit(2);
  }
  final lines = await file.readAsLines();
  final timestamp = await file.lastModified();
  return (lines: lines, label: '$name\t${timestamp.toIso8601String()}');
}

Future<void> main(List<String> arguments) async {
  final result = argParser.parse(arguments);
  final factory = differs[result['format']] ?? printUsage();
  final differ = factory(int.parse(result['context'] as String));
  final color =
      result['color'] as bool
          ? colors[result['format']] ?? {}
          : <String, Map<String, String>>{};
  if (result.rest.length != 2) printUsage();

  final source = await readFile(result.rest[0]);
  final target = await readFile(result.rest[1]);
  for (var output in differ.compareLines(
    source.lines,
    target.lines,
    sourceLabel: source.label,
    targetLabel: target.label,
  )) {
    final prefix = color.keys.where(output.startsWith).firstOrNull;
    if (prefix != null) output = '${color[prefix]}$output$reset';
    stdout.writeln(output);
  }
}
