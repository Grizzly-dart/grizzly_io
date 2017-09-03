/// Provides [CsvParser] class to parse CSV-like file formats
///
/// [csvParser] convenience function creates a [CsvParser] with given settings
///
/// Static method [CsvParser.parseRow] can be used parse a single row.
library grizzly.io.csv.parser;

import 'dart:convert';

/// Creates a CSV parser with given field separator [fieldSep], text separator
/// [textSep] and multiline [multiline]
CsvParser csvParser(
        {String fieldSep: ',', String textSep: '"', bool multiline: true}) =>
    new CsvParser(fieldSep: fieldSep, textSep: textSep, multiline: multiline);

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
      {this.fieldSep: ',', this.textSep: '"', this.multiline: true});

  /// Parses single CSV row [csv]
  ///
  /// If the row spans multiple lines, returns null.
  ///
  /// Throws if the row is invalid!
  ///
  ///     parser.convertRow('Name,'Age',House');  // => [Name, Age, House]
  List<String> convertRow(String csv) =>
      parseRow(csv, fs: fieldSep, ts: textSep);

  List<List> convert(String buffer, {bool multiline: true}) {
    final Iterable<String> lines = LineSplitter.split(buffer).toList();

    return convertLines(lines, multiline: multiline);
  }

  /// Parses given CSV [lines]
  ///
  /// [multiline] can be used to control if a single row can span multiple lines
  List<List> convertLines(Iterable<String> lines, {bool multiline: true}) {
    final bool m = multiline ?? this.multiline ?? true;

    final List<List> ret = [];

    String previousLine;
    for (String line in lines) {
      if (previousLine == null) {
        final List row = parseRow(line, fs: fieldSep, ts: textSep);
        if (row != null) {
          ret.add(row);
        } else {
          if (!m) throw new Exception('Invalid row!');
          previousLine = line;
        }
      } else {
        previousLine = previousLine + '\r\n' + line;
        final List row = parseRow(previousLine, fs: fieldSep, ts: textSep);
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
  ///     CsvParser.parse('Name,'Age',House');  // => [Name, Age, House]
  static List<String> parseRow(String input,
      {String fs: r',', String ts: r'"'}) {
    final RegExp regExp1 =
        new RegExp('([^$ts$fs]+)' + r'(?:' + fs + r'|$)', multiLine: true);
    final RegExp regExp2 = new RegExp(
        '$ts((?:$ts{2}|[^$ts])*)$ts' + r'(?:' + fs + r'|$)',
        multiLine: true);
    final RegExp fsRegExp = new RegExp(fs);
    final RegExp tsRegExp = new RegExp(ts);

    final List<String> columns = [];

    while (input.isNotEmpty) {
      bool found = false;
      {
        if (input.startsWith(fsRegExp)) {
          Match match = fsRegExp.firstMatch(input);
          if (match != null) {
            found = true;
            columns.add(null);
            input = input.substring(match.end);
          }
        }
      }
      if (!found && input.startsWith(regExp1)) {
        Match match = regExp1.firstMatch(input);
        if (match != null) {
          found = true;
          columns.add(match.group(1));
          input = input.substring(match.end);
        }
      }
      if (!found && input.startsWith(regExp2)) {
        Match match = regExp2.firstMatch(input);
        if (match != null) {
          found = true;
          columns.add(match.group(1));
          input = input.substring(match.end);
        }
      }

      if (!found) {
        if (input.startsWith(tsRegExp)) return null;
        throw new Exception('Invalid row!');
      }
    }

    return columns;
  }
}
