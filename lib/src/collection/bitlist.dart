import 'dart:collection' show ListBase;
import 'dart:math';
import 'dart:typed_data' show Uint32List;

import 'package:collection/collection.dart' show NonGrowableListMixin;

import '../math/bit.dart';
import 'range/integer.dart' show IntegerRange;

/// An space efficient [List] that stores boolean values.
abstract class BitList extends ListBase<bool> {
  /// Constructs a bit list of the given [length].
  factory BitList(int length, {bool fill = false, bool growable = false}) =>
      BitList.filled(length, fill, growable: growable);

  /// Constructs an empty bit list.
  factory BitList.empty({bool growable = false}) =>
      BitList.filled(0, false, growable: growable);

  /// Constructs a bit list of the given [length], and initializes the value at
  /// each position with [fill].
  factory BitList.filled(int length, bool fill, {bool growable = false}) {
    final buffer = Uint32List((length + bitOffset) >>> bitShift);
    if (fill) buffer.fillRange(0, buffer.length, bitMask);
    return growable
        ? GrowableBitList(buffer, length)
        : FixedBitList(buffer, length);
  }

  /// Constructs a bit list of the given [length] by calling a [generator]
  /// function for each index.
  factory BitList.generate(int length, bool Function(int index) generator,
          {bool growable = false}) =>
      BitList.of(IntegerRange.length(length).map(generator),
          growable: growable);

  /// Constructs a new list from a given [Iterable] of booleans.
  factory BitList.of(Iterable<bool> other, {bool growable = false}) {
    final length = other.length;
    final result = BitList(length, growable: growable);
    final buffer = result.buffer;
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
    return result;
  }

  /// Constructs a new list from a given [Iterable] of booleans.
  factory BitList.from(Iterable<bool> other, {bool growable = false}) =>
      BitList.of(other, growable: growable);

  /// Internal generative constructor.
  BitList._();

  /// The underlying typed buffer of this object.
  Uint32List get buffer;

