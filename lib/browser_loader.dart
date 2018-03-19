/// Provides loaders in browser environment
///
/// [requestLTsv] parses TSV files fetched from HTTP requests.
///
/// [readLTsv] parses TSV files opened through file input element.
library grizzly.io.browser_loader;

import 'dart:html';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:http/browser_client.dart';
import 'package:grizzly_io/grizzly_io.dart';

export 'package:grizzly_io/grizzly_io.dart';

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<LabeledTable> requestLCsv(String url,
    {String fieldSep: ',',
    String textSep: '"',
    bool multiline: true,
    int headerRow: 0}) async {
  final client = new BrowserClient();
  final Response resp = await client.get(url);
  return parseLCsv(resp.body,
      fieldSep: fieldSep,
      textSep: textSep,
      multiline: multiline,
      headerRow: headerRow);
}

/// Downloads the TSV file from specified [url] and returns the parsed data
Future<List<List<String>>> requestCsv(String url,
    {String fieldSep: ',', String textSep: '"', bool multiline: true}) async {
  final client = new BrowserClient();
  final Response resp = await client.get(url);
  return parseCsv(resp.body,
      fieldSep: fieldSep, textSep: textSep, multiline: multiline);
}

Future<LabeledTable> requestLTsv(String url) async {
  final client = new BrowserClient();
  final Response resp = await client.get(url);
  return parseLTsv(resp.body);
}

/// Reads file/blob as labeled TSV file
Future<LabeledTable> readLTsv(Blob file, {Encoding encoding: UTF8}) async {
  FileReader reader = new FileReader();
  reader.readAsText(file);
  await reader.onLoadEnd.first;
  if (reader.readyState != FileReader.DONE) {
    throw new Exception('Loading File/Blob failed!');
  }
  if (reader.result is! String) {
    throw new Exception('Could not read File/Blob!');
  }
  return parseLTsv(reader.result);
}
