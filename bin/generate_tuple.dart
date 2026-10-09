import 'dart:io';
import 'dart:math';

import 'package:more/collection.dart';

import 'utils/generating.dart';

/// Ordinal value names.
const ordinals = [
  'first',
  'second',
  'third',
  'fourth',
  'fifth',
  'sixth',
  'seventh',
  'eighth',
  'ninth',
  'tenth',
];

/// Number of tuples to generate (exclusive).
final int max = ordinals.length;

/// Export file.
final File exportFile = File('lib/tuple.dart');

/// Abstract file.
final File abstractFile = File('lib/src/tuple/tuple.dart');

/// Implementation file.
File implementationFile(int i) => File('lib/src/tuple/tuple_$i.dart');

/// Directory for tests.
final Directory testDir = Directory('test/tuple');

/// Tuple test file.
final File tupleTestFile = File('test/tuple/tuple_test.dart');

/// Implementation test file.
File implementationTestFile(int i) => File('test/tuple/tuple_${i}_test.dart');

/// Random generator for hash values.
final Random generator = Random(42);

Future<void> generateExport() async {
  final file = exportFile;
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('/// Tuple extension methods on generic records.');
  out.writeln('library;');
  out.writeln();
  out.writeln('export \'src/tuple/tuple.dart\';');
  for (var i = 0; i < max; i++) {
    out.writeln('export \'src/tuple/tuple_$i.dart\';');
  }
  await out.close();
  await format(file);
}

Future<void> generateAbstract() async {
  final file = abstractFile;
  final out = file.openWrite();
  generateWarning(out);

  for (var i = 0; i < max; i++) {
    out.writeln('import \'tuple_$i.dart\';');
  }
  out.writeln();

  out.writeln('/// Extension methods on [Record].');
  out.writeln('extension Tuple on Record {');

  out.writeln('/// Creates a [Record] tuple from the elements in [list].');
  out.writeln('static Record fromList<T>(List<T> list) =>');
  out.writeln('switch (list.length) {');
  for (var i = 0; i < max; i++) {
    out.writeln('$i => Tuple$i.fromList(list),');
  }
  out.writeln('_ =>');
  out.writeln(
    'throw ArgumentError.value(list, \'list\', '
    '\'Length \${list.length} not in range 0..${max - 1}\'),',
  );
  out.writeln('};');
  out.writeln();

  out.writeln('}');
  await out.close();
  await format(file);
}

