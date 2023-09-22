import 'dart:io';
import 'dart:math';

import 'package:more/src/collection/iterable/zip.dart';

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

/// Generate the variable names.
List<String> generateValues(int i) => List.generate(i, (i) => '\$${i + 1}');

/// Generate the type names.
List<String> generateTypes(int i) => List.generate(i, (i) => 'T${i + 1}');

/// Creates an argument list from types or variables.
String listify(Iterable<String> values) => values.join(', ');

/// Wraps a list of types in generics brackets.
String generify(Iterable<String> values) =>
    values.isEmpty ? '' : '<${listify(values)}>';

/// Creates a record type.
String recordify(Iterable<String> values) =>
    '(${listify(values)}${values.length == 1 ? ', ' : ''})';

/// Capitalizes the first character of a string.
String capitalize(String value) =>
    value.replaceRange(0, 1, value[0].toUpperCase());

/// Export file.
final File exportFile = File('lib/tuple.dart');

/// Abstract file.
final File abstractFile = File('lib/src/tuple/tuple.dart');

/// Implementation file.
File implementationFile(int i) => File('lib/src/tuple/tuple_$i.dart');

/// Test file.
final File testFile = File('test/tuple_test.dart');

/// Random generator for hash values.
final Random generator = Random(42);

/// Pretty prints and cleans up a dart file.
Future<void> format(File file) async =>
    Process.run('dart', ['format', '--fix', file.absolute.path]);

Future<void> generateExport() async {
  final file = exportFile;
  final out = file.openWrite();
  out.writeln('/// Tuple extension methods on generic records.');
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
  for (var i = 0; i < max; i++) {
    out.writeln('import \'tuple_$i.dart\';');
  }
  out.writeln();

  out.writeln('/// Extension methods on [Record].');
  out.writeln('extension Tuple on Record {');

  out.writeln('/// List constructor.');
  out.writeln('static Record fromList<T>(List<T> list) =>');
  out.writeln('switch (list.length) {');
  for (var i = 0; i < max; i++) {
    out.writeln('$i => Tuple$i.fromList(list),');
  }
  out.writeln('_ =>');
  out.writeln('throw ArgumentError.value(list, \'list\', '
      '\'Length \${list.length} not in range 0..${max - 1}\'),');
  out.writeln('};');
  out.writeln();

  out.writeln('}');
  await out.close();
  await format(file);
}

