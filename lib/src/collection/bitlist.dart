library more.collection.bitlist;

import 'dart:collection' show ListBase;
import 'dart:typed_data' show Uint32List;

import 'package:collection/collection.dart' show NonGrowableListMixin;

/// An space efficient fixed length [List] that stores boolean values.
class BitList extends ListBase<bool> with NonGrowableListMixin<bool> {

  // Constants specific to mapping bits into a [UInt32List].
  static const int _shift = 5;
  static const int _offset = 31;
  static const int _mask = 0xffffffff;
  static const List<int> _setMask = const [
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
  static const List<int> _clrMask = const [
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

  /// Constructs a bit list of the given [length].
  factory BitList(int length) {
    return new BitList.filled(length, false);
  }

  /// Constructs a bit list of the given [length], and initializes the
  /// value at each position with [fill].
  factory BitList.filled(int length, bool fill) {
    var buffer = new Uint32List((length + _offset) >> _shift);
    if (fill) {
      buffer.fillRange(0, buffer.length, _mask);
    }
    return new BitList._(buffer, length);
  }

  /// Constructs a new list from a given [Iterable] of booleans.
  factory BitList.from(Iterable<bool> other) {
    var length = other.length;
    var buffer = new Uint32List((length + _offset) >> _shift);
    if (other is BitList) {
      buffer.setAll(0, other.buffer);
    } else {
      for (var i = 0, iterator = other.iterator; i < buffer.length; i++) {
        var value = 0;
        for (var j = 0; j <= _offset && iterator.moveNext(); j++) {
          if (iterator.current) {
            value |= _setMask[j];
          }
        }
        buffer[i] = value;
      }
    }
    return new BitList._(buffer, length);
  }

  BitList._(this.buffer, this.length);

  /// The underlying typed buffer of this object.
  final Uint32List buffer;

  /// Returns the number of bits in this object.
  @override
  final int length;

  /// Returns the value of the bit with the given [index].
  @override
  bool operator [](int index) {
    if (0 <= index && index < length) {
      return (buffer[index >> _shift] & _setMask[index & _offset]) != 0;
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /// Sets the [value] of the bit with the given [index].
  @override
  void operator []=(int index, bool value) {
    if (0 <= index && index < length) {
      if (value) {
        buffer[index >> _shift] |= _setMask[index & _offset];
      } else {
        buffer[index >> _shift] &= _clrMask[index & _offset];
      }
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /// Sets the bit at the specified [index] to the complement of its
  /// current value.
  void flip(int index) {
    if (0 <= index && index < length) {
      buffer[index >> _shift] ^= _setMask[index & _offset];
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /// Counts the number of bits that are set to [expected].
  int count([bool expected = true]) {
    var tally = 0;
    for (var index = 0; index < length; index++) {
      var actual = (buffer[index >> _shift] & _setMask[index & _offset]) != 0;
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
    var shift = amount >> _shift;
    var offset = amount & _offset;
    var result = new BitList(length);
    if (offset == 0) {
      for (var i = shift; i < buffer.length; i++) {
        result.buffer[i] = buffer[i - shift];
      }
    } else {
      var otherOffset = 1 + _offset - offset;
      for (var i = shift + 1; i < buffer.length; i++) {
        result.buffer[i] = ((buffer[i - shift] << offset) & _mask) |
            ((buffer[i - shift - 1] >> otherOffset) & _mask);
      }
      if (shift < buffer.length) {
        result.buffer[shift] = (buffer[0] << offset) & _mask;
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
    var shift = amount >> _shift;
    var offset = amount & _offset;
    var result = new BitList(length);
    if (offset == 0) {
      for (var i = 0; i < buffer.length - shift; i++) {
        result.buffer[i] = buffer[i + shift];
      }
    } else {
      var last = buffer.length - shift - 1;
      var otherOffset = 1 + _offset - offset;
      for (var i = 0; i < last; i++) {
        result.buffer[i] = ((buffer[i + shift] >> offset) & _mask) |
            ((buffer[i + shift + 1] << otherOffset) & _mask);
      }
      if (0 <= last) {
        result.buffer[last] = (buffer[buffer.length - 1] >> offset) & _mask;
      }
    }
    return result;
  }
}
