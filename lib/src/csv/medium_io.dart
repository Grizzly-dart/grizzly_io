import 'dart:convert';
import 'dart:io';

import 'csv.dart';

extension DartIOCSVExt on CSV {
  Stream<List<String>> readStream(String path, {Encoding encoding = utf8}) =>
      parseByteStream(File(path).openRead(), encoding: encoding);

  Future<Iterable<List<String>>> read(String path,
          {Encoding encoding = utf8}) async =>
      parseLines(await File(path).readAsLines(encoding: encoding));

  Future<void> write(String path, Iterable<List> data,
          {Encoding encoding = utf8}) =>
      File(path).writeAsString(encode(data), encoding: encoding);

  Stream<List<String>> request(Uri url,
      {Encoding encoding = utf8,
      List<int> statusCodes = const [200],
      HttpClientResponse? response}) async* {
    if (response == null) {
      final req = await HttpClient().getUrl(url);
      response = await req.close();
      if (!statusCodes.contains(response.statusCode)) {
        throw Exception('invalid status code: ${response.statusCode}');
      }
    }

    yield* parseByteStream(response, encoding: encoding);
  }
}

extension FileCSVExt on File {
  Future<Iterable<List<String>>> readCSV({Encoding encoding = utf8}) async =>
      csv.parseLines(await readAsLines());

  Stream<List<String>> streamCSV({Encoding encoding = utf8}) =>
      csv.parseByteStream(openRead());
}

extension HttpClientResponseExt on HttpClientResponse {
  Stream<List<String>> readCSV({Encoding encoding = utf8}) =>
      csv.parseByteStream(this, encoding: encoding);
}
