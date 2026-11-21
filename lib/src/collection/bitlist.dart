import 'dart:collection' show ListBase;
import 'dart:math';
import 'dart:typed_data' show Uint32List;

import 'package:collection/collection.dart' show NonGrowableListMixin;

import '../pragma/pragma.dart';
import '../shared/bit.dart';

/// A space efficient [List] that stores boolean values.
abstract class BitList extends ListBase<bool> {
  /// Constructs a bit list of the given [length].
  ///
  /// Throws a [RangeError] if [length] is negative.
  factory(int length, {bool fill = false, bool growable = false}) =>
      BitList.filled(length, fill, growable: growable);

  /// Constructs an empty bit list.
  factory empty({bool growable = false}) =>
      BitList.filled(0, false, growable: growable);

  /// Constructs a bit list of the given [length], and initializes the value at
  /// each position with [fill].
  ///
  /// Throws a [RangeError] if [length] is negative.
  factory filled(int length, bool fill, {bool growable = false}) {
    RangeError.checkNotNegative(length, 'length');
    final buffer = Uint32List((length + bitOffset) >>> bitShift);
    if (fill) {
      buffer.fillRange(0, buffer.length, bitMask);
      _maskTail(buffer, length);
    }
    return growable
        ? GrowableBitList(buffer, length)
        : FixedBitList(buffer, length);
  }

  /// Constructs a bit list of the given [length] by calling a [generator]
  /// function for each index.
  ///
  /// Throws a [RangeError] if [length] is negative.
  factory generate(
    int length,
    bool Function(int index) generator, {
    bool growable = false,
  }) {
    RangeError.checkNotNegative(length, 'length');
    final wordCount = (length + bitOffset) >>> bitShift;
    final buffer = Uint32List(wordCount);
    var index = 0;
    for (var i = 0; i < wordCount; i++) {
      var value = 0;
      for (var j = 0; j <= bitOffset && index < length; j++, index++) {
        if (generator(index)) {
          value |= bitSetMask[j];
        }
      }
      buffer[i] = value;
    }
    return growable
        ? GrowableBitList(buffer, length)
        : FixedBitList(buffer, length);
  }

  /// Constructs a new list from a given [Iterable] of booleans.
  factory of(Iterable<bool> other, {bool growable = false}) {
    if (other is BitList) {
      final length = other.length;
      final wordCount = (length + bitOffset) >>> bitShift;
      final buffer = Uint32List(wordCount);
      buffer.setRange(0, wordCount, other.buffer);
      _maskTail(buffer, length);
      return growable
          ? GrowableBitList(buffer, length)
          : FixedBitList(buffer, length);
    }
    if (other is List<bool>) {
      final length = other.length;
      final wordCount = (length + bitOffset) >>> bitShift;
      final buffer = Uint32List(wordCount);
      var index = 0;
      for (var i = 0; i < wordCount; i++) {
        var value = 0;
        for (var j = 0; j <= bitOffset && index < length; j++, index++) {
          if (other[index]) {
            value |= bitSetMask[j];
          }
        }
        buffer[i] = value;
      }
      return growable
          ? GrowableBitList(buffer, length)
          : FixedBitList(buffer, length);
    }
    final result = GrowableBitList(Uint32List(0), 0);
    for (final value in other) {
      result.add(value);
    }
    if (growable) return result;
    final wordCount = (result._length + bitOffset) >>> bitShift;
    final buffer = result.buffer.length == wordCount
        ? result.buffer
        : result.buffer.sublist(0, wordCount);
    return FixedBitList(buffer, result._length);
  }

  /// Constructs a new list from a given [Iterable], casting each element to
  /// [bool].
  factory from(Iterable<Object?> other, {bool growable = false}) {
    if (other is Iterable<bool>) {
      return BitList.of(other, growable: growable);
    }
    final result = GrowableBitList(Uint32List(0), 0);
    for (final value in other) {
      result.add(value as bool);
    }
    if (growable) return result;
    final wordCount = (result._length + bitOffset) >>> bitShift;
    final buffer = result.buffer.length == wordCount
        ? result.buffer
        : result.buffer.sublist(0, wordCount);
    return FixedBitList(buffer, result._length);
  }

  /// Internal generative constructor.
  new _();

  /// The underlying typed buffer of this object.
  Uint32List get buffer;

