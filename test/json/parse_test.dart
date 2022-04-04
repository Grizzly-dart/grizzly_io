import 'package:grizzly_io/grizzly_io.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('JSON.read', () {
    test('list_list', () async {
      final data = await JSON().read('data/json/list_list.json');
      print(data);
      // TODO
    });
    test('map', () async {
      final data = await JSON().read('data/json/map.json');
      print(data);
      // TODO
    });
    test('list_map', () async {
      final data = await JSON().read('data/json/list_map.json');
      print(data);
      // TODO
    });
  });
}