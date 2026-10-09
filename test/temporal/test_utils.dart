import 'package:checks/context.dart';

extension CloseToChecks on Subject<num> {
  void isRelativeCloseTo(num expected, num epsilon) {
    context.expect(
      () => ['is relatively close to $expected (epsilon $epsilon)'],
      (actual) {
        final difference = (expected - actual).abs();
        final relative = difference > 0 ? difference / actual : 0;
        if (relative <= epsilon) return null;
        return Rejection(which: ['differs by relative error $relative']);
      },
    );
  }
}
