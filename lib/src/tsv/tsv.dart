library grizzly.io.tsv;

import '../csv/parser/parser.dart';
import 'dart:math' as math;
import 'package:grizzly_io/grizzly_io.dart';

/// Parses the given labeled TSV buffer
LabeledTable parseLabTsv(String buffer) {
  final List<List<dynamic>> rows = tsvParser.convert(buffer);

  if (rows.length == 0) return new LabeledTable([], []);

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

  return new LabeledTable(labels, data);
}

/// Returns labeled TSV string
String toLabTsv(Iterable<String> labels, Iterator<Map> rows) {
  throw new UnimplementedError();
  // TODO
}

const CsvParser tsvParser = const CsvParser(fieldSep: '\t');
