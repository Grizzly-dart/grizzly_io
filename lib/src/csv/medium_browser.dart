import 'dart:convert';
import 'dart:html';
import 'csv.dart';
import 'package:js_bindings/js_bindings.dart' as js;

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

  Stream<List<String>> request(
    Uri url, {
    Encoding encoding = utf8,
    List<int> statusCodes = const [200],
  }) async* {
    final resp = await js.window.fetch(url.toString());
    if (!statusCodes.contains(resp.status)) {
      throw Exception('invalid status code: ${resp.status}');
    }
    final body = resp.body;
    if (body == null) {
      throw Exception('body not found response');
    }
    js.ReadableStreamDefaultReader reader = body.getReader();
    yield* parseByteStream(reader.asStream());
  }
}

extension on js.ReadableStreamDefaultReader {
  Stream<List<int>> asStream() async* {
    while (true) {
      final res = await read();
      if (res.done) {
        break;
      }
      yield (res.value as List).cast<int>();
    }
  }
}
