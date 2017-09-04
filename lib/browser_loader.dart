/// Provides loaders in browser environment
///
/// [requestLabTsv] parses TSV files fetched from HTTP requests.
///
/// [readLabTsv] parses TSV files opened through file input element.
library grizzly.io.browser_loader;

import 'dart:html';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:http/browser_client.dart';
import 'package:grizzly_io/grizzly_io.dart';

Future<LabeledTsv> requestLabTsv(String url) async {
	final client = new BrowserClient();
	final Response resp = await client.get(url);
	return new LabeledTsv.parse(resp.body);
}

/// Reads file/blob as labeled TSV file
Future<LabeledTsv> readLabTsv(Blob file, {Encoding encoding: UTF8}) async {
	FileReader reader = new FileReader();
	reader.readAsText(file);
	await reader.onLoadEnd.first;
	if(reader.readyState != FileReader.DONE) {
		throw new Exception('Loading File/Blob failed!');
	}
	if(reader.result is! String) {
		throw new Exception('Could not read File/Blob!');
	}
	return new LabeledTsv.parse(reader.result);
}
