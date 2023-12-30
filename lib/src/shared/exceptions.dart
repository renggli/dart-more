/// Check that an integer value is non-zero and positive.
int checkNonZeroPositive(int value, [String? name, String? message]) {
  if (value < 1) {
    throw RangeError.range(value, 1, null, name ?? 'value', message);
  }
  return value;
}
