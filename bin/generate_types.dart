import 'dart:io';

import 'utils/generating.dart';

/// Number of types to generate (exclusive).
const int max = 11;

/// Root directory of paths.
File getFile(String name) => File('lib/src/functional/types/$name.dart');

Future<void> generateCallback() async {
  final file = getFile('callback');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Function types for generic callbacks.');
  out.writeln('library;');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Callback function type with $i positional '
        'argument${i == 1 ? '' : 's'}.');
    out.writeln('typedef Callback$i${generify(generateTypes(i))} = '
        'void Function(${listify(generateTypeAndArgs(i))});');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateMapping() async {
  final file = getFile('mapping');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Function type for generic mapping functions.');
  out.writeln('library;');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Mapping function type with $i positional '
        'argument${i == 1 ? '' : 's'}.');
    out.writeln('typedef Map$i${generify([...generateTypes(i), 'R'])} = '
        'R Function(${listify(generateTypeAndArgs(i))});');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generatePredicate() async {
  final file = getFile('predicate');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Function type for generic predicate functions.');
  out.writeln('library;');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Predicate function type with $i positional '
        'argument${i == 1 ? '' : 's'}.');
    out.writeln('typedef Predicate$i${generify(generateTypes(i))} = '
        'bool Function(${listify(generateTypeAndArgs(i))});');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateEmpty() async {
  final file = getFile('empty');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Generic empty functions returning nothing.');
  out.writeln('library;');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Empty function with $i positional '
        'argument${i == 1 ? '' : 's'}.');
    out.writeln('void emptyFunction$i${generify(generateTypes(i))} '
        '(${listify(generateTypeAndArgs(i))}) {}');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateIdentity() async {
  final file = getFile('identity');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Generic identity functions.');
  out.writeln('library;');
  out.writeln();

  out.writeln('/// Generic identity function with 1 positional argument.');
  out.writeln('T identityFunction<T>(T arg) => arg;');
  out.writeln();

  await out.close();
  await format(file);
}

