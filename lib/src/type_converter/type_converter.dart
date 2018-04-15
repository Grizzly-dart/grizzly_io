/// Utility functions to convert dynamic columns in tables to typed columns
library grizzly.io.transform;

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:grizzly_io/src/csv/writer.dart';

/// Utility functions to convert dynamic columns in tables to typed columns
class TypeConverter {
  static const String defDateTimeFormat = 'yyyy-MM-dd';

  static bool isInt(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return int.parse(v, onError: (_) => null) != null;
    return false;
  }

  static int toInt(v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    try {
      if (v is String) return int.parse(v);
    } catch (_) {}
    throw new Exception('Trying to convert a non-integer to int!');
  }

  static bool isDouble(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return double.parse(v, (_) => null) != null;
    return false;
  }

  static double toDouble(v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    try {
      if (v is String) return double.parse(v);
    } catch (_) {}
    throw new Exception('Trying to convert a non-double to double!');
  }

  static bool isNum(v) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is String) return num.parse(v, (_) => null) != null;
    return false;
  }

  static num toNum(v) {
    if (v == null) return null;
    if (v is num) return v;
    try {
      if (v is String) return num.parse(v);
    } catch (_) {}
    throw new Exception('Trying to convert a non-num to num!');
  }

  static bool isBool(v,
      {List<String> trues: const ['true', 'True'],
      List<String> falses: const ['false', 'False']}) {
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
      {List<String> trues: const ['true', 'True'],
      List<String> falses: const ['false', 'False']}) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      if (trues.contains(v)) return true;
      if (falses.contains(v)) return false;
      throw new Exception('Trying to convert a non-bool to bool!');
    }
    throw new Exception('Trying to convert a non-bool to bool!');
  }

  static bool isDateTime(v,
      {String format: defDateTimeFormat, String locale, bool isUtc: false}) {
    if (v == null) return true;
    if (v is num) return true;
    if (v is DateTime) return true;
    if (v is String) {
      final num n = num.parse(v, (_) => null);
      if (n != null) return true;

      final df = new DateFormat(format, locale);
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
      {String format: defDateTimeFormat, String locale, bool isUtc: false}) {
    if (v == null) return null;
    if (v is num) return new DateTime.fromMillisecondsSinceEpoch(v.toInt());
    if (v is DateTime) return v;
    if (v is String) {
      final num n = num.parse(v, (_) => null);
      if (n != null) new DateTime.fromMillisecondsSinceEpoch(n.toInt());

      final df = new DateFormat(format, locale);
      try {
        return df.parse(v, isUtc);
      } catch (e) {
        throw new Exception('Trying to convert a non-DateTime to DateTime!');
      }
    }
    throw new Exception('Trying to convert a non-DateTime to DateTime!');
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
          {List<String> trues: const ['true', 'True'],
          List<String> falses: const ['false', 'False']}) =>
      list.every((e) => isBool(e, trues: trues, falses: falses));

  static List<bool> toBoolList(Iterable list,
          {List<String> trues: const ['true', 'True'],
          List<String> falses: const ['false', 'False']}) =>
      list.map((e) => toBool(e, trues: trues, falses: falses)).toList();

  static bool isDateTimeList(Iterable list,
          {String format: defDateTimeFormat,
          String locale,
          bool isUtc: false}) =>
      list.every(
          (v) => isDateTime(v, format: format, locale: locale, isUtc: isUtc));

  static List<DateTime> toDateTimeList(Iterable list,
          {String format: defDateTimeFormat,
          String locale,
          bool isUtc: false}) =>
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
          {List<String> trues: const ['true', 'True'],
          List<String> falses: const ['false', 'False']}) =>
      list.every((m) => isBool(m[label], trues: trues, falses: falses));

  static Iterable<Map> toBoolColumn(Iterable<Map> list, label,
          {List<String> trues: const ['true', 'True'],
          List<String> falses: const ['false', 'False']}) =>
      list
        ..forEach(
            (m) => m[label] = toBool(m[label], trues: trues, falses: falses));

  static bool isDateTimeColumn(Iterable<Map> list, label,
          {String format: defDateTimeFormat,
          String locale,
          bool isUtc: false}) =>
      list.every((m) =>
          isDateTime(m[label], format: format, locale: locale, isUtc: isUtc));

  static Iterable<Map> toDateTimeColumn(Iterable<Map> list, String label,
          {String format: defDateTimeFormat,
          String locale,
          bool isUtc: false}) =>
      list
        ..forEach((m) => m[label] =
            toDateTime(m[label], format: format, locale: locale, isUtc: isUtc));

  static List<List> convertLists(
      Iterable<Iterable> list, Map<int, TransformFunc> labelOps) {
    final List<List> ret = new List<List>(list.length);

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

typedef OT TransformFunc<OT>(dynamic v);

class LabeledTable {
  /// Labels/columns
  final List<String> columns;

  final List<Map<String, dynamic>> data;

  LabeledTable(Iterable<String> labels, this.data, {bool autoConvert: false})
      : columns = labels.toList() {
    for (String column in labels) {
      if (TypeConverter.isIntColumn(data, column)) {
        TypeConverter.toIntColumn(data, column);
      } else if (TypeConverter.isDoubleColumn(data, column)) {
        TypeConverter.toDoubleColumn(data, column);
      } else if (TypeConverter.isNumColumn(data, column)) {
        TypeConverter.toNumColumn(data, column);
      } else if (TypeConverter.isBoolColumn(data, column)) {
        TypeConverter.toBoolColumn(data, column);
      } else if (TypeConverter.isDateTimeColumn(data, column)) {
        TypeConverter.toDateTimeColumn(data, column);
      }
    }
  }

  factory LabeledTable.from(List<List<String>> rows, {int headerRow: 0}) {
    if (rows.length == 0) return new LabeledTable([], []);

    final List<String> labels = rows[headerRow];
    final List<Map<String, dynamic>> data = [];

    // Parse the label header
    for (int i = 0; i < rows.length; i++) {
      if (i == headerRow) continue;

      final List row = rows[i];
      final int len = math.min(row.length, labels.length);

      final d = <String, dynamic>{};

      for (int j = 0; j < len; j++) {
        d[labels[j]] = row[j];
      }
      data.add(d);
    }

    return new LabeledTable(labels, data);
  }

  /*    List interface implementation    */

  Map<String, dynamic> operator [](int index) => data[index];

  void operator []=(int index, Map value) => data[index] = value;

  int get length => data.length;

  /* Column operations */

  /// Adds or updates column with label [label] with given values [values]
  LabeledTable setColumn<T>(String label, Iterable<T> values) {
    columns.add(label);
    final int len = math.min(values.length, length);

    Iterator<T> it = values.iterator;
    it.moveNext();
    for (int i = 0; i < len; i++) {
      if (data[i] is! Map) data[i] = {};
      data[i][label] = it.current;
      it.moveNext();
    }

    return this;
  }

  /// Removes the column with label [label]
  LabeledTable removeColumn<T>(label) {
    columns.remove(label);

    for (int i = 0; i < length; i++) {
      data[i].remove(label);
    }

    return this;
  }

  List<T> getColumn<T>(String column) {
    if (!columns.contains(column)) throw new Exception('Column not found!');
    final ret = new List<T>()..length = length;
    for (int i = 0; i < length; i++) {
      ret[i] = data[i][column];
    }
    return ret;
  }

  List getRow(int row) {
    final ret = new List()..length = columns.length;
    int i = 0;
    for (String col in columns) {
      ret[i] = data[row][col];
      i++;
    }
    return ret;
  }

  List<List> toList() {
    final ret = new List<List>()..length = length + 1;
    ret[0] = columns.toList();
    for (int i = 1; i <= length; i++) {
      ret[i] = getRow(i - 1);
    }
    return ret;
  }

  /* Column converters */

  List<int> columnAsInt(String column) =>
      TypeConverter.toIntList(getColumn(column));

  List<double> columnAsDouble(String column) =>
      TypeConverter.toDoubleList(getColumn(column));

  List<num> columnAsNum(String column) =>
      TypeConverter.toNumList(getColumn(column));

  List<bool> columnAsBool(String column,
          {List<String> trues: const ['true', 'True'],
          List<String> falses: const ['false', 'False']}) =>
      TypeConverter.toBoolList(getColumn(column), trues: trues, falses: falses);

  List<DateTime> columnAsDateTime(String column,
          {String format: TypeConverter.defDateTimeFormat,
          String locale,
          bool isUtc: false}) =>
      TypeConverter.toDateTimeList(getColumn(column),
          format: format, locale: locale, isUtc: isUtc);

  /* Column casters */

  void columnToInt(String column) {
    TypeConverter.toIntColumn(data, column);
  }

  void columnToDouble(String column) {
    TypeConverter.toDoubleColumn(data, column);
  }

  void columnToNum(String column) {
    TypeConverter.toNumColumn(data, column);
  }

  void columnToBool(String column,
      {List<String> trues: const ['true', 'True'],
      List<String> falses: const ['false', 'False']}) {
    TypeConverter.toBoolColumn(data, column, trues: trues, falses: falses);
  }

  void columnToDateTime(String column,
      {String format: TypeConverter.defDateTimeFormat,
      String locale,
      bool isUtc: false}) {
    TypeConverter.toDateTimeColumn(data, column,
        format: format, locale: locale, isUtc: isUtc);
  }

  String toString() => encodeCsv(toList(), fieldSep: '\t');
}
