/// Provides loaders in browser environment
///
/// [requestLTsv] parses TSV files fetched from HTTP requests.
///
/// [readLTsv] parses TSV files opened through file input element.
library grizzly.io.browser_loader;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'package:grizzly_io/grizzly_io.dart';

export 'package:grizzly_io/grizzly_io.dart';

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<Table> requestLCsv(String url,
    {String fieldSep = ',',
    String textSep = '"',
    bool multiline = true,
    int headerRow = 0}) async {
  final client = BrowserClient();
  final Response resp = await client.get(url);
  return parseLCsv(resp.body,
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<List<List<String>>> requestCsv(String url,
    {String fieldSep = ',',
    String textSep = '"',
    bool multiline = true}) async {
  final client = BrowserClient();
  final Response resp = await client.get(url);
  return parseCsv(resp.body,
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

Future<Table> requestLTsv(String url) async {
  final client = BrowserClient();
  final Response resp = await client.get(url);
  return parseLTsv(resp.body);
}

/// Reads file/blob as labeled TSV file
Future<Table> readLTsv(Blob file, {Encoding encoding = utf8}) async {
  final reader = FileReader();
  reader.readAsText(file);
  await reader.onLoadEnd.first;
  if (reader.readyState != FileReader.DONE) {
    throw Exception('Loading File/Blob failed!');
  }
  if (reader.result is! String) {
    throw Exception('Could not read File/Blob!');
  }
  return parseLTsv(reader.result);
}