  /// Returns the value of the bit with the given [index].
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  @override
  bool operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return getUnchecked(index);
  }

  /// Returns the value of the bit with the given [index]. The behavior is
  /// undefined if [index] is outside of bounds.
  @preferInline
  @noBoundsChecks
  bool getUnchecked(int index) =>
      (buffer[index >>> bitShift] & bitSetMask[index & bitOffset]) != 0;

  /// Sets the [value] of the bit with the given [index].
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  @override
  void operator []=(int index, bool value) {
    RangeError.checkValidIndex(index, this);
    setUnchecked(index, value);
  }

  /// Sets the [value] of the bit with the given [index]. The behavior is
  /// undefined if [index] is outside of bounds.
  @preferInline
  @noBoundsChecks
  void setUnchecked(int index, bool value) => value
      ? buffer[index >>> bitShift] |= bitSetMask[index & bitOffset]
      : buffer[index >>> bitShift] &= bitClearMask[index & bitOffset];

  @override
  bool contains(Object? element) => indexOf(element) >= 0;

  @override
  int indexOf(Object? element, [int start = 0]) {
    if (element is! bool) return -1;
    if (start < 0) start = 0;
    if (start >= length) return -1;
    final wordCount = (length + bitOffset) >>> bitShift;
    final startWord = start >>> bitShift;
    final startBit = start & bitOffset;
    final tailRem = length & bitOffset;
    for (var w = startWord; w < wordCount; w++) {
      var bits = element ? buffer[w] : (~buffer[w] & bitMask);
      if (w == startWord && startBit != 0) {
        bits &= (bitMask << startBit) & bitMask;
      }
      if (w == wordCount - 1 && tailRem != 0) {
        bits &= (1 << tailRem) - 1;
      }
      if (bits != 0) {
        final bit = ((bits & -bits) >>> 0).bitLength - 1;
        return (w << bitShift) + bit;
      }
    }
    return -1;
  }

  @override
  int lastIndexOf(Object? element, [int? start]) {
    if (element is! bool) return -1;
    var end = start ?? length - 1;
    if (end >= length) end = length - 1;
    if (end < 0) return -1;
    final endWord = end >>> bitShift;
    final endBit = end & bitOffset;
    for (var w = endWord; w >= 0; w--) {
      var bits = element ? buffer[w] : (~buffer[w] & bitMask);
      if (w == endWord && endBit != bitOffset) {
        bits &= (1 << (endBit + 1)) - 1;
      }
      if (bits != 0) {
        return (w << bitShift) + bits.bitLength - 1;
      }
    }
    return -1;
  }

  @override
  BitList operator +(List<bool> other) {
    final result = BitList(length + other.length);
    final wordCount = (length + bitOffset) >>> bitShift;
    result.buffer.setRange(0, wordCount, buffer);
    _maskTail(result.buffer, length);
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
  ///
  /// Throws a [RangeError] if [index] is negative or not less than [length].
  void flip(int index) {
    RangeError.checkValidIndex(index, this);
    flipUnchecked(index);
  }

  /// Sets the bit at the specified [index] to the complement of its current
  /// value. The behavior is undefined if [index] is outside of bounds.
  @preferInline
  @noBoundsChecks
  void flipUnchecked(int index) =>
      buffer[index >>> bitShift] ^= bitSetMask[index & bitOffset];

  /// Counts the number of bits set to [expected].
  int count({bool expected = true}) =>
      countRange(0, length, expected: expected);

  /// Counts the number of bits set to [expected] in the range of [start]
  /// (inclusive) to [end] (exclusive).
  ///
  /// Throws a [RangeError] if `0 <= start <= end <= length` does not hold.
  int countRange(int start, int end, {bool expected = true}) {
    RangeError.checkValidRange(start, end, length);
    if (start == end) return 0;
    final startIndex = start >>> bitShift, startBit = start & bitOffset;
    final endIndex = (end - 1) >>> bitShift, endBit = (end - 1) & bitOffset;
    var result = 0;
    if (startIndex == endIndex) {
      result += countBits32(
        buffer[startIndex] & (((1 << (endBit - startBit + 1)) - 1) << startBit),
      );
    } else {
      result += countBits32(buffer[startIndex] & (bitMask << startBit));
      for (var i = startIndex + 1; i < endIndex; i++) {
        result += countBits32(buffer[i]);
      }
      result += countBits32(buffer[endIndex] & ((1 << (endBit + 1)) - 1));
    }
    return expected ? result : (end - start) - result;
  }

  /// Returns an iterable over the indices with the bit set to [expected].
  Iterable<int> indices({bool expected = true}) sync* {
    final wordCount = (length + bitOffset) >>> bitShift;
    final tailRem = length & bitOffset;
    for (var w = 0; w < wordCount; w++) {
      var bits = expected ? buffer[w] : (~buffer[w] & bitMask);
      if (w == wordCount - 1 && tailRem != 0) {
        bits &= (1 << tailRem) - 1;
      }
      final base = w << bitShift;
      while (bits != 0) {
        final bit = ((bits & -bits) >>> 0).bitLength - 1;
        yield base + bit;
        bits &= bits - 1;
      }
    }
  }

  /// Returns the complement of the receiver.
  ///
  /// The new [BitList] has all the bits of the receiver inverted.
  BitList operator ~() => BitList.of(this)..not();

  /// Computes the complement of the receiver in-place.
  void not() {
    final wordCount = (length + bitOffset) >>> bitShift;
    for (var i = 0; i < wordCount; i++) {
      buffer[i] = ~buffer[i];
    }
    _maskTail(buffer, length);
  }

  /// Returns the intersection of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are set in the receiver and in
  /// [other]. Throws an [ArgumentError] if [other] does not have the same
  /// length.
  BitList operator &(BitList other) => BitList.of(this)..and(other);

  /// Computes the intersection of the receiver and [other] in-place.
  ///
  /// Throws an [ArgumentError] if [other] does not have the same length.
  void and(BitList other) {
    _checkLength(other);
    final wordCount = (length + bitOffset) >>> bitShift;
    for (var i = 0; i < wordCount; i++) {
      buffer[i] &= other.buffer[i];
    }
  }

  /// Returns the union of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are either set in the receiver
  /// or in [other]. Throws an [ArgumentError] if [other] does not have the same
  /// length.
  BitList operator |(BitList other) => BitList.of(this)..or(other);

  /// Computes the union of the receiver and [other] in-place.
  ///
  /// Throws an [ArgumentError] if [other] does not have the same length.
  void or(BitList other) {
    _checkLength(other);
    final wordCount = (length + bitOffset) >>> bitShift;
    for (var i = 0; i < wordCount; i++) {
      buffer[i] |= other.buffer[i];
    }
  }

  /// Returns the exclusive-or (symmetric difference) of the receiver and
  /// [other].
  ///
  /// The new [BitList] has all the bits set that are set in either the receiver
  /// or [other], but not in both. Throws an [ArgumentError] if [other] does not
  /// have the same length.
  BitList operator ^(BitList other) => BitList.of(this)..xor(other);

  /// Computes the exclusive-or of the receiver and [other] in-place.
  ///
  /// Throws an [ArgumentError] if [other] does not have the same length.
  void xor(BitList other) {
    _checkLength(other);
    final wordCount = (length + bitOffset) >>> bitShift;
    for (var i = 0; i < wordCount; i++) {
      buffer[i] ^= other.buffer[i];
    }
  }

  /// Returns the difference of the receiver and [other].
  ///
  /// The new [BitList] has all the bits set that are set in the receiver, but
  /// not in [other]. Throws an [ArgumentError] if [other] does not have the
  /// same length.
  BitList operator -(BitList other) => BitList.of(this)..difference(other);

  /// Computes the difference of the receiver and [other] in-place.
  ///
  /// Throws an [ArgumentError] if [other] does not have the same length.
  void difference(BitList other) {
    _checkLength(other);
    final wordCount = (length + bitOffset) >>> bitShift;
    for (var i = 0; i < wordCount; i++) {
      buffer[i] &= ~other.buffer[i];
    }
    _maskTail(buffer, length);
  }

  /// Returns a [BitList] of the same length, with the bits of the receiver
  /// shifted to the left by [amount].
  ///
  /// Throws a [RangeError] if [amount] is negative.
  BitList operator <<(int amount) {
    RangeError.checkNotNegative(
      amount,
      'amount',
      'Unable to left-shift by $amount',
    );
    if (amount == 0 || length == 0) {
      return BitList.of(this);
    }
    final shift = amount >>> bitShift;
    final offset = amount & bitOffset;
    final result = BitList(length);
    final wordCount = result.buffer.length;
    if (offset == 0) {
      for (var i = shift; i < wordCount; i++) {
        result.buffer[i] = buffer[i - shift];
      }
    } else {
      final otherOffset = 1 + bitOffset - offset;
      for (var i = shift + 1; i < wordCount; i++) {
        result.buffer[i] =
            ((buffer[i - shift] << offset) & bitMask) |
            (buffer[i - shift - 1] >> otherOffset);
      }
      if (shift < wordCount) {
        result.buffer[shift] = (buffer[0] << offset) & bitMask;
      }
    }
    _maskTail(result.buffer, length);
    return result;
  }

  /// Returns a [BitList] of the same length, with the bits of the receiver
  /// shifted to the right by [amount].
  ///
  /// Throws a [RangeError] if [amount] is negative.
  BitList operator >>(int amount) {
    RangeError.checkNotNegative(
      amount,
      'amount',
      'Unable to right-shift by $amount',
    );
    if (amount == 0 || length == 0) {
      return BitList.of(this);
    }
    final shift = amount >>> bitShift;
    final offset = amount & bitOffset;
    final result = BitList(length);
    final wordCount = result.buffer.length;
    if (offset == 0) {
      for (var i = 0; i < wordCount - shift; i++) {
        result.buffer[i] = buffer[i + shift];
      }
    } else {
      final last = wordCount - shift - 1;
      final otherOffset = 1 + bitOffset - offset;
      for (var i = 0; i < last; i++) {
        result.buffer[i] =
            (buffer[i + shift] >> offset) |
            ((buffer[i + shift + 1] << otherOffset) & bitMask);
      }
      if (0 <= last) {
        result.buffer[last] = buffer[wordCount - 1] >> offset;
      }
    }
    _maskTail(result.buffer, length);
    return result;
  }

  void _checkLength(BitList other) {
    if (length != other.length) {
      throw ArgumentError.value(
        other,
        'other',
        'Expected list with length $length, but got ${other.length}',
      );
    }
  }
}

