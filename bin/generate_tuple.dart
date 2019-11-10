library more.bin.generate_tuple;

import 'dart:io';
import 'dart:math';

/// Number of tuples to generate (exclusive).
const max = 10;

/// Generate the variable names.
List<String> generateValues(int i) => List.generate(i, (i) => 'value$i');

/// Generate the type names.
List<String> generateTypes(int i) => List.generate(i, (i) => 'T$i');

/// Creates an argument list from types or variables.
String listify(Iterable<String> values) => values.join(', ');

/// Wraps a list of types in generics brackets.
String generify(Iterable<String> types) =>
    types.isEmpty ? '' : '<${listify(types)}>';

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
  out.writeln('library more.tuple;');
  out.writeln('');
  for (var i = 0; i < max; i++) {
    out.writeln('import \'package:more/src/tuple/tuple_$i.dart\';');
  }
  out.writeln('');
  for (var i = 0; i < max; i++) {
    out.writeln('export \'package:more/src/tuple/tuple_$i.dart\';');
  }
  out.writeln('');
  out.writeln('/// Abstract tuple class.');
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
  out.writeln('/// Number of elements in the tuple.');
  out.writeln('int get length;');
  out.writeln('');
  out.writeln('/// An [Iterable] over the values of this tuple.');
  out.writeln('Iterable get iterable;');
  out.writeln('');
  out.writeln('/// Returns a new tuple with the `value` added to the start.');
  out.writeln('Tuple addFirst<T>(T value);');
  out.writeln('');
  out.writeln('/// Returns a new tuple with the `value` added to the end.');
  out.writeln('Tuple addLast<T>(T value);');
  out.writeln('');
  out.writeln('/// Returns a new tuple with the first value removed.');
  out.writeln('Tuple removeFirst();');
  out.writeln('');
  out.writeln('/// Returns a new tuple with the last value removed.');
  out.writeln('Tuple removeLast();');
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

  out.writeln('library more.tuple.tuple_$i;');
  out.writeln('');
  out.writeln('import \'package:more/tuple.dart\';');
  out.writeln('');
  out.writeln('/// Tuple with $i element${i != 1 ? 's' : ''}.');
  out.writeln('class Tuple$i${generify(types)} extends Tuple {');

  // variables
  for (var j = 0; j < i; j++) {
    out.writeln('final ${types[j]} ${values[j]};');
  }

  // constructors
  final constructorVariables = listify(values.map((value) => 'this.$value'));
  out.writeln('');
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

  // replace
  for (var j = 0; j < i; j++) {
    final typesReplaced = [...types];
    final valuesReplaced = [...values];
    typesReplaced[j] = 'T';
    valuesReplaced[j] = 'value';
    out.writeln('');
    out.writeln('/// Returns a new tuple with index $j replaced by [value].');
    out.writeln('Tuple$i${generify(typesReplaced)} '
        'with$j<T>(T value) => Tuple$i(${listify(valuesReplaced)});');
  }

  // add first / last
  if (i < max - 1) {
    {
      final addTypes = generify(['T', ...types]);
      out.writeln('');
      out.writeln('@override');
      out.writeln('Tuple${i + 1}$addTypes addFirst<T>(T value) => '
          'addAt0(value);');
    }
    {
      final addTypes = generify([...types, 'T']);
      out.writeln('');
      out.writeln('@override');
      out.writeln('Tuple${i + 1}$addTypes addLast<T>(T value) => '
          'addAt$i(value);');
    }
    for (var j = 0; j <= i; j++) {
      final addTypes =
          generify([...types.sublist(0, j), 'T', ...types.sublist(j, i)]);
      final addValues =
          listify([...values.sublist(0, j), 'value', ...values.sublist(j, i)]);
      out.writeln('');
      out.writeln('/// Returns a new tuple with [value] added at index $j.');
      out.writeln('Tuple${i + 1}$addTypes addAt$j<T>(T value) => '
          'Tuple${i + 1}($addValues);');
    }
  } else {
    out.writeln('');
    out.writeln('@override');
    out.writeln(
        'Tuple addFirst<T>(T value) => throw StateError(\'Too many\');');
    out.writeln('');
    out.writeln('@override');
    out.writeln('Tuple addLast<T>(T value) => throw StateError(\'Too many\');');
  }

  // remove first / last
  if (i > 0) {
    {
      final removeTypes = generify(types.sublist(1, i));
      out.writeln('');
      out.writeln('@override');
      out.writeln('Tuple${i - 1}$removeTypes removeFirst() => removeAt0();');
    }
    {
      final removeTypes = generify(types.sublist(0, i - 1));
      out.writeln('');
      out.writeln('@override');
      out.writeln(
          'Tuple${i - 1}$removeTypes removeLast() => removeAt${i - 1}();');
    }
    for (var j = 0; j < i; j++) {
      final removeTypes =
          generify([...types.sublist(0, j), ...types.sublist(j + 1)]);
      final removeValues =
          listify([...values.sublist(0, j), ...values.sublist(j + 1)]);
      out.writeln('');
      out.writeln('/// Returns a new tuple with index $j removed.');
      out.writeln('Tuple${i - 1}$removeTypes removeAt$j() => '
          '${i - 1 == 0 ? 'const ' : ''}Tuple${i - 1}($removeValues);');
    }
  } else {
    out.writeln('');
    out.writeln('@override');
    out.writeln('Tuple removeFirst() => throw StateError(\'Too few\');');
    out.writeln('');
    out.writeln('@override');
    out.writeln('Tuple removeLast() => throw StateError(\'Too few\');');
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
    final hashCodes = values.map((each) => ' ^ $each.hashCode').join();
    out.writeln('');
    out.writeln('@override');
    out.writeln('int get hashCode => ${generator.nextInt(4294967296)}'
        '$hashCodes;');
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

  out.writeln('library more.test.tuple_test;');
  out.writeln('');
  out.writeln('import \'package:more/tuple.dart\';');
  out.writeln('import \'package:test/test.dart\';');
  out.writeln('');
  out.writeln('void main() {');

  for (var i = 0; i < max; i++) {
    nest('group', 'Tuple$i', () {
      final numbers = List.generate(i, (i) => '${generator.nextInt(256)}');
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
            out.writeln('expect(tuple.value$j, ${numbers[j]});');
          }
        });
      }
      for (var j = 0; j < i; j++) {
        nest('test', 'with$j', () {
          out.writeln('final other = tuple.with$j(\'a\');');
          for (var k = 0; k < i; k++) {
            out.writeln(
                'expect(other.value$k, ${j == k ? '\'a\'' : numbers[k]});');
          }
        });
      }
      if (i < max - 1) {
        nest('test', 'addFirst', () {
          out.writeln('final other = tuple.addFirst(\'a\');');
          out.writeln('expect(other.length,  tuple.length + 1);');
          for (var j = 0; j < i + 1; j++) {
            final expected = j == 0 ? '\'a\'' : numbers[j - 1];
            out.writeln('expect(other.value$j, $expected);');
          }
        });
        nest('test', 'addLast', () {
          out.writeln('final other = tuple.addLast(\'a\');');
          out.writeln('expect(other.length,  tuple.length + 1);');
          for (var j = 0; j < i + 1; j++) {
            final expected = j == i ? '\'a\'' : numbers[j];
            out.writeln('expect(other.value$j, $expected);');
          }
        });
        for (var j = 0; j <= i; j++) {
          nest('test', 'addAt$j', () {
            out.writeln('final other = tuple.addAt$j(\'a\');');
            out.writeln('expect(other.length,  tuple.length + 1);');
            for (var k = 0; k < i + 1; k++) {
              final expected =
                  k == j ? '\'a\'' : k < j ? numbers[k] : numbers[k - 1];
              out.writeln('expect(other.value$k, $expected);');
            }
          });
        }
      } else {
        nest('test', 'add', () {
          out.writeln('expect(() => tuple.addFirst(-1), throwsStateError);');
          out.writeln('expect(() => tuple.addLast(-1), throwsStateError);');
        });
      }
      if (i > 0) {
        nest('test', 'removeFirst', () {
          out.writeln('final other = tuple.removeFirst();');
          out.writeln('expect(other.length,  tuple.length - 1);');
          for (var j = 0; j < i - 1; j++) {
            out.writeln('expect(other.value$j, ${numbers[j + 1]});');
          }
        });
        nest('test', 'removeLast', () {
          out.writeln('final other = tuple.removeLast();');
          out.writeln('expect(other.length,  tuple.length - 1);');
          for (var j = 0; j < i - 1; j++) {
            out.writeln('expect(other.value$j, ${numbers[j]});');
          }
        });
        for (var j = 0; j < i; j++) {
          nest('test', 'removeAt$j', () {
            out.writeln('final other = tuple.removeAt$j();');
            out.writeln('expect(other.length,  tuple.length - 1);');
            for (var k = 0; k < i - 1; k++) {
              final expected = k < j ? numbers[k] : numbers[k + 1];
              out.writeln('expect(other.value$k, $expected);');
            }
          });
        }
      } else {
        nest('test', 'remove', () {
          out.writeln('expect(() => tuple.removeFirst(), throwsStateError);');
          out.writeln('expect(() => tuple.removeLast(), throwsStateError);');
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
      nest('test', 'equals', () {
        out.writeln('expect(tuple == tuple, isTrue);');
        if (i > 0) {
          out.writeln('expect(tuple == tuple.with${i - 1}(-1), isFalse);');
          out.writeln('// ignore: unrelated_type_equality_checks');
          out.writeln('expect(tuple == tuple.with${i - 1}(\'a\'), isFalse);');
        } else {
          out.writeln('expect(tuple == const Tuple1(-1), isFalse);');
        }
      });
      nest('test', 'hashCode', () {
        out.writeln('expect(tuple.hashCode == tuple.hashCode, isTrue);');
        if (i > 0) {
          out.writeln('expect(tuple.hashCode == '
              'tuple.with${i - 1}(-1).hashCode, isFalse);');
          out.writeln('expect(tuple.hashCode == '
              'tuple.with${i - 1}(\'a\').hashCode, isFalse);');
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
