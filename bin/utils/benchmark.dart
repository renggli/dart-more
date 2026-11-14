import 'dart:io';

/// Measures the average time it takes to run [function] in microseconds.
double benchmark(
  void Function() function, {
  Duration warmup = const Duration(milliseconds: 50),
  Duration measure = const Duration(milliseconds: 250),
}) {
  _measure(function, warmup);
  return _measure(function, measure);
}

double _measure(void Function() function, Duration duration) {
  final watch = Stopwatch()..start();
  final micros = duration.inMicroseconds;
  var count = 0;
  var elapsed = 0;
  while (elapsed < micros) {
    function();
    elapsed = watch.elapsedMicroseconds;
    count++;
  }
  return elapsed / count;
}

/// Prints [results] as an aligned comparison table relative to [reference].
void printReport(
  List<(String name, Map<String, double> measures)> results, {
  required String reference,
}) {
  if (results.isEmpty) return;
  final columns = results.first.$2.keys.toList();
  final rows = results.map((result) {
    final ref = result.$2[reference];
    return [
      result.$1,
      ...columns.map((col) {
        final value = result.$2[col];
        if (value == null) return '-';
        final time = '${value.toStringAsFixed(1)} us';
        if (ref != null && col != reference) {
          return '$time (${(value / ref).toStringAsFixed(1)}x)';
        }
        return time;
      }),
    ];
  }).toList();

  final headers = ['Benchmark', ...columns];
  final widths = List<int>.generate(
    headers.length,
    (i) => [
      headers[i].length,
      ...rows.map((r) => r[i].length),
    ].reduce((a, b) => a > b ? a : b),
  );

  String formatRow(List<String> cells) => [
    cells[0].padRight(widths[0]),
    for (var i = 1; i < cells.length; i++) cells[i].padLeft(widths[i]),
  ].join(' | ');

  stdout.writeln(formatRow(headers));
  stdout.writeln(widths.map((w) => '-' * w).join('-+-'));
  for (final row in rows) {
    stdout.writeln(formatRow(row));
  }
}
