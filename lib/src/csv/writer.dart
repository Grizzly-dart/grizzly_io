library grizzly.io.csv.writer;

String encodeCsv(List<List> data,
    {String fieldSep = ',', String textSep = '"'}) {
  final sb = StringBuffer();
  data.map((List row) {
    return row.map((col) {
      String scol = col.toString();
      if (scol.contains(fieldSep)) {
        scol = '$textSep$scol$textSep';
      }
      return scol;
    }).join(fieldSep);
  }).forEach(sb.writeln);
  return sb.toString();
}
