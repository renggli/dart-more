import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:more/collection.dart';

abstract class ReflowCommand extends Command<void> {
  @override
  void run() async {
    for (final argument in argResults!.rest) {
      final file = File(argument);
      if (file.existsSync()) {
        final input = await file.readAsString();
        stdout.writeln(transform(input));
      } else {
        stderr.writeln('File not found: $file');
        exit(2);
      }
    }
  }

  T getArgument<T>(String name) => argResults![name] as T;

  String transform(String input);
}

class IndentCommand extends ReflowCommand {
  IndentCommand() {
    argParser
      ..addOption('prefix',
          abbr: 'p',
          help: 'Prefix to be prepended to each line.',
          defaultsTo: '  ')
      ..addOption('first-prefix',
          abbr: 'f',
          help: 'Prefix to be prepended to the first line.',
          defaultsTo: null)
      ..addFlag('trim-whitespace',
          abbr: 't',
          help: 'Trims each line from existing whitespace.',
          defaultsTo: true)
      ..addFlag('indent-empty',
          abbr: 'e', help: 'Indents empty lines as well.', defaultsTo: false);
  }

  @override
  String get name => 'indent';

  @override
  String get description => 'Adds a prefix to each line.';

  @override
  String transform(String input) => input.indent(getArgument('prefix'),
      firstPrefix: getArgument('first-prefix'),
      trimWhitespace: getArgument('trim-whitespace'),
      indentEmpty: getArgument('indent-empty'));
}

class DedentCommand extends ReflowCommand {
  DedentCommand() {
    argParser.addFlag('ignore-empty',
        abbr: 'e',
        help: 'Ignore empty lines when detecting the prefix.',
        defaultsTo: true);
  }

  @override
  String get name => 'dedent';

  @override
  String get description => 'Removes a common leading prefix.';

  @override
  String transform(String input) =>
      input.dedent(ignoreEmpty: getArgument('ignore-empty'));
}

class WrapCommand extends ReflowCommand {
  WrapCommand() {
    argParser
      ..addOption('width',
          abbr: 'w',
          help: 'The width in characters to target.',
          defaultsTo:
              stdout.hasTerminal ? stdout.terminalColumns.toString() : '80')
      ..addFlag('break-long-words',
          abbr: 'b',
          help: 'Break long words that do not fit.',
          defaultsTo: true);
  }

  @override
  String get name => 'wrap';

  @override
  String get description => 'Wraps a long text.';

  @override
  String transform(String input) => input.wrap(int.parse(getArgument('width')),
      breakLongWords: getArgument('break-long-words'));
}

class UnwrapCommand extends ReflowCommand {
  @override
  String get name => 'unwrap';

  @override
  String get description => 'Unwraps a long text.';

  @override
  String transform(String input) => input.unwrap();
}

final runner = CommandRunner<void>('reflow', 'Reflows text in different ways.')
  ..addCommand(IndentCommand())
  ..addCommand(DedentCommand())
  ..addCommand(WrapCommand())
  ..addCommand(UnwrapCommand());

Future<void> main(List<String> arguments) async {
  await runner.run(arguments).catchError((Object error) {
    stdout.writeln(error);
    exit(1);
  }, test: (error) => error is UsageException);
}
