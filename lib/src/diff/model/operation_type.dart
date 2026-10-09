/// The four different types of operations.
enum OperationType {
  /// Replaces elements in source with elements in target.
  replace,

  /// Deletes elements from source.
  delete,

  /// Inserts elements into target.
  insert,

  /// Leaves elements unchanged.
  equal,
}
