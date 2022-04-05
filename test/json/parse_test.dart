import 'package:grizzly_io/grizzly_io.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../data.dart';

void main() {
  group('JSON.read', () {
    test('list_list', () async {
      final data = await JSON().read('data/json/list_list.json');
      print(data);
      expect(data, gameOfThrones);
    });
    test('map', () async {
      final data = await JSON().read('data/json/map.json');
      print(data);
      expect(data, rates);
    });
    test('list_map', () async {
      final data = await JSON().read('data/json/list_map.json');
      print(data);
      expect(data, gameOfThrones);
    });
  });
}