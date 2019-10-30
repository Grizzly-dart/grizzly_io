import 'dart:core';
import 'package:grizzly_io/grizzly_io.dart';

import 'type_converter.dart';

class Table {
  final List<String> header;

  final List<List> rows;

  Table(this.header, this.rows);

  factory Table.from(List<List<String>> data, {bool hasHeader = false}) {
    if (data.isEmpty) return Table(<String>[], <List>[]);
    List<String> header;
    List<List> rows = data;
    if (hasHeader) {
      header = data.first;
      rows = rows.skip(1).toList();
    } else {
      header = <String>[]..length = data.first.length;
    }
    return Table(header, rows);
  }

  bool get hasHeader => header.any((h) => h != null);

  List<List> toList() {
    final list = <List>[];
    if (hasHeader) list.add(header);
    list.addAll(rows);
    return list;
  }

  String toString() => toList().toString();

  Iterable<dynamic> column(/* String | int */ index) {
    if (index is String) {
      index = header.indexOf(index);
      if (index == -1) throw Exception("columns $index does not exist");
    }
    return rows.map((r) => r[index]);
  }

  Iterable<int> columnAsInt(/* String | int */ index) {
    final input = column(index);
    if (input == null) return null;
    if (!ColumnConverter.isInts(input)) return null;
    return ColumnConverter.toInts(input);
  }

  Iterable<double> columnAsDouble(/* String | int */ index) {
    final input = column(index);
    if (input == null) return null;
    if (!ColumnConverter.isDoubles(input)) return null;
    return ColumnConverter.toDoubles(input);
  }

  Iterable<num> columnAsNum(/* String | int */ index) {
    final input = column(index);
    if (input == null) return null;
    if (!ColumnConverter.isNums(input)) return null;
    return ColumnConverter.toNums(input);
  }

  Iterable<bool> columnAsBool(/* String | int */ index,
      {List<String> trues = const ['true', 'True'],
      List<String> falses = const ['false', 'False']}) {
    final input = column(index);
    if (input == null) return null;
    if (!ColumnConverter.isBools(input, trues: trues, falses: falses))
      return null;
    return ColumnConverter.toBools(input, trues: trues, falses: falses);
  }

  Iterable<DateTime> columnAsDateTime(/* String | int */ index,
      {String format = ColumnConverter.defDateTimeFormat,
      String locale,
      bool isUtc = false}) {
    final input = column(index);
    if (input == null) return null;
    if (!ColumnConverter.isDateTimes(input,
        format: format, locale: locale, isUtc: isUtc)) return null;
    return ColumnConverter.toDateTimes(input);
  }
}
