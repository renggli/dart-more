import 'dart:io';
import 'dart:math';

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
List<String> generateValues(int i) => List.generate(i, (i) => ordinals[i]);

/// Generate the type names.
List<String> generateTypes(int i) => List.generate(i, (i) => 'T$i');

/// Creates an argument list from types or variables.
String listify(Iterable<String> values) => values.join(', ');

/// Wraps a list of types in generics brackets.
String generify(Iterable<String> types) =>
    types.isEmpty ? '' : '<${listify(types)}>';

/// Capitalizes the first character of a string.
String capitalize(String value) =>
    value.replaceRange(0, 1, value[0].toUpperCase());

/// Library file.
final File parentFile = File('lib/tuple.dart');

/// Tuple filename.
File childFile(int i) => File('lib/src/tuple/tuple_$i.dart');

/// Library file.
final File testFile = File('test/tuple_test.dart');

/// Random generator for hash values.
final Random generator = Random(42);

/// Pretty prints and cleans up a dart file.
Future<void> format(File file) async =>
    Process.run('dartfmt', ['--overwrite', '--fix', file.absolute.path]);

Future<void> generateParent(int max) async {
  final file = parentFile;
  final out = file.openWrite();
  out.writeln('/// Tuple data type.');
  out.writeln('import \'package:meta/meta.dart\' show immutable;');
  out.writeln('');
  for (var i = 0; i < max; i++) {
    out.writeln('import \'src/tuple/tuple_$i.dart\';');
  }
  out.writeln('');
  for (var i = 0; i < max; i++) {
    out.writeln('export \'src/tuple/tuple_$i.dart\';');
  }
  out.writeln('');
  out.writeln('/// Abstract tuple class.');
  out.writeln('@immutable');
  out.writeln('abstract class Tuple {');
  out.writeln('');
  out.writeln('/// Const constructor.');
  out.writeln('const Tuple();');
  out.writeln('');
  out.writeln('/// List constructor.');
  out.writeln('static Tuple fromList<T>(List<T> list) {');
  out.writeln('switch (list.length) {');
  for (var i = 0; i < max; i++) {
    out.writeln('case $i:');
    if (i > 0) {
      out.writeln('return Tuple$i.fromList(list);');
    } else {
      out.writeln('return const Tuple0();');
    }
  }
  out.writeln('default:');
  out.writeln('throw ArgumentError.value(list, \'list\', '
      '\'Length \${list.length} not in range 0..${max - 1}.\');');
  out.writeln('}');
  out.writeln('}');
  out.writeln('');
  out.writeln('/// The number of elements in the tuple.');
  out.writeln('int get length;');
  out.writeln('');
  out.writeln('/// An [Iterable] over the values of this tuple.');
  out.writeln('Iterable get iterable;');
  out.writeln('');
  out.writeln('/// A (untyped) [List] with the values of this tuple.');
  out.writeln('List toList({bool growable: false}) => ');
  out.writeln('  List.from(iterable, growable: growable);');
  out.writeln('');
  out.writeln('/// A (untyped) [Set] with the unique values of this tuple.');
  out.writeln('Set toSet() => Set.from(iterable);');
  out.writeln('');
  out.writeln('/// A string representation of this tuple.');
  out.writeln('@override');
  out.writeln('String toString() => \'(\${iterable.join(\', \')})\';');
  out.writeln('}');
  await out.close();
  await format(file);
}

