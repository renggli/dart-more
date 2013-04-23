// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_list;

import 'dart:collection';
import 'dart:typeddata';

class BitList extends ListBase<bool> {

  static final BIT_MASK = const [1, 2, 4, 8, 16, 32, 64, 128];
  static final BIT_MASK_LENGTH = BIT_MASK.length;

  /**
   * Constructs a bit list of the given [length].
   */
  factory BitList(int length) {
    var lengthInBytes = 1 + length ~/ BIT_MASK_LENGTH;
    return new BitList._(new Uint8List(lengthInBytes), length);
  }

  /**
   * Constucts a new list from a given [list] of booleans or [BitSet].
   */
  factory BitList.fromList(List<bool> list) {
    var lengthInBytes = 1 + list.length ~/ BIT_MASK_LENGTH;
    var buffer = new Uint8List(lengthInBytes);
    for (var i = 0; i < list.length; ) {
      var byte = 0;
      for (var j = 0; j < BIT_MASK_LENGTH && i < list.length; j++, i++) {
        byte = byte << 1;
        if (list[i]) {
          byte |= 1;
        }
      }
      buffer[i % BIT_MASK_LENGTH] = byte;
    }
    return new BitList._(buffer, list.length);
  }

  /**
   * Constructs a view onto a given [buffer] at offset [offsetInBytes].
   */
  factory BitList.view(ByteBuffer buffer, [int offsetInBytes = 0, int length]) {
    var lengthInBytes = 1 + length ~/ BIT_MASK_LENGTH;
    return new BitList._(new Uint8List.view(buffer, offsetInBytes, lengthInBytes),
        length);
  }

  final Uint8List _buffer;
  final int _length;

  BitList._(this._buffer, this._length);

  int get length => _length;

  bool operator [] (int index) {
    if (0 <= index && index < length) {
      var i = index ~/ BIT_MASK_LENGTH;
      return (_buffer[i] & BIT_MASK[index % BIT_MASK_LENGTH]) != 0;
    } else {
      throw new RangeError.value(index);
    }
  }

  void operator []= (int index, bool value) {
    if (0 <= index && index < length) {
      var i = index ~/ BIT_MASK_LENGTH;
      if (value) {
        _buffer[i] |= BIT_MASK[index % BIT_MASK_LENGTH];
      } else {
        _buffer[i] &= ~BIT_MASK[index % BIT_MASK_LENGTH];
      }
    } else {
      throw new RangeError.value(index);
    }
  }

}