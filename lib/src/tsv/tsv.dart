library grizzly.io.tsv;

import 'package:grizzly_io/grizzly_io.dart';

const CsvParser tsvParser = CsvParser(fieldSep: '\t');

/// Parses the given labeled TSV buffer
List<List<String>> parseTsv(String buffer) => tsvParser.convert(buffer);

/// Parses the given labeled TSV buffer
CSV parseLTsv(String buffer) => tsvParser.convertLabeled(buffer);