class GrowableBitList extends BitList {
  new(this.buffer, this._length) : super._();

  @override
  Uint32List buffer;

  int _length;

  @override
  int get length => _length;

  @override
  void add(bool element) {
    final index = _length;
    final wordIndex = index >>> bitShift;
    if (wordIndex >= buffer.length) {
      final newBuffer = Uint32List(max(2 * buffer.length, wordIndex + 1));
      newBuffer.setRange(0, buffer.length, buffer);
      buffer = newBuffer;
    }
    if (element) {
      buffer[wordIndex] |= bitSetMask[index & bitOffset];
    } else {
      buffer[wordIndex] &= bitClearMask[index & bitOffset];
    }
    _length = index + 1;
  }

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
    } else if (length < _length) {
      final endIndex = min((_length + bitOffset) >>> bitShift, buffer.length);
      if (requested < endIndex) {
        buffer.fillRange(requested, endIndex, 0);
      }
    }
    _maskTail(buffer, length);
    _length = length;
  }
}

class FixedBitList extends BitList with NonGrowableListMixin<bool> {
  new(this.buffer, this.length) : super._();

  @override
  final Uint32List buffer;

  @override
  final int length;
}

/// Extension on [Iterable] of booleans to convert to a [BitList].
extension BitListExtension on Iterable<bool> {
  /// Converts this [Iterable] to a space-efficient [BitList].
  BitList toBitList({bool growable = false}) =>
      BitList.of(this, growable: growable);
}

