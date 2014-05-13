/**
 * A space efficient list storing boolean values.
 */
library bit_list;

import 'dart:collection';
import 'dart:typed_data';

import 'package:more/iterable.dart';

/**
 * An space efficient fixed length [List] that stores boolean values.
 */
class BitList extends ListBase<bool> with FixedLengthListMixin<bool> {

  // constants specific to mapping bits into a [Uint32List]
  static const int _SHIFT = 5;
  static const int _OFFSET = 31;
  static const int _MASK = 0xffffffff;
  static const List<int> _SET_MASK = const [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096,
      8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216,
      33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483648];
  static const List<int> _CLR_MASK = const [-2, -3, -5, -9, -17, -33, -65, -129, -257, -513, -1025,
      -2049, -4097, -8193, -16385, -32769, -65537, -131073, -262145, -524289, -1048577, -2097153,
      -4194305, -8388609, -16777217, -33554433, -67108865, -134217729, -268435457, -536870913,
      -1073741825, -2147483649];

  /**
   * Constructs a bit list of the given [length].
   */
  factory BitList(int length) {
    var buffer = new Uint32List((length + _OFFSET) >> _SHIFT);
    return new BitList._(buffer, length);
  }

  /**
   * Constructs a new list from a given [Iterable] of booleans.
   */
  factory BitList.from(Iterable<bool> other) {
    var length = other.length;
    var buffer = new Uint32List((length + _OFFSET) >> _SHIFT);
    if (other is BitList) {
      buffer.setAll(0, other._buffer);
    } else {
      for (var index = 0, iterator = other.iterator; iterator.moveNext(); index++) {
        if (iterator.current) {
          buffer[index >> _SHIFT] |= _SET_MASK[index & _OFFSET];
        }
      }
    }
    return new BitList._(buffer, length);
  }

  final Uint32List _buffer;
  final int _length;

  BitList._(this._buffer, this._length);

  /**
   * Returns the number of bits in this object.
   */
  @override
  int get length => _length;

  /**
   * Returns the value of the bit with the given [index].
   */
  @override
  bool operator [](int index) {
    if (0 <= index && index < length) {
      return (_buffer[index >> _SHIFT] & _SET_MASK[index & _OFFSET]) != 0;
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /**
   * Sets the [value] of the bit with the given [index].
   */
  @override
  void operator []=(int index, bool value) {
    if (0 <= index && index < length) {
      if (value) {
        _buffer[index >> _SHIFT] |= _SET_MASK[index & _OFFSET];
      } else {
        _buffer[index >> _SHIFT] &= _CLR_MASK[index & _OFFSET];
      }
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /**
   * Sets the bit at the specified [index] to the complement of its
   * current value.
   */
  void flip(int index) {
    if (0 <= index && index < length) {
      _buffer[index >> _SHIFT] ^= _SET_MASK[index & _OFFSET];
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /**
   * Counts the number of bits that are set to [expected].
   */
  int count([bool expected = true]) {
    int tally = 0;
    for (var index = 0; index < _length; index++) {
      var actual = (_buffer[index >> _SHIFT] & _SET_MASK[index & _OFFSET]) != 0;
      if (actual == expected) {
        tally++;
      }
    }
    return tally;
  }

  /**
   * Returns the complement of the receiver.
   *
   * The new [BitList] has all the bits of the receiver inverted.
   */
  BitList operator ~() {
    var result = new BitList(_length);
    for (var i = 0; i < _buffer.length; i++) {
      result._buffer[i] = ~_buffer[i];
    }
    return result;
  }

  /**
   * Returns the intersection of the receiver and [other].
   *
   * The new [BitList] has all the bits set that are set in the receiver
   * and in [other]. The receiver and [other] need to have the same length,
   * otherwise an exception is thrown.
   */
  BitList operator &(BitList other) {
    if (_length != other._length) {
      throw new ArgumentError('Expected list with length ${this.length}, but got ${other.length}');
    }
    var result = new BitList(_length);
    for (var i = 0; i < _buffer.length; i++) {
      result._buffer[i] = _buffer[i] & other._buffer[i];
    }
    return result;
  }

  /**
   * Returns the union of the receiver and [other].
   *
   * The new [BitList] has all the bits set that are either set in the
   * receiver or in [other]. The receiver and [other] need to have the
   * same length, otherwise an exception is thrown.
   */
  BitList operator |(BitList other) {
    if (_length != other._length) {
      throw new ArgumentError('Expected list with length ${this.length}, but got ${other.length}');
    }
    var result = new BitList(_length);
    for (var i = 0; i < _buffer.length; i++) {
      result._buffer[i] = _buffer[i] | other._buffer[i];
    }
    return result;
  }

  /**
   * Returns the difference of the receiver and [other].
   *
   * The new [BitList] has all the bits set that are set in the receiver,
   * but not in [other]. The receiver and [other] need to have the same
   * length, otherwise an exception is thrown.
   */
  BitList operator -(BitList other) {
    if (_length != other._length) {
      throw new ArgumentError('Expected list with length ${this.length}, but got ${other.length}');
    }
    var result = new BitList(_length);
    for (var i = 0; i < _buffer.length; i++) {
      result._buffer[i] = _buffer[i] & ~other._buffer[i];
    }
    return result;
  }

  /**
   * Returns a [BitList] of the same length, but with the bits of the receiver shifted
   * to the left by [amount]. Throws an [ArgumentError] if [amount] is negative.
   */
  BitList operator <<(int amount) {
    if (amount < 0) {
      throw new ArgumentError('Unable to left-shift by $amount');
    }
    if (amount == 0 || _length == 0) {
      return new BitList.from(this);
    }
    var shift = amount >> _SHIFT;
    var offset = amount & _OFFSET;
    var result = new BitList(_length);
    if (offset == 0) {
      for (var i = shift; i < _buffer.length; i++) {
        result._buffer[i] = _buffer[i - shift];
      }
    } else {
      var other_offset = 1 + _OFFSET - offset;
      for (var i = shift + 1; i < _buffer.length; i++) {
        result._buffer[i] = ((_buffer[i - shift] << offset) & _MASK)
                          | ((_buffer[i - shift - 1] >> other_offset) & _MASK);
      }
      if (shift < _buffer.length) {
        result._buffer[shift] = (_buffer[0] << offset) & _MASK;
      }
    }
    return result;
  }

  /**
   * Returns a [BitList] of the same length, but with the bits of the receiver shifted
   * to the right by [amount]. Throws an [ArgumentError] if [amount] is negative.
   */
  BitList operator >>(int amount) {
    if (amount < 0) {
      throw new ArgumentError('Unable to right-shift by $amount');
    }
    if (amount == 0 || _length == 0) {
      return new BitList.from(this);
    }
    var shift = amount >> _SHIFT;
    var offset = amount & _OFFSET;
    var result = new BitList(_length);
    if (offset == 0) {
      for (var i = 0; i < _buffer.length - shift; i++) {
        result._buffer[i] = _buffer[i + shift];
      }
    } else {
      var last = _buffer.length - shift - 1;
      var other_offset = 1 + _OFFSET - offset;
      for (var i = 0; i < last; i++) {
        result._buffer[i] = ((_buffer[i + shift] >> offset) & _MASK)
                          | ((_buffer[i + shift + 1] << other_offset) & _MASK);
      }
      if (0 <= last) {
        result._buffer[last] = (_buffer[_buffer.length - 1] >> offset) & _MASK;
      }
    }
    return result;
  }

}
