/// Provides loaders in dart:io environment
///
/// [requestLabTsv] parses TSV files fetched from HTTP requests.
///
/// [readLabTsv] parses TSV files from the file system.
library grizzly.io.io_loader;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:grizzly_io/grizzly_io.dart';

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<LabeledTable> requestLabTsv(String url) async {
  final client = new Client();
  final Response resp = await client.get(url);
  return parseLabTsv(resp.body);
}

/// Reads file at specified path [path] as TSV file
Future<LabeledTable> readLabTsv(String path, {Encoding encoding: UTF8}) async {
  final File file = new File(path);
  if (!await file.exists()) throw new Exception('File not found!');
  return parseLabTsv(await file.readAsString(encoding: encoding));
}
