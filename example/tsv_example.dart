// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// import 'package:grizzly_io/src/csv/parser/parser.dart';
import 'package:grizzly_io/grizzly_io.dart';

Future<void> main() async {
  var data = await tsv.read('data/labeled_tsv/headers/tab_in_label.tsv');
  print(data);
  final out = tsv.encode(data);
  print(out);
  data = tsv.parse(out);
  print(data);
}
