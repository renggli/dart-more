import 'dart:collection' show ListBase;
import 'dart:typed_data' show Uint32List;

import 'package:collection/collection.dart' show NonGrowableListMixin;

/// An space efficient fixed length [List] that stores boolean values.
class BitList extends ListBase<bool> with NonGrowableListMixin<bool> {
  /// Constructs a bit list of the given [length].
  factory BitList(int length) => BitList.filled(length, false);

  /// Constructs a bit list of the given [length], and initializes the value at
  /// each position with [fill].
  factory BitList.filled(int length, bool fill) {
    final buffer = Uint32List((length + bitOffset) >> bitShift);
    if (fill) {
      buffer.fillRange(0, buffer.length, bitMask);
    }
    return BitList._(buffer, length);
  }

  /// Constructs a new list from a given [Iterable] of booleans.
  factory BitList.of(Iterable<bool> other) {
    final length = other.length;
    final buffer = Uint32List((length + bitOffset) >> bitShift);
    if (other is BitList) {
      buffer.setAll(0, other.buffer);
    } else {
      final iterator = other.iterator;
      for (var i = 0; i < buffer.length; i++) {
        var value = 0;
        for (var j = 0; j <= bitOffset && iterator.moveNext(); j++) {
          if (iterator.current) {
            value |= bitSetMask[j];
          }
        }
        buffer[i] = value;
      }
    }
    return BitList._(buffer, length);
  }

  /// Constructs a new list from a given [Iterable] of booleans.
  factory BitList.from(Iterable<bool> other) => BitList.of(other);

  /// Internal constructor for this object.
  BitList._(this.buffer, this.length);

  /// The underlying typed buffer of this object.
  final Uint32List buffer;

  /// Returns the number of bits in this object.
  @override
  final int length;

