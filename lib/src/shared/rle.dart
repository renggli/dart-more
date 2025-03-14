import 'dart:typed_data';

/// Encodes a list of positive integers using run-length encoding.
List<int> encodeRle(List<int> input) {
  final output = <int>[input.length];
  for (var i = 0; i < input.length;) {
    assert(input[i] >= 0, 'invalid input value ${input[i]} at $i');
    var count = 1;
    while (i + count < input.length && input[i] == input[i + count]) {
      count++;
    }
    if (count > 1) output.add(-count);
    output.add(input[i]);
    i += count;
  }
  return output;
}

/// Decodes a list of run-length encoded integers.
List<int> decodeRle(List<int> input) {
  final output = Int32List(input.first);
  var i = 1, o = 0;
  while (o < output.length) {
    final i1 = input[i++];
    if (i1 < 0) {
      output.fillRange(o, o -= i1, input[i++]);
    } else {
      output[o++] = i1;
    }
  }
  assert(input.length == i, 'invalid input pointer $i');
  assert(output.length == o, 'invalid output pointer $o');
  return output;
}
