/// Mixin for objects that support approximate equality within an epsilon.
mixin CloseTo<T> {
  /// Tests if this object is close to another object.
  bool closeTo(T other, num epsilon);
}
