# Grizzly IO

Readers and writers for several file formats (CSV, TSV, JSON, YAML, etc)

## Usage

### Labeled TSV

#### Read

```dart
main() {
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
}
```

*normal.tsv*:

```text
Name	Age	House
Jon	25	Stark
Dany	28	Targaryan
Tyrion	40	Lannister
Elia Martell	75	Martell
```

## TODO

- [x] Read tsv
- [ ] Write tsv
- [ ] Read csv
- [ ] Write csv
- [ ] Read JSON
- [ ] Write JSON
- [ ] Read yaml
- [ ] Write yaml
- [ ] Read mongo
- [ ] Write mongo
- [ ] Handle zip files