Future<void> generateConstant() async {
  final file = getFile('constant');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// The constant functions.');
  out.writeln('library;');
  out.writeln();

  out.writeln("import 'mapping.dart';");
  out.writeln();

  for (var i = 0; i < max; i++) {
    final prefix = '$i${generify([...generateTypes(i), 'R'])}';
    out.writeln('/// Constant function with $i positional '
        'argument${i == 1 ? '' : 's'}.');
    out.writeln('Map$prefix constantFunction$prefix(R value) '
        '=> (${listify(generateArgs(i))}) '
        '=> value;');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateThrowing() async {
  final file = getFile('throwing');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// The throwing functions.');
  out.writeln('library;');
  out.writeln();

  out.writeln("import 'mapping.dart';");
  out.writeln();

  for (var i = 0; i < max; i++) {
    final mapType = '$i${generify([...generateTypes(i), 'Never'])}';
    final throwType = '$i${generify([...generateTypes(i)])}';
    out.writeln('/// Throwing function with $i positional '
        'argument${i == 1 ? '' : 's'}.');
    out.writeln('Map$mapType throwFunction$throwType(Object throwable) '
        '=> (${listify(generateArgs(i))}) '
        '=> throw throwable;');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generatePartial() async {
  final file = getFile('partial');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Binds positional arguments and returns a new function:');
  out.writeln('/// https://en.wikipedia.org/wiki/Partial_application');
  out.writeln('library;');
  out.writeln();

  out.writeln("import 'mapping.dart';");
  out.writeln();

  for (var i = 1; i < max; i++) {
    final types = [...generateTypes(i), 'R'];
    final argsAndTypes = generateTypeAndArgs(i);
    final args = generateArgs(i);

    out.writeln('extension Partial$i${generify(types)} '
        'on Map$i${generify(types)} {');

    for (var j = 0; j < i; j++) {
      final resultType = types.toList()..removeAt(j);
      final unboundArgs = argsAndTypes.toList()..removeAt(j);
      out.writeln('/// Returns a new function with the ${ordinal.print(j)} '
          'argument bound to `arg$j`.');
      out.writeln('Map${i - 1}${generify(resultType)} '
          'bind$j(${argsAndTypes[j]}) => ');
      out.writeln('(${listify(unboundArgs)}) => this(${listify(args)});');
      out.writeln();
    }

    out.writeln('}');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateCurry() async {
  final file = getFile('curry');
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Converts a function with positional arguments into a '
      'sequence of functions ');
  out.writeln('/// taking a single argument: '
      'https://en.wikipedia.org/wiki/Currying');
  out.writeln('library;');
  out.writeln();

  out.writeln("import 'mapping.dart';");
  out.writeln();

  for (var i = 1; i < max; i++) {
    final types = [...generateTypes(i), 'R'];
    final argsAndTypes = generateTypeAndArgs(i);
    final args = generateArgs(i);

    out.writeln('extension Curry$i${generify(types)} '
        'on Map$i${generify(types)} {');
    out.writeln('/// Converts a function with $i positional arguments into a '
        'sequence of $i ');
    out.writeln('/// functions taking a single argument.');
    for (var j = 0; j < i; j++) {
      out.write('Map1<${types[j]}, ');
    }
    out.write('${types.last}${'>' * i} get curry => ');
    for (var j = 0; j < i; j++) {
      out.write('(${argsAndTypes[j]}) =>');
    }
    out.writeln('this(${listify(args)});');

    out.writeln('}');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateTest() async {
  final file = File('test/functional_type_test.dart');
  final out = file.openWrite();
  generateWarning(out);

  void nest(String type, String name, void Function() callback) {
    out.writeln('$type(\'$name\', () {');
    callback();
    out.writeln('});');
  }

  out.writeln('// ignore_for_file: unnecessary_lambdas');
  out.writeln();

  out.writeln('import \'package:more/functional.dart\';');
  out.writeln('import \'package:test/test.dart\';');
  out.writeln();

  out.writeln('void main() {');

  nest('group', 'constant', () {
    for (var i = 0; i < max; i++) {
      nest('test', 'constantFunction$i', () {
        final types = generify([for (var j = 0; j < i; j++) 'int', 'String']);
        final values = listify(List.generate(i, (i) => '$i'));
        out.writeln('final function = constantFunction$i$types(\'default\');');
        out.writeln('expect(function($values), \'default\');');
      });
    }
  });
  nest('group', 'empty', () {
    for (var i = 0; i < max; i++) {
      nest('test', 'emptyFunction$i', () {
        final values = listify(List.generate(i, (i) => '$i'));
        out.writeln('expect(() => emptyFunction$i($values), '
            'isNot(throwsException));');
      });
    }
  });
  nest('test', 'identity', () {
    out.writeln('expect(identityFunction(42), 42);');
    out.writeln('expect(identityFunction(\'foo\'), \'foo\');');
  });
  nest('group', 'throwing', () {
    out.writeln('final throwable = UnimplementedError();');
    for (var i = 0; i < max; i++) {
      nest('test', 'throwFunction$i', () {
        final types = generify([for (var j = 0; j < i; j++) 'int']);
        final values = listify(List.generate(i, (i) => '$i'));
        out.writeln('final function = throwFunction$i$types(throwable);');
        out.writeln('expect(() => function($values), '
            'throwsUnimplementedError);');
      });
    }
  });
  nest('group', 'partial', () {
    for (var i = 1; i < max; i++) {
      nest('group', '$i-ary function', () {
        for (var j = 0; j < i; j++) {
          nest('test', 'bind ${ordinal.print(j)} argument', () {
            final args = generateArgs(i);
            final typesAndArgs = args.map((each) => 'int $each');
            out.writeln('List<int> function(${listify(typesAndArgs)}) => '
                '[${listify(args)}];');
            out.writeln('final bound = function.bind$j(-1);');
            final arguments = List.generate(i - 1, (i) => '$i');
            final expected = arguments.toList()..insert(j, '-1');
            out.writeln('expect(bound(${listify(arguments)}), '
                '[${listify(expected)}]);');
          });
        }
      });
    }
  });
  nest('group', 'curry', () {
    for (var i = 1; i < max; i++) {
      nest('test', '$i-ary function', () {
        final args = generateArgs(i);
        final typesAndArgs = args.map((each) => 'int $each');
        out.writeln('List<int> function(${listify(typesAndArgs)}) => '
            '[${listify(args)}];');
        final calls = List.generate(i, (i) => '($i)');
        final result = List.generate(i, (i) => '$i');
        out.writeln('expect(function.curry${calls.join()}, '
            '[${listify(result)}]);');
      });
    }
  });
  out.writeln('}');

  await out.close();
  await format(file);
}

Future<void> main() => Future.wait([
      generateCallback(),
      generateConstant(),
      generateCurry(),
      generateEmpty(),
      generateIdentity(),
      generateMapping(),
      generatePartial(),
      generatePredicate(),
      generateThrowing(),
      generateTest(),
    ]);
