import 'dart:convert';
import 'dart:html';
import 'csv.dart';

extension DartIOCSVExt on CSV {
  /// Reads file/blob as CSV
  Future<Iterable<List<String>>> readBlob(Blob file,
      {Encoding encoding = utf8}) async {
    final reader = FileReader();
    reader.readAsText(file);
    await reader.onLoadEnd.first;
    if (reader.readyState != FileReader.DONE) {
      throw Exception('Loading File/Blob failed!');
    }
    if (reader.result is! String) {
      throw Exception('Could not read File/Blob!');
    }
    return parse(reader.result as String);
  }

  Stream<List<String>> request(Uri url, {Encoding encoding = utf8}) async* {
    window.fetch();
    final client = HttpRequest();
    // TODO
    throw UnimplementedError();
  }
}
