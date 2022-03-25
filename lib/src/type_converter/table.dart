import 'dart:collection';
import 'dart:core';

class Table extends ListBase<List> {
  final List<String>? header;

  final List<List> _rows;

  Table(this.header, this._rows);

  factory Table.from(List<List> data, {bool hasHeader = false}) {
    if (data.isEmpty) return Table(<String>[], <List>[]);
    List<String>? header;
    List<List<dynamic>> rows;
    if (hasHeader) {
      header = data.first.cast<String>();
      rows = data.skip(1).map((e) => List<dynamic>.from(e)).toList();
    } else {
      rows = data.map((e) => List<dynamic>.from(e)).toList();
    }
    return Table(header, rows);
  }

  List<List> toListWithHeader() {
    final list = <List>[];
    if (header != null) list.add(header!);
    list.addAll(_rows);
    return list;
  }

  String toString() => toListWithHeader().toString();

  Map<String, dynamic> rowToMap(int index) {
    if (header == null) {
      throw Exception('This table does not have a header!');
    }
    final row = _rows[index];

    final ret = <String, dynamic>{};

    for (int i = 0; i < header!.length; i++) {
      ret[header![i]] = i < row.length ? row[i] : null;
    }

    return ret;
  }

  Iterable<Map<String, dynamic>> toMap() sync* {
    for (int i = 0; i < _rows.length; i++) {
      yield rowToMap(i);
    }
  }

  O rowToObject<O>(int index, O mapper(Map<String, dynamic> row)) =>
      mapper(rowToMap(index));

  Iterable<O> toObjects<O>(O mapper(Map<String, dynamic> row)) =>
      toMap().map(mapper);

  @override
  int get length => _rows.length;

  @override
  List operator [](int index) => _rows[index];

  @override
  void operator []=(int index, List value) {
    _rows[index] = value;
  }

  @override
  set length(int newLength) {
    _rows.length = newLength;
  }

  int _toColIndex(/* String | int */ index) {
    int pos;
    if (index is String) {
      if (header == null) {
        throw Exception(
            'indexing by column name is not allowed when table does not have a header!');
      }
      pos = header!.indexOf(index);
      if (pos == -1) throw Exception("column $index does not exist");
    } else {
      pos = index;
    }
    return pos;
  }

  List column(/* String | int */ index) {
    index = _toColIndex(index);
    return _RowsToColumns(this, index);
  }
}

class _RowsToColumns<T> extends ListBase<T?> {
  final List<List<T?>> _inner;

  final int colIndex;

  _RowsToColumns(this._inner, this.colIndex);

  @override
  int get length => _inner.isEmpty? 0: _inner.first.length;

  @override
  T? operator [](int index) => _inner[index][colIndex];

  @override
  void operator []=(int index, T? value) {
    _inner[index][colIndex] = value;
  }

  @override
  set length(int newLength) {
    throw UnsupportedError('changing length of a column');
  }
}
