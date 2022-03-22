import 'dart:core';
import 'package:grizzly_io/grizzly_io.dart';

import 'type_converter.dart';

class Table {
  final List<String>? header;

  final List<List> rows;

  Table(this.header, this.rows);

  factory Table.from(List<List<String?>> data, {bool hasHeader = false}) {
    if (data.isEmpty) return Table(<String>[], <List>[]);
    List<String> header;
    List<List> rows = data;
    if (hasHeader) {
      header = data.first.cast<String>();
      rows = rows.skip(1).toList();
    } else {
      header = <String>[]..length = data.first.length;
    }
    return Table(header, rows);
  }

  // bool get hasHeader => header.any((h) => h != null);

  List<List> toList() {
    final list = <List>[];
    if(header != null) list.add(header!);
    list.addAll(rows);
    return list;
  }

  String toString() => toList().toString();

  Map<String, dynamic> rowToMap(int index) {
    if(header == null) {
      throw Exception('This table does not have a header!');
    }
    final row = rows[index];

    final ret = <String, dynamic>{};

    for (int i = 0; i < header!.length; i++) {
      ret[header![i]] = i < row.length ? row[i] : null;
    }

    return ret;
  }

  Iterable<Map<String, dynamic>> toMap() sync* {
    for (int i = 0; i < rows.length; i++) {
      yield rowToMap(i);
    }
  }

  O rowToObject<O>(int index, O mapper(Map<String, dynamic> row)) =>
      mapper(rowToMap(index));

  Iterable<O> toObjects<O>(O mapper(Map<String, dynamic> row)) =>
      toMap().map(mapper);

  int _toIndex(/* String | int */ index) {
    if (index is String) {
      if(header == null) {
        throw Exception('indexing by column name is not allowed when table does not have a header!');
      }
      index = header!.indexOf(index);
      if (index == -1) throw Exception("columns $index does not exist");
    }
    return index;
  }

  Iterable<T> column<T>(/* String | int */ index) {
    index = _toIndex(index);
    return rows.map((r) => r[index]).cast<T>();
  }

  void columnToInt(/* String | int */ index, {int? defaultValue}) {
    index = _toIndex(index);

    for (int r = 0; r < rows.length; r++) {
      rows[r][index] =
          ColumnConverter.toInt(rows[r][index], defaultValue: defaultValue);
    }
  }

  void columnToDouble(/* String | int */ index, {double? defaultValue}) {
    index = _toIndex(index);

    for (int r = 0; r < rows.length; r++) {
      rows[r][index] =
          ColumnConverter.toDouble(rows[r][index], defaultValue: defaultValue);
    }
  }

  void columnToNum(/* String | int */ index, {num? defaultValue}) {
    index = _toIndex(index);

    for (int r = 0; r < rows.length; r++) {
      rows[r][index] =
          ColumnConverter.toNum(rows[r][index], defaultValue: defaultValue);
    }
  }

  void columnToBool(/* String | int */ index,
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False'],
      bool? defaultValue}) {
    index = _toIndex(index);

    for (int r = 0; r < rows.length; r++) {
      rows[r][index] = ColumnConverter.toBool(rows[r][index],
          trues: trues, falses: falses, defaultValue: defaultValue);
    }
  }

  void columnToDateTime(/* String | int */ index,
      {String format = ColumnConverter.defDateTimeFormat,
      String? locale,
      bool isUtc = false,
      DateTime? defaultValue}) {
    index = _toIndex(index);

    for (int r = 0; r < rows.length; r++) {
      rows[r][index] = ColumnConverter.toDateTime(rows[r][index],
          format: format,
          locale: locale,
          isUtc: isUtc,
          defaultValue: defaultValue);
    }
  }

  Iterable<int?> columnAsInt(/* String | int */ index, {int? defaultValue}) {
    final input = column(index);
    return ColumnConverter.toInts(input, defaultValue: defaultValue);
  }

  Iterable<double?> columnAsDouble(/* String | int */ index,
      {double? defaultValue}) {
    final input = column(index);
    return ColumnConverter.toDoubles(input, defaultValue: defaultValue);
  }

  Iterable<num?> columnAsNum(/* String | int */ index, {num? defaultValue}) {
    final input = column(index);
    return ColumnConverter.toNums(input, defaultValue: defaultValue);
  }

  Iterable<bool?> columnAsBool(/* String | int */ index,
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False'],
      bool? defaultValue}) {
    final input = column(index);
    return ColumnConverter.toBools(input,
        trues: trues, falses: falses, defaultValue: defaultValue);
  }

  Iterable<DateTime?> columnAsDateTime(/* String | int */ index,
      {String format = ColumnConverter.defDateTimeFormat,
      String? locale,
      bool isUtc = false,
      DateTime? defaultValue}) {
    final input = column(index);
    return ColumnConverter.toDateTimes(input, defaultValue: defaultValue);
  }
}
