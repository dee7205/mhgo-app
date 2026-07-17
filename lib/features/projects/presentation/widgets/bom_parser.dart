import 'package:flutter/services.dart';

Future<List<(String, String, double)>> parseBomAssets(String assetPath) async {
  try {
    final content = await rootBundle.loadString(assetPath);
    final lines = content.split('\n');
    final result = <(String, String, double)>[];
    for (final line in lines) {
      final cols = line.split('\t');
      if (cols.length >= 3) {
        final qtyStr = cols[1].trim();
        final qty = double.tryParse(qtyStr);
        if (qty != null) {
          final name = cols[0].trim();
          final unit = cols[2].trim();
          if (name.isNotEmpty && unit.isNotEmpty) {
            result.add((name, unit, qty));
          }
        }
      }
    }
    return result;
  } catch (e) {
    return [];
  }
}
