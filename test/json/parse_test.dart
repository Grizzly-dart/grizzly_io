import 'package:grizzly_io/grizzly_io.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('JSON', () {
    test('parse', () async {
      final data = await JSON().read('data/json/list_of_list/list_of_list.json');
      print(data);
      // TODO
    });
  });
}