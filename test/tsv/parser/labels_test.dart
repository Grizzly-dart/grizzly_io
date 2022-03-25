// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:grizzly_io/grizzly_io.dart';
import 'package:test/test.dart';

void main() {
  group('LabeledTsv.Header', () {
    setUp(() {});

    test('Normal', () {
      final file = File('data/labeled_tsv/normal.tsv');
      final tsv = parseLTsv(file.readAsStringSync());
      expect(tsv.header, ['Name', 'Age', 'House']);
      expect(tsv, hasLength(4));
      expect(tsv[0], ['Jon', '25', "Stark"]);
      expect(tsv[1], ['Dany', '28', "Targaryan"]);
      expect(tsv[2], ['Tyrion', '40', "Lannister"]);
      expect(tsv[3], ['Elia Martell', '75', "Martell"]);
    });

    test('Quoted', () {
      final file = File('data/labeled_tsv/headers/quoted.tsv');
      final tsv = parseLTsv(file.readAsStringSync());
      expect(tsv.header, ['Name', 'Age', 'House']);
      expect(tsv, hasLength(4));
      expect(tsv[0], ['Jon', '25', "Stark"]);
      expect(tsv[1], ['Dany', '28', "Targaryan"]);
      expect(tsv[2], ['Tyrion', '40', "Lannister"]);
      expect(tsv[3], ['Elia Martell', '75', "Martell"]);
    });

    test('Tab in label', () {
      final file = File('data/labeled_tsv/headers/tab_in_label.tsv');
      final tsv = parseLTsv(file.readAsStringSync());
      expect(tsv.header, ['Name', 'Age', 'House\t(h)']);
      expect(tsv, hasLength(4));
      expect(tsv[0], ['Jon', '25', "Stark"]);
      expect(tsv[1], ['Dany', '28', "Targaryan"]);
      expect(tsv[2], ['Tyrion', '40', "Lannister"]);
      expect(tsv[3], ['Elia Martell', '75', "Martell"]);
    });
  });
}