Future<void> generateImplementation(int i) async {
  final file = implementationFile(i);
  final out = file.openWrite();
  final types = generateTypes(i);
  final values = generateValues(i);

  out.writeln('/// Extension methods on [Record] with $i positional '
      'element${i != 1 ? 's' : ''}.');
  out.writeln('extension Tuple$i${generify(types)} on ${recordify(types)} {');

  // constructors
  final listTypes = List.generate(i, (i) => 'T');
  final listAccessors = List.generate(i, (i) => 'list[$i]');
  out.writeln('/// List constructor.');
  out.writeln('static ${recordify(listTypes)} fromList<T>(List<T> list) {');
  if (i == 0) {
    out.writeln('if (list.isNotEmpty) {');
  } else {
    out.writeln('if (list.length != $i) {');
  }
  out.writeln('throw ArgumentError.value(list, \'list\', '
      '\'Expected list of length $i, but got \${list.length}\');');
  out.writeln('}');
  out.writeln('return ${recordify(listAccessors)};');
  out.writeln('}');

  // length
  out.writeln();
  out.writeln('/// Returns the number of elements in the tuple.');
  out.writeln('int get length => $i;');

  // access
  for (var j = 0; j < i; j++) {
    out.writeln();
    out.writeln('/// Returns the ${ordinals[j]} element of this tuple.');
    out.writeln('${types[j]} get ${ordinals[j]} => ${values[j]};');
  }
  if (i > 0) {
    out.writeln();
    out.writeln('/// Returns the last element of this tuple.');
    out.writeln('${types.last} get last => ${values.last};');
  }

  // replace
  for (var j = 0; j < i; j++) {
    final typesReplaced = [...types];
    final valuesReplaced = [...values];
    typesReplaced[j] = 'T';
    valuesReplaced[j] = 'value';
    out.writeln();
    out.writeln('/// Returns a new tuple with the ${ordinals[j]} element '
        'replaced by [value].');
    out.writeln('${recordify(typesReplaced)} '
        'with${capitalize(ordinals[j])}<T>(T value) => '
        '${recordify(valuesReplaced)};');
    if (j == i - 1) {
      out.writeln();
      out.writeln('/// Returns a new tuple with the last element replaced by '
          '[value].');
      out.writeln('${recordify(typesReplaced)} '
          'withLast<T>(T value) => ${recordify(valuesReplaced)};');
    }
  }

  // add
  if (i < max - 1) {
    for (var j = 0; j <= i; j++) {
      final addTypes = [...types.sublist(0, j), 'T', ...types.sublist(j, i)];
      final addValues = [
        ...values.sublist(0, j),
        'value',
        ...values.sublist(j, i)
      ];
      out.writeln();
      out.writeln('/// Returns a new tuple with [value] added at the '
          '${ordinals[j]} position.');
      out.writeln('${recordify(addTypes)} '
          'add${capitalize(ordinals[j])}<T>(T value) => '
          '${recordify(addValues)};');
      if (j == i) {
        out.writeln();
        out.writeln('/// Returns a new tuple with [value] added at the last '
            'position.');
        out.writeln('${recordify(addTypes)} '
            'addLast<T>(T value) => ${recordify(addValues)};');
      }
    }
  }

  // remove
  if (i > 0) {
    for (var j = 0; j < i; j++) {
      final removeTypes = [...types.sublist(0, j), ...types.sublist(j + 1)];
      final removeValues = [...values.sublist(0, j), ...values.sublist(j + 1)];
      out.writeln();
      out.writeln('/// Returns a new tuple with the ${ordinals[j]} element '
          'removed.');
      out.writeln('${recordify(removeTypes)} '
          'remove${capitalize(ordinals[j])}() => ${recordify(removeValues)};');
      if (j == i - 1) {
        out.writeln();
        out.writeln('/// Returns a new tuple with the last element removed.');
        out.writeln('${recordify(removeTypes)} '
            'removeLast() => ${recordify(removeValues)};');
      }
    }
  }

  // map
  final typeAndOrdinals =
      [types, ordinals].zip().map((value) => value.join(' '));
  out.writeln();
  out.writeln('/// Applies the values of this tuple to an $i-ary function.');
  out.writeln('R map<R>(R Function(${listify(typeAndOrdinals)}) callback) => ');
  out.writeln('callback(${listify(values)});');

  // iterable
  final prefix = i == 0 ? 'const ' : '';
  out.writeln();
  out.writeln('/// An (untyped) [Iterable] over the values of this tuple.');
  out.write('Iterable<dynamic> get iterable ');
  if (i == 0) {
    out.writeln('=> const [];');
  } else {
    out.writeln('sync* {');
    for (var j = 0; j < i; j++) {
      out.writeln('yield ${values[j]};');
    }
    out.writeln('}');
  }
  out.writeln();
  out.writeln('/// An (untyped) [List] with the values of this tuple.');
  out.writeln('List<dynamic> toList() => $prefix[${listify(values)}];');
  out.writeln();
  out.writeln('/// An (untyped) [Set] with the unique values of this tuple.');
  out.writeln('Set<dynamic> toSet() => $prefix{${listify(values)}};');

  out.writeln('}');
  await out.close();
  await format(file);
}

