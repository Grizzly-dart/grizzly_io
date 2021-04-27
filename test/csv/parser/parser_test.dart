// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:grizzly_io/src/csv/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  group('CsvParser.parseRow', () {
    setUp(() {});

    test('Normal', () {
      final String input = "Name,Age,House";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', 'Age', 'House']);
    });

    test('Empty', () {
      final String input = "Name,,Age,House";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', '', 'Age', 'House']);
    });

    test('TextSep', () {
      final String input = "Name,'Age',House";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', 'Age', 'House']);
    });

    test('Empty in TextSep', () {
      final String input = "Name,'','Age',House";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', '', 'Age', 'House']);
    });

    test('TextSep.Last', () {
      final String input = "Name,,'Age','House'";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', '', 'Age', 'House']);
    });

    test('TextSep in text', () {
      final String input = "Name,,'''a''Age''','House'";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', '', "''a''Age''", 'House']);
    });

    test('FieldSep in text', () {
      final String input = "Name,,'''Age'',''','House'";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', '', "''Age'',''", 'House']);
    });

    test('Muliline', () {
      final String input = "Name,,'''Age'',''','House\r\nh'";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', '', "''Age'',''", "House\r\nh"]);
    });

    test('Multiline.TextSepTextInLineEnd', () {
      final String input = "Name,,'Age','House''\r\nh'";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, ['Name', '', "Age", "House''\r\nh"]);
    });

    test('Multiline.Incomplete', () {
      final String input = "Name,,'Age','House";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, null);
    });

    test('Multiline.Incomplete.TextSepTextInEnd', () {
      final String input = "Name,,'Age','House''";
      List<String>? cols = CsvParser.parseRow(input, ts: r"'");
      expect(cols, null);
    });

    test('Neg.TextSep.Mismatch', () {
      final String input = "Name,Age',''House'";
      expect(() => CsvParser.parseRow(input, ts: r"'"), throwsA(isException));
    });
  });
}
