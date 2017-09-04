library grizzly.io.tsv;

import 'dart:async';
import 'dart:collection';
import '../base.dart';
import '../csv/parser/parser.dart';
import 'dart:math' as math;

/// Reads and writes labeled TSV files
class LabeledTsv implements LabeledAccess {
  /// Labels/columns
  final UnmodifiableListView<dynamic> labels;

  /// Rows
  final UnmodifiableListView<Map> data;

  LabeledTsv(Iterable<dynamic> labels, Iterable<Map<String, dynamic>> data)
      : labels = new UnmodifiableListView(labels),
        data = new UnmodifiableListView(data);

  /// Parses the given labeled TSV buffer
  factory LabeledTsv.parse(String buffer) {
    final List<List<dynamic>> rows = parser.convert(buffer);

    if (rows.length == 0) return new LabeledTsv([], []);

    final List labels = rows.first;
    final List<Map<String, dynamic>> data = [];

    // Parse the label header
    for (int i = 1; i < rows.length; i++) {
      final List row = rows[i];
      final int len = math.min(row.length, labels.length);

      final Map d = {};

      for (int j = 0; j < len; j++) {
        d[labels[j]] = row[j];
      }
      data.add(d);
    }

    return new LabeledTsv(labels, data);
  }

  /// Returns labeled TSV string
  String write() {
    throw new UnimplementedError();
    /* TODO
    final List<List> d = data.map((Map m) {
      final List ret = [];

      labels.forEach((l) => ret.add(m[l]));

      return ret;
    }).toList();
    return writer.convert([labels]..addAll(d));
    */
  }

  Iterable<T> map<T>(T mapper(Map row)) => data.map<T>(mapper);

  /// TSV parser
  static const CsvParser parser = const CsvParser(fieldSep: '\t');

  /* TODO
  static const ListToCsvConverter writer =
  const ListToCsvConverter(fieldDelimiter: '\t+');
  */
}
