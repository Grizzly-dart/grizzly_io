library grizzly.io.base;

/// Interface that all labeled IO reader/writers should implement
abstract class LabeledAccess {
  /// Labels/columns
  List<dynamic> get labels;

  /// Rows
  List<Map> get data;

  /// Returns string in output format
  String write();
}