Future<void> generateImplementation(int i) async {
  final file = implementationFile(i);
  final out = file.openWrite();
  generateWarning(out);

  final types = generateTypes(i);
  final values = generateValues(i);

  out.writeln(
    '/// Extension methods on [Record] with $i positional '
    'element${i != 1 ? 's' : ''}.',
  );
  out.writeln('extension Tuple$i${generify(types)} on ${recordify(types)} {');

  // constructors
  final listTypes = List.generate(i, (i) => 'T');
  final listAccessors = List.generate(i, (i) => 'list[$i]');
  out.writeln('/// Creates a tuple from the elements in [list].');
  out.writeln('static ${recordify(listTypes)} fromList<T>(List<T> list) {');
  if (i == 0) {
    out.writeln('if (list.isNotEmpty) {');
  } else {
    out.writeln('if (list.length != $i) {');
  }
  out.writeln(
    'throw ArgumentError.value(list, \'list\', '
    '\'Expected list of length $i, but got \${list.length}\');',
  );
  out.writeln('}');
  out.writeln('return ${recordify(listAccessors)};');
  out.writeln('}');

  // length
  out.writeln();
  out.writeln('/// The number of elements in the tuple.');
  out.writeln('int get length => $i;');

  // access
  for (var j = 0; j < i; j++) {
    out.writeln();
    out.writeln('/// The ${ordinals[j]} element of this tuple.');
    out.writeln('${types[j]} get ${ordinals[j]} => ${values[j]};');
  }
  if (i > 0) {
    out.writeln();
    out.writeln('/// The last element of this tuple.');
    out.writeln('${types.last} get last => ${values.last};');
  }

  // replace
  for (var j = 0; j < i; j++) {
    final typesReplaced = [...types];
    final valuesReplaced = [...values];
    typesReplaced[j] = 'T';
    valuesReplaced[j] = 'value';
    out.writeln();
    out.writeln(
      '/// Returns a new tuple with the ${ordinals[j]} element '
      'replaced by [value].',
    );
    out.writeln(
      '${recordify(typesReplaced)} '
      'with${capitalize(ordinals[j])}<T>(T value) => '
      '${recordify(valuesReplaced)};',
    );
    if (j == i - 1) {
      out.writeln();
      out.writeln(
        '/// Returns a new tuple with the last element replaced by '
        '[value].',
      );
      out.writeln(
        '${recordify(typesReplaced)} '
        'withLast<T>(T value) => ${recordify(valuesReplaced)};',
      );
    }
  }

  // add
  if (i < max - 1) {
    for (var j = 0; j <= i; j++) {
      final addTypes = [...types.sublist(0, j), 'T', ...types.sublist(j, i)];
      final addValues = [
        ...values.sublist(0, j),
        'value',
        ...values.sublist(j, i),
      ];
      out.writeln();
      out.writeln(
        '/// Returns a new tuple with [value] added at the '
        '${ordinals[j]} position.',
      );
      out.writeln(
        '${recordify(addTypes)} '
        'add${capitalize(ordinals[j])}<T>(T value) => '
        '${recordify(addValues)};',
      );
      if (j == i) {
        out.writeln();
        out.writeln(
          '/// Returns a new tuple with [value] added at the last '
          'position.',
        );
        out.writeln(
          '${recordify(addTypes)} '
          'addLast<T>(T value) => ${recordify(addValues)};',
        );
      }
    }
  }

  // remove
  if (i > 0) {
    for (var j = 0; j < i; j++) {
      final removeTypes = [...types.sublist(0, j), ...types.sublist(j + 1)];
      final removeValues = [...values.sublist(0, j), ...values.sublist(j + 1)];
      out.writeln();
      out.writeln(
        '/// Returns a new tuple with the ${ordinals[j]} element '
        'removed.',
      );
      out.writeln(
        '${recordify(removeTypes)} '
        'remove${capitalize(ordinals[j])}() => ${recordify(removeValues)};',
      );
      if (j == i - 1) {
        out.writeln();
        out.writeln('/// Returns a new tuple with the last element removed.');
        out.writeln(
          '${recordify(removeTypes)} '
          'removeLast() => ${recordify(removeValues)};',
        );
      }
    }
  }

  // map
  final typeAndOrdinals = [
    types,
    ordinals,
  ].zip().map((value) => value.join(' '));
  out.writeln();
  out.writeln('/// Transforms the elements of this tuple using [callback].');
  out.writeln('R map<R>(R Function(${listify(typeAndOrdinals)}) callback) => ');
  out.writeln('callback(${listify(values)});');

  // iterable
  final prefix = i == 0 ? 'const ' : '';
  out.writeln();
  out.writeln('/// An untyped [Iterable] over the values of this tuple.');
  out.writeln('Iterable<dynamic> get iterable => toList();');
  out.writeln();
  out.writeln('/// Converts this tuple to an untyped [List].');
  out.writeln('List<dynamic> toList() => $prefix[${listify(values)}];');
  out.writeln();
  out.writeln('/// Converts this tuple to an untyped [Set] of unique values.');
  out.writeln('Set<dynamic> toSet() => $prefix{${listify(values)}};');

  out.writeln('}');
  await out.close();
  await format(file);
}

Future<void> generateTupleTest() async {
  final file = tupleTestFile;
  final out = file.openWrite();
  generateWarning(out);

  out.writeln('import \'package:checks/checks.dart\';');
  out.writeln('import \'package:more/tuple.dart\';');
  out.writeln('import \'package:test/scaffolding.dart\';');
  out.writeln();
  out.writeln('void main() {');
  out.writeln('  group(\'Tuple\', () {');
  out.writeln('    test(\'fromList\', () {');
  for (var i = 0; i < max; i++) {
    final list = List.generate(i, (j) => '${j + 1}');
    out.writeln(
      '      check(Tuple.fromList([${listify(list)}])).equals(${recordify(list)});',
    );
  }
  final many = List.generate(max + 1, (j) => '${j + 1}');
  out.writeln(
    '      check(() => Tuple.fromList([${listify(many)}])).throws<ArgumentError>();',
  );
  out.writeln('    });');
  out.writeln('  });');
  out.writeln('}');

  await out.close();
  await format(file);
}

