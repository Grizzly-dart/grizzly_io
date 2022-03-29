/// Provides loaders in browser environment
///
/// [requestLTsv] parses TSV files fetched from HTTP requests.
///
/// [readLTsv] parses TSV files opened through file input element.
library grizzly.io.browser_loader;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:grizzly_io/grizzly_io.dart';

export 'package:grizzly_io/grizzly_io.dart';

/// Reads file/blob as labeled TSV file
Future<CSV> readLTsv(Blob file, {Encoding encoding = utf8}) async {
  final reader = FileReader();
  reader.readAsText(file);
  await reader.onLoadEnd.first;
  if (reader.readyState != FileReader.DONE) {
    throw Exception('Loading File/Blob failed!');
  }
  if (reader.result is! String) {
    throw Exception('Could not read File/Blob!');
  }
  return parseLTsv(reader.result as String);
}
