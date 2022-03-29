/// Provides loaders in dart:io environment
///
/// [requestLTsv] parses TSV files fetched from HTTP requests.
///
/// [readLTsv] parses TSV files from the file system.
library grizzly.io.io_loader;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:grizzly_io/grizzly_io.dart';

export 'package:grizzly_io/grizzly_io.dart';

extension CSVExt on HttpClientResponse {
  Stream<List<String>> parseCsv({String fieldSep = ',',
    String textSep = '"',
    bool multiline = true}) => CsvParser().convertStream(Stream.)
}

/// Reads file at specified path [path] as TSV file
Future<List<List<String>>> readCsv(String path,
    {Encoding encoding = utf8,
    String fieldSep = ',',
    String textSep = '"',
    bool multiline = true}) async {
  final File file = File(path);
  return parseCsv(await file.readAsString(encoding: encoding),
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

Stream<List<String>> streamCsv(String path,
    {Encoding encoding = utf8,
    String fieldSep = ',',
    String textSep = '"',
    bool multiline = true}) {
  return CsvParser(fieldSep: fieldSep, textSep: textSep, multiline: multiline)
      .convertStream(File(path).openRead().transform(encoding.decoder));
}

/// Reads file at specified path [path] as TSV file
Future<CSV> readLCsv(String path,
    {Encoding encoding = utf8,
    String fieldSep = ',',
    String textSep = '"',
    bool multiline = true}) async {
  final File file = File(path);
  return parseLCsv(await file.readAsString(encoding: encoding),
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

/// Reads file at specified path [path] as TSV file
Future<CSV> readLTsv(String path, {Encoding encoding = utf8}) async {
  final File file = File(path);
  return parseLTsv(await file.readAsString(encoding: encoding));
}