Future<void> generateImplementationTest(int i) async {
  final file = implementationTestFile(i);
  final out = file.openWrite();
  generateWarning(out);

  void nest(String type, String name, void Function() callback) {
    out.writeln('$type(\'$name\', () {');
    callback();
    out.writeln('});');
  }

  out.writeln('import \'package:checks/checks.dart\';');
  out.writeln('import \'package:more/tuple.dart\';');
  out.writeln('import \'package:test/scaffolding.dart\';');
  out.writeln();
  out.writeln('void main() {');

  nest('group', 'Tuple$i', () {
    // Make sure the numbers are unique.
    var numbers = <String>[];
    do {
      numbers = List.generate(i, (i) => '${generator.nextInt(256)}');
    } while (Set.of(numbers).length != i);
    out.writeln('const tuple = ${recordify(numbers)};');
    nest('test', 'fromList', () {
      final many = List.generate(i + 1, (i) => '${generator.nextInt(256)}');
      out.writeln('final other = Tuple$i.fromList([${listify(numbers)}]);');
      out.writeln('check(other).equals(tuple);');
      out.writeln(
        'check(() => Tuple$i.fromList([${listify(many)}])).throws<ArgumentError>();',
      );
    });
    if (i > 0) {
      nest('test', 'read', () {
        for (var j = 0; j < i; j++) {
          out.writeln('check(tuple.${ordinals[j]}).equals(${numbers[j]});');
        }
        out.writeln('check(tuple.last).equals(${numbers.last});');
      });
    }
    for (var j = 0; j < i; j++) {
      nest('test', 'with${capitalize(ordinals[j])}', () {
        out.writeln(
          'final other = '
          'tuple.with${capitalize(ordinals[j])}(\'a\');',
        );
        for (var k = 0; k < i; k++) {
          out.writeln(
            'check(other.${ordinals[k]}).equals(${j == k ? '\'a\'' : numbers[k]});',
          );
        }
      });
      if (j == i - 1) {
        nest('test', 'withLast', () {
          out.writeln('final other = tuple.withLast(\'a\');');
          for (var k = 0; k < i; k++) {
            out.writeln(
              'check(other.${ordinals[k]}).equals(${j == k ? '\'a\'' : numbers[k]});',
            );
          }
        });
      }
    }
    if (i < max - 1) {
      for (var j = 0; j <= i; j++) {
        nest('test', 'add${capitalize(ordinals[j])}', () {
          out.writeln(
            'final other = '
            'tuple.add${capitalize(ordinals[j])}(\'a\');',
          );
          out.writeln('check(other.length).equals(tuple.length + 1);');
          for (var k = 0; k < i + 1; k++) {
            final expected = k == j
                ? '\'a\''
                : k < j
                ? numbers[k]
                : numbers[k - 1];
            out.writeln('check(other.${ordinals[k]}).equals($expected);');
          }
        });
      }
      nest('test', 'addLast', () {
        out.writeln('final other = tuple.addLast(\'a\');');
        out.writeln('check(other.length).equals(tuple.length + 1);');
        for (var k = 0; k < i + 1; k++) {
          final expected = k == i ? '\'a\'' : numbers[k];
          out.writeln('check(other.${ordinals[k]}).equals($expected);');
        }
      });
    }
    if (i > 0) {
      for (var j = 0; j < i; j++) {
        nest('test', 'remove${capitalize(ordinals[j])}', () {
          out.writeln(
            'final other = '
            'tuple.remove${capitalize(ordinals[j])}();',
          );
          out.writeln('check(other.length).equals(tuple.length - 1);');
          for (var k = 0; k < i - 1; k++) {
            final expected = k < j ? numbers[k] : numbers[k + 1];
            out.writeln('check(other.${ordinals[k]}).equals($expected);');
          }
        });
      }
      nest('test', 'removeLast', () {
        out.writeln('final other = tuple.removeLast();');
        out.writeln('check(other.length).equals(tuple.length - 1);');
        for (var k = 0; k < i - 1; k++) {
          out.writeln('check(other.${ordinals[k]}).equals(${numbers[k]});');
        }
      });
    }
    nest('test', 'length', () {
      out.writeln('check(tuple.length).equals($i);');
    });
    nest('test', 'map', () {
      final values = ordinals.sublist(0, i);
      final result = generator.nextInt(1024);
      out.writeln('check(tuple.map((${listify(values)}) ');
      if (values.isEmpty) {
        out.writeln('=> $result');
      } else {
        out.writeln('{');
        for (var j = 0; j < i; j++) {
          out.writeln('check(${values[j]}).equals(${numbers[j]});');
        }
        out.writeln('return $result;');
        out.writeln('}');
      }
      out.writeln(')).equals($result);');
    });
    nest('test', 'iterable', () {
      out.writeln(
        'check(tuple.iterable).deepEquals(<dynamic>[${listify(numbers)}]);',
      );
    });
    nest('test', 'toList', () {
      out.writeln(
        'check(tuple.toList()).deepEquals(<dynamic>[${listify(numbers)}]);',
      );
    });
    nest('test', 'toSet', () {
      out.writeln(
        'check(tuple.toSet()).deepEquals(<dynamic>{${listify(numbers)}});',
      );
    });
  });

  out.writeln('}');
  await out.close();
  await format(file);
}

Future<void> main() {
  testDir.createSync(recursive: true);
  return Future.wait([
    generateExport(),
    generateAbstract(),
    for (var i = 0; i < max; i++) generateImplementation(i),
    generateTupleTest(),
    for (var i = 0; i < max; i++) generateImplementationTest(i),
  ]);
}
