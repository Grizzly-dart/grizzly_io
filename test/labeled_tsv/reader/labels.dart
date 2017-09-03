// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'package:grizzly_io/grizzly_io.dart';
import 'package:test/test.dart';

void main() {
  group('LabeledTsv.Header', () {
    setUp(() {});

    test('Normal', () {
      final file = new File('data/labeled_tsv/normal.tsv');
      final tsv = new LabeledTsv.parse(file.readAsStringSync());
      expect(tsv.labels, ['Name', 'Age', 'House']);
      expect(tsv.data, hasLength(4));
      expect(tsv.data[0], {'Name': 'Jon', 'Age': '25', 'House': "Stark"});
      expect(tsv.data[1], {'Name': 'Dany', 'Age': '28', 'House': "Targaryan"});
      expect(
          tsv.data[2], {'Name': 'Tyrion', 'Age': '40', 'House': "Lannister"});
      expect(tsv.data[3],
          {'Name': 'Elia Martell', 'Age': '75', 'House': "Martell"});
    });

    test('Quoted', () {
      final file = new File('data/labeled_tsv/headers/quoted.tsv');
      final tsv = new LabeledTsv.parse(file.readAsStringSync());
      expect(tsv.labels, ['Name', 'Age', 'House']);
      expect(tsv.data, hasLength(4));
      expect(tsv.data[0], {'Name': 'Jon', 'Age': '25', 'House': "Stark"});
      expect(tsv.data[1], {'Name': 'Dany', 'Age': '28', 'House': "Targaryan"});
      expect(
          tsv.data[2], {'Name': 'Tyrion', 'Age': '40', 'House': "Lannister"});
      expect(tsv.data[3],
          {'Name': 'Elia Martell', 'Age': '75', 'House': "Martell"});
    });

    test('Tab in label', () {
      final file = new File('data/labeled_tsv/headers/tab_in_label.tsv');
      final tsv = new LabeledTsv.parse(file.readAsStringSync());
      expect(tsv.labels, ['Name', 'Age', 'House\t(h)']);
      expect(tsv.data, hasLength(4));
      expect(tsv.data[0], {'Name': 'Jon', 'Age': '25', 'House\t(h)': "Stark"});
      expect(tsv.data[1],
          {'Name': 'Dany', 'Age': '28', 'House\t(h)': "Targaryan"});
      expect(tsv.data[2],
          {'Name': 'Tyrion', 'Age': '40', 'House\t(h)': "Lannister"});
      expect(tsv.data[3],
          {'Name': 'Elia Martell', 'Age': '75', 'House\t(h)': "Martell"});
    });
  });
}
