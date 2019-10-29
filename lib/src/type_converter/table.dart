import 'dart:math' as math;
import 'package:grizzly_io/grizzly_io.dart';

import 'type_converter.dart';

class Table {
  /// Labels/columns
  final List<String> columns;

  final List<Map<String, dynamic>> data;

  Table(Iterable<String> labels, this.data) : columns = labels.toList() {
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

  factory Table.from(List<List<String>> rows, {int headerRow = 0}) {
    if (rows.isEmpty) return Table([], []);

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

    return Table(labels, data);
  }

  /*    List interface implementation    */

  Map<String, dynamic> operator [](int index) => data[index];

  void operator []=(int index, Map value) => data[index] = value;

  int get length => data.length;

  /* Column operations */

  /// Adds or updates column with label [label] with given values [values]
  Table setColumn<T>(String label, Iterable<T> values) {
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
  Table removeColumn<T>(label) {
    columns.remove(label);

    for (int i = 0; i < length; i++) {
      data[i].remove(label);
    }

    return this;
  }

  List<T> getColumn<T>(String column) {
    if (!columns.contains(column)) throw Exception('Column not found!');
    final ret = []..length = length;
    for (int i = 0; i < length; i++) {
      ret[i] = data[i][column];
    }
    return ret;
  }

  List getRow(int row) {
    final ret = []..length = columns.length;
    int i = 0;
    for (String col in columns) {
      ret[i] = data[row][col];
      i++;
    }
    return ret;
  }

  List<List> toList() {
    final ret = []..length = length + 1;
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
          {List<String> trues = const ['true', 'True'],
          List<String> falses = const ['false', 'False']}) =>
      TypeConverter.toBoolList(getColumn(column), trues: trues, falses: falses);

  List<DateTime> columnAsDateTime(String column,
          {String format = TypeConverter.defDateTimeFormat,
          String locale,
          bool isUtc = false}) =>
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
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False']}) {
    TypeConverter.toBoolColumn(data, column, trues: trues, falses: falses);
  }

  void columnToDateTime(String column,
      {String format = TypeConverter.defDateTimeFormat,
      String locale,
      bool isUtc = false}) {
    TypeConverter.toDateTimeColumn(data, column,
        format: format, locale: locale, isUtc: isUtc);
  }

  String toString() => encodeCsv(toList(), fieldSep: '\t');
}
