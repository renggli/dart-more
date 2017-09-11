library more.collection.bitlist;

import 'dart:collection' show ListBase;
import 'dart:typed_data' show Uint32List;

import 'package:collection/collection.dart' show NonGrowableListMixin;

/// An space efficient fixed length [List] that stores boolean values.
class BitList extends ListBase<bool> with NonGrowableListMixin<bool> {

  /// Constructs a bit list of the given [length].
  factory BitList(int length) => new BitList.filled(length, false);

  /// Constructs a bit list of the given [length], and initializes the
  /// value at each position with [fill].
  factory BitList.filled(int length, bool fill) {
    var buffer = new Uint32List((length + OFFSET) >> SHIFT);
    if (fill) {
      buffer.fillRange(0, buffer.length, MASK);
    }
    return new BitList._(buffer, length);
  }

  /// Constructs a new list from a given [Iterable] of booleans.
  factory BitList.from(Iterable<bool> other) {
    var length = other.length;
    var buffer = new Uint32List((length + OFFSET) >> SHIFT);
    if (other is BitList) {
      buffer.setAll(0, other.buffer);
    } else {
      for (var i = 0, iterator = other.iterator; i < buffer.length; i++) {
        var value = 0;
        for (var j = 0; j <= OFFSET && iterator.moveNext(); j++) {
          if (iterator.current) {
            value |= SET_MASK[j];
          }
        }
        buffer[i] = value;
      }
    }
    return new BitList._(buffer, length);
  }

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
    return (buffer[index >> SHIFT] & SET_MASK[index & OFFSET]) != 0;
  }

  /// Sets the [value] of the bit with the given [index].
  @override
  void operator []=(int index, bool value) {
    RangeError.checkValidIndex(index, this);
    if (value) {
      buffer[index >> SHIFT] |= SET_MASK[index & OFFSET];
    } else {
      buffer[index >> SHIFT] &= CLEAR_MASK[index & OFFSET];
    }
  }

  /// Sets the bit at the specified [index] to the complement of its
  /// current value.
  void flip(int index) {
    RangeError.checkValidIndex(index, this);
    buffer[index >> SHIFT] ^= SET_MASK[index & OFFSET];
  }

  /// Counts the number of bits that are set to [expected].
  int count([bool expected = true]) {
    var tally = 0;
    for (var index = 0; index < length; index++) {
      var actual = (buffer[index >> SHIFT] & SET_MASK[index & OFFSET]) != 0;
      if (actual == expected) {
        tally++;
      }
    }
    return tally;
  }

  /// Returns the complement of the receiver.
  ///
  /// The new [BitList] has all the bits of the receiver inverted.
  BitList operator ~() {
    var result = new BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = ~buffer[i];
    }
    return result;
  }

  /// Returns the intersection of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are set in the receiver
  /// and in [other]. The receiver and [other] need to have the same length,
  /// otherwise an exception is thrown.
  BitList operator &(BitList other) {
    if (length != other.length) {
      throw new ArgumentError('Expected list with length ${length}, but got ${other.length}');
    }
    var result = new BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = buffer[i] & other.buffer[i];
    }
    return result;
  }

  /// Returns the union of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are either set in the
  /// receiver or in [other]. The receiver and [other] need to have the
  /// same length, otherwise an exception is thrown.
  BitList operator |(BitList other) {
    if (length != other.length) {
      throw new ArgumentError('Expected list with length ${length}, but got ${other.length}');
    }
    var result = new BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = buffer[i] | other.buffer[i];
    }
    return result;
  }

  /// Returns the difference of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are set in the receiver,
  /// but not in [other]. The receiver and [other] need to have the same
  /// length, otherwise an exception is thrown.
  BitList operator -(BitList other) {
    if (length != other.length) {
      throw new ArgumentError('Expected list with length ${length}, but got ${other.length}');
    }
    var result = new BitList(length);
    for (var i = 0; i < buffer.length; i++) {
      result.buffer[i] = buffer[i] & ~other.buffer[i];
    }
    return result;
  }

  /// Returns a [BitList] of the same length, but with the bits of the receiver shifted
  /// to the left by [amount]. Throws an [ArgumentError] if [amount] is negative.
  BitList operator <<(int amount) {
    if (amount < 0) {
      throw new ArgumentError('Unable to left-shift by $amount');
    }
    if (amount == 0 || length == 0) {
      return new BitList.from(this);
    }
    var shift = amount >> SHIFT;
    var offset = amount & OFFSET;
    var result = new BitList(length);
    if (offset == 0) {
      for (var i = shift; i < buffer.length; i++) {
        result.buffer[i] = buffer[i - shift];
      }
    } else {
      var otherOffset = 1 + OFFSET - offset;
      for (var i = shift + 1; i < buffer.length; i++) {
        result.buffer[i] = ((buffer[i - shift] << offset) & MASK) |
            ((buffer[i - shift - 1] >> otherOffset) & MASK);
      }
      if (shift < buffer.length) {
        result.buffer[shift] = (buffer[0] << offset) & MASK;
      }
    }
    return result;
  }

  /// Returns a [BitList] of the same length, but with the bits of the receiver shifted
  /// to the right by [amount]. Throws an [ArgumentError] if [amount] is negative.
  BitList operator >>(int amount) {
    if (amount < 0) {
      throw new ArgumentError('Unable to right-shift by $amount');
    }
    if (amount == 0 || length == 0) {
      return new BitList.from(this);
    }
    var shift = amount >> SHIFT;
    var offset = amount & OFFSET;
    var result = new BitList(length);
    if (offset == 0) {
      for (var i = 0; i < buffer.length - shift; i++) {
        result.buffer[i] = buffer[i + shift];
      }
    } else {
      var last = buffer.length - shift - 1;
      var otherOffset = 1 + OFFSET - offset;
      for (var i = 0; i < last; i++) {
        result.buffer[i] = ((buffer[i + shift] >> offset) & MASK) |
            ((buffer[i + shift + 1] << otherOffset) & MASK);
      }
      if (0 <= last) {
        result.buffer[last] = (buffer[buffer.length - 1] >> offset) & MASK;
      }
    }
    return result;
  }
}

// Constants specific to mapping bits into a [UInt32List].
const int SHIFT = 5;
const int OFFSET = 31;
const int MASK = 0xffffffff;
const List<int> SET_MASK = const [
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
const List<int> CLEAR_MASK = const [
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