  /// Returns the value of the bit with the given [index].
  @override
  bool operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return getUnchecked(index);
  }

  /// Returns the value of the bit with the given [index]. The behavior is
  /// undefined if [index] is outside of bounds.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool getUnchecked(int index) =>
      (buffer[index >>> bitShift] & bitSetMask[index & bitOffset]) != 0;

  /// Sets the [value] of the bit with the given [index].
  @override
  void operator []=(int index, bool value) {
    RangeError.checkValidIndex(index, this);
    setUnchecked(index, value);
  }

  /// Sets the [value] of the bit with the given [index]. The behavior is
  /// undefined if [index] is outside of bounds.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void setUnchecked(int index, bool value) => value
      ? buffer[index >>> bitShift] |= bitSetMask[index & bitOffset]
      : buffer[index >>> bitShift] &= bitClearMask[index & bitOffset];

  @override
  BitList operator +(List<bool> other) {
    final result = BitList(length + other.length);
    result.buffer.setRange(0, buffer.length, buffer);
    for (var i = 0; i < other.length; i++) {
      result.setUnchecked(length + i, other[i]);
    }
    return result;
  }

  @override
  void fillRange(int start, int end, [bool? fill]) {
    RangeError.checkValidRange(start, end, length);
    _fillRange(buffer, start, end, fill ?? false);
  }

  /// Sets the bit at the specified [index] to the complement of its current
  /// value.
  void flip(int index) {
    RangeError.checkValidIndex(index, this);
    flipUnchecked(index);
  }

  /// Sets the bit at the specified [index] to the complement of its current
  /// value. The behavior is undefined if [index] is outside of bounds.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void flipUnchecked(int index) =>
      buffer[index >>> bitShift] ^= bitSetMask[index & bitOffset];

  /// Counts the number of bits set to [expected].
  int count({bool expected = true}) =>
      countRange(0, length, expected: expected);

  /// Counts the number of bits set to [expected] in the range of [start]
  /// (inclusive) to [end] (exclusive).
  int countRange(int start, int end, {bool expected = true}) {
    RangeError.checkValidRange(start, end, length);
    if (start == end) return 0;
    final startIndex = start >>> bitShift, startBit = start & bitOffset;
    final endIndex = (end - 1) >>> bitShift, endBit = (end - 1) & bitOffset;
    var result = 0;
    if (startIndex == endIndex) {
      result += (buffer[startIndex] &
              (((1 << (endBit - startBit + 1)) - 1) << startBit))
          .bitCount;
    } else {
      result += (buffer[startIndex] & (bitMask << startBit)).bitCount;
      for (var i = startIndex + 1; i < endIndex; i++) {
        result += buffer[i].bitCount;
      }
      result += (buffer[endIndex] & ((1 << (endBit + 1)) - 1)).bitCount;
    }
    return expected ? result : (end - start) - result;
  }

  /// Returns an iterable over the indices with the bit set to [expected].
  Iterable<int> indices({bool expected = true}) sync* {
    var mask = 0, index = 0, value = 0;
    for (var i = 0; i < length; i++) {
      if (mask == 0) {
        value = buffer[index++];
        mask = 1;
      }
      if ((value & mask != 0) == expected) {
        yield i;
      }
      mask = (mask << 1) & bitMask;
    }
  }

  /// Returns the complement of the receiver.
  ///
  /// The new [BitList] has all the bits of the receiver inverted.
  BitList operator ~() => BitList.of(this)..not();

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
  BitList operator &(BitList other) => BitList.of(this)..and(other);

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
  BitList operator |(BitList other) => BitList.of(this)..or(other);

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
  BitList operator -(BitList other) => BitList.of(this)..difference(other);

  /// Computes the difference of the receiver and [other] in-place.
  void difference(BitList other) {
    _checkLength(other);
    for (var i = 0; i < buffer.length; i++) {
      buffer[i] &= ~other.buffer[i];
    }
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
    final shift = amount >>> bitShift;
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
    final shift = amount >>> bitShift;
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

class GrowableBitList extends BitList {
  GrowableBitList(this.buffer, this._length) : super._();

  @override
  Uint32List buffer;

  int _length;

  @override
  int get length => _length;

  @override
  set length(int length) {
    RangeError.checkNotNegative(length, 'length');
    final requested = (length + bitOffset) >>> bitShift;
    if (buffer.length < requested) {
      final newBuffer = Uint32List(max(2 * buffer.length, requested));
      newBuffer.setRange(0, buffer.length, buffer);
      buffer = newBuffer;
    } else if (2 * requested < buffer.length) {
      final newBuffer = Uint32List(requested);
      newBuffer.setRange(0, newBuffer.length, buffer);
      buffer = newBuffer;
    }
    if (_length < length) {
      // When growing, make sure we always have predictable state.
      _fillRange(buffer, _length, length, false);
    }
    _length = length;
  }
}

class FixedBitList extends BitList with NonGrowableListMixin<bool> {
  FixedBitList(this.buffer, this.length) : super._();

  @override
  final Uint32List buffer;

  @override
  final int length;
}

extension BitListExtension on Iterable<bool> {
  /// Converts this [Iterable] to a space-efficient [BitList].
  BitList toBitList({bool growable = false}) =>
      BitList.of(this, growable: growable);
}

// Constants specific to mapping bits into a [UInt32List].
const int bitShift = 5;
const int bitOffset = 31;
const int bitCount = bitOffset + 1;
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

void _fillRange(Uint32List buffer, int start, int end, bool value) {
  if (start == end) return;
  final startIndex = start >>> bitShift, startBit = start & bitOffset;
  final endIndex = (end - 1) >>> bitShift, endBit = (end - 1) & bitOffset;
  if (value) {
    if (startIndex == endIndex) {
      buffer[startIndex] |= ((1 << (endBit - startBit + 1)) - 1) << startBit;
    } else {
      buffer[startIndex] |= bitMask << startBit;
      buffer.fillRange(startIndex + 1, endIndex, bitMask);
      buffer[endIndex] |= (1 << (endBit + 1)) - 1;
    }
  } else {
    if (startIndex == endIndex) {
      buffer[startIndex] &= ((1 << startBit) - 1) | (bitMask << (endBit + 1));
    } else {
      buffer[startIndex] &= (1 << startBit) - 1;
      buffer.fillRange(startIndex + 1, endIndex, 0);
      buffer[endIndex] &= bitMask << (endBit + 1);
    }
  }
}
