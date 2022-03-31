import 'dart:convert';
import 'dart:io';

import 'csv.dart';

extension DartIOCSVExt on CSV {
  Stream<List<String>> readStream(String path, {Encoding encoding = utf8}) =>
      parseByteStream(File(path).openRead(), encoding: encoding);

  Future<Iterable<List<String>>> read(String path,
          {Encoding encoding = utf8}) async =>
      parseLines(await File(path).readAsLines(encoding: encoding));
}

extension FileCSVExt on File {
  Future<Iterable<List<String>>> readCSV({Encoding encoding = utf8}) async =>
      csv.parseLines(await readAsLines());

  Stream<List<String>> streamCSV({Encoding encoding = utf8}) =>
      csv.parseByteStream(openRead());
}