Future<void> generateChild(int i, int max) async {
  final file = childFile(i);
  final out = file.openWrite();
  final types = generateTypes(i);
  final values = generateValues(i);

  if (i > 0) {
    out.writeln('import \'../../hash.dart\';');
  }
  out.writeln('import \'../../tuple.dart\';');
  out.writeln('');
  out.writeln('/// Tuple with $i element${i != 1 ? 's' : ''}.');
  out.writeln('class Tuple$i${generify(types)} extends Tuple {');

  // constructors
  final constructorVariables = listify(values.map((value) => 'this.$value'));
  out.writeln('/// Const constructor.');
  out.writeln('const Tuple$i($constructorVariables);');

  final listTypes = generify(List.generate(i, (i) => 'T'));
  final listAccessors = listify(List.generate(i, (i) => 'list[$i]'));
  out.writeln('');
  out.writeln('/// List constructor.');
  out.writeln('  // ignore: prefer_constructors_over_static_methods');
  out.writeln('static Tuple$i$listTypes fromList<T>(List<T> list) {');
  if (i == 0) {
    out.writeln('if (list.isNotEmpty) {');
  } else {
    out.writeln('if (list.length != $i) {');
  }
  out.writeln('throw ArgumentError.value(list, \'list\', '
      '\'Expected list of length $i, but got \${list.length}.\');');
  out.writeln('}');
  out.writeln('return ${i == 0 ? 'const ' : ''} Tuple$i($listAccessors);');
  out.writeln('}');

  // length
  out.writeln('');
  out.writeln('@override');
  out.writeln('int get length => $i;');

  // access
  for (var j = 0; j < i; j++) {
    out.writeln('');
    out.writeln('/// Returns the ${values[j]} element of this tuple.');
    out.writeln('final ${types[j]} ${values[j]};');
  }
  if (i > 0) {
    out.writeln('');
    out.writeln('/// Returns the last element of this tuple.');
    out.writeln('${types.last} get last => ${values.last};');
  }

  // replace
  for (var j = 0; j < i; j++) {
    final typesReplaced = [...types];
    final valuesReplaced = [...values];
    typesReplaced[j] = 'T';
    valuesReplaced[j] = 'value';
    out.writeln('');
    out.writeln('/// Returns a new tuple with the ${ordinals[j]} element '
        'replaced by [value].');
    out.writeln('Tuple$i${generify(typesReplaced)} '
        'with${capitalize(ordinals[j])}<T>(T value) => '
        'Tuple$i(${listify(valuesReplaced)});');
    if (j == i - 1) {
      out.writeln('');
      out.writeln('/// Returns a new tuple with the last element replaced by '
          '[value].');
      out.writeln('Tuple$i${generify(typesReplaced)} '
          'withLast<T>(T value) => '
          'Tuple$i(${listify(valuesReplaced)});');
    }
  }

  // add
  if (i < max - 1) {
    for (var j = 0; j <= i; j++) {
      final addTypes =
          generify([...types.sublist(0, j), 'T', ...types.sublist(j, i)]);
      final addValues =
          listify([...values.sublist(0, j), 'value', ...values.sublist(j, i)]);
      out.writeln('');
      out.writeln('/// Returns a new tuple with [value] added at the '
          '${ordinals[j]} position.');
      out.writeln('Tuple${i + 1}$addTypes '
          'add${capitalize(ordinals[j])}<T>(T value) => '
          'Tuple${i + 1}($addValues);');
      if (j == i) {
        out.writeln('');
        out.writeln('/// Returns a new tuple with [value] added at the last '
            'position.');
        out.writeln('Tuple${i + 1}$addTypes '
            'addLast<T>(T value) => '
            'Tuple${i + 1}($addValues);');
      }
    }
  }

  // remove
  if (i > 0) {
    for (var j = 0; j < i; j++) {
      final removeTypes =
          generify([...types.sublist(0, j), ...types.sublist(j + 1)]);
      final removeValues =
          listify([...values.sublist(0, j), ...values.sublist(j + 1)]);
      out.writeln('');
      out.writeln('/// Returns a new tuple with the ${ordinals[j]} element '
          'removed.');
      out.writeln('Tuple${i - 1}$removeTypes '
          'remove${capitalize(ordinals[j])}() => '
          '${i - 1 == 0 ? 'const ' : ''}Tuple${i - 1}($removeValues);');
      if (j == i - 1) {
        out.writeln('');
        out.writeln('/// Returns a new tuple with the last element removed.');
        out.writeln('Tuple${i - 1}$removeTypes '
            'removeLast() => '
            '${i - 1 == 0 ? 'const ' : ''}Tuple${i - 1}($removeValues);');
      }
    }
  }

  // iterable
  out.writeln('');
  out.writeln('@override');
  out.writeln('Iterable get iterable sync* {');
  for (var j = 0; j < i; j++) {
    out.writeln('yield ${values[j]};');
  }
  out.writeln('}');

  // equals
  {
    final equality = values.map((each) => ' && $each == other.$each').join();
    out.writeln('');
    out.writeln('@override');
    out.writeln('bool operator ==(Object other) => '
        'identical(this, other) || '
        '(other is Tuple$i$equality);');
  }

  // hashCode
  {
    final hashCode = i == 0
        ? generator.nextInt(4294967296).toString()
        : i <= 9 ? 'hash$i(${values.join(', ')})' : 'hash(iterable)';
    out.writeln('');
    out.writeln('@override');
    out.writeln('int get hashCode => $hashCode;');
  }

  out.writeln('}');
  await out.close();
  await format(file);
}

