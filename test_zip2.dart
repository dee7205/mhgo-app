import 'dart:io';
import 'package:archive/archive_io.dart';
void main() {
  final encoder = ZipFileEncoder();
  final d = Directory('test_zip_dir');
  d.createSync();
  File('${d.path}/test.json').writeAsStringSync('{}');
  encoder.create('test2.zip');
  for (var f in d.listSync()) {
    if (f is File) {
      encoder.addFile(f, f.path.split('/').last);
    }
  }
  encoder.close();
  
  final bytes = File('test2.zip').readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);
  for (var f in archive) {
    print("File in zip2: ${f.name}");
  }
}
