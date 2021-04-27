/// Utility functions to convert dynamic columns in tables to typed columns
library grizzly.io.transform;

import 'package:intl/intl.dart';

export 'table.dart';

/// Utility functions to convert dynamic columns in tables to typed columns
class ColumnConverter {
  static const String defDateTimeFormat = 'yyyy-MM-dd';

  static bool isInt(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return int.tryParse(v) != null;
    return false;
  }

  static int? toInt(v, {int? defaultValue}) {
    if (v == null) return defaultValue;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? defaultValue;
    if (defaultValue != null) return defaultValue;
    throw Exception('Trying to convert a non-integer to int!');
  }

  static bool isDouble(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return double.tryParse(v) != null;
    return false;
  }

  static double? toDouble(v, {double? defaultValue}) {
    if (v == null) return defaultValue;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? defaultValue;
    if (defaultValue != null) return defaultValue;
    throw Exception('Trying to convert a non-double to double!');
  }

  static bool isNum(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return num.tryParse(v) != null;
    return false;
  }

  static num? toNum(v, {num? defaultValue}) {
    if (v == null) return defaultValue;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? defaultValue;
    if (defaultValue != null) return defaultValue;
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

  static bool? toBool(v,
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False'],
      bool? defaultValue}) {
    if (v == null) return defaultValue;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      if (trues.contains(v)) return true;
      if (falses.contains(v)) return false;
      if (defaultValue != null) return defaultValue;
      throw Exception('Trying to convert a non-bool to bool!');
    }
    if (defaultValue != null) return defaultValue;
    throw Exception('Trying to convert a non-bool to bool!');
  }

  static bool isDateTime(v,
      {String format = defDateTimeFormat, String? locale, bool isUtc = false}) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is DateTime) return true;
    if (v is String) {
      final num? n = num.tryParse(v);
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

  static DateTime? toDateTime(v,
      {String format = defDateTimeFormat,
      String? locale,
      bool isUtc = false,
      DateTime? defaultValue}) {
    if (v == null) return defaultValue;
    if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
    if (v is DateTime) return v;
    if (v is String) {
      final num? n = num.tryParse(v);
      if (n != null) DateTime.fromMillisecondsSinceEpoch(n.toInt());

      final df = DateFormat(format, locale);
      try {
        return df.parse(v, isUtc);
      } catch (e) {
        if (defaultValue != null) return defaultValue;
        throw Exception('Trying to convert a non-DateTime to DateTime!');
      }
    }
    if (defaultValue != null) return defaultValue;
    throw Exception('Trying to convert a non-DateTime to DateTime!');
  }

  /// Checks that if `List` [list] can be a `List<int>`
  static bool isInts(Iterable list) => list.every(isInt);

  static Iterable<int?> toInts(Iterable list, {int? defaultValue}) =>
      list.map((v) => toInt(v, defaultValue: defaultValue));

  /// Checks that if `List` [list] can be a `List<double>`
  static bool isDoubles(Iterable list) => list.every(isDouble);

  static Iterable<double?> toDoubles(Iterable list, {double? defaultValue}) =>
      list.map((v) => toDouble(v, defaultValue: defaultValue));

  /// Checks that if `List` [list] can be a `List<num>`
  static bool isNums(Iterable list) => list.every(isNum);

  static Iterable<num?> toNums(Iterable list, {num? defaultValue}) =>
      list.map((v) => toNum(v, defaultValue: defaultValue));

  /// Checks that if `List` [list] can be a `List<bool>`
  static bool isBools(Iterable list,
          {List<String> trues = const ['true', 'True'],
          List<String> falses = const ['false', 'False']}) =>
      list.every((e) => isBool(e, trues: trues, falses: falses));

  static Iterable<bool?> toBools(Iterable list,
          {List<String> trues = const ['true', 'True'],
          List<String> falses = const ['false', 'False'],
          bool? defaultValue}) =>
      list.map((e) =>
          toBool(e, trues: trues, falses: falses, defaultValue: defaultValue));

  static bool isDateTimes(Iterable list,
          {String format = defDateTimeFormat,
          String? locale,
          bool isUtc = false}) =>
      list.every(
          (v) => isDateTime(v, format: format, locale: locale, isUtc: isUtc));

  static Iterable<DateTime?> toDateTimes(Iterable list,
          {String format = defDateTimeFormat,
          String? locale,
          bool isUtc = false,
          DateTime? defaultValue}) =>
      list.map((v) => toDateTime(v,
          format: format,
          locale: locale,
          isUtc: isUtc,
          defaultValue: defaultValue));

  static Iterable<String?> toStrings(Iterable list, {String? defaultValue}) =>
      list.map((v) => v?.toString() ?? defaultValue);
}
