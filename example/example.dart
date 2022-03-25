// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// import 'package:grizzly_io/src/csv/parser/parser.dart';
import 'package:grizzly_io/io_loader.dart';

Future<void> main() async {
  Table tsv = await readLTsv('data/labeled_tsv/headers/tab_in_label.tsv');
  print(tsv);
  final out = encodeCsv(tsv.toListWithHeader(), fieldSep: '\t');
  print(out);
  tsv = parseLTsv(out);
  print(tsv);

  print(tsv.column("Age").asInts());
  print(tsv.toMap());
  tsv.column("Age").convertToDoubles();
  print(tsv.column(1));
  print(tsv.rowToObject(0, GoTCharacter.fromMap));
}

class GoTCharacter {
  final String name;
  final double age;
  final String house;

  GoTCharacter({required this.name, required this.age, required this.house});

  factory GoTCharacter.fromMap(Map map) =>
      GoTCharacter(name: map['Name'], age: map['Age'], house: map['House	(h)']);

  String toString() => 'Name => $name | Age => $age | House => $house';
}
