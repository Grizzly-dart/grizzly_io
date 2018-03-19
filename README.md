# Grizzly IO

Readers and writers for several file formats (CSV, TSV, JSON, YAML, etc)

# Usage

## Labeled TSV

### Read from file system

```dart
main() async {
      final tsv = await readLTsv('data/example.tsv');
      print(tsv);
}
```

### Read from HTTP

```dart
main() async {
      final tsv = await requestLTsv('http://localhost:8000/example.tsv');
      print(tsv);
}
```

### Read with custom separators

```dart
main() async {
      final tsv = await readCsv('data/example.csv', fieldSep: '|', textSep: "'");
      print(tsv);
}
```

### Write

```dart
main() async {
      final csv = await readCsv('data/example.csv');
      String encoded = encodeCsv(csv);
}
```

*example.tsv*:

```text
Name	Age	House
Jon	25	Stark
Dany	28	Targaryan
Tyrion	40	Lannister
Elia Martell	75	Martell
```

*example.csv*:

```text
Name,Age,House
Jon,25,Stark
Dany,28,Targaryan
Tyrion,40,Lannister
Elia Martell,75,Martell
```

## TODO
- [ ] Read JSON
- [ ] Write JSON
- [ ] Read yaml
- [ ] Write yaml
- [ ] Read mongo
- [ ] Write mongo
- [ ] Handle zip files