Future<void> generateTest() async {
  final file = testFile;
  final out = file.openWrite();

  void nest(String type, String name, void Function() callback) {
    out.writeln('$type(\'$name\', () {');
    callback();
    out.writeln('});');
  }

  out.writeln('import \'package:more/tuple.dart\';');
  out.writeln('import \'package:test/test.dart\';');
  out.writeln();
  out.writeln('void main() {');

  for (var i = 0; i < max; i++) {
    nest('group', 'Tuple$i', () {
      // Make sure the numbers are unique.
      var numbers = <String>[];
      do {
        numbers = List.generate(i, (i) => '${generator.nextInt(256)}');
      } while (Set.of(numbers).length != i);
      out.writeln('const tuple = ${recordify(numbers)};');
      nest('test', 'Tuple.fromList', () {
        final many = List.generate(max, (i) => '${generator.nextInt(256)}');
        out.writeln('final other = Tuple.fromList([${listify(numbers)}]);');
        out.writeln('expect(other, tuple);');
        out.writeln('expect(() => Tuple.fromList([${listify(many)}]), '
            'throwsArgumentError);');
      });
      nest('test', 'fromList', () {
        final many = List.generate(i + 1, (i) => '${generator.nextInt(256)}');
        out.writeln('final other = Tuple$i.fromList([${listify(numbers)}]);');
        out.writeln('expect(other, tuple);');
        out.writeln('expect(() => Tuple$i.fromList([${listify(many)}]), '
            'throwsArgumentError);');
      });
      if (i > 0) {
        nest('test', 'read', () {
          for (var j = 0; j < i; j++) {
            out.writeln('expect(tuple.${ordinals[j]}, ${numbers[j]});');
          }
          out.writeln('expect(tuple.last, ${numbers.last});');
        });
      }
      for (var j = 0; j < i; j++) {
        nest('test', 'with${capitalize(ordinals[j])}', () {
          out.writeln('final other = '
              'tuple.with${capitalize(ordinals[j])}(\'a\');');
          for (var k = 0; k < i; k++) {
            out.writeln('expect(other.${ordinals[k]}, '
                '${j == k ? '\'a\'' : numbers[k]});');
          }
        });
        if (j == i - 1) {
          nest('test', 'withLast', () {
            out.writeln('final other = tuple.withLast(\'a\');');
            for (var k = 0; k < i; k++) {
              out.writeln('expect(other.${ordinals[k]}, '
                  '${j == k ? '\'a\'' : numbers[k]});');
            }
          });
        }
      }
      if (i < max - 1) {
        for (var j = 0; j <= i; j++) {
          nest('test', 'add${capitalize(ordinals[j])}', () {
            out.writeln('final other = '
                'tuple.add${capitalize(ordinals[j])}(\'a\');');
            out.writeln('expect(other.length, tuple.length + 1);');
            for (var k = 0; k < i + 1; k++) {
              final expected = k == j
                  ? '\'a\''
                  : k < j
                      ? numbers[k]
                      : numbers[k - 1];
              out.writeln('expect(other.${ordinals[k]}, $expected);');
            }
          });
        }
        nest('test', 'addLast', () {
          out.writeln('final other = tuple.addLast(\'a\');');
          out.writeln('expect(other.length, tuple.length + 1);');
          for (var k = 0; k < i + 1; k++) {
            final expected = k == i ? '\'a\'' : numbers[k];
            out.writeln('expect(other.${ordinals[k]}, $expected);');
          }
        });
      }
      if (i > 0) {
        for (var j = 0; j < i; j++) {
          nest('test', 'remove${capitalize(ordinals[j])}', () {
            out.writeln('final other = '
                'tuple.remove${capitalize(ordinals[j])}();');
            out.writeln('expect(other.length, tuple.length - 1);');
            for (var k = 0; k < i - 1; k++) {
              final expected = k < j ? numbers[k] : numbers[k + 1];
              out.writeln('expect(other.${ordinals[k]}, $expected);');
            }
          });
        }
        nest('test', 'removeLast', () {
          out.writeln('final other = tuple.removeLast();');
          out.writeln('expect(other.length, tuple.length - 1);');
          for (var k = 0; k < i - 1; k++) {
            out.writeln('expect(other.${ordinals[k]}, ${numbers[k]});');
          }
        });
      }
      nest('test', 'length', () {
        out.writeln('expect(tuple.length, $i);');
      });
      nest('test', 'map', () {
        final values = ordinals.sublist(0, i);
        final result = generator.nextInt(1024);
        out.writeln('expect(tuple.map((${listify(values)}) ');
        if (values.isEmpty) {
          out.writeln('=> $result');
        } else {
          out.writeln('{');
          for (var j = 0; j < i; j++) {
            out.writeln('expect(${values[j]}, ${numbers[j]});');
          }
          out.writeln('return $result;');
          out.writeln('}');
        }
        out.writeln('), $result);');
      });
      nest('test', 'iterable', () {
        out.writeln('expect(tuple.iterable, <dynamic>[${listify(numbers)}]);');
      });
      nest('test', 'toList', () {
        out.writeln('expect(tuple.toList(), <dynamic>[${listify(numbers)}]);');
      });
      nest('test', 'toSet', () {
        out.writeln('expect(tuple.toSet(), <dynamic>{${listify(numbers)}});');
      });
    });
  }
  out.writeln('}');

  await out.close();
  await format(file);
}

Future<void> main() => Future.wait([
      generateExport(),
      generateAbstract(),
      for (var i = 0; i < max; i++) generateImplementation(i),
      generateTest(),
    ]);
