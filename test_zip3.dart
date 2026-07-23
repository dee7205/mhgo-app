import 'dart:io';
import 'package:archive/archive_io.dart';
void main() {
  final d = Directory('test_zip_dir');
  final archive = Archive();
  for (var f in d.listSync()) {
    if (f is File) {
      archive.addFile(ArchiveFile(f.path.split('/').last, f.lengthSync(), f.readAsBytesSync()));
    }
  }
  final zipData = ZipEncoder().encode(archive);
  File('test3.zip').writeAsBytesSync(zipData);
}
