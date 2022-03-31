import 'dart:convert';
import 'dart:io';

import 'json.dart';

extension DartIOJSONExt on JSON {
  Future<Iterable<List<dynamic>>> read(String path,
          {Encoding encoding = utf8}) async =>
      parse(await File(path).readAsString(encoding: encoding));
}
