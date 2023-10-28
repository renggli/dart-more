import 'dart:typed_data';

extension DoubleExtension on double {
  /// Returns the nearest [double] in direction of positive infinity.
  double get nextUp {
    if (isNaN || this == double.infinity) return this;
    if (this == 0.0) return double.minPositive;
    return this < 0.0 ? _decrement(this) : _increment(this);
  }

  /// Returns the nearest [double] in direction of negative infinity.
  double get nextDown {
    if (isNaN || this == double.negativeInfinity) return this;
    if (this == 0.0) return -double.minPositive;
    return this < 0.0 ? _increment(this) : _decrement(this);
  }

  /// Returns the url (unit in the last place) of this value, that is the
  /// positive spacing between two consecutive floating-point numbers.
  double get ulp {
    if (this < 0.0) return (-this).ulp;
    if (!isFinite) return this;
    if (this == double.maxFinite) return this - nextDown;
    return nextUp - this;
  }

  /// Returns the nearest [double] in direction of [other]. If this is identical
  /// to [other], other is returned.
  double nextTowards(double other) {
    if (isNaN || other.isNaN) return double.nan;
    if (this == other) return other;
    if (this < other) return nextUp;
    return nextDown;
  }
}

final _dataBuffer = ByteData(8);

double _increment(double value) {
  _dataBuffer.setFloat64(0, value);
  final hi32 = _dataBuffer.getUint32(0);
  final lo32 = _dataBuffer.getUint32(4);
  _dataBuffer.setUint32(4, lo32 + 1);
  if (lo32 == 0xffffffff) {
    _dataBuffer.setUint32(0, hi32 + 1);
  }
  return _dataBuffer.getFloat64(0);
}

double _decrement(double value) {
  _dataBuffer.setFloat64(0, value);
  final hi32 = _dataBuffer.getUint32(0);
  final lo32 = _dataBuffer.getUint32(4);
  _dataBuffer.setUint32(4, lo32 - 1);
  if (lo32 == 0x00000000) {
    _dataBuffer.setUint32(0, hi32 - 1);
  }
  return _dataBuffer.getFloat64(0);
}