Future<void> generateTest(int max) async {
  final file = testFile;
  final out = file.openWrite();

  void nest(String type, String name, void Function() callback) {
    out.writeln('$type(\'$name\', () {');
    callback();
    out.writeln('});');
  }

  out.writeln('import \'package:more/tuple.dart\';');
  out.writeln('import \'package:test/test.dart\';');
  out.writeln('');
  out.writeln('void main() {');

  for (var i = 0; i < max; i++) {
    nest('group', 'Tuple$i', () {
      // Make sure the numbers are unique.
      var numbers = <String>[];
      do {
        numbers = List.generate(i, (i) => '${generator.nextInt(256)}');
      } while (Set.of(numbers).length != i);
      out.writeln('const tuple = Tuple$i(${numbers.join(', ')});');
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
              final expected =
                  k == j ? '\'a\'' : k < j ? numbers[k] : numbers[k - 1];
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
      nest('test', 'iterable', () {
        out.writeln('expect(tuple.iterable, <Object>[${numbers.join(', ')}]);');
      });
      nest('test', 'toList', () {
        out.writeln('expect(tuple.toList(), <Object>[${numbers.join(', ')}]);');
      });
      nest('test', 'toSet', () {
        out.writeln('expect(tuple.toSet(), <Object>{${numbers.join(', ')}});');
      });
      nest('test', 'toString', () {
        out.writeln('expect(tuple.toString(), \'(${numbers.join(', ')})\');');
      });
      final accessors =
          List.generate(i, (j) => 'tuple.${ordinals[j]}').join(', ');
      if (i == 0) {
        out.writeln('// ignore: prefer_const_constructors');
      }
      out.writeln('final copy = Tuple$i($accessors);');
      nest('test', 'equals', () {
        out.writeln('expect(tuple == tuple, isTrue);');
        out.writeln('expect(tuple == copy, isTrue);');
        out.writeln('expect(copy == tuple, isTrue);');
        for (var j = 0; j < i; j++) {
          out.writeln('expect(tuple == '
              'tuple.with${capitalize(ordinals[j])}(-1), isFalse);');
        }
      });
      nest('test', 'hashCode', () {
        out.writeln('expect(tuple.hashCode == copy.hashCode, isTrue);');
        for (var j = 0; j < i; j++) {
          out.writeln('expect(tuple.hashCode == '
              'tuple.with${capitalize(ordinals[j])}(-1).hashCode, isFalse);');
        }
      });
    });
  }
  out.writeln('}');

  await out.close();
  await format(file);
}

Future<void> main() async {
  await generateParent(max);
  for (var i = 0; i < max; i++) {
    await generateChild(i, max);
  }
  await generateTest(max);
}
