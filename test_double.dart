void main() {
  print(8.96.toString().replaceAll(RegExp(r'\.0$'), ''));
  print(9.0.toString().replaceAll(RegExp(r'\.0$'), ''));
  print(14.8.toString().replaceAll(RegExp(r'\.0$'), ''));
  print(8.964.toString().replaceAll(RegExp(r'\.0$'), ''));
}
