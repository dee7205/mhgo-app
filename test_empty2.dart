void main() {
  List<int> list1 = [];
  try {
    list1[0];
  } catch(e) {
    print("List1 error: $e");
  }

  List<int> list2 = List.empty(growable: true);
  try {
    list2[0];
  } catch(e) {
    print("List2 error: $e");
  }

  List<String> list3 = const [];
  try {
    list3[0];
  } catch(e) {
    print("List3 error: $e");
  }
}
