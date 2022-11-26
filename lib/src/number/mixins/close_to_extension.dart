extension CloseToNumExtension on num /* implements CloseTo<num> */ {
  /// Tests if this object is close to another object.
  bool closeTo(num other, num epsilon) =>
      isFinite && other.isFinite && (this - other).abs() <= epsilon;
}
