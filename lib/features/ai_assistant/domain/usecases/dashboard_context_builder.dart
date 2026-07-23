import 'package:mhgo/features/dashboard/domain/models/dashboard_overview.dart';
import 'package:intl/intl.dart';

class DashboardContextBuilder {
  static String build(DashboardOverview data) {
    final buffer = StringBuffer();
    final currencyFormatter = NumberFormat.currency(symbol: '₱', decimalDigits: 2);

    // 1. Executive Summary
    buffer.writeln('# Executive Dashboard Summary');
    buffer.writeln('- Total Projects: ${data.totalProjectsCount}');
    buffer.writeln('- Active / Construction Projects: ${data.activeProjectsCount}');
    buffer.writeln('- Planning / Pipeline Projects: ${data.planningProjectsCount}');
    buffer.writeln('- Accumulated Project Value: ${currencyFormatter.format(data.accumulatedTotalCost)}');
    buffer.writeln('- Global Active Progress: ${(data.overallProgress * 100).toStringAsFixed(1)}%');
    buffer.writeln('- Recent DARs Filed: ${data.recentDarCount}');
    buffer.writeln('');

    // 2. Capacity by Unit
    buffer.writeln('# Total Capacity Implemented');
    if (data.capacityByUnit.isEmpty) {
      buffer.writeln('No capacity data recorded.');
    } else {
      data.capacityByUnit.forEach((unit, value) {
        buffer.writeln('- $value $unit');
      });
    }
    buffer.writeln('');

    // 3. Project Pipeline (Stages)
    buffer.writeln('# Projects by Stage');
    if (data.projectsByStage.isEmpty) {
      buffer.writeln('No stages recorded.');
    } else {
      data.projectsByStage.forEach((stage, count) {
        buffer.writeln('- $stage: $count projects');
      });
    }
    buffer.writeln('');

    // 4. Project List
    buffer.writeln('# All Registered Projects');
    if (data.projects.isEmpty) {
      buffer.writeln('No projects found.');
    } else {
      for (final p in data.projects) {
        buffer.writeln('- **${p.name}** (${p.status}) - ${p.capacity} ${p.capacityUnit ?? ""}');
        buffer.writeln('  - Location: ${p.location}');
        buffer.writeln('  - Progress: ${(p.progress * 100).toStringAsFixed(1)}%');
      }
    }
    buffer.writeln('');

    // 5. Low Stock Materials
    buffer.writeln('# Inventory Alerts (Low Stock)');
    if (data.lowStockMaterials.isEmpty) {
      buffer.writeln('All materials are well-stocked.');
    } else {
      for (final m in data.lowStockMaterials) {
        buffer.writeln('- ${m.name}: ${m.currentStock} ${m.unit} remaining (Category: ${m.category})');
      }
    }
    buffer.writeln('');

    // 6. Recent Inspections/Surveys
    buffer.writeln('# Recent Surveys & Site Inspections');
    if (data.recentInspections.isEmpty) {
      buffer.writeln('No recent surveys.');
    } else {
      for (final s in data.recentInspections) {
        buffer.writeln('- ${s.clientName} at ${s.address} (Status: ${s.status})');
      }
    }

    return buffer.toString();
  }
}
