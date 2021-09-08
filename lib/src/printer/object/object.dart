import 'package:meta/meta.dart';

import '../../../functional.dart';
import '../../../printer.dart';
import '../standard.dart';
import 'field.dart';
import 'type.dart';
import 'utils.dart';

/// Configurable printer for standard objects.
class ObjectPrinter<T> extends Printer<T> {
  /// Printer of the object type.
  final Printer<T> type;

  /// String to print before the fields.
  final String? beforeFields;

  /// Printer of the field name.
  final Printer<String>? fieldName;

  /// String to print between field name and value.
  final String? fieldNameSeparator;

  /// Printer of the field value.
  final Printer<String>? fieldValue;

  /// String to print between fields themselves.
  final String? fieldSeparator;

  /// String to print after the fields.
  final String? afterFields;

  /// Fields to print.
  final List<FieldPrinter<T>> fields = [];

  /// Creates an object printer based on the static type.
  ObjectPrinter.static({
    this.beforeFields = defaultBeforeFields,
    this.fieldName,
    this.fieldNameSeparator = defaultFieldNameSeparator,
    this.fieldValue,
    this.fieldSeparator = defaultFieldSeparator,
    this.afterFields = defaultAfterFields,
  }) : type = LiteralPrinter<T>(T.toString());

  /// Creates an object printer based on the dynamic type.
  ObjectPrinter.dynamic({
    this.beforeFields = defaultBeforeFields,
    this.fieldName,
    this.fieldNameSeparator = defaultFieldNameSeparator,
    this.fieldValue,
    this.fieldSeparator = defaultFieldSeparator,
    this.afterFields = defaultAfterFields,
  }) : type = TypePrinter<T>();

  /// Creates a custom object printer.
  ObjectPrinter(
    this.type, {
    this.beforeFields = defaultBeforeFields,
    this.fieldName,
    this.fieldNameSeparator = defaultFieldNameSeparator,
    this.fieldValue,
    this.fieldSeparator = defaultFieldSeparator,
    this.afterFields = defaultAfterFields,
  });

  /// Adds a standard field printer.
  void add<F>(
    Map1<T, F> callback, {
    String? name,
    Printer<F>? printer,
    bool omitNull = false,
    Predicate2<T, F>? omitPredicate,
  }) =>
      addField(StandardField<T, F>(name, callback, omitNull, omitPredicate,
          printer ?? StandardPrinter<F>()));

  /// Adds a custom field printer.
  void addField(FieldPrinter<T> field) => fields.add(field);

  @override
  void printOn(T object, StringBuffer buffer) {
    type.printOn(object, buffer);
    printFieldsOn(object, buffer);
  }

  @protected
  void printFieldsOn(T object, StringBuffer buffer) {
    var fieldCounter = 0;
    for (final field in fields) {
      if (!field.isOmitted(object)) {
        if (fieldCounter == 0 && beforeFields != null) {
          buffer.write(beforeFields);
        }
        if (fieldCounter > 0 && fieldSeparator != null) {
          buffer.write(fieldSeparator);
        }
        printFieldOn(object, field, buffer);
        fieldCounter++;
      }
    }
    if (fieldCounter > 0 && afterFields != null) {
      buffer.write(afterFields);
    }
  }

  @protected
  void printFieldOn(T object, FieldPrinter<T> field, StringBuffer buffer) {
    final name = field.name;
    if (name != null) {
      if (fieldName != null) {
        fieldName!.printOn(name, buffer);
      } else {
        buffer.write(name);
      }
      if (fieldNameSeparator != null) {
        buffer.write(fieldNameSeparator);
      }
    }
    if (fieldValue != null) {
      fieldValue!.printOn(field.print(object), buffer);
    } else {
      field.printOn(object, buffer);
    }
  }
}

class StandardField<T, F> extends FieldPrinter<T> {
  StandardField(this.name, this.callback, this.omitNull, this.omitPredicate,
      this.printer);

  @override
  final String? name;
  final Map1<T, F> callback;
  final bool omitNull;
  final Predicate2<T, F>? omitPredicate;
  final Printer<F> printer;

  @override
  bool isOmitted(T object) {
    if (omitNull || omitPredicate != null) {
      final value = callback(object);
      if (omitNull && value == null) {
        return true;
      }
      if (omitPredicate != null && omitPredicate!(object, value)) {
        return true;
      }
    }
    return false;
  }

  @override
  void printOn(T object, StringBuffer buffer) =>
      printer.printOn(callback(object), buffer);
}
