import 'dart:io';
import 'package:archive/archive_io.dart';
void main() {
  final encoder = ZipFileEncoder();
  final d = Directory('test_zip_dir');
  d.createSync();
  File('${d.path}/test.json').writeAsStringSync('{}');
  encoder.create('test.zip');
  encoder.addDirectory(d);
  encoder.close();
  
  final bytes = File('test.zip').readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);
  for (var f in archive) {
    print("File in zip: ${f.name}");
  }
}
