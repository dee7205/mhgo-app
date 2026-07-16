class ProgressReport {
  String uuid;
  ProgressReport(this.uuid);
}

void main() {
  List<ProgressReport> reports = [ProgressReport('123')];
  
  try {
    final report = reports.cast<ProgressReport?>().firstWhere(
      (r) => r?.uuid == '456',
      orElse: () => null,
    );
    print('Report is: $report');
  } catch (e, stack) {
    print('Exception: $e');
    print(stack);
  }
}
