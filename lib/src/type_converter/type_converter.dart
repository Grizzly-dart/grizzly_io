/// Utility functions to convert dynamic columns in tables to typed columns
library grizzly.io.transform;

import 'package:intl/intl.dart';

export 'table.dart';

/// Utility functions to convert dynamic columns in tables to typed columns
class ColumnConverter {
  static const String defDateTimeFormat = 'yyyy-MM-dd';

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

extension ConvExt on Object {
  bool canToInt() {
    if (this is int) {
      return true;
    } else if (this is num) {
      return true;
    } else if (this is String) {
      return int.tryParse(this as String) != null;
    }

    return false;
  }

  bool canToDouble() {
    if (this is double) {
      return true;
    } else if (this is num) {
      return true;
    } else if (this is String) {
      return double.tryParse(this as String) != null;
    }

    return false;
  }

  bool canToNum() {
    if (this is num) {
      return true;
    } else if (this is String) {
      return num.tryParse(this as String) != null;
    }

    return false;
  }

  bool canToBool(
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False']}) {
    if (this is bool) return true;
    if (this is num) return true;
    if (this is String) {
      if (trues.contains(this)) return true;
      if (falses.contains(this)) return true;
      return false;
    }
    return false;
  }

  int? asInt({int? defaultValue}) {
    if (this is int) {
      return this as int;
    } else if (this is num) {
      return (this as num).toInt();
    } else if (this is String) {
      return int.parse(this as String);
    }

    return defaultValue;
  }

  double? asDouble({double? defaultValue}) {
    if (this is double) {
      return this as double;
    } else if (this is num) {
      return (this as num).toDouble();
    } else if (this is String) {
      return double.parse(this as String);
    }

    return defaultValue;
  }

  num? asNum({num? defaultValue}) {
    if (this is num) {
      return this as num;
    } else if (this is String) {
      return num.parse(this as String);
    }

    return defaultValue;
  }

  bool? asBool(
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False'],
      bool? defaultValue}) {
    if (this is bool) return this as bool;
    if (this is num) return this != 0;
    if (this is String) {
      if (trues.contains(this)) return true;
      if (falses.contains(this)) return false;
      return defaultValue;
    }
    return defaultValue;
  }
}

extension NullableIterableConvExt<T> on Iterable<T?> {
  /// Checks that if `Iterable` [iterable] can be a `Iterable<int>`
  bool get canToInts => every((v) => v?.canToInt() ?? true);

  Iterable<int?> toInts({int? defaultValue}) =>
      map((v) => v?.asInt(defaultValue: defaultValue));

  bool get canToDoubles => every((v) => v?.canToDouble() ?? true);

  Iterable<double?> toDoubles({double? defaultValue}) =>
      map((v) => v?.asDouble(defaultValue: defaultValue));

  bool get canToNums => every((v) => v?.canToNum() ?? true);

  Iterable<num?> toNums({num? defaultValue}) =>
      map((v) => v?.asNum(defaultValue: defaultValue));
}

extension IterableConvExt<T extends Object> on Iterable<T> {
  /// Checks that if `Iterable` [iterable] can be a `Iterable<int>`
  bool get canToInts => every((v) => v.canToInt());

  Iterable<int> toInts({int? defaultValue}) => map((v) {
        final ret = v.asInt(defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to int');
        }
        return ret;
      });

  bool get canToDoubles => every((v) => v.canToDouble());

  Iterable<double> toDoubles({double? defaultValue}) => map((v) {
        final ret = v.asDouble(defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to double');
        }
        return ret;
      });

  bool get canToNums => every((v) => v.canToNum());

  Iterable<num> toNums({num? defaultValue}) => map((v) {
        final ret = v.asNum(defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to num');
        }
        return ret;
      });
}