// Constants specific to mapping bits into a [Uint32List].
const int bitShift = 5;
const int bitOffset = 31;
const int bitMask = 0xffffffff;
const List<int> bitSetMask = [
  0x00000001,
  0x00000002,
  0x00000004,
  0x00000008,
  0x00000010,
  0x00000020,
  0x00000040,
  0x00000080,
  0x00000100,
  0x00000200,
  0x00000400,
  0x00000800,
  0x00001000,
  0x00002000,
  0x00004000,
  0x00008000,
  0x00010000,
  0x00020000,
  0x00040000,
  0x00080000,
  0x00100000,
  0x00200000,
  0x00400000,
  0x00800000,
  0x01000000,
  0x02000000,
  0x04000000,
  0x08000000,
  0x10000000,
  0x20000000,
  0x40000000,
  0x80000000,
];
const List<int> bitClearMask = [
  0xfffffffe,
  0xfffffffd,
  0xfffffffb,
  0xfffffff7,
  0xffffffef,
  0xffffffdf,
  0xffffffbf,
  0xffffff7f,
  0xfffffeff,
  0xfffffdff,
  0xfffffbff,
  0xfffff7ff,
  0xffffefff,
  0xffffdfff,
  0xffffbfff,
  0xffff7fff,
  0xfffeffff,
  0xfffdffff,
  0xfffbffff,
  0xfff7ffff,
  0xffefffff,
  0xffdfffff,
  0xffbfffff,
  0xff7fffff,
  0xfeffffff,
  0xfdffffff,
  0xfbffffff,
  0xf7ffffff,
  0xefffffff,
  0xdfffffff,
  0xbfffffff,
  0x7fffffff,
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

void _maskTail(Uint32List buffer, int length) {
  final rem = length & bitOffset;
  final wordIndex = length >>> bitShift;
  if (rem != 0 && wordIndex < buffer.length) {
    buffer[wordIndex] &= (1 << rem) - 1;
  }
}
