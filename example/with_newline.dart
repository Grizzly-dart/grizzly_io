import 'package:grizzly_io/grizzly_io.dart';

Future<void> main() async {
  var data = await csv.read('data/csv/newline.csv');
  print(data);
  print(csv.encode(data));
}