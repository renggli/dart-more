import 'dart:io';

import 'package:more/collection.dart';
import 'package:more/printer.dart';

/// Pretty prints and cleans up a Dart file.
Future<void> format(File file) async =>
    Process.run('dart', ['format', '--fix', file.absolute.path]);

/// Prints a warning at the top of generated files.
void generateWarning(StringSink out) {
  out.writeln('// AUTO-GENERATED CODE: DO NOT EDIT');
  out.writeln();
}

/// Pretty printer for ordinal numbers.
final ordinal = OrdinalNumberPrinter();

/// Generate the variable names.
List<String> generateValues(int i) => List.generate(i, (i) => '\$${i + 1}');

/// Generate the type names.
List<String> generateTypes(int i) => List.generate(i, (i) => 'T${i + 1}');

/// Generate argument names.
List<String> generateArgs(int i) => List.generate(i, (i) => 'arg${i + 1}');

/// Generate type and argument names.
List<String> generateTypeAndArgs(int i) => [generateTypes(i), generateArgs(i)]
    .zip()
    .map((elements) => elements.join(' '))
    .toList();

/// Creates an argument list from types or variables.
String listify(Iterable<String> values) => values.join(', ');

/// Wraps a list of types in generics brackets.
String generify(Iterable<String> values) =>
    values.isEmpty ? '' : '<${listify(values)}>';

/// Creates a record type.
String recordify(Iterable<String> values) =>
    '(${listify(values)}${values.length == 1 ? ', ' : ''})';

/// Capitalizes the first character of a string.
String capitalize(String value) => value.toUpperCaseFirstCharacter();

/// Converts a label with separators into a camel-case name.
String namify(String value) => value
    .split(RegExp(r'[ /_-]'))
    .map((each) => each.toLowerCase().toUpperCaseFirstCharacter())
    .join()
    .toLowerCaseFirstCharacter();
