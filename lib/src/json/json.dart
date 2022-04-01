import 'dart:convert';
export 'medium_io.dart' if (dart.library.html) 'medium_browser.dart';

class JSON {
  const JSON();

  Iterable<List<dynamic>> parse(String buffer) {
    final j = jsonDecode(buffer);

    if (j is List) {
      if (j.every((e) => e is Map)) {
        // TODO
        throw UnimplementedError();
      } else if (j.every((e) => e is List)) {
        return _parseListOfList(j.cast<List>());
      } else {
        throw UnsupportedError('unsupported ');
      }
    } else {
      throw UnsupportedError('unsupported ');
    }
  }

  static Iterable<List<dynamic>> _parseListOfList(List<List> list) {
    if (list.every((List r) => r.every(_isBuiltin))) {
      return list;
    } else {
      throw UnimplementedError();
    }
  }
}

bool _isBuiltin(dynamic v) =>
    v is String || v is num || v is bool || v is DateTime || v is Duration;

List<Map<String, List<dynamic>>> _flattenMap(Map map) {
  if(map.values.every(_isBuiltin)) {
    return map.map((key, value) => MapEntry<String, List<dynamic>>(key, [value]));
  }
}