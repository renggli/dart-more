import 'package:meta/meta.dart';

import '../../../functional.dart';
import '../printer.dart';
import 'config.dart';
import 'field.dart';
import 'field_callback.dart';
import 'field_value.dart';
import 'type.dart';

/// Configurable printer for standard objects.
@optionalTypeArgs
class ObjectPrinter<T> extends Printer<T> {
  /// Creates an object printer based on the static type.
  ObjectPrinter.static({
    this.beforeFields = defaultBeforeFields,
    this.fieldName,
    this.fieldNameSeparator = defaultFieldNameSeparator,
    this.fieldValue,
    this.fieldSeparator = defaultFieldSeparator,
    this.afterFields = defaultAfterFields,
  }) : type = Printer<T>.literal(T.toString());

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

  /// Adds a callback field printer.
  void addCallback<F>(
    Map1<T, F> callback, {
    String? name,
    Printer<F>? printer,
    bool omitNull = defaultOmitNull,
    Predicate2<T, F>? omitPredicate,
    int? index,
  }) => addField(
    FieldCallback<T, F>(
      name,
      callback,
      omitNull,
      omitPredicate,
      printer ?? Printer<F>.standard(),
    ),
    index: index,
  );

  /// Adds a value field printer.
  void addValue<F>(
    F value, {
    String? name,
    Printer<F>? printer,
    bool omitNull = defaultOmitNull,
    Predicate1<F>? omitPredicate,
    int? index,
  }) => addField(
    FieldValue<T, F>(
      name,
      value,
      omitNull,
      omitPredicate,
      printer ?? Printer<F>.standard(),
    ),
    index: index,
  );

  /// Adds a custom field printer.
  void addField(FieldPrinter<T> field, {int? index}) =>
      index == null ? fields.add(field) : fields.insert(index, field);

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

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(type, name: 'type')
    ..addValue(beforeFields, name: 'beforeFields')
    ..addValue(fieldName, name: 'fieldName')
    ..addValue(fieldNameSeparator, name: 'fieldNameSeparator')
    ..addValue(fieldValue, name: 'fieldValue')
    ..addValue(fieldSeparator, name: 'fieldSeparator')
    ..addValue(afterFields, name: 'afterFields')
    ..addValue(fields, name: 'fields');
}
