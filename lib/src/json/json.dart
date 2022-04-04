import 'dart:convert';
export 'medium_io.dart' if (dart.library.html) 'medium_browser.dart';

class JSON {
  const JSON();

  Iterable<List<dynamic>> parse(String buffer) {
    final j = jsonDecode(buffer);

    if (j is List) {
      if (j.every((e) => e is List)) {
        return _parseListOfList(j.cast<List>());
      } else if (j.every((e) => e is Map)) {
        final data = <String?, List>{};
        for (final map in j) {
          _flattenMap(null, map, data);
        }
        return data.entries.map((e) => [e.key, ...e.value]);
      } else {
        throw UnsupportedError('unsupported ');
      }
    } else if (j is Map) {
      final data = <String?, List>{};
      _flattenMap(null, j, data);
      return data.entries.map((e) => [e.key, ...e.value]);
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
    v == null ||
    v is String ||
    v is num ||
    v is bool ||
    v is DateTime ||
    v is Duration;

void _flattenMap(String? name, Map map, Map<String?, List<dynamic>> ret) {
  int length = ret.isEmpty ? 0 : ret.values.first.length;

  if (map.values.every(_isBuiltin)) {
    if (name != null) {
      ret[null] = (ret[null] ?? [])..add(name);
    }

    for (final entry in map.entries) {
      ret[entry.key] = (ret[entry.key] ??
          List.filled(length, null, growable: true))
        ..add(entry.value);
    }
    ret.values.where((r) => r.length == length).forEach((r) => r.add(null));
    return;
  }

  map.entries.where((e) => e.value is Map).forEach((entry) {
    _flattenMap(entry.key, entry.value, ret);
  });

  map.entries.where((e) => e.value is List).forEach((entry) {
    ret[null] = (ret[null] ?? [])..add(entry.key);

    final list = entry.value as List;
    int i = 0;
    for (final row in ret.entries) {
      if (row.key == null) {
        continue;
      }
      if (i < list.length) {
        row.value.add(list[i++]);
      } else {
        row.value.add(null);
      }
    }
    /* TODO(tejag): add remaining
      for(; i < list.length; i++) {
        ret.ad
      }*/
  });

  map.entries
      .where((e) => e.value is! List && e.value is! Map)
      .forEach((entry) {
    ret[null] = (ret[null] ?? [])..add(entry.key);
    ret.entries
        .where((r) => r.key != null)
        .forEach((r) => r.value.add(entry.value));
  });
}

void _flattenListMap(
    List<Map<String, dynamic>> list, Map<String?, List<dynamic>> ret) {
  for (final item in list) {
    int length = ret.isEmpty ? 0 : ret.values.first.length;
    for (final entry in item.entries) {
      ret[entry.key] = (ret[entry.key] ?? List.filled(length, null))
        ..add(entry.value);
    }
    _equalizeMapListLength(ret, length + 1);
  }
}

void _equalizeMapListLength(Map<dynamic, List<dynamic>> map, int length) {
  for (final item in map.values) {
    if (item.length != length) {
      item.length = length;
    }
  }
}
