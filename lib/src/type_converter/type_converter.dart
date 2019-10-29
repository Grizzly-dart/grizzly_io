/// Utility functions to convert dynamic columns in tables to typed columns
library grizzly.io.transform;

import 'package:intl/intl.dart';

export 'table.dart';

/// Utility functions to convert dynamic columns in tables to typed columns
class TypeConverter {
  static const String defDateTimeFormat = 'yyyy-MM-dd';

  static bool isInt(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return int.tryParse(v) != null;
    return false;
  }

  static int toInt(v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    try {
      if (v is String) return int.parse(v);
    } catch (_) {}
    throw Exception('Trying to convert a non-integer to int!');
  }

  static bool isDouble(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return double.tryParse(v) != null;
    return false;
  }

  static double toDouble(v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    try {
      if (v is String) return double.parse(v);
    } catch (_) {}
    throw Exception('Trying to convert a non-double to double!');
  }

  static bool isNum(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return num.tryParse(v) != null;
    return false;
  }

  static num toNum(v) {
    if (v == null) return null;
    if (v is num) return v;
    try {
      if (v is String) return num.parse(v);
    } catch (_) {}
    throw Exception('Trying to convert a non-num to num!');
  }

  static bool isBool(v,
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False']}) {
    if (v == null) return true;
    if (v is bool) return true;
    if (v is num) return true;
    if (v is String) {
      if (trues.contains(v)) return true;
      if (falses.contains(v)) return true;
      return false;
    }
    return false;
  }

  static bool toBool(v,
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False']}) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      if (trues.contains(v)) return true;
      if (falses.contains(v)) return false;
      throw Exception('Trying to convert a non-bool to bool!');
    }
    throw Exception('Trying to convert a non-bool to bool!');
  }

  static bool isDateTime(v,
      {String format = defDateTimeFormat, String locale, bool isUtc = false}) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is DateTime) return true;
    if (v is String) {
      final num n = num.tryParse(v);
      if (n != null) return true;

      final df = DateFormat(format, locale);
      try {
        df.parse(v, isUtc);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static DateTime toDateTime(v,
      {String format = defDateTimeFormat, String locale, bool isUtc = false}) {
    if (v == null) return null;
    if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
    if (v is DateTime) return v;
    if (v is String) {
      final num n = num.tryParse(v);
      if (n != null) DateTime.fromMillisecondsSinceEpoch(n.toInt());

      final df = DateFormat(format, locale);
      try {
        return df.parse(v, isUtc);
      } catch (e) {
        throw Exception('Trying to convert a non-DateTime to DateTime!');
      }
    }
    throw Exception('Trying to convert a non-DateTime to DateTime!');
  }

  /// Checks that if `List` [list] can be a `List<int>`
  static bool isIntList(Iterable list) => list.every(isInt);

  static List<int> toIntList(Iterable list) => list.map(toInt).toList();

  /// Checks that if `List` [list] can be a `List<double>`
  static bool isDoubleList(Iterable list) => list.every(isDouble);

  static List<double> toDoubleList(Iterable list) =>
      list.map(toDouble).toList();

  /// Checks that if `List` [list] can be a `List<num>`
  static bool isNumList(Iterable list) => list.every(isNum);

  static List<num> toNumList(Iterable list) => list.map(toNum).toList();

  /// Checks that if `List` [list] can be a `List<bool>`
  static bool isBoolList(Iterable list,
          {List<String> trues = const ['true', 'True'],
          List<String> falses = const ['false', 'False']}) =>
      list.every((e) => isBool(e, trues: trues, falses: falses));

  static List<bool> toBoolList(Iterable list,
          {List<String> trues = const ['true', 'True'],
          List<String> falses = const ['false', 'False']}) =>
      list.map((e) => toBool(e, trues: trues, falses: falses)).toList();

  static bool isDateTimeList(Iterable list,
          {String format = defDateTimeFormat,
          String locale,
          bool isUtc = false}) =>
      list.every(
          (v) => isDateTime(v, format: format, locale: locale, isUtc: isUtc));

  static List<DateTime> toDateTimeList(Iterable list,
          {String format = defDateTimeFormat,
          String locale,
          bool isUtc = false}) =>
      list
          .map((v) =>
              toDateTime(v, format: format, locale: locale, isUtc: isUtc))
          .toList();

  static List<String> toStringList(Iterable list) =>
      list.map((v) => v?.toString()).toList();

  static bool isIntColumn(Iterable<Map> list, label) =>
      list.every((m) => isInt(m[label]));

  static Iterable<Map> toIntColumn(Iterable<Map> list, label) =>
      list..forEach((m) => m[label] = toInt(m[label]));

  static bool isDoubleColumn(Iterable<Map> list, label) =>
      list.every((m) => isDouble(m[label]));

  static Iterable<Map> toDoubleColumn(Iterable<Map> list, label) =>
      list..forEach((m) => m[label] = toDouble(m[label]));

  static bool isNumColumn(Iterable<Map> list, label) =>
      list.every((m) => isNum(m[label]));

  static Iterable<Map> toNumColumn(Iterable<Map> list, label) =>
      list..forEach((m) => m[label] = toNum(m[label]));

  static bool isBoolColumn(Iterable<Map> list, label,
          {List<String> trues = const ['true', 'True'],
          List<String> falses = const ['false', 'False']}) =>
      list.every((m) => isBool(m[label], trues: trues, falses: falses));

  static Iterable<Map> toBoolColumn(Iterable<Map> list, label,
          {List<String> trues = const ['true', 'True'],
          List<String> falses = const ['false', 'False']}) =>
      list
        ..forEach(
            (m) => m[label] = toBool(m[label], trues: trues, falses: falses));

  static bool isDateTimeColumn(Iterable<Map> list, label,
          {String format = defDateTimeFormat,
          String locale,
          bool isUtc = false}) =>
      list.every((m) =>
          isDateTime(m[label], format: format, locale: locale, isUtc: isUtc));

  static Iterable<Map> toDateTimeColumn(Iterable<Map> list, String label,
          {String format = defDateTimeFormat,
          String locale,
          bool isUtc = false}) =>
      list
        ..forEach((m) => m[label] =
            toDateTime(m[label], format: format, locale: locale, isUtc: isUtc));

  static List<List> convertLists(
      Iterable<Iterable> list, Map<int, TransformFunc> labelOps) {
    final List<List> ret = List<List>(list.length);

    Iterator<Iterable> iterator = list.iterator;
    for (int i = 0; i < list.length; i++) {
      iterator.moveNext();

      if (labelOps[i] == null) ret[i] = iterator.current.toList();

      ret[i] = iterator.current.map(labelOps[i]).toList();
    }

    return ret;
  }

  static Iterable<Map> convertColumns(
          Iterable<Map> list, Map<dynamic, TransformFunc> labelOps) =>
      list
        ..forEach((m) {
          labelOps.forEach((label, op) {
            m[label] = op(m[label]);
          });
        });
}

typedef TransformFunc<OT> = OT Function(dynamic v);
