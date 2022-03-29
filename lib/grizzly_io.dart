// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Readers and writers for several file formats (CSV, TSV, JSON, YAML, etc)
library grizzly.io;

export 'src/csv.dart';
export 'src/csv/writer.dart';
export 'src/csv/parser/parser.dart';
export 'src/tsv/tsv.dart';
export 'src/type_converter/type_converter.dart';
import 'package:http/http.dart';

import 'src/csv.dart';
import 'src/csv/writer.dart';
import 'src/csv/parser/parser.dart';
import 'src/tsv/tsv.dart';

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<CSV> requestLCsv(String url,
    {String fieldSep = ',',
      String textSep = '"',
      bool multiline = true}) async {
  final client = Client();
  final Response resp = await client.get(Uri.parse(url));
  return parseLCsv(resp.body,
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<List<List<String>>> requestCsv(String url,
    {String fieldSep = ',',
      String textSep = '"',
      bool multiline = true}) async {
  final client = Client();
  final Response resp = await client.get(Uri.parse(url));
  return parseCsv(resp.body,
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<CSV> requestLTsv(String url) async {
  final client = Client();
  final Response resp = await client.get(Uri.parse(url));
  return parseLTsv(resp.body);
}
