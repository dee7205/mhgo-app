void main() {
  try {
    "".substring(0, 8);
  } catch (e) {
    print("Substring error: $e");
  }

  try {
    [][0];
  } catch (e) {
    print("List error: $e");
  }

  try {
    ""[0];
  } catch (e) {
    print("String index error: $e");
  }
}
