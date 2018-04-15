// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:grizzly_io/grizzly_io.dart';
// import 'package:grizzly_io/src/csv/parser/parser.dart';
import 'package:grizzly_io/io_loader.dart';

main() async {
  /*
  String fs = r',';
  String ts = r"'";

  String input = """Name,Age,'House
  (H)'""";

  List<String> cols = CsvParser.parseRow(input, fs: fs, ts: ts);

  if (cols == null) {
    print(null);
  } else {
    cols.forEach(print);
  }
  */
  var tsv = await readLTsv('data/labeled_tsv/headers/tab_in_label.tsv');
  print(tsv);
  final out = encodeCsv(tsv.toList(), fieldSep: '\t');
  print(out);
  tsv = await parseLTsv(out);
  print(tsv);
}
