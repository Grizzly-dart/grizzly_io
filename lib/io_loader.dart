/// Provides loaders in dart:io environment
///
/// [requestLTsv] parses TSV files fetched from HTTP requests.
///
/// [readLTsv] parses TSV files from the file system.
library grizzly.io.io_loader;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:grizzly_io/grizzly_io.dart';

export 'package:grizzly_io/grizzly_io.dart';

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<LabeledTable> requestLCsv(String url,
    {String fieldSep = ',',
    String textSep = '"',
    bool multiline = true,
    int headerRow = 0}) async {
  final client = Client();
  final Response resp = await client.get(url);
  return parseLCsv(resp.body,
      fieldSep: fieldSep,
      textSep: textSep,
      multiline: multiline,
      headerRow: headerRow);
}

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<List<List<String>>> requestCsv(String url,
    {String fieldSep = ',',
    String textSep = '"',
    bool multiline = true}) async {
  final client = Client();
  final Response resp = await client.get(url);
  return parseCsv(resp.body,
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<LabeledTable> requestLTsv(String url) async {
  final client = Client();
  final Response resp = await client.get(url);
  return parseLTsv(resp.body);
}

/// Reads file at specified path [path] as TSV file
Future<List<List<String>>> readCsv(String path,
    {Encoding encoding = utf8,
    String fieldSep = ',',
    String textSep = '"',
    bool multiline = true,
    int headerRow = 0}) async {
  final File file = File(path);
  if (!await file.exists()) throw Exception('File not found!');
  return parseCsv(await file.readAsString(encoding: encoding),
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

/// Reads file at specified path [path] as TSV file
Future<LabeledTable> readLCsv(String path,
    {Encoding encoding = utf8,
    String fieldSep = ',',
    String textSep = '"',
    bool multiline = true,
    int headerRow = 0}) async {
  final File file = File(path);
  if (!await file.exists()) throw Exception('File not found!');
  return parseLCsv(await file.readAsString(encoding: encoding),
      fieldSep: fieldSep,
      textSep: textSep,
      multiline: multiline,
      headerRow: headerRow);
}

/// Reads file at specified path [path] as TSV file
Future<LabeledTable> readLTsv(String path, {Encoding encoding = utf8}) async {
  final File file = File(path);
  if (!await file.exists()) throw Exception('File not found!');
  return parseLTsv(await file.readAsString(encoding: encoding));
}
