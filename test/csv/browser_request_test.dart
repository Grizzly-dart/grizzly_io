@TestOn('browser')

import 'package:test/test.dart';
import 'package:grizzly_io/grizzly_io.dart';

void main() {
  group('CSV.browser.request', () {
    test('request', () async {
      final stream = csv.request(Uri.parse('https://raw.githubusercontent.com/cs109/2014_data/master/countries.csv'));

      await for(final row in stream) {
        print(row);
      }
    });
  });
}
