library grizzly.io.tsv;

import '../csv/parser/parser.dart';
import 'package:grizzly_io/grizzly_io.dart';

const CsvParser tsvParser = const CsvParser(fieldSep: '\t');

/// Parses the given labeled TSV buffer
List<List<String>> parseTsv(String buffer) => tsvParser.convert(buffer);

/// Parses the given labeled TSV buffer
LabeledTable parseLTsv(String buffer) => tsvParser.convertLabeled(buffer);
