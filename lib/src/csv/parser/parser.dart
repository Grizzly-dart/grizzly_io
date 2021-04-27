/// Provides [CsvParser] class to parse CSV-like file formats
///
/// [parseCsv] and [parseLCsv]  are convenience function to parse CSV
/// and labeled CSV respectively.
///
/// Static method [CsvParser.parseRow] can be used parse a single row.
library grizzly.io.csv.parser;

import 'dart:convert';
import 'package:grizzly_io/src/type_converter/type_converter.dart' show Table;

/// Parses the given CSV buffer
List<List<String>> parseCsv(String buffer,
        {String fieldSep = ',', String textSep = '"', bool multiline = true}) =>
    CsvParser(fieldSep: fieldSep, textSep: textSep, multiline: multiline)
        .convert(buffer);

/// Parses the given labeled CSV buffer
Table parseLCsv(String buffer,
        {String fieldSep = ',', String textSep = '"', bool multiline = true}) =>
    CsvParser(fieldSep: fieldSep, textSep: textSep, multiline: multiline)
        .convertLabeled(buffer);

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

  /// Can a row span multiple lines?
  final bool multiline;

  const CsvParser(
      {this.fieldSep = ',', this.textSep = '"', this.multiline = true});

  Table convertLabeled(String csv) => Table.from(convert(csv), hasHeader: true);

  /// Parses single CSV row [csv]
  ///
  /// If the row spans multiple lines, returns null.
  ///
  /// Throws if the row is invalid!
  ///
  ///     parser.convertRow('Name,'Age',House');  // => [Name, Age, House]
  List<String>? convertRow(String csv) {
    final ret = parseRow(csv, fs: fieldSep, ts: textSep);

    if (ret == null) {
      throw Exception('invalid row');
    }

    return ret;
  }

  List<List<String>> convert(String buffer, {bool multiline = true}) {
    final Iterable<String> lines = LineSplitter.split(buffer).toList();

    return convertLines(lines, multiline: multiline);
  }

  /// Parses given CSV [lines]
  ///
  /// [multiline] can be used to control if a single row can span multiple lines
  List<List<String>> convertLines(Iterable<String> lines, {bool? multiline}) {
    final bool isMultiline = multiline ?? this.multiline;

    final List<List<String>> ret = [];

    String? previousLine;
    for (String line in lines) {
      if (previousLine == null) {
        final List<String>? row = parseRow(line, fs: fieldSep, ts: textSep);
        if (row != null) {
          ret.add(row);
        } else {
          if (!isMultiline) {
            throw Exception('Invalid row!');
          }
          previousLine = line;
        }
      } else {
        previousLine = previousLine + '\r\n' + line;
        final List<String>? row =
            parseRow(previousLine, fs: fieldSep, ts: textSep);
        if (row != null) {
          ret.add(row);
          previousLine = null;
        }
      }
    }

    return ret;
  }

  /// Parses single CSV row [input] with field separator [fs] and text separator
  /// [ts]
  ///
  /// If the row spans multiple lines, returns null.
  ///
  /// Throws if the row is invalid!
  ///
  ///     CsvParser.parse("Name,'Age',House");  // => [Name, Age, House]
  static List<String>? parseRow(String input,
      {String fs = r',', String ts = r'"'}) {
    final RegExp fieldWithoutTS =
        RegExp('([^$ts$fs]+)' r'(?:' + fs + r'|$)', multiLine: true);
    final RegExp fieldWithTS = RegExp(
        '$ts((?:$ts{2}|[^$ts])*)$ts' r'(?:' + fs + r'|$)',
        multiLine: true);
    final RegExp fsRegExp = RegExp(fs);
    final RegExp tsRegExp = RegExp(ts);

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
}
