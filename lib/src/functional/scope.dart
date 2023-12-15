extension ScopeFunctionExtension<T> on T {
  /// Evaluates the [callback] with the receiver as the argument. Returns
  /// the results of [callback] as the return value.
  ///
  /// In a cascade, this is useful to chain calls to other functions:
  ///
  ///     [1, 2, 3]
  ///       ..also((list) => print('Before: $list'))
  ///       ..add(4)
  ///       ..also((list) => print('After: $list'));
  ///
  /// On a nullable value, this is useful to only evaluate code on non-null
  /// objects. For example, to convert a nullable string to an int, one could
  /// write:
  ///
  ///     final value = nullableString?.also(int.tryParse);
  ///
  S also<S>(S Function(T value) callback) => callback(this);
}
