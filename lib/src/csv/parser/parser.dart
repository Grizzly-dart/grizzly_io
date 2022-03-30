/// Provides [CsvParser] class to parse CSV-like file formats
///
/// [parseCsv] and [parseLCsv]  are convenience function to parse CSV
/// and labeled CSV respectively.
///
/// Static method [CsvParser.parseRow] can be used parse a single row.
library grizzly.io.csv.parser;

import 'dart:convert';
import 'package:grizzly_io/src/csv.dart';

const csv = CsvParser();

const tsv = CsvParser.tsv();

/// Parser of CSV-like file formats
class CsvParser {
  /// Field separator
  ///
  /// Defaults to `,`
  final String fieldSep;

  /// Text separator
  ///
  /// Defaults to `"`
  final String textSep;

  final String lineSep;

  /// Can a row span multiple lines?
  final bool multiline;

  const CsvParser(
      {this.fieldSep = ',',
      this.textSep = '"',
      this.multiline = true,
      this.lineSep = '\n'});

  const CsvParser.tsv(
      {this.textSep = '"', this.multiline = true, this.lineSep = '\n'})
      : fieldSep = '\t';

  /// Parses the given CSV content and returns the rows it contains
  Iterable<List<String>> parse(String buffer) =>
      parseLines(LineSplitter.split(buffer));

  /// Parses a single CSV row [csv].
  ///
  /// Throws if the row is invalid!
  ///
  ///     parser.convertRow('Name,'Age',House');  // => [Name, Age, House]
  List<String> parseRow(String csv) {
    final ret = parseIncompleteRow(csv);

    if (ret == null) {
      throw Exception('invalid or incomplete CSV row');
    }

    return ret;
  }

  Stream<List<String>> parseLineStream(Stream<String> stream) async* {
    String? previousLine;
    await for (final line in stream.transform(LineSplitter())) {
      if (previousLine == null) {
        final List<String>? row = parseIncompleteRow(line);
        if (row != null) {
          yield row;
        } else {
          if (!multiline) {
            throw Exception('Invalid row!');
          }
          previousLine = line;
        }
      } else {
        previousLine = previousLine + '\r\n' + line;
        final List<String>? row = parseIncompleteRow(previousLine);
        if (row != null) {
          yield row;
          previousLine = null;
        }
      }
    }

    if (previousLine != null) {
      throw Exception('incomplete or invalid last row');
    }
  }

  /// Parses given CSV [lines]
  Iterable<List<String>> parseLines(Iterable<String> lines) sync* {
    String? previousLine;
    for (String line in lines) {
      if (previousLine == null) {
        final List<String>? row = parseIncompleteRow(line);
        if (row != null) {
          yield row;
        } else {
          if (!multiline) {
            throw Exception('Invalid row!');
          }
          previousLine = line;
        }
      } else {
        previousLine = previousLine + '\r\n' + line;
        final List<String>? row = parseIncompleteRow(previousLine);
        if (row != null) {
          yield row;
          previousLine = null;
        }
      }
    }

    if (previousLine != null) {
      throw Exception('incomplete or invalid last row');
    }
  }

  /// Parses single potentially incomplete multiline CSV row [input]
  ///
  /// If the row spans multiple lines, returns null.
  ///
  /// Throws if the row is invalid!
  ///
  ///     CsvParser.parse("Name,'Age',House");  // => [Name, Age, House]
  List<String>? parseIncompleteRow(String input) {
    final fieldWithoutTS = RegExp(
        '([^$textSep$fieldSep]+)' r'(?:' + fieldSep + r'|$)',
        multiLine: true);
    final RegExp fieldWithTS = RegExp(
        '$textSep((?:$textSep{2}|[^$textSep])*)$textSep' r'(?:' +
            fieldSep +
            r'|$)',
        multiLine: true);
    final fsRegExp = RegExp(fieldSep);
    final tsRegExp = RegExp(textSep);

    final List<String> columns = [];

    while (input.isNotEmpty) {
      // Empty column
      if (input.startsWith(fsRegExp)) {
        Match? match = fsRegExp.firstMatch(input);
        if (match != null) {
          columns.add('');
          input = input.substring(match.end);
        } else {
          throw Exception('unknown error');
        }
        continue;
      }

      // Single/Multi line column without text separator
      if (input.startsWith(fieldWithoutTS)) {
        Match? match = fieldWithoutTS.firstMatch(input);
        if (match != null) {
          columns.add(match.group(1)!);
          input = input.substring(match.end);
        } else {
          throw Exception('unknown error');
        }
        continue;
      }

      // Single/Multi line column with text separator
      if (input.startsWith(fieldWithTS)) {
        Match? match = fieldWithTS.firstMatch(input);
        if (match != null) {
          columns.add(match.group(1)!);
          input = input.substring(match.end);
        } else {
          throw Exception('unknown error');
        }
        continue;
      }

      if (input.startsWith(tsRegExp)) {
        return null;
      }

      throw Exception('Invalid row!');
    }

    return columns;
  }

  String encode(List<List> data) {
    final sb = StringBuffer();
    data.map(encodeRow).forEach((row) => sb.writeAll([row, lineSep]));
    return sb.toString();
  }

  String encodeRow(List row) => row.map((col) {
        String scol = col.toString();
        if (scol.contains(fieldSep) || scol.contains(lineSep)) {
          // TODO what if scol contains textSep?
          scol = '$textSep$scol$textSep';
        }
        return scol;
      }).join(fieldSep);
}