  /// Returns the value of the bit with the given [index].
  @override
  bool operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return getUnchecked(index);
  }

  /// Returns the value of the bit with the given [index]. The behavior is
  /// undefined if [index] is outside of bounds.
  bool getUnchecked(int index) =>
      (buffer[index >> bitShift] & bitSetMask[index & bitOffset]) != 0;

  /// Sets the [value] of the bit with the given [index].
  @override
  void operator []=(int index, bool value) {
    RangeError.checkValidIndex(index, this);
    setUnchecked(index, value);
  }

  /// Sets the [value] of the bit with the given [index].  The behavior is
  /// undefined if [index] is outside of bounds.
  void setUnchecked(int index, bool value) {
    if (value) {
      buffer[index >> bitShift] |= bitSetMask[index & bitOffset];
    } else {
      buffer[index >> bitShift] &= bitClearMask[index & bitOffset];
    }
  }

  @override
  BitList operator +(List<bool> other) {
    final result = BitList(length + other.length);
    result.buffer.setRange(0, buffer.length, buffer);
    for (var i = 0; i < other.length; i++) {
      result[length + i] = other[i];
    }
    return result;
  }

  /// Sets the bit at the specified [index] to the complement of its current
  /// value.
  void flip(int index) {
    RangeError.checkValidIndex(index, this);
    buffer[index >> bitShift] ^= bitSetMask[index & bitOffset];
  }

  /// Counts the number of bits that are set to [expected].
  int count([bool expected = true]) {
    var tally = 0;
    for (var index = 0; index < length; index++) {
      if (getUnchecked(index) == expected) {
        tally++;
      }
    }
    return tally;
  }

  /// Returns an iterable over the indexes with the bit set to [expected].
  Iterable<int> indexes([bool expected = true]) sync* {
    for (var index = 0; index < length; index++) {
      if (getUnchecked(index) == expected) {
        yield index;
      }
    }
  }

  /// Returns the complement of the receiver.
  ///
  /// The new [BitList] has all the bits of the receiver inverted.
  BitList operator ~() {
    final result = BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = ~buffer[i];
    }
    return result;
  }

  /// Computes the complement of the receiver in-place.
  void not() {
    for (var i = 0; i < buffer.length; i++) {
      buffer[i] = ~buffer[i];
    }
  }

  /// Returns the intersection of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are set in the receiver and in
  /// [other]. The receiver and [other] need to have the same length, otherwise
  /// an exception is thrown.
  BitList operator &(BitList other) {
    _checkLength(other);
    final result = BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = buffer[i] & other.buffer[i];
    }
    return result;
  }

  /// Computes the intersection of the receiver and [other] in-place.
  void and(BitList other) {
    _checkLength(other);
    for (var i = 0; i < buffer.length; i++) {
      buffer[i] &= other.buffer[i];
    }
  }

  /// Returns the union of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are either set in the receiver
  /// or in [other]. The receiver and [other] need to have the same length,
  /// otherwise an exception is thrown.
  BitList operator |(BitList other) {
    _checkLength(other);
    final result = BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = buffer[i] | other.buffer[i];
    }
    return result;
  }

  /// Computes the union of the receiver and [other] in-place.
  void or(BitList other) {
    _checkLength(other);
    for (var i = 0; i < buffer.length; i++) {
      buffer[i] |= other.buffer[i];
    }
  }

  /// Returns the difference of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are set in the receiver, but
  /// not in [other]. The receiver and [other] need to have the same length,
  /// otherwise an exception is thrown.
  BitList operator -(BitList other) {
    _checkLength(other);
    final result = BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = buffer[i] & ~other.buffer[i];
    }
    return result;
  }

  /// Returns a [BitList] of the same length, but with the bits of the receiver
  /// shifted to the left by [amount]. Throws an [ArgumentError] if [amount] is
  /// negative.
  BitList operator <<(int amount) {
    RangeError.checkNotNegative(
        amount, 'amount', 'Unable to left-shift by $amount');
    if (amount == 0 || length == 0) {
      return BitList.of(this);
    }
    final shift = amount >> bitShift;
    final offset = amount & bitOffset;
    final result = BitList(length);
    if (offset == 0) {
      for (var i = shift; i < buffer.length; i++) {
        result.buffer[i] = buffer[i - shift];
      }
    } else {
      final otherOffset = 1 + bitOffset - offset;
      for (var i = shift + 1; i < buffer.length; i++) {
        result.buffer[i] = ((buffer[i - shift] << offset) & bitMask) |
            ((buffer[i - shift - 1] >> otherOffset) & bitMask);
      }
      if (shift < buffer.length) {
        result.buffer[shift] = (buffer[0] << offset) & bitMask;
      }
    }
    return result;
  }

  /// Returns a [BitList] of the same length, but with the bits of the receiver
  /// shifted to the right by [amount]. Throws an [ArgumentError] if [amount] is
  /// negative.
  BitList operator >>(int amount) {
    RangeError.checkNotNegative(
        amount, 'amount', 'Unable to right-shift by $amount');
    if (amount == 0 || length == 0) {
      return BitList.of(this);
    }
    final shift = amount >> bitShift;
    final offset = amount & bitOffset;
    final result = BitList(length);
    if (offset == 0) {
      for (var i = 0; i < buffer.length - shift; i++) {
        result.buffer[i] = buffer[i + shift];
      }
    } else {
      final last = buffer.length - shift - 1;
      final otherOffset = 1 + bitOffset - offset;
      for (var i = 0; i < last; i++) {
        result.buffer[i] = ((buffer[i + shift] >> offset) & bitMask) |
            ((buffer[i + shift + 1] << otherOffset) & bitMask);
      }
      if (0 <= last) {
        result.buffer[last] = (buffer[buffer.length - 1] >> offset) & bitMask;
      }
    }
    return result;
  }

  void _checkLength(BitList other) {
    if (length != other.length) {
      throw ArgumentError.value(other, 'other',
          'Expected list with length $length, but got ${other.length}');
    }
  }
}

extension BitListExtension on Iterable<bool> {
  /// Converts this [Iterable] to a space-efficient [BitList].
  BitList toBitList() => BitList.of(this);
}

// Constants specific to mapping bits into a [UInt32List].
const int bitShift = 5;
const int bitOffset = 31;
const int bitMask = 0xffffffff;
const List<int> bitSetMask = [
  1,
  2,
  4,
  8,
  16,
  32,
  64,
  128,
  256,
  512,
  1024,
  2048,
  4096,
  8192,
  16384,
  32768,
  65536,
  131072,
  262144,
  524288,
  1048576,
  2097152,
  4194304,
  8388608,
  16777216,
  33554432,
  67108864,
  134217728,
  268435456,
  536870912,
  1073741824,
  2147483648
];
const List<int> bitClearMask = [
  -2,
  -3,
  -5,
  -9,
  -17,
  -33,
  -65,
  -129,
  -257,
  -513,
  -1025,
  -2049,
  -4097,
  -8193,
  -16385,
  -32769,
  -65537,
  -131073,
  -262145,
  -524289,
  -1048577,
  -2097153,
  -4194305,
  -8388609,
  -16777217,
  -33554433,
  -67108865,
  -134217729,
  -268435457,
  -536870913,
  -1073741825,
  -2147483649
];
