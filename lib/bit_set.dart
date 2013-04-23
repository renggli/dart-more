// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_set;

import 'dart:collection';
import 'dart:typeddata';

class BitSet extends ListBase<bool> implements TypedData {

  static final int BITS_PER_INDEX = 8;

  factory BitSet(int length) {
    var lengthInBytes = 1 + length ~/ BITS_PER_INDEX;
    return new BitSet._(new Uint8List(lengthInBytes), length);
  }

  factory BitSet.fromList(List<bool> elements) {
    // TODO(renggli): optimize this common case of construction
    var result = new BitSet(elements.length);
    for (var i = 0; i < elements.length; i++) {
      if (elements[i]) {
        result[i] = true;
      }
    }
    return result;
  }

  factory BitSet.view(ByteBuffer buffer, [int offsetInBytes = 0, int length]) {
    var lengthInBytes = 1 + length ~/ BITS_PER_INDEX;
    return new BitSet._(new Uint8List.view(buffer, offsetInBytes, lengthInBytes),
        length);
  }

  final Uint8List _buffer;
  final int _length;

  BitSet._(this._buffer, this._length);

  int get length => _length;

  bool operator [] (int index) {
    if (0 <= index && index < length) {
      var i = index ~/ BITS_PER_INDEX;
      var j = index % BITS_PER_INDEX;
      return (_buffer[i] & (1 << j)) != 0;
    } else {
      throw new RangeError.value(index);
    }
  }

  void operator []= (int index, bool value) {
    if (0 <= index && index < length) {
      var i = index ~/ BITS_PER_INDEX;
      var j = index % BITS_PER_INDEX;
      if (value) {
        _buffer[i] |= (1 << j);
      } else {
        _buffer[i] &= ~(1 << j);
      }
    } else {
      throw new RangeError.value(index);
    }
  }

}