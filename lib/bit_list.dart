// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_list;

import 'dart:collection';
import 'dart:typeddata';

class BitList extends ListBase<bool> {

  static final _BIT_MASK = const [1, 2, 4, 8, 16, 32, 64, 128];
  static final _BIT_MASK_LENGTH = _BIT_MASK.length;

  static int _bufferLength(int length) {
    var bufferLength = length ~/ _BIT_MASK_LENGTH;
    if (length % _BIT_MASK_LENGTH > 0) bufferLength++;
    return bufferLength;
  }

  /**
   * Constructs a bit list of the given [length].
   */
  factory BitList(int length) {
    return new BitList._(new Uint8List(_bufferLength(length)), length);
  }

  /**
   * Constucts a new list from a given [list] of booleans or [BitSet].
   */
  factory BitList.fromList(List<bool> list) {
    var result = new BitList(list.length);
    for (var i = 0; i < list.length; i++) {
      if (list[i]) {
        result[i] = true;
      }
    }
    return result;
  }

  /**
   * Constructs a view onto a given [buffer] at offset [offsetInBytes].
   */
  factory BitList.view(ByteBuffer buffer, [int offsetInBytes = 0, int length]) {
    return new BitList._(new Uint8List.view(buffer, offsetInBytes,
        _bufferLength(length)), length);
  }

  final Uint8List _buffer;
  final int _length;

  BitList._(this._buffer, this._length);

  int get length => _length;

  bool operator [] (int index) {
    if (0 <= index && index < length) {
      var i = index ~/ _BIT_MASK_LENGTH;
      return (_buffer[i] & _BIT_MASK[index % _BIT_MASK_LENGTH]) != 0;
    } else {
      throw new RangeError.value(index);
    }
  }

  void operator []= (int index, bool value) {
    if (0 <= index && index < length) {
      var i = index ~/ _BIT_MASK_LENGTH;
      if (value) {
        _buffer[i] |= _BIT_MASK[index % _BIT_MASK_LENGTH];
      } else {
        _buffer[i] &= ~_BIT_MASK[index % _BIT_MASK_LENGTH];
      }
    } else {
      throw new RangeError.value(index);
    }
  }

}