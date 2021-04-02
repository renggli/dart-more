/// Abstract tagged union data type.
import 'package:meta/meta.dart';

export 'src/union/union_2.dart';
export 'src/union/union_3.dart';
export 'src/union/union_4.dart';
export 'src/union/union_5.dart';
export 'src/union/union_6.dart';
export 'src/union/union_7.dart';
export 'src/union/union_8.dart';
export 'src/union/union_9.dart';

/// Abstract union class.
@immutable
abstract class Union {
  /// Const constructor.
  const Union();

  /// Returns the value of this union.
  dynamic get value;
}
