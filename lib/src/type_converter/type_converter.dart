/// Utility functions to convert dynamic columns in tables to typed columns
library grizzly.io.transform;

import 'package:intl/intl.dart';

export 'table.dart';

const String _defDateFormat = 'yyyy-MM-dd';
const _trues = ['true', 'True', 't', 'T', 'Y', 'y'];
const _falses = ['false', 'False', 'f', 'F', 'N', 'n'];

extension _ConvExt on Object {
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

  bool canToBool({List<String> trues = _trues, List<String> falses = _falses}) {
    if (this is bool) return true;
    if (this is num) return true;
    if (this is String) {
      if (trues.contains(this)) return true;
      if (falses.contains(this)) return true;
      return false;
    }
    return false;
  }

  bool canToDate({String format = _defDateFormat, String? locale}) {
    if (this is num) return true;
    if (this is DateTime) return true;
    if (this is String) {
      final num? n = num.tryParse(this as String);
      if (n != null) {
        return true;
      }

      final df = DateFormat(format, locale);
      try {
        df.parse(this as String);
        return true;
      } catch (e) {
        return false;
      }
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
      {List<String> trues = _trues,
      List<String> falses = _falses,
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

  DateTime? asDate(
      {String format = _defDateFormat,
      String? locale,
      bool isUtc = false,
      DateTime? defaultValue}) {
    if (this is num) {
      return DateTime.fromMillisecondsSinceEpoch((this as num).toInt());
    }
    if (this is DateTime) return this as DateTime;
    if (this is String) {
      final num? n = num.tryParse(this as String);
      if (n != null) {
        return DateTime.fromMillisecondsSinceEpoch(n.toInt());
      }

      final df = DateFormat(format, locale);
      try {
        return df.parse(this as String, isUtc);
      } catch (e) {
        return defaultValue;
      }
    }
    return defaultValue;
  }
}

extension NullableIterableConvExt<T> on Iterable<T?> {
  /// Checks that if `Iterable` [iterable] can be a `Iterable<int>`
  bool get canToInts => every((v) => v?.canToInt() ?? true);

  Iterable<int?> asInts({int? defaultValue}) =>
      map((v) => v?.asInt(defaultValue: defaultValue));

  bool get canToDoubles => every((v) => v?.canToDouble() ?? true);

  Iterable<double?> asDoubles({double? defaultValue}) =>
      map((v) => v?.asDouble(defaultValue: defaultValue));

  bool get canToNums => every((v) => v?.canToNum() ?? true);

  Iterable<num?> asNums({num? defaultValue}) =>
      map((v) => v?.asNum(defaultValue: defaultValue));

  bool canToBools(
          {List<String> trues = _trues, List<String> falses = _falses}) =>
      every((v) => v?.canToBool(trues: trues, falses: falses) ?? true);

  Iterable<bool?> asBools(
          {List<String> trues = _trues,
          List<String> falses = _falses,
          bool? defaultValue}) =>
      map((v) =>
          v?.asBool(trues: trues, falses: falses, defaultValue: defaultValue));

  bool canToDates({String format = _defDateFormat, String? locale}) =>
      every((v) => v?.canToDate(format: format, locale: locale) ?? true);

  Iterable<DateTime?> asDates(
          {String format = _defDateFormat,
          String? locale,
          bool isUtc = false,
          DateTime? defaultValue}) =>
      map((v) => v?.asDate(
          format: format,
          locale: locale,
          isUtc: isUtc,
          defaultValue: defaultValue));
}

extension IterableConvExt<T extends Object> on Iterable<T> {
  /// Checks that if `Iterable` [iterable] can be a `Iterable<int>`
  bool get canToInts => every((v) => v.canToInt());

  Iterable<int> asInts({int? defaultValue}) => map((v) {
        final ret = v.asInt(defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to int');
        }
        return ret;
      });

  bool get canToDoubles => every((v) => v.canToDouble());

  Iterable<double> asDoubles({double? defaultValue}) => map((v) {
        final ret = v.asDouble(defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to double');
        }
        return ret;
      });

  bool get canToNums => every((v) => v.canToNum());

  Iterable<num> asNums({num? defaultValue}) => map((v) {
        final ret = v.asNum(defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to num');
        }
        return ret;
      });

  bool canToBools(
          {List<String> trues = _trues,
          List<String> falses = _falses,
          bool? defaultValue}) =>
      every((v) => v.canToBool(trues: trues, falses: falses));

  Iterable<bool> asBools(
          {List<String> trues = _trues,
          List<String> falses = _falses,
          bool? defaultValue}) =>
      map((v) {
        final ret =
            v.asBool(trues: trues, falses: falses, defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to bool');
        }
        return ret;
      });

  bool canToDates({String format = _defDateFormat, String? locale}) =>
      every((v) => v.canToDate(format: format, locale: locale));

  Iterable<DateTime> asDates(
          {String format = _defDateFormat,
          String? locale,
          bool isUtc = false,
          DateTime? defaultValue}) =>
      map((v) {
        final ret = v.asDate(
            format: format,
            locale: locale,
            isUtc: isUtc,
            defaultValue: defaultValue);
        if (ret == null) {
          throw Exception('Cannot convert ${v.runtimeType} to DateTime');
        }
        return ret;
      });
}

extension NullListConvExt on List<Object?> {
  void convertToInts({int? defaultValue}) {
    for (int i = 0; i < length; i++) {
      this[i] = this[i]?.asInt(defaultValue: defaultValue);
    }
  }

  void convertToDoubles({double? defaultValue}) {
    for (int i = 0; i < length; i++) {
      this[i] = this[i]?.asDouble(defaultValue: defaultValue);
    }
  }

  void convertToNums({num? defaultValue}) {
    for (int i = 0; i < length; i++) {
      this[i] = this[i]?.asNum(defaultValue: defaultValue);
    }
  }

  void convertToBools(
      {List<String> trues = _trues,
      List<String> falses = _falses,
      bool? defaultValue}) {
    for (int i = 0; i < length; i++) {
      this[i] = this[i]
          ?.asBool(trues: trues, falses: falses, defaultValue: defaultValue);
    }
  }

  void toDates(
      {String format = _defDateFormat,
      String? locale,
      bool isUtc = false,
      DateTime? defaultValue}) {
    for (int i = 0; i < length; i++) {
      this[i] = this[i]?.asDate(
          format: format,
          locale: locale,
          isUtc: isUtc,
          defaultValue: defaultValue);
    }
  }
}

extension ListConvExt on List<Object> {
  void convertToInts({int? defaultValue}) {
    for (int i = 0; i < length; i++) {
      final v = this[i].asInt(defaultValue: defaultValue);
      if (v == null) {
        throw Exception('Cannot convert ${v.runtimeType} to int');
      }
      this[i] = v;
    }
  }

  void convertToDoubles({double? defaultValue}) {
    for (int i = 0; i < length; i++) {
      final v = this[i].asDouble(defaultValue: defaultValue);
      if (v == null) {
        throw Exception('Cannot convert ${v.runtimeType} to double');
      }
      this[i] = v;
    }
  }

  void convertToNums({num? defaultValue}) {
    for (int i = 0; i < length; i++) {
      final v = this[i].asNum(defaultValue: defaultValue);
      if (v == null) {
        throw Exception('Cannot convert ${v.runtimeType} to num');
      }
      this[i] = v;
    }
  }

  void convertToBools(
      {List<String> trues = _trues,
      List<String> falses = _falses,
      bool? defaultValue}) {
    for (int i = 0; i < length; i++) {
      final v = this[i]
          .asBool(trues: trues, falses: falses, defaultValue: defaultValue);
      if (v == null) {
        throw Exception('Cannot convert ${v.runtimeType} to bool');
      }
      this[i] = v;
    }
  }

  void toDates(
      {String format = _defDateFormat,
      String? locale,
      bool isUtc = false,
      DateTime? defaultValue}) {
    for (int i = 0; i < length; i++) {
      final v = this[i].asDate(
          format: format,
          locale: locale,
          isUtc: isUtc,
          defaultValue: defaultValue);
      if (v == null) {
        throw Exception('Cannot convert ${v.runtimeType} to DateTime');
      }
      this[i] = v;
    }
  }
